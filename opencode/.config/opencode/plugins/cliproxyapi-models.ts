import type { Plugin } from "@opencode-ai/plugin"
import { mkdir, readFile, rename, writeFile } from "node:fs/promises"
import { homedir } from "node:os"
import { dirname, join } from "node:path"

const PROVIDER_ID = "cliproxyapi"
const DEFAULT_BASE_URL = "http://127.0.0.1:8317/v1"
const CLIENT_VERSION = "opencode-cliproxyapi-models/1"

type CatalogModel = {
  id?: string
  slug?: string
  display_name?: string
  context_window?: number
  max_context_window?: number
  input_modalities?: string[]
  supported_in_api?: boolean
  supported_reasoning_levels?: unknown[]
  visibility?: string
}

type OpenCodeModel = {
  name: string
  attachment: boolean
  reasoning: boolean
  tool_call: boolean
  limit: { context: number; output: number }
  modalities: {
    input: Array<"text" | "audio" | "image" | "video" | "pdf">
    output: ["text"]
  }
}

type ModelMap = Record<string, OpenCodeModel>

const baseURL = (process.env.CLIPROXY_BASE_URL || DEFAULT_BASE_URL).replace(/\/$/, "")
const dataHome = process.env.XDG_DATA_HOME || join(homedir(), ".local", "share")
const cacheHome = process.env.XDG_CACHE_HOME || join(homedir(), ".cache")
const authPath = join(dataHome, "opencode", "auth.json")
const cachePath = join(cacheHome, "opencode", "cliproxyapi-models.json")
const proxyKeyPath = join(homedir(), ".cli-proxy-api", "api-key.txt")

async function apiKey(): Promise<string | undefined> {
  if (process.env.CLIPROXY_API_KEY) return process.env.CLIPROXY_API_KEY

  try {
    const auth = JSON.parse(await readFile(authPath, "utf8"))
    const credential = auth[PROVIDER_ID]
    if (credential?.type === "api" && typeof credential.key === "string") {
      return credential.key
    }
  } catch {
    // OpenCode may not have a credential yet; the caller handles this gracefully.
  }

  try {
    const key = (await readFile(proxyKeyPath, "utf8")).trim()
    if (key) return key
  } catch {
    // CLIProxyAPI's conventional key file is optional.
  }
}

function normalizeInput(modalities?: string[]): OpenCodeModel["modalities"]["input"] {
  const supported = new Set(["text", "audio", "image", "video", "pdf"])
  const normalized = (modalities || ["text"]).filter((item) => supported.has(item))
  if (!normalized.includes("text")) normalized.unshift("text")
  return [...new Set(normalized)] as OpenCodeModel["modalities"]["input"]
}

function toModelMap(catalog: CatalogModel[]): ModelMap {
  const models: ModelMap = {}

  for (const item of catalog) {
    const id = item.slug || item.id
    if (!id || item.supported_in_api === false || item.visibility === "hide") continue

    const input = normalizeInput(item.input_modalities)
    const context = Math.max(item.context_window || item.max_context_window || 128_000, 1)
    models[id] = {
      name: item.display_name || id,
      attachment: input.some((modality) => modality !== "text"),
      reasoning: Boolean(item.supported_reasoning_levels?.length),
      tool_call: true,
      limit: {
        context,
        output: Math.min(context, 65_536),
      },
      modalities: { input, output: ["text"] },
    }
  }

  return models
}

async function fetchModels(): Promise<ModelMap> {
  const key = await apiKey()
  if (!key) throw new Error(`missing ${PROVIDER_ID} credential in ${authPath} or ${proxyKeyPath}`)

  const url = new URL(`${baseURL}/models`)
  url.searchParams.set("client_version", CLIENT_VERSION)
  const response = await fetch(url, {
    headers: {
      accept: "application/json",
      authorization: `Bearer ${key}`,
    },
    signal: AbortSignal.timeout(5_000),
  })
  if (!response.ok) throw new Error(`model endpoint returned HTTP ${response.status}`)

  const body = (await response.json()) as {
    models?: CatalogModel[]
    data?: CatalogModel[]
  }
  const catalog = body.models || body.data || []
  const models = toModelMap(catalog)
  if (!Object.keys(models).length) throw new Error("model endpoint returned no usable models")
  return models
}

async function readCache(): Promise<ModelMap | undefined> {
  try {
    const parsed = JSON.parse(await readFile(cachePath, "utf8"))
    if (parsed?.version === 1 && parsed.models && Object.keys(parsed.models).length) {
      return parsed.models as ModelMap
    }
  } catch {
    // A missing or stale cache is fine when the proxy is available.
  }
}

async function writeCache(models: ModelMap): Promise<void> {
  const temporaryPath = `${cachePath}.${process.pid}.tmp`
  await mkdir(dirname(cachePath), { recursive: true })
  await writeFile(
    temporaryPath,
    `${JSON.stringify({ version: 1, updatedAt: new Date().toISOString(), models }, null, 2)}\n`,
    "utf8",
  )
  await rename(temporaryPath, cachePath)
}

export const CLIProxyAPIModelsPlugin: Plugin = async () => ({
  config: async (config) => {
    let discovered: ModelMap | undefined

    try {
      discovered = await fetchModels()
      await writeCache(discovered)
    } catch (error) {
      discovered = await readCache()
      const detail = error instanceof Error ? error.message : String(error)
      console.warn(
        `[${PROVIDER_ID}] live model discovery failed (${detail}); ` +
          (discovered ? "using cached catalog" : "provider was not added"),
      )
    }

    if (!discovered) return

    config.provider ||= {}
    const existing = config.provider[PROVIDER_ID] || {}
    config.provider[PROVIDER_ID] = {
      ...existing,
      npm: "@ai-sdk/openai",
      name: existing.name || "CLIProxyAPI (local)",
      options: {
        ...(existing.options || {}),
        baseURL,
      },
      models: {
        ...discovered,
        ...(existing.models || {}),
      },
    }
  },
})

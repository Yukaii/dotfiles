#!/usr/bin/env bash
set -Eeuo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
PACKAGES_FILE="${SCRIPT_DIR}/packages.txt"

deno eval --ext=ts '
type Lockfile = {
  specifiers?: Record<string, string>;
};

const installRoot = Deno.env.get("DENO_INSTALL_ROOT") ?? `${Deno.env.get("HOME")}/.deno`;
const binDir = `${installRoot}/bin`;
const specs = new Set<string>();

const stripQuotes = (value: string) => value.replace(/^\x27|\x27$/g, "");

const getPinnedSpecifier = (wrapperSpec: string, lock: Lockfile): string => {
  const specifiers = lock.specifiers ?? {};

  if (wrapperSpec.startsWith("npm:")) {
    const packageName = wrapperSpec.slice(4);
    const version = Object.entries(specifiers).find(([key]) => key.startsWith(`npm:${packageName}@`))?.[1];
    return version ? `npm:${packageName}@${version}` : wrapperSpec;
  }

  if (wrapperSpec.startsWith("jsr:")) {
    const jsrPath = wrapperSpec.slice(4);
    const slashIndex = jsrPath.indexOf("/", 1);
    const packageName = slashIndex === -1 ? jsrPath : jsrPath.slice(0, slashIndex);
    const subpath = slashIndex === -1 ? "" : jsrPath.slice(slashIndex);
    const version = Object.entries(specifiers).find(([key]) => key.startsWith(`jsr:${packageName}@`))?.[1];
    return version ? `jsr:${packageName}@${version}${subpath}` : wrapperSpec;
  }

  return wrapperSpec;
};

for await (const entry of Deno.readDir(binDir)) {
  if (!entry.isFile || entry.name.startsWith(".")) continue;

  const wrapperPath = `${binDir}/${entry.name}`;
  const wrapperText = await Deno.readTextFile(wrapperPath).catch(() => "");
  const match = wrapperText.match(/exec deno run .*? ?\x27([^\x27]+)\x27 \"\$@\"/);
  if (!match) continue;

  const wrapperSpec = stripQuotes(match[1]);
  const metadataDir = `${binDir}/.${entry.name}`;
  const lockText = await Deno.readTextFile(`${metadataDir}/deno.lock`).catch(() => "");
  const lock = lockText ? (JSON.parse(lockText) as Lockfile) : {};

  specs.add(getPinnedSpecifier(wrapperSpec, lock));
}

const lines = [...specs].sort((a, b) => a.localeCompare(b));
await Deno.writeTextFile(Deno.args[0], `${lines.join("\n")}${lines.length ? "\n" : ""}`);
' "$PACKAGES_FILE"

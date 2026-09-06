#!/usr/bin/env python3
import sys
import re
import os
import json
import urllib.request

def rule_based_format(text: str) -> str:
    """Fast, accurate full-width Chinese punctuation conversion (sub-millisecond)."""
    if not re.search(r'[\u4e00-\u9fff\u3400-\u4dbf]', text):
        return text

    # Commas (avoid converting commas within numbers like 1,000)
    text = re.sub(r'(?<!\d),(?!\d)', '，', text)
    # Question marks
    text = re.sub(r'\?+', '？', text)
    # Exclamation marks
    text = re.sub(r'!+', '！', text)
    # Colons (avoid time like 12:30 or URLs like http:)
    text = re.sub(r'(?<!\d):(?!\d|//)', '：', text)
    # Semicolons
    text = re.sub(r';', '；', text)
    # Periods: avoid decimals (3.14) and file extensions/domains (config.toml, apple.com)
    text = re.sub(r'([\u4e00-\u9fff\u3400-\u4dbf])\s*\.', r'\1。', text)
    text = re.sub(r'(?<![a-zA-Z0-9])\.(?![a-zA-Z0-9])', '。', text)
    text = re.sub(r'\.\s*$', '。', text)
    # Ellipsis (... or ……)
    text = re.sub(r'\.{3,}|…{2,}', '……', text)

    # Clean up redundant spaces around Chinese punctuation
    text = re.sub(r'\s*([，。？！：；……])\s*', r'\1', text)

    return text.strip()

def llm_format(text: str) -> str:
    """Smart LLM formatting via local Ollama (qwen2.5:1.5b)."""
    url = "http://localhost:11434/api/generate"
    model = os.environ.get("VOXTYPE_LLM_MODEL", "qwen2.5:1.5b")
    prompt = (
        "請將以下語音識別文字轉為標準繁體中文全形標點（，。？！：；）。\n"
        "注意：請嚴格保留所有中英文詞彙、專有名詞與數字原樣，不要翻譯或改寫任何字詞。\n"
        "請直接輸出修正標點後的結果，不要添加任何引號、前綴或說明文字。\n\n"
        f"輸入：{text}\n輸出："
    )

    payload = json.dumps({
        "model": model,
        "prompt": prompt,
        "stream": False,
        "keep_alive": "24h",
        "options": {
            "temperature": 0.1,
            "num_predict": 128
        }
    }).encode("utf-8")

    req = urllib.request.Request(url, data=payload, headers={"Content-Type": "application/json"})
    try:
        with urllib.request.urlopen(req, timeout=2.0) as resp:
            data = json.loads(resp.read().decode("utf-8"))
            out = data.get("response", "").strip()
            # Strip accidental wrapping quotes from model output
            for q in [("「", "」"), ('"', '"'), ("'", "'"), ("『", "』")]:
                if out.startswith(q[0]) and out.endswith(q[1]):
                    out = out[1:-1].strip()
            if out:
                return rule_based_format(out)
    except Exception:
        # Fallback to pure rules if Ollama is offline or times out
        pass

    return rule_based_format(text)

def main():
    raw_input = sys.stdin.read()
    if not raw_input:
        return

    text = raw_input.strip()

    # Detect if any Chinese characters appear
    has_chinese = bool(re.search(r'[\u4e00-\u9fff\u3400-\u4dbf]', text))

    # 只要有中文出現（純中文或中英混排），就盡量替換為全形標點
    # 只有在完全沒有中文（如純英文輸入）時，才保持原樣不替換
    if has_chinese:
        use_llm = os.environ.get("VOXTYPE_USE_LLM", "1").lower() not in ("0", "false", "no")
        if use_llm:
            output = llm_format(text)
        else:
            output = rule_based_format(text)
    else:
        output = text

    sys.stdout.write(output)

if __name__ == "__main__":
    main()

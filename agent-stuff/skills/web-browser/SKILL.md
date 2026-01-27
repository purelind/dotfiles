---
name: web-browser
description: "Allows to interact with web pages by performing actions such as clicking buttons, filling out forms, and navigating links. It works by remote controlling Google Chrome or Chromium browsers using the Chrome DevTools Protocol (CDP). When Claude needs to browse the web, it can use this skill to do so."
license: Modified from Mario Zechner's original
---

# Web Browser Skill

Minimal CDP tools for collaborative site exploration.

## Start Chrome

```bash
./scripts/start.js              # Start test Chrome (keeps your normal Chrome running)
./scripts/start.js --profile    # Start with copy of your Chrome profile (cookies, logins)
./scripts/start.js --force      # Force restart (WARNING: kills ALL Chrome windows)
```

Start a separate Chrome instance on `:9222` with remote debugging.

### Important Notes

- **默认行为安全**：不会关闭你正在使用的 Chrome 窗口
- **独立实例**：测试用 Chrome 使用单独的 profile 目录 (`~/.cache/chrome-automation`)
- **可并行使用**：你可以一边用正常 Chrome 查资料，一边让 Claude 操作测试 Chrome
- **复用检测**：如果调试 Chrome 已在运行，会直接复用而不是重新启动

### 修改说明 (2024-01-24)

原版脚本会执行 `killall 'Google Chrome'`，导致关闭用户所有 Chrome 窗口。

**修改内容：**
1. 移除默认的 `killall` 行为
2. 添加 `--force` 参数，仅在明确指定时才杀死现有 Chrome
3. 检测端口 9222 是否已有调试器运行，如果有则复用
4. 使用独立的 profile 目录 `~/.cache/chrome-automation`（原为 `~/.cache/scraping`）

**潜在问题：**
- 如果你的正常 Chrome 恰好也在用 9222 端口（罕见），需要用 `--force` 重启
- 两个 Chrome 窗口同时运行可能造成视觉混淆（测试用的没有你的书签和扩展）

---

## Navigate

```bash
./scripts/nav.js https://example.com
./scripts/nav.js https://example.com --new
```

Navigate current tab or open new tab.

## Evaluate JavaScript

```bash
./scripts/eval.js 'document.title'
./scripts/eval.js 'document.querySelectorAll("a").length'
./scripts/eval.js 'JSON.stringify(Array.from(document.querySelectorAll("a")).map(a => ({ text: a.textContent.trim(), href: a.href })))'
```

Execute JavaScript in active tab (async context). Be careful with string escaping, best to use single quotes.

## Screenshot

```bash
./scripts/screenshot.js
```

Screenshot current viewport, returns temp file path.

## Pick Elements

```bash
./scripts/pick.js "Click the submit button"
```

Interactive element picker. Click to select, Cmd/Ctrl+Click for multi-select, Enter to finish.

## Dismiss Cookie Dialogs

```bash
./scripts/dismiss-cookies.js          # Accept cookies
./scripts/dismiss-cookies.js --reject # Reject cookies (where possible)
```

Automatically dismisses EU cookie consent dialogs.

Run after navigating to a page:
```bash
./scripts/nav.js https://example.com && ./scripts/dismiss-cookies.js
```

## Background Logging (Console + Errors + Network)

Automatically started by `start.js` and writes JSONL logs to:

```
~/.cache/agent-web/logs/YYYY-MM-DD/<targetId>.jsonl
```

Manually start:
```bash
./scripts/watch.js
```

Tail latest log:
```bash
./scripts/logs-tail.js           # dump current log and exit
./scripts/logs-tail.js --follow  # keep following
```

Summarize network responses:
```bash
./scripts/net-summary.js
```

## Cleanup

To stop the test Chrome:
```bash
# Find and kill only the automation Chrome (by its profile directory)
pkill -f 'chrome-automation'
```

Or simply close the test Chrome window manually.

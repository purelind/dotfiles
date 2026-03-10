---
description: "Perform structured code review on GitHub Pull Requests"
allowed-tools: Bash, Read, Glob, Grep, Agent
argument-hint: [PR_ID|owner/repo#ID|URL] [--comment|--review]
---

# Code Review for GitHub Pull Request

请对 PR `$ARGUMENTS` 进行结构化 code review。

先读取 skill 文件获取完整指引：

~/.claude/skills/review-pr/SKILL.md

然后按照 skill 中定义的流程执行 review。

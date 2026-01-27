---
description: Draft and create a git commit with LLM assistance
allowed-tools: Bash
argument-hint: [auto|staged|changed|<description>]
---

# Git Commit

Based on "$ARGUMENTS":

- **空参数 / auto**: 分析当前状态，自动判断要提交什么
- **staged**: 只提交已暂存的文件
- **changed**: 暂存所有已修改的跟踪文件并提交
- **其他文字**: 按描述选择相关文件提交

## 检查当前状态

!git status --short
!git diff --cached --stat

## 文件选择原则

**保守选择，有疑问就不加：**
- 只包含与当前工作明确相关的文件
- 不要提交 untracked 文件，除非明确是本次工作的一部分
- 不要提交可能是之前遗留的无关改动
- 不要提交配置文件、日志、或不应进入版本控制的内容

## Commit 格式

```
<type>[scope]: <description>

[body]

[footer]
```

**类型**: feat | fix | docs | refactor | test | chore | perf | build | ci | revert

**原则**:
- type 后紧跟冒号和空格
- scope 仅在能提升清晰度时添加
- description 用祈使语气，说明改了什么而非怎么改
- body 用于补充上下文、原因、非显而易见的行为
- Breaking change 在 type 后加感叹号标记
- **清晰实用比严格规范更重要**

## 执行提交

根据分析结果：
1. 暂存相关文件（如需要）
2. 生成 commit message
3. 执行 `git commit`

!git commit -m "$(cat <<'EOF'
[commit message]
EOF
)"

提交后显示结果：
!git log -1 --oneline

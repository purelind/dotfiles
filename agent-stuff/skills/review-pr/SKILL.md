---
name: review-pr
description: "Perform structured code review on GitHub Pull Requests. Checks out the PR, analyzes diffs and context, and outputs prioritized issues with actionable suggestions."
---

# Review PR Skill

对 GitHub Pull Request 进行结构化 code review，输出优先级排序的问题和可操作建议。

## 使用方式

```
/review-pr <PR_REF> [--comment|--review]
```

`PR_REF` 支持以下格式（自动识别）：

| 格式 | 示例 | 说明 |
|------|------|------|
| PR 编号 | `123` | 使用当前目录 git remote 推断仓库 |
| `owner/repo#ID` | `facebook/react#1234` | 显式指定仓库 |
| GitHub URL | `https://github.com/owner/repo/pull/123` | 从 URL 解析 |

## 脚本

| 脚本 | 用途 |
|------|------|
| `./scripts/parse-pr-ref.sh <REF>` | 解析 PR 引用，输出 JSON `{"repo","pr_id","repo_flag"}` |
| `./scripts/submit-review.sh <REF> --comment <file>` | 提交整体 review 评论 |
| `./scripts/submit-review.sh <REF> --review <file>` | 提交带行级评论的结构化 review |

## 执行流程

### 第一步：解析仓库和 PR

使用脚本解析输入：

```bash
PARSED=$(./scripts/parse-pr-ref.sh "$PR_REF")
# 输出示例: {"repo":"owner/repo","pr_id":"123","repo_flag":"--repo owner/repo"}
# 纯数字输入: {"repo":"","pr_id":"123","repo_flag":""}
```

- 纯数字：`repo` 为空，`gh` 从当前目录的 git remote 自动推断仓库。如果当前目录不是目标仓库的 clone，需要提示用户补充仓库信息。
- `owner/repo#ID` 或 GitHub URL：`repo_flag` 自动填充 `--repo owner/repo`。

### 第二步：获取 PR 信息

```bash
# REPO_FLAG 来自上一步解析结果

# 获取 PR 元信息
gh pr view $PR_ID $REPO_FLAG --json title,body,baseRefName,headRefName,author,files | cat

# 获取完整 diff
gh pr diff $PR_ID $REPO_FLAG | cat
```

- **当前仓库的 PR**（`repo` 为空）：执行 `gh pr checkout $PR_ID` 切换到分支，方便本地阅读代码。
- **跨仓库的 PR**（`repo` 非空）：不 checkout，直接通过 `gh pr diff/view --repo` 远程获取信息。

### 第三步：深入理解上下文（不要跳过）

不要只看 diff，还需要主动查看：

- 修改文件的完整实现
- 相关调用链和依赖
- 测试代码
- 当前分支与目标分支中的关联实现

### 第四步：逐项 Review

按以下 7 个维度逐步检查。如果改动简单直接，可以跳过某些步骤，但必须明确说明跳过原因。

#### 1. 理解业务目标

判断改动的业务目标、背景和预期收益。如果 PR 描述不充分，基于代码、命名、上下文和关联实现自行推断，并明确指出不确定之处。

#### 2. High-level Review

- 改动是否放在了合适的位置
- 是否尽可能复用了已有逻辑
- 是否可能破坏现有设计、边界约束、模块职责、依赖关系或兼容性

#### 3. 检查 Bug

仔细分析代码修改，判断是否存在：

- 业务逻辑错误
- 边界条件遗漏
- 空值 / 异常处理问题
- 并发问题
- 性能隐患
- 安全风险
- 可观测性不足（日志、监控、错误信息）

对"没有修改但与本次改动直接相关"的代码也需要一并检查。

#### 4. 代码清晰度

- 设计是否简洁易懂
- 命名是否清晰准确
- 注释是否必要且有效
- 一年后再读是否仍然容易理解和维护

#### 5. KISS 原则

审视是否存在：

- 重复造轮子
- 过度设计
- 无用定义
- 冗余分支
- 不必要的兼容代码
- 可以显著简化的实现

#### 6. 单一职责

- 每个函数、类、模块是否职责明确
- 文件大小、函数长度、参数数量是否合理
- 是否存在隐藏副作用或过高耦合

#### 7. 测试覆盖

- 复杂业务逻辑必须有测试
- 公共行为优先测试
- 对纯声明式、无明显控制流的简单代码不要机械补测试
- 如果未补测试，需要说明为什么可以接受

## Review 原则

- **主动阅读上下文**：不要只复述 diff，主动阅读相关上下文代码。
- **质疑假设**：不要默认作者的实现是对的，主动验证关键假设。
- **关注遗漏**：不要只看"改了什么"，还要看"哪里本该改但没改"。
- **给出触发场景**：对风险高的问题，尽量给出触发场景或示例。
- **坦诚不确定**：如果某一部分不确定，明确写出"不确定"和原因，不要编造。
- **优先级排序**：优先关注 correctness、reliability、security、maintainability，弱化纯风格类意见。
- **不草率下结论**：如果没有发现明显问题，不要草率说"没问题"，请明确说明你检查过哪些方面。

## 输出格式

以中文输出，优先给出"真正重要的问题"，不要罗列无关紧要的风格问题。按以下结构输出：

```markdown
## Review Summary

简要说明 PR 的目的、改动范围和整体评价。

## Major Issues

### 1. 问题标题
- **级别**：严重 / 中等
- **位置**：`file/path.go:123` - `functionName()`
- **描述**：问题是什么
- **原因**：为什么是问题
- **建议**：修改建议

### 2. ...

## Minor Issues

### 1. 问题标题
- **级别**：建议
- **位置**：`file/path.go:456` - `functionName()`
- **描述**：问题是什么
- **原因**：为什么是问题
- **建议**：修改建议

### 2. ...

## Merge Recommendation

**建议合并** / **修复后合并** / **暂不建议合并**

理由说明。
```

如果某个分类没有问题，写"无"即可，不要省略分类。

## 提交 Review 到 GitHub

当用户要求将 review 结果评论到 PR 时（如 `--comment` 或 `--review` 参数），使用脚本提交。

### 方式一：提交整体 Review 评论（`--comment`）

将完整 review 写入临时文件后提交：

```bash
# 将 review 内容写入临时文件
cat > /tmp/pr-review-body.md <<'EOF'
## Review Summary
...
## Major Issues
...
## Merge Recommendation
...
EOF

# 提交
./scripts/submit-review.sh "$PR_REF" --comment /tmp/pr-review-body.md
```

### 方式二：提交行级评论（`--review`）

对于能精确定位到 diff 中具体行的问题，使用结构化 review。将 review 内容构造为 JSON 文件：

```json
{
  "body": "## Review Summary\n\n整体评价...\n\n## Merge Recommendation\n\n修复后合并",
  "event": "COMMENT",
  "comments": [
    {
      "path": "src/handler.go",
      "line": 42,
      "body": "**[严重]** 这里缺少空值检查，当 `user` 为 nil 时会 panic。\n\n建议添加 `if user == nil { return ErrNotFound }`"
    },
    {
      "path": "src/service.go",
      "line": 108,
      "body": "**[建议]** 这个方法可以复用已有的 `validateInput()`，避免重复逻辑。"
    }
  ]
}
```

`event` 取值：`COMMENT`（普通评论）、`APPROVE`（批准）、`REQUEST_CHANGES`（请求修改）。

`line` 是文件中的绝对行号（新文件侧），GitHub API 会自动映射到 diff 位置。

```bash
# 提交结构化 review
./scripts/submit-review.sh "$PR_REF" --review /tmp/pr-review.json
```

### 提交策略

- **默认**：只在终端输出 review 结果，不自动评论到 PR
- **`--comment`**：将整体 review 作为 PR review comment 提交
- **`--review`**：使用行级评论 + 整体总结，作为正式 PR review 提交
- **提交前必须向用户确认内容，避免误发**

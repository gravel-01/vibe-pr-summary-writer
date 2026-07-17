---
name: vibe-pr-summary-writer
description: 在 AI 辅助开发或 vibe coding 后，生成面向 reviewer 的 PR/MR 描述和简短 mentor 汇报。适用于需要准确总结需求、commit、diff、测试、截图、日志、API、数据持久化、排查结论和未完成边界的场景。支持提交前使用 commit 拆分计划生成草稿，以及提交后使用真实 commit ID 生成最终描述，并根据新功能、抽象、Bug 排查、计算口径、调度、AI 编排、前端和清理类 PR 选择不同证据模板。
---

# Vibe PR 总结生成器

## 目标

把 vibe coding 产生的开发改动整理成 reviewer 能快速理解、可验证的工程说明。

输出应回答：

1. 真实需求是什么？
2. 本 PR 实际完成了哪一部分？
3. 改动按什么功能边界组织？
4. 有什么证据证明实现生效？
5. 新增公共能力如何使用或扩展？
6. 哪些内容明确不在本 PR 范围内？

不要写代码改动流水账。先识别 PR 类型，再只读取相关模板和证据规则。

## 操作边界

生成 PR 文档不代表用户授权执行 commit、push、分支历史重写、修改 `.gitignore`、上传截图、发表评论或创建 PR/MR。只有用户明确要求时才能执行这些操作。

默认只做只读仓库检查。不要在 PR 描述或截图中暴露密钥、token、cookie、账号密码、客户隐私数据、个人桌面内容或敏感日志 payload。

## 工作流程

### 1. 判断输出阶段

当流程跨越 commit 创建时，产出两份独立文档：

| 文档 | 使用时机 | Commit 部分 |
|---|---|---|
| `pr-description-draft.md` | commit 前 | 写 commit 拆分计划，不虚构 hash，可以保留待确认项 |
| `pr-description-final.md` | commit 后 | 写真实 commit ID、最终 diff 范围、最终测试、截图说明和未完成内容 |

最终版不能只在草稿里补 hash。commit 完成后，必须从实际仓库状态重新采集证据，再生成最终版。

### 2. 确认 target branch

不要默认使用 `origin/dev`、`origin/main`、`main` 或 `master`。

- 用户明确提供 target branch 时，先验证分支存在，再使用它。
- 用户未提供时，检查当前分支、upstream、远端默认分支和远端分支候选。
- 远端默认分支只能作为候选，不能证明它就是本次 PR target。
- 如果存在已有 PR 信息或明确仓库约定，可以作为判断依据。
- 如果仍有多个合理候选，必须先询问用户，再计算 PR diff。

可以先运行无参数发现模式：

```bash
scripts/collect-pr-context.sh
```

### 3. 收集证据

如果当前目录是 Git 仓库，运行只读采集脚本：

```bash
scripts/collect-pr-context.sh <target-branch>
```

如果脚本不可用，至少检查：

```bash
git status --short --branch
git merge-base <target-branch> HEAD
git log --oneline <merge-base>..HEAD
git diff --name-status <merge-base>..HEAD
git diff --stat <merge-base>..HEAD
git diff --check <merge-base>..HEAD
```

根据 PR 内容继续收集测试结果、人工验收、API example、数据存储位置、页面入口、日志、SQL 和截图。

如果当前不是 Git 仓库，则退化为使用用户需求、改动文件列表、测试和验收证据，并明确说明无法获取 commit 和 target branch 证据。

### 4. 处理需求来源

需求文档是可选信息：

- 有本地或可访问文档时，读取并总结。
- 有云文档链接但无法访问时，保留链接供 reviewer 追溯，并说明总结来自用户讨论、开发记录、commit 和 diff。
- 没有文档或链接时，完全省略需求文档模块。

不得声称读过无法访问的文档。信息冲突时按以下顺序判断：

1. 最终已提交 diff 和真实测试输出。
2. 可访问的需求文档。
3. 用户明确说明。
4. 开发记录和讨论历史。
5. AI 推断，并明确标记为假设。

### 5. 识别 PR 类型

选择一个主类型，最多两个辅助类型：

- 新功能。
- 抽象或扩展点。
- Bugfix 或数据排查。
- 计算口径。
- 后台任务或调度。
- AI、Prompt 或编排。
- 前端体验。
- 清理或收敛。

读取 [references/pr-type-routing.md](references/pr-type-routing.md)，只加载所选类型需要的部分。

### 6. 选择语言和模板

- 中文输出读取 [references/templates-zh.md](references/templates-zh.md)。
- 英文输出读取 [references/templates-en.md](references/templates-en.md)。
- 只有用户明确要求中英文时才同时生成两份。

支持三种输出长度：

- 极简 mentor 汇报：4-8 行。
- 标准 PR 描述：适合 PR/MR 页面，完整但简洁。
- 深度排查描述：增加 SQL、日志、公式、根因和后续问题。

### 7. 补充证据和 Example

如果 PR 涉及数据持久化、日志、SQL、截图、后台任务、AI 行为或敏感信息，读取 [references/evidence-and-safety.md](references/evidence-and-safety.md)。

如果 PR 新增公共 API、配置、模板机制、抽象、workflow、数据结构或扩展点，读取 [references/examples.md](references/examples.md)。

Example 必须说明：

1. 什么时候使用？
2. 怎么使用？
3. 预期结果是什么？

私有实现细节如果没有形成新的使用或扩展方式，不强制写 example。

### 8. 检查 PR 范围

最终生成前确认：

- source 和 target branch 正确。
- commit 列表符合预期。
- 没有误带旧 PR 或无关 commit。
- 没有误带生成文件、截图、本地文档、lockfile 和临时文件。
- stacked PR 依赖已说明。
- 没有混淆 commit 数量和 changed file 数量。

如果 PR 混合了互相独立的新功能、重构、Bugfix 和清理，应建议拆分或使用 stacked PR；如果拆分会产生不可运行的中间状态，则保留在一个 PR 中。

### 9. 写作和校验

默认按 commit 或功能模块组织改动。除非用户明确要求完整文件审计，否则不要平铺所有文件。

测试结果要区分：

- 自动测试。
- 人工验收。
- 未运行。
- 被环境阻塞。

不得把“未运行”写成“失败”或“通过”。除非证据证明，不要把 demo、prompt-only 改动或 AI 建议描述成生产执行闭环。

交付草稿或最终版前，读取 [references/final-checklist.md](references/final-checklist.md)。

## 截图规则

截图是可选 review evidence，不是代码 artifact。

- 只有用户要求或截图对前端、视觉、日志、人工验收有实质帮助时才截图。
- 优先使用项目已有的 ignored 本地目录。
- 保存前使用 `git check-ignore -q <path>` 验证目录。
- 未经用户授权不要修改 `.gitignore`。
- 使用带业务语义的文件名。
- 截图后运行 `git status --short`，确认截图不会进入 commit。
- 未经授权不要上传截图，也不要把本地绝对路径写进 PR。

## 输出质量

默认按 reviewer 2-3 分钟阅读预算组织内容：

- 开头先写需求和结果。
- 最重要的风险放在靠前位置。
- Commit 表只保留功能目标、主要文件和 Review 重点。
- 长 SQL、日志、公式和完整文件清单放入可选章节。
- 准确说明数据持久化、兼容性和未完成边界。

最终 PR 描述必须反映最终仓库状态，而不是开发计划。

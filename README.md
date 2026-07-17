# Vibe PR Summary Writer

一个面向 AI 辅助开发和 vibe coding 的 PR/MR 总结 skill。

它会根据真实需求、commit、diff、测试、日志、截图和人工验收，生成 reviewer 友好的 PR 描述，并明确说明实现范围、证据、使用示例和未完成边界。

## 主要能力

- 提交前生成 `pr-description-draft.md` 和 commit 拆分计划。
- 提交后重新读取真实 commit / diff，生成 `pr-description-final.md`。
- 根据 PR 类型选择不同模板：新功能、抽象、Bug 排查、计算口径、调度、AI 编排、前端和清理。
- 灵活处理需求文档：可读则总结，不可读则保留链接，没有文档则省略该模块。
- 对新增 API、模板、配置和扩展点生成 example。
- 明确数据持久化、验收路径、测试结果、风险和未完成内容。
- 支持中文和英文 PR 模板。
- 提供只读 Git 上下文采集脚本。

## 安装

安装稳定版本：

```bash
mkdir -p "${CODEX_HOME:-$HOME/.codex}/skills"

git clone --branch v1.0.0 --depth 1 \
  https://github.com/gravel-01/vibe-pr-summary-writer.git \
  "${CODEX_HOME:-$HOME/.codex}/skills/vibe-pr-summary-writer"
```

安装最新 `main`：

```bash
mkdir -p "${CODEX_HOME:-$HOME/.codex}/skills"

git clone --depth 1 \
  https://github.com/gravel-01/vibe-pr-summary-writer.git \
  "${CODEX_HOME:-$HOME/.codex}/skills/vibe-pr-summary-writer"
```

安装后重新打开 Codex 或新建对话。

## 使用

### 先确定 target branch

不同项目可能使用 `main`、`master`、`dev`、`develop` 或 release branch 作为 PR target，因此不要默认使用 `origin/dev`。

推荐先让 skill 检查仓库上下文：

```text
使用 $vibe-pr-summary-writer，先检查当前分支、upstream、远端默认分支和远端分支候选。
如果无法唯一确认这次 PR 的 target branch，请先询问我，不要直接生成 diff。
```

也可以运行：

```bash
scripts/collect-pr-context.sh
```

无参数时，脚本只输出 target branch 候选，不会擅自选择。确认 target 后再传入目标分支。

提交前生成草稿：

```text
使用 $vibe-pr-summary-writer，先确认本次 PR 的 target branch，
生成 pr-description-draft.md 和 commit 拆分计划。不要执行 commit 或 push。
```

例如当前项目明确以 `origin/dev` 为 target 时：

```text
使用 $vibe-pr-summary-writer，基于 origin/dev 检查当前改动，
生成 pr-description-draft.md 和 commit 拆分计划。不要执行 commit 或 push。
```

提交后生成最终版：

```text
使用 $vibe-pr-summary-writer，重新读取实际 commit、最终 diff 和测试结果，
生成 pr-description-final.md，并补充真实 commit ID。
```

生成简短 mentor 汇报：

```text
使用 $vibe-pr-summary-writer，把当前 PR 总结成 4 到 8 行的 mentor 汇报。
```

## 工作方式

```text
需求和证据收集
-> PR 类型识别
-> 提交前草稿和 commit 计划
-> commit 完成后重新取证
-> 最终 PR 描述和真实 commit ID
```

这个 skill 不会把所有 PR 套进同一个模板。它会选择一个主类型，按需加载对应的证据和模板。

## 目录结构

```text
vibe-pr-summary-writer/
├── SKILL.md
├── SKILL-zh.md
├── agents/
│   └── openai.yaml
├── references/
│   ├── evidence-and-safety.md
│   ├── examples.md
│   ├── final-checklist.md
│   ├── pr-type-routing.md
│   ├── templates-en.md
│   └── templates-zh.md
└── scripts/
    └── collect-pr-context.sh
```

`SKILL.md` 是正式加载入口，`SKILL-zh.md` 是中文对照版。

## 只读上下文采集

先发现 target branch 候选：

```bash
scripts/collect-pr-context.sh
```

确认 target 后采集完整 PR 上下文，例如：

```bash
scripts/collect-pr-context.sh origin/dev
```

脚本只读取：

- 当前分支、upstream、远端默认分支和 target branch 候选。
- merge-base。
- PR commit 列表。
- changed files 和 diff stat。
- working tree 状态。
- `git diff --check` 结果。

脚本不会 stage、commit、push 或修改仓库。

远端默认分支只是候选，不一定是团队实际使用的 PR target。脚本和 skill 都不会仅凭默认分支自动下结论。

## 更新

如果安装的是 `main`：

```bash
git -C "${CODEX_HOME:-$HOME/.codex}/skills/vibe-pr-summary-writer" \
  pull --ff-only
```

## 安全边界

- 生成 PR 文档不代表授权 commit、push、创建 PR/MR 或上传截图。
- 不会假装读取无法访问的需求文档。
- 不应把 token、账号密码、客户数据或敏感日志写进 PR。
- 截图默认保存在 ignored 本地目录，不作为代码 artifact 提交。

## English

Vibe PR Summary Writer turns AI-assisted development work into evidence-backed, reviewer-friendly PR/MR descriptions.

It supports pre-commit drafts, post-commit final descriptions with real commit IDs, PR-type-specific templates, requirement-source handling, examples for new APIs and abstractions, persistence documentation, verification evidence, and explicit non-goals.

Install and invoke it with `$vibe-pr-summary-writer` using the commands above.

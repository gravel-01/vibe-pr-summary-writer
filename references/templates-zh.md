# 中文 PR 模板

只加载与当前任务匹配的模板。不要把所有可选模块拼进同一个 PR。

## 提交前草稿

````markdown
# PR 描述草稿

## 背景

本次需求目标是：XXX。

需求文档：【仅在有链接时保留】

## 计划完成的范围

- XXX
- XXX

## Commit 拆分计划

| 计划 Commit | 功能目标 | 主要文件 | Review 重点 |
|---|---|---|---|
| `feat(xxx): ...` | XXX | XXX | XXX |
| `test(xxx): ...` | XXX | XXX | XXX |

## 计划验收

1. XXX
2. XXX

## 风险 / 待确认

- 待确认：XXX

## 暂不包含

- XXX
````

草稿不得包含虚构 commit hash，不得把待执行测试写成已通过。

## 提交后最终版

````markdown
# PR 描述

## 背景

本次需求目标是：XXX。

需求文档：【仅在有链接时保留】

## 本 PR 完成了什么

- XXX
- XXX

## Commit 记录

| Commit | 功能目标 | 主要文件 | Review 重点 |
|---|---|---|---|
| `abc1234 feat(xxx): ...` | XXX | XXX | XXX |
| `def5678 test(xxx): ...` | XXX | XXX | XXX |

## 数据 / API / 使用入口

| 类型 | 变化 | 说明 |
|---|---|---|
| 数据 | XXX | XXX |
| API | XXX | XXX |
| 页面 / 使用入口 | XXX | XXX |

## 验收路径

1. XXX
2. XXX

## 已验证

| 类型 | 命令 / 验收项 | 结果 |
|---|---|---|
| 自动测试 | `pytest ...` | Passed |
| 人工验收 | XXX | Passed |

## 暂不包含

- XXX
````

只保留适用的“数据 / API / 使用入口”行。简单 PR 可以删除整个表格。

## Bugfix / 数据排查模块

按以下顺序写：

````markdown
## 现象

XXX。

## 排查结论

问题主要来自 XXX，不是 XXX。

## 根因拆分

1. XXX
2. XXX

## 本 PR 能修什么

- XXX

## 本 PR 不能修什么

- XXX，因为 XXX。

## Mentor / 上游后续需要确认

- XXX

## 证据

| 证据 | 结论 |
|---|---|
| SQL / 日志 / 截图 / 测试 | XXX |
````

## 计算口径模块

````markdown
## 计算口径

数据源：XXX。

公式：

```text
result = XXX
```

选择规则：XXX。

Fallback：XXX。

限制：XXX。
````

## 调度模块

````markdown
## 自动触发链路

配置 -> worker scan -> due item -> execution -> business task -> notification

## 日志示例

```text
[scheduler] due_item ...
[scheduler] execution_completed ...
```

## 失败处理

- XXX
````

## AI / Prompt 模块

````markdown
## AI 输入

- XXX

## AI 输出

- 可读报告：XXX
- 结构化输出：XXX

## 人工确认边界

- AI 只生成建议。
- XXX 不会自动执行。

## 证据

- Prompt snapshot：XXX
- JSON / 日志 / run summary：XXX
````

## Example 模块

````markdown
## Example：XXX

使用场景：XXX。

使用方式：

```http
POST /api/example
Content-Type: application/json

{"key":"value"}
```

预期结果：XXX。
````

## 截图模块

````markdown
## 截图

| 截图 | 说明 |
|---|---|
| 截图 1：用户完成 XXX | 展示 XXX 状态 |
| 截图 2：执行结果 | 展示 XXX 已成功 |
````

## 极简 Mentor 汇报

````markdown
超哥，这个是最新 PR：
【PR 链接】

主要改动是：XXX。

这次完成了 XXX，可以在 XXX 完成 XXX，并且已经完成 XXX 验收。

这轮暂不包含：XXX。
````

控制在 4-8 行。不要把 commit 表和完整技术细节塞进聊天汇报。


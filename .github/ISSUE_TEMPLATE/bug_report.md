---
name: Bug report
about: Report a bug to help us improve GudaCC Skills
title: "[BUG] "
labels: bug
assignees: GuDaStudio

---

## Bug Description / Bug描述
A clear and concise description of the bug.
清晰简洁的错误描述。

## Environment / 运行环境
- **OS**: e.g., Ubuntu 22.04 / macOS 14.0 / Windows 11 / WSL2 ...
- **Skills Installation**: e.g., user-level (`~/.claude/skills/`) / project-level (`./.claude/skills/`)
- **Claude Code Version**: run `claude --version`
- **Codex CLI Version** (if using collaborating-with-codex): run `codex --version`
- **Gemini CLI Version** (if using collaborating-with-gemini): run `gemini --version`

## Affected Skill / 受影响的 Skill
- [ ] collaborating-with-codex
- [ ] collaborating-with-gemini
- [ ] Other / 其他

## Steps to Reproduce / 复现步骤
1.
2.
3.

## Logs / 错误日志
If the `error` field is returned, please paste it here.
如有`error`字段返回，请粘贴在这里。
```json

```

## Skill Call Parameters / Skill 调用参数
If the bug is related to calling a skill, please provide the parameters used.
若该故障与调用 Skill 相关，请提供所用参数。

<details>
<summary>collaborating-with-codex</summary>

```json
{
  "PROMPT": "",
  "cd": "",
  "sandbox": "read-only",
  "SESSION_ID": "",
  "return_all_messages": false
}
```
</details>

<details>
<summary>collaborating-with-gemini</summary>

```json
{
  "PROMPT": "",
  "cd": "",
  "sandbox": false,
  "SESSION_ID": "",
  "return_all_messages": false
}
```
</details>

## Additional Context / 其他信息
Additional background information regarding this issue, such as screenshots or related discussions. We highly recommend including complete report screenshots!
关于该问题的其他背景信息，例如截图或相关议题。我们十分建议您添加完整的报告截图！

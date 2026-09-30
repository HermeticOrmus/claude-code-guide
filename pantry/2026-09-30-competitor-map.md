# Competitor map: Claude Code Guide

## How this fills

1. Name the product and its surfaces (plugins, agents, skills, commands, install paths).
2. WebSearch / WebFetch public competitor docs, READMEs and homepages: other Claude Code plugin packs and marketplaces in this domain, Cursor rules and plugins, Codex or Gemini CLI extensions, and standalone tools people use for the same job.
3. One row per competitor; blank unknowns; cite a URL per row.
4. Fill the capabilities matrix (Y / N / P / ?) with the capabilities that matter in this domain, and a source per claimed cell.
5. Save as `YYYY-MM-DD-competitor-map.md` (keep this template).

## Product

- Name: Claude Code Guide ([HermeticOrmus/claude-code-guide](https://github.com/HermeticOrmus/claude-code-guide)), second edition, v2.0.0
- Flagship: one long README checked against Claude Code 2.1.285 (philosophy, MCP servers with `claude mcp add`, commands, skills, agents, the global CLAUDE.md, hooks, settings and permission modes, plugins and marketplaces, terminal tips, Boris Cherny's patterns, a setup checklist)
- Our surfaces: the `claude-code-guide` marketplace with one plugin, `starter-kit` (2 agents, 3 commands, 1 skill template, 1 auto-format hook), installed with `/plugin install starter-kit@claude-code-guide`; `setup.sh`; `examples/hooks/` and `examples/mcp-configs/`; CI in `.github/workflows/validate.yml`

Star counts are `stargazers_count` from `https://api.github.com/repos/<owner>/<name>`, read on 2026-09-30.

## Map

| Competitor | What it is | Overlap with us | Watch / differentiator | Source URL |
|------------|------------|-----------------|------------------------|------------|
| Official Claude Code docs, with anthropics/claude-code (148,701 stars) and anthropics/claude-plugins-official (37,242 stars) | The reference docs; the repo ships 13 plugin folders and a `.claude-plugin/marketplace.json` | Every chapter we cover | Canonical and translated (for example `/docs/ja/` and `/docs/es/` pages load); a reference rather than a learning path | https://code.claude.com/docs/en/overview, https://github.com/anthropics/claude-code |
| luongnv89/claude-howto (41,719 stars, MIT) | "A visual, example-driven guide to Claude Code", modules with copy-paste templates | Same scope and the same version stamp: its README badge reads `version-2.1.285` | Translations (Tiếng Việt, 中文, Українська, 日本語), "Get Started in 15 Minutes", a feature catalog; files are copied by hand | https://github.com/luongnv89/claude-howto |
| FlorianBruniaux/claude-code-ultimate-guide (6,075 stars, CC-BY-SA-4.0) | A very large guide with quizzes, templates, a searchable site and an MCP server of the guide | Same scope | Site at cc.bruniaux.com, community editions in 简体中文, Українська and Español latinoamericano with a translation status page | https://github.com/FlorianBruniaux/claude-code-ultimate-guide, https://cc.bruniaux.com/ |
| zebbern/claude-code-guide (4,643 stars, MIT) | A single-README reference with `skills/` and `agents/` folders | Same format as ours | Its CHANGELOG starts at `## 2.1.285` and tracks each release | https://github.com/zebbern/claude-code-guide |
| ykdojo/claude-code-tips (10,171 stars) | Tips in one README plus the `dx` plugin | Own-marketplace plugin pattern | Installs with `claude plugin marketplace add ykdojo/claude-code-tips` then `claude plugin install dx@ykdojo`, the same pattern as our starter kit | https://github.com/ykdojo/claude-code-tips |
| shanraisshan/claude-code-best-practice (66,839 stars, MIT) | A concepts table plus "TIPS AND TRICKS (83)" and per-topic files | Boris Cherny's tips, settings, MCP | Collects Boris Cherny's threads by date; version badges on pages | https://github.com/shanraisshan/claude-code-best-practice |
| davila7/claude-code-templates (32,221 stars, MIT) | A CLI (`npx claude-code-templates@latest`) and the aitmpl.com catalog of agents, commands, hooks, MCPs and settings | Installable starter pieces | Installs parts by flag rather than teaching; "Browse All Templates" web interface | https://github.com/davila7/claude-code-templates, https://aitmpl.com |
| hesreallyhim/awesome-claude-code (54,845 stars) | Curated list of Claude Code resources | Discovery of guides like ours | A listing there is how many readers find guides | https://github.com/hesreallyhim/awesome-claude-code |
| ClaudeLog | "The no.1 Claude Code community resource. Experiments, insights & mechanics by InventorBlack"; "not affiliated with, endorsed by, or sponsored by Anthropic" | Install, tutorial, configuration, CLAUDE.md, MCPs | A docs and blog site with a CLAUDE.md vault and a changelog | https://claudelog.com |
| affaan-m/everything-claude-code (270,104 stars, MIT) | "The agent harness performance optimization system", configs for Claude Code, Codex, Opencode and more | Skills, memory, security setup | Cross-tool; not inspected further this run | https://github.com/affaan-m/everything-claude-code |
| Cursor rules: PatrickJS/awesome-cursorrules (40,862 stars, CC0-1.0) and Cursor's rules docs | The Cursor analog: a list of `.mdc` rule files, and Cursor's own Project, User and Team Rules docs | CLAUDE.md-style project instructions | Rules only; no hooks or plugin install | https://github.com/PatrickJS/awesome-cursorrules, https://cursor.com/docs/context/rules |
| Gemini CLI docs (google-gemini/gemini-cli, 107,194 stars) and OpenAI Codex docs (openai/codex, 127,408 stars) | Official docs for the rival CLIs, including Gemini CLI extensions and Codex `AGENTS.md` | The same setup questions for other agents | Readers comparing agents meet these first | https://geminicli.com/docs/, https://learn.chatgpt.com/docs/agent-configuration/agents-md |

## Capabilities matrix

Mark Y / N / P (partial) / ? and cite. Rows are the capabilities that matter for this domain.

Columns: Us = this repo on `master`; Official = code.claude.com docs; howto = claude-howto; Ultimate = claude-code-ultimate-guide; zebbern = zebbern/claude-code-guide; ykdojo = claude-code-tips; BP = claude-code-best-practice; Templates = claude-code-templates.

| Capability | Us | Official | howto | Ultimate | zebbern | ykdojo | BP | Templates | Source notes |
|------------|----|----------|-------|----------|---------|--------|----|-----------|--------------|
| Install and first session walkthrough | Y | Y | Y | Y | Y | N | P | ? | Us: README "Quick Start". howto: "Get Started in 15 Minutes". Ultimate: "complete a first task online". zebbern: README `#quick-start`. |
| CLAUDE.md and memory | Y | Y | Y | Y | Y | Y | Y | ? | Us: "The Global CLAUDE.md", "Where instructions load from". Official: /docs/en/memory. |
| Hooks with a working config example | Y | Y | Y | Y | Y | P | P | P | Us: Hooks chapter, `starter-kit/hooks/`, `examples/hooks/`. Official: /docs/en/hooks. howto: `06-hooks/README.md`. zebbern: `#hooks-system`. Templates: `--hook` installs. |
| MCP setup with `claude mcp add` and scopes | Y | Y | Y | Y | Y | P | P | P | Us: "Add servers with `claude mcp add`", "Scopes". howto: `05-mcp/README.md` scopes table. BP: `best-practice/claude-mcp.md`. |
| Skills | Y | Y | Y | Y | Y | Y | Y | P | Us: Skills chapter. |
| Subagents | Y | Y | Y | Y | Y | P | Y | P | Us: Agents chapter. |
| Plugins and marketplaces (build, validate, share) | Y | Y | Y | Y | Y | P | P | P | Us: "Plugins and marketplaces". Official: /docs/en/plugins. howto: `07-plugins/README.md`. zebbern: `#plugin-system`. |
| Settings and permission modes | Y | Y | P | Y | Y | P | Y | P | Us: "Settings and permission modes". Official: /docs/en/permission-modes. BP: `claude-settings.md`. |
| Installable starter kit (plugin or template install) | Y | P | P | Y | P | Y | P | Y | Us: `starter-kit@claude-code-guide`. ykdojo: `dx@ykdojo`. Templates: `npx claude-code-templates@latest`. Ultimate: `claude mcp add` of its guide MCP server. |
| States which Claude Code version it was checked against | Y | P | Y | P | Y | N | P | ? | Us: README "checked against Claude Code **2.1.285**". howto: badge `version-2.1.285`. zebbern: CHANGELOG `## 2.1.285`. |
| Automated check that documented commands still exist | N | ? | ? | ? | ? | ? | ? | ? | Us: the 2.1.285 check was done by hand; CI validates the plugin, not the README. Competitors not checked this run. |
| Plugin eval suite shipped | N | ? | ? | ? | ? | ? | ? | ? | Us: README "The starter kit does not ship an eval suite yet." Competitors not checked this run. |
| Translations (non-English editions) | N | Y | Y | Y | N | N | N | ? | Us: English only. Official: `/docs/ja/overview` and `/docs/es/overview` return 200. howto: README language bar. Ultimate: "Languages and translations". |
| Community contributions of tips or configs | P | P | Y | Y | P | P | P | Y | Us: `CONTRIBUTING.md`, no outside pull requests yet (see the people mine). Ultimate: community translation editions. |
| Searchable website | N | ? | P | Y | N | N | N | Y | Us: README only. Ultimate: cc.bruniaux.com. Templates: aitmpl.com "Browse All Templates". ClaudeLog: no search box on its home page. |

## Search log

- WebSearch: unavailable for this research pass. The session's shared budget was already used up (200 of 200 calls), so 4 queries were refused: `site:x.com "awesome-claude-code"`, `site:x.com "claude code" hooks confusing`, `site:x.com "claude code" docs outdated`, `site:x.com "claude code" "CLAUDE.md" tips`.
- Other search pages fetched instead: DuckDuckGo HTML (CAPTCHA, no results); Bing, 2 queries (irrelevant results); Mojeek (HTTP 403); Brave, 7 queries with results (awesome-claude-code, hooks confusing, docs outdated, CLAUDE.md tips, `"claude-code-templates"`, claudelog, plugin marketplace install) and 6 that answered HTTP 429 (plugins marketplace, skills vs commands confusing, "permission prompts", permission prompts annoying, skills slash commands difference, ykdojo claude-code-tips).
- GitHub API: repo metadata for every repo in the Map, their READMEs, CONTRIBUTING files and CHANGELOGs; issue search including `[DOCS]` issues in anthropics/claude-code (for example https://github.com/anthropics/claude-code/issues/21090).
- Pages fetched: https://code.claude.com/docs/en/overview, https://code.claude.com/docs/en/hooks.md, https://code.claude.com/docs/ja/overview, https://code.claude.com/docs/es/overview, https://claudelog.com, https://cc.bruniaux.com/, https://aitmpl.com, https://cursor.com/docs/context/rules, https://geminicli.com/docs/, https://learn.chatgpt.com/docs/agent-configuration/agents-md (the developers.openai.com link redirected there).
- Our own column was read from this repo on `master`: `README.md`, `.claude-plugin/marketplace.json`, `starter-kit/`, `examples/`, `.github/workflows/validate.yml`, `claude plugin validate .` and `claude plugin validate --strict starter-kit` (both pass), and a clean-config install with `claude plugin details starter-kit@claude-code-guide`.

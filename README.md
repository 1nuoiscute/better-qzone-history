<div align="center">

# QQ 空间历史恢复工具（**Qzone-History**）



[![Version](https://img.shields.io/badge/version-v0.0.4-brightgreen)](version/version.go)
[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](LICENSE)
[![Go](https://img.shields.io/badge/Go-1.21+-00ADD8?style=flat&logo=go&logoColor=white)](https://go.dev/)
[![Platform](https://img.shields.io/badge/Platform-Windows-0078D6?style=flat&logo=windows&logoColor=white)](#从源码编译)
[![GitHub](https://img.shields.io/badge/GitHub-ZHChen2000/qzone--history-181717?style=flat&logo=github)](https://github.com/ZHChen2000/qzone-history)

<br>

从QQ空间「与我相关」活动记录、说说接口、留言板接口中，尽可能恢复**已删除的说说与留言**，<br>
并导出为本地JSON与HTML浏览页。

<sub>仅供个人备份QQ空间数据 · 请遵守<strong>腾讯相关服务条款</strong></sub>

</div>

---

## 界面预览

双击 `qzone-history-gui.exe` 后，浏览器自动打开 Web 控制台，扫码登录即可开始恢复：

<p align="center">
  <img src="docs/images/gui-overview.png" alt="控制台总览" width="720">
</p>

实时日志与抓取进度：

<p align="center">
  <img src="docs/images/gui-logs.png" alt="运行日志与进度" width="720">
</p>

恢复完成后，在本地 HTML 浏览页按时间线查看说说、留言与活动记录：

<p align="center">
  <img src="docs/images/viewer-result.png" alt="恢复结果浏览页" width="720">
</p>

---

## 功能特性

- QQ 扫码登录（官方登录流程，Cookie 仅存本机）
- Web 控制台：实时日志、进度、可停止 / 可退出进程
- 按目标年份推荐 Max Offset，支持手动调大深扫
- 恢复未删除说说、从活动记录重建已删说说
- 留言板 API 拉取，失败时从活动记录重建
- 导出 `{QQ}_export.json`、`{QQ}_activities.json`、`{QQ}_view.html`

## 快速上手

**不想编译？** 直接双击目录中的 `qzone-history-gui.exe`，按**quickStart.md**操作即可。

详细步骤、Offset 对照表、耗时预估、常见问题见[quickStart.md](./quickStart.md)

## 目录结构

```
qzone-history/
├── qzone-history-gui.exe   # Windows预编译
├── docs/images/            # 文档配图
├── cmd/                    # 入口与调试工具
├── internal/               # 业务逻辑、GUI、API客户端
├── pkg/                    # 导出、路径、日志等公共包
├── config/                 # 默认配置
├── version/                # 版本与作者信息
├── go.mod
├── README.md
└── quickStart.md
```

## 从源码编译

需要 [Go 1.25.2+](https://go.dev/dl/)。

```powershell
# 分发，与仓库根目录预编译包相同
go build -ldflags="-H windowsgui -s -w -X qzone-history/version.Version=v0.0.4" -o qzone-history-gui.exe ./cmd/main.go

# 控制台
go build -o qzone-history.exe ./cmd/main.go
```

发布维护者可用 `scripts/build-release.ps1` 一键编译根目录 `qzone-history-gui.exe`（版本号自动读取 `version/version.go`），**每次功能更新请同步提交源码与预编译 exe。**

## 技术说明

本工具**不是**腾讯开放平台正式 API，而是模拟浏览器访问 QQ 空间网页版使用的内部接口（与你在浏览器中打开空间类似），请求带登录 Cookie 与浏览器请求头，并在抓取时做间隔限速。

- 数据**仅保存在本机** exe 同目录，不上传任何第三方服务器
- 深扫（大 Offset）会产生较多请求，请合理设置参数，自行承担使用风险

## 开源协议

本项目采用 [Apache License 2.0](LICENSE)。

## 免责声明

本工具仅供学习与个人数据备份。请勿用于未授权访问他人空间、商用爬取或其他违法行为。使用本工具所产生的一切后果由使用者自行承担。

---

<div align="center">

**作者：[ZHChen](https://github.com/ZHChen2000)** &nbsp;·&nbsp; **联系：QQ 1415094395**

</div>

## DuGuo fork 的改动

本仓库基于 [ZHChen2000/qzone-history](https://github.com/ZHChen2000/qzone-history)，保留原作者署名与 Apache-2.0 协议。当前版本为 `v0.0.4-duguo.1`。

- 修复中文日期和带转义空白的历史时间文本无法参与排序的问题；JSON 导出稳定地从新到旧排列，浏览页可切换最新或最早在前。
- 缺少年份的记录保留原文并排在最后，不为离线历史数据猜测年份。
- 默认折叠疑似重复说说，可展开比较全部记录的时间、图片、评论、文字前缀和活动来源，也可切回逐条显示。
- 在唯一原说说候选和自己的点赞线索支持下，将现有说说与互动重建副本放入同一组，优先显示原说说的发表时间。
- 有转发线索、不同且无法确认的来源前缀或多个原说说候选时保持独立。相同文案分组只改变显示，原始 JSON 和数据库记录不会因此删除或合并；不累计各副本的点赞数。

### 验证与编译

需要 Go 1.25.2 或以上，以及 Node.js 18 或以上。

```powershell
go test ./...
node scripts/test-viewer.cjs
./scripts/build-release.ps1
```

Windows 用户可直接使用仓库根目录更新后的 `qzone-history-gui.exe`。已有导出无需重新抓取，可编译 `cmd/htmlview`，在包含 `{QQ}_export.json` 和 `{QQ}_activities.json` 的目录运行 `qzone-history-htmlview.exe -qq 你的QQ号` 生成新浏览页。

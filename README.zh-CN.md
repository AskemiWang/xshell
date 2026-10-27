# Catppuccin for Xshell

<p align="center">
  <a href="README.md">English</a> · <b>简体中文</b>
</p>

给 NetSarang Xshell 用的 Catppuccin 配色，四套：Latte、Frappé、Macchiato、Mocha。

| Latte | Frappé |
|:--:|:--:|
| <img src="assets/screenshots/latte.png" width="420"> | <img src="assets/screenshots/frappe.png" width="420"> |

| Macchiato | Mocha |
|:--:|:--:|
| <img src="assets/screenshots/macchiato.png" width="420"> | <img src="assets/screenshots/mocha.png" width="420"> |

## 1. 下载

点右上角绿色的 **Code** → **Download ZIP**，或者直接 `git clone`。解压/克隆到哪都行。

## 2. 导入

打开 Xshell，进 `工具 → 配色方案…`，点 **导入**，选 `Catppuccin Mocha.scs`。

想四套都留着，就把另外三个 `.scs` 也各导入一次。

## 3. 选上它

还在那个窗口里，选中方案，点确定。

只想给某个会话用：右键会话 → `属性 → 外观 → 配色方案`，单独选。

## 4. 建议开启：让亮色也生效（推荐）

Xshell 连服务器的时候，会报上一个老名字 `xterm`。在系统的记录里，`xterm` 只有 **8 种颜色**。

但 Xshell 其实能显示 16 种，我们的配色也认真准备了 16 个。麻烦在于 `ls`、`git`、`vim` 这些程序很老实：
终端说自己只有 8 色，它们就只挑前 8 个用，后面那 8 个更亮的颜色一次都不碰。

| | 不设置 | 设置后 |
|---|---|---|
| 程序以为终端支持 | 8 色 | 256 色 |
| 我们这套 16 色方案 | 照样显示 | 照样显示 |
| `vim`、`htop` 这类全屏程序 | 8 色模式，高亮偏素 | 256 色模式，层次更多 |

改法是在服务器的 `~/.bashrc` 里加三行：

```bash
case "$TERM" in
  xterm) export TERM=xterm-256color ;;
esac
```

重连后跑一下 `tput colors`，显示 `256` 就成了。

不设置也不会坏，只是等于买了一大盒 16 色蜡笔，每次只用其中 8 支。

---

想细看颜色表、排错、兼容性，见 [docs/details.zh-CN.md](docs/details.zh-CN.md)。

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

## 4. 想让亮色也生效（可选）

Xshell 跟服务器自我介绍时说的是 `xterm`，而 terminfo 里 `xterm` 等于 8 色。方案照样能画出 16 个
槽位，但 `ls`、`git`、`vim` 这些程序会照着词条办事，只用前 8 个——亮的那半就闲置了。

在服务器的 `~/.bashrc` 里加三行：

```bash
case "$TERM" in
  xterm) export TERM=xterm-256color ;;
esac
```

重连后 `tput colors` 应该变成 256。

不改也完全能用，只是亮色那半继续闲着。顺便说一句，9–14 号槽位和 1–6 号本来就是同一个颜色，
所以实际差别主要落在 `brightBlack` 和 `brightWhite` 这两个槽位上。

---

想细看颜色表、排错、兼容性，见 [docs/details.zh-CN.md](docs/details.zh-CN.md)。

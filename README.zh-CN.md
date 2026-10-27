<h1 align="center">Catppuccin for Xshell</h1>

<p align="center">
  NetSarang Xshell 的 Catppuccin 配色方案<br/>
  Latte · Frappé · Macchiato · Mocha
</p>

<p align="center">
  <a href="README.md">English</a> · <b>简体中文</b>
</p>

---

四套开箱即用的 Xshell 配色，取自官方 [Catppuccin](https://github.com/catppuccin/catppuccin) 调色板。
16 个 ANSI 槽位用的是 Catppuccin 的终端映射——即
[Catppuccin for Windows Terminal](https://github.com/catppuccin/windows-terminal) 发布的那些取值——
也是 [Catppuccin for VS Code](https://github.com/catppuccin/vscode) 集成终端所用的同一套颜色，
所以 Xshell 里的效果和你本地终端、编辑器一致。

Catppuccin **没有官方 Xshell 移植**（没有 `catppuccin/xshell` 仓库，
[netsarang/Xshell-ColorScheme](https://github.com/netsarang/Xshell-ColorScheme) 的 250+ 套方案里也没有），
本仓库补上这个空缺。

## 开始之前：TERM 与 256 色

Xshell 8 向服务器自我介绍时用的是普通的 `xterm`，而 terminfo 数据库里 `xterm` 对应的是
**8 色**。本仓库的方案仍然会画出全部 16 个槽位——下面那个 16 色测试就是证据——但守规矩的程序
（`ls`、`git`、`vim`、`htop`）会相信 terminfo，永远不去请求 8–15 号槽位，调色板的亮色半区就闲置了。

有两条路可选。

### 方案 A —— 声明 256 色（推荐）

在**服务器**的 `~/.bashrc` 里加上：

```bash
case "$TERM" in
  xterm) export TERM=xterm-256color ;;
esac
```

重新登录，或 `source ~/.bashrc`，然后确认：

```bash
echo $TERM      # xterm-256color
tput colors     # 256
```

**为什么写在 shell 配置里而不是 Xshell 设置里：** Xshell 的「终端类型」下拉通常只有
`xterm`、`vt100`、`vt220` 这些传统值，而且不少服务器会在 `/etc/profile` 里重写 `TERM`；
`~/.bashrc` 在那之后执行，优先级更高，也更可靠。

**为什么要加 `case` 判断：** 在 `tmux` 或 `screen` 里，`TERM` 是 `screen-256color`。
无条件覆盖会让这些程序误判终端类型；加了判断就只升级「当前正好是 xterm」的情况。

### 方案 B —— 什么都不改

本仓库的一切照常工作：四套方案都按规范渲染（见[兼容性](#兼容性)）。唯一后果是，依赖
terminfo 的程序会停留在 8 色模式：

| | `TERM=xterm` | `TERM=xterm-256color` |
|---|---|---|
| `ls --color` | 只用基础 8 色 | 也会用到亮色槽位 |
| `git log --graph` | 正常 | 同色，对比略强 |
| `vim` | `t_Co=8` | `t_Co=256` |
| 16 色测试（显式 `90`–`97` 转义） | 16 个槽位全显示 | 16 个槽位全显示 |

实际损失不大：Catppuccin 把 9–14 映射成和 1–6 相同的 hex，真正有区别的只有
`black`/`brightBlack` 和 `white`/`brightWhite`。如果你从来没觉得缺亮色，方案 B 完全够用——
只是要知道 `tput colors` 显示 `8` 是预期行为，不是装坏了。

![Catppuccin 四套配色：Latte、Frappé、Macchiato、Mocha](assets/preview.svg)

## 四套配色

| Flavor | 背景 | 前景 | 适合 |
| --- | --- | --- | --- |
| **Latte** | `#EFF1F5` | `#4C4F69` | 明亮环境、白天 |
| **Frappé** | `#303446` | `#C6D0F5` | 光线较暗 |
| **Macchiato** | `#24273A` | `#CAD3F5` | 介于两者之间 |
| **Mocha** | `#1E1E2E` | `#CDD6F4` | 暗环境、夜间 |

## 安装

Xshell 可以直接导入配色方案，所以只有一步。

1. 下载本仓库——绿色 **Code** 按钮 → **Download ZIP**，或 `git clone`——解压。
2. 在 Xshell 里打开 `工具 → 配色方案…`
3. 点 **导入**，选中 `Catppuccin Mocha.scs`（或其它 flavor）。
4. 其余 flavor 重复一次——一个文件导入一次。
5. 方案已出现在列表里，选中并确定即可。

## 启用

- **所有会话：** `工具 → 配色方案`，选中某个 flavor，确定。
- **只给单个会话：** 右键会话 → `属性 → 外观 → 配色方案`。

列表里显示的名字就是文件名，所以文件保留了 `Catppuccin ` 前缀。

## 验证

把下面这段粘进会话，确认 16 个槽位真的生效：

```bash
printf 'TERM=%s  colors=%s\n\n' "$TERM" "$(tput colors 2>/dev/null)"
i=0
while [ $i -le 15 ]; do
  if [ $i -lt 8 ]; then fg=$((30+i)); bg=$((40+i)); else fg=$((90+i-8)); bg=$((100+i-8)); fi
  printf '\033[%sm%-14s\033[0m \033[%sm              \033[0m \033[1;%smBOLD\033[0m\n' "$fg" "ANSI $i" "$bg" "$fg"
  i=$((i+1))
done
```

应该看到 16 行带标签的色块，标签后面是实心背景块；这些块的颜色要和调色板表一致。
即使 `tput colors` 显示 `8`，亮色行也照样能渲染出来——那个数字描述的是程序「会请求什么」，
不是终端「能显示什么」。

## 调色板

每个方案定义 16 个 ANSI 槽位 + 背景 + 前景；**粗体走 bright 槽位**，和 Windows Terminal
的 `brightBlack` … `brightWhite` 逻辑一致。

| ANSI | 角色 | Latte | Frappé | Macchiato | Mocha |
| --- | --- | --- | --- | --- | --- |
| 0 | black | `#5C5F77` | `#51576D` | `#494D64` | `#45475A` |
| 1 | red | `#D20F39` | `#E78284` | `#ED8796` | `#F38BA8` |
| 2 | green | `#40A02B` | `#A6D189` | `#A6DA95` | `#A6E3A1` |
| 3 | yellow | `#DF8E1D` | `#E5C890` | `#EED49F` | `#F9E2AF` |
| 4 | blue | `#1E66F5` | `#8CAAEE` | `#8AADF4` | `#89B4FA` |
| 5 | magenta | `#EA76CB` | `#F4B8E4` | `#F5BDE6` | `#F5C2E7` |
| 6 | cyan | `#179299` | `#81C8BE` | `#8BD5CA` | `#94E2D5` |
| 7 | white | `#ACB0BE` | `#B5BFE2` | `#B8C0E0` | `#BAC2DE` |
| 8 | bright black | `#ACB0BE` | `#626880` | `#5B6078` | `#585B70` |
| 9–14 | bright red … bright cyan | 同 1–6 | 同 1–6 | 同 1–6 | 同 1–6 |
| 15 | bright white | `#BCC0CC` | `#A5ADCE` | `#A5ADCB` | `#A6ADC8` |

前景（`text`）：Latte `#4C4F69`、Frappé `#C6D0F5`、Macchiato `#CAD3F5`、Mocha `#CDD6F4`。

## 文件里有什么

每个 `.scs` 就是一个只有 19 个键的 INI：

```ini
[Color Scheme]
background=1e1e2e
text=cdd6f4
text(bold)=cdd6f4
black=45475a
black(bold)=585b70
red=f38ba8
red(bold)=f38ba8
...
white=bac2de
white(bold)=a6adc8
```

改文件时注意两点：

- **编码必须是 UTF-16 LE + BOM，换行 CRLF。** Xshell 8 自带的方案就是这样；存成 UTF-8 会乱码或被拒绝。
  本仓库每个文件正好 676 字节。
- **没有光标色、选中色、标签栏色。** 这个格式没有对应的键，只能到会话属性里另设。

## 看似异常但正常

- **ANSI 1–6 与对应 bright 完全相同。** Catppuccin 的 `brightRed` 就是 `red` 的同一个 hex，粗体只是粗，不会更亮。
- **暗色三套里 `brightWhite` 比 `white` 更暗。** bright 槽位遵循调色板的 Overlay/Subtext 顺序，不是「越亮越好」。
- **Latte 的 `white` 与 `brightBlack` 同色（`#ACB0BE`）**，对 `#EFF1F5` 只有 1.91:1。所以 ANSI white 的文字本来就该发灰；
  如果某个 TUI 用 white 输出正文，单独改这一个键即可。
- **低对比度是设计本身。** pastel 强调色相对背景大约 2–3:1（Latte 的 yellow 2.31:1，Mocha 的 bright black 2.46:1）。
  这些值与上游完全一致，不是转换错误。

## 排错

| 现象 | 处理 |
| --- | --- |
| 导入后列表里没有 | 重启 Xshell，再确认导入是否真的完成（`工具 → 配色方案`）。Xshell 把方案存在 `%USERPROFILE%\Documents\NetSarang Computer\<版本>\Xshell\ColorScheme Files`，这个目录在第一次运行 Xshell 时创建。 |
| 名字乱码 / 方案被拒绝 | 文件存成了 UTF-8，重新存为 UTF-16 LE + BOM。 |
| 粗体看起来发灰 | 正常现象：粗体走 bright 槽位，Catppuccin 的 bright 与普通色很接近。想更分明就改 `*(bold)` 键。 |
| TUI 程序颜色发暗、像 256 色 | Xshell 没开真彩色（`Xshell.ini` 里 `TrueColorTerminal=1`，或会话里的对应选项）。 |
| 某段文字突然多出青色背景 | 同样是没开真彩色：终端把 `48;2;r;g;b` 拆开解析，尾部的 `46` 被当成「青色背景」。处理方式同上。 |
| `tput colors` 只显示 8 / 亮色好像没生效 | 见[开始之前](#开始之前term-与-256-色)。 |
| 只想改某个会话 | 在那一个会话的属性里选配色方案，不要动全局列表。 |

## 兼容性

在 Windows 11 + **Xshell 8.0.0099** 上验证。四套方案都从真实的 Xshell 窗口里逐像素采样过：
16 个槽位全部与文件中的 hex 完全一致，没有色彩管理偏移。`.scs` 是 Xshell 8 自带的格式；部分旧版本和
大多数社区包用的是 `.xcs`，结构不同（方案名作节标题，另加 `[Names]` 块）。如果你的 Xshell 只认 `.xcs`：

```ini
[Catppuccin Mocha]
; ...同样这 19 个键...
[Names]
count=1
name0=Catppuccin Mocha
```

## 致谢

- 调色板：[Catppuccin Org](https://github.com/catppuccin/catppuccin)，MIT——所需的版权与许可声明
  已原文收录在 [LICENSE-Catppuccin](LICENSE-Catppuccin)。
- 槽位映射参考 [catppuccin/windows-terminal](https://github.com/catppuccin/windows-terminal)；
  配色与 [catppuccin/vscode](https://github.com/catppuccin/vscode) 同源。
- 非官方移植，与 Catppuccin、NetSarang 均无隶属关系。Catppuccin 的名称与 logo 归 Catppuccin Org 所有，
  此处仅在「移植对象」的意义上使用名称，未打包其 logo。

MIT 协议，见 [LICENSE](LICENSE)。

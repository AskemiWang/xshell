# Catppuccin for Xshell · 其余说明

[README](../README.zh-CN.md) 只讲怎么装。这个文件放剩下的：为什么有时候一半颜色用不上、那些
数字是什么意思、以及颜色不对时该查哪儿。

## 1. TERM，以及为什么一半的颜色可能用不上

Xshell 连服务器时会说「我是个普通 xterm」，而 terminfo 里 xterm 代表的是 **8 色**。

有意思的地方就在这儿：我们的方案写了 16 个槽位，Xshell 也确实全都能画出来（第 4 节有测试，
16 个一个不少）。但 `ls`、`git`、`vim`、`htop` 这些程序是照 terminfo 办事的，它们只申请前 8 个。
剩下那半亮色，就白给了。

两条路，挑一条。

### 1.1 让它知道有 256 色（推荐）

在服务器的 `~/.bashrc` 里加三行：

```bash
case "$TERM" in
  xterm) export TERM=xterm-256color ;;
esac
```

重连，或者 `source ~/.bashrc`，然后确认：

```bash
echo $TERM      # xterm-256color
tput colors     # 256
```

为什么不直接改 Xshell？它的「终端类型」下拉一般只有 `xterm`、`vt100`、`vt220` 这些老值；而且不少
服务器会在 `/etc/profile` 里重写 `TERM`，`~/.bashrc` 在它之后跑，能盖过去。

为什么要套一层 `case`？tmux 或 screen 里 `TERM` 是 `screen-256color`，无脑覆盖会让它们误判终端。
这层判断只升级「正好是 xterm」的情况。

### 1.2 不改也行

什么都不影响，四套配色照样按规范渲染。

| | `TERM=xterm` | `TERM=xterm-256color` |
|---|---|---|
| `ls --color` | 只用基础 8 色 | 也会用到亮色槽位 |
| `git log --graph` | 正常 | 同色，对比略强 |
| `vim` | `t_Co=8` | `t_Co=256` |
| 16 色测试（显式 `90`–`97`） | 16 个全显示 | 16 个全显示 |

说句公道话，损失不大：9–14 和 1–6 是同一个 hex，真正有区别的只有 `black`/`brightBlack` 和
`white`/`brightWhite`。`tput colors` 显示 8 但你用得挺舒服，那也是完全合理的配置。

## 2. 颜色表

每套方案都是 16 个 ANSI 槽位 + 背景 + 前景。粗体走 bright 槽位，和 Windows Terminal 的
`brightBlack` … `brightWhite` 一个逻辑。

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

这些值和 [catppuccin/windows-terminal](https://github.com/catppuccin/windows-terminal) 完全一致，
所以 Xshell 里的观感和本地终端对得上。

## 3. .scs 里到底是什么

就是一个 19 个键的 INI 文件，没了。

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

要动手改的话，记住两件事：

- **UTF-16 LE + BOM，换行 CRLF。** Xshell 8 自己写出来就是这样。存成 UTF-8 会乱码或者被拒绝。
  仓库里每个文件正好 676 字节。
- **没有光标色、选中色、标签栏色。** 这个格式压根没有对应的键，那些只能在会话属性里设。

## 4. 验证一下真装上了

粘进会话：

```bash
printf 'TERM=%s  colors=%s\n\n' "$TERM" "$(tput colors 2>/dev/null)"
i=0
while [ $i -le 15 ]; do
  if [ $i -lt 8 ]; then fg=$((30+i)); bg=$((40+i)); else fg=$((90+i-8)); bg=$((100+i-8)); fi
  printf '\033[%sm%-14s\033[0m \033[%sm              \033[0m \033[1;%smBOLD\033[0m\n' "$fg" "ANSI $i" "$bg" "$fg"
  i=$((i+1))
done
```

应该出来 16 行，每行标签后面有个实心色块。拿这些块跟上面的表对一下，必须一模一样。
即使 `tput colors` 显示 8，亮色那几行也照样会画出来——那个数字说的是程序「会申请什么」，
不是终端「能显示什么」。

## 5. 看着像坏了，其实正常

- **粗体和普通一个色。** Catppuccin 把 `brightRed` 就映射成 `red` 的同一个 hex，粗体只是粗，不更亮。
- **暗色三套里 `brightWhite` 比 `white` 还暗。** bright 槽位按调色板的 Overlay/Subtext 顺序排，不是「越往后越亮」。
- **Latte 的 `white` 和 `brightBlack` 同色**（`#ACB0BE`），对 `#EFF1F5` 只有 1.91:1。白字在那儿本来就该发灰。
  真有 TUI 拿 white 写正文，单独改这一个键就行。
- **对比度本来就低。** pastel 强调色大致 2–3:1（Latte 黄 2.31:1、Mocha 的 bright black 2.46:1）。
  这是上游的值，不是换算错了。

## 6. 出问题先看这里

| 现象 | 怎么办 |
| --- | --- |
| 导入完列表里没有 | 重启 Xshell。还是没有的话，确认导入确实完成了。Xshell 把方案存在 `%USERPROFILE%\Documents\NetSarang Computer\<版本>\Xshell\ColorScheme Files`，这个目录是第一次运行 Xshell 时创建的。 |
| 名字乱码，或者方案被拒绝 | 文件存成 UTF-8 了，重新存为 UTF-16 LE + BOM。 |
| 粗体看着发灰 | 设计如此（见第 5 节）。想更分明就改 `*(bold)` 那几个键。 |
| 某段文字突然多出青色背景 | 没开真彩色，终端把 `48;2;r;g;b` 拆开解析，末尾的 `46` 被当成「青色背景」。把 `Xshell.ini` 里的 `TrueColorTerminal` 改成 1，或用会话里的对应选项。 |
| TUI 程序颜色发暗、像 256 色 | 同上，真彩色没开。 |
| `tput colors` 只显示 8 | 见第 1 节。 |
| 只想改某个会话 | 在那个会话的属性里选方案，别动全局列表。 |

## 7. 兼容性

在 **Xshell 8.0.0099**（Windows 11）上验证过。四套方案都从真实窗口里逐像素采样：16 个槽位全部
与文件里的 hex 一致，没有色彩管理偏移。

`.scs` 是 Xshell 8 自带的格式。部分旧版本和大多数社区包用 `.xcs`，结构不一样——方案名作节标题，
另外多一个 `[Names]` 块。如果你的只认 `.xcs`，改一下节名再补上这个块：

```ini
[Catppuccin Mocha]
; ...同样这 19 个键...
[Names]
count=1
name0=Catppuccin Mocha
```

## 8. 致谢

- 调色板：[Catppuccin Org](https://github.com/catppuccin/catppuccin)，MIT。所需的版权与许可声明
  原文收录在 [LICENSE-Catppuccin](../LICENSE-Catppuccin)。
- 槽位映射参考 [catppuccin/windows-terminal](https://github.com/catppuccin/windows-terminal)；
  配色与 [catppuccin/vscode](https://github.com/catppuccin/vscode) 同源。
- 非官方移植，与 Catppuccin、NetSarang 都没隶属关系。Catppuccin 的名字和 logo 归 Catppuccin Org，
  这里只用来表示「移植的是什么」，没有打包任何 logo。

MIT 协议，见 [LICENSE](../LICENSE)。

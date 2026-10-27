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
16 个 ANSI 槽位的取值与
[Catppuccin for Windows Terminal](https://github.com/catppuccin/windows-terminal) 和
[Catppuccin for VS Code](https://github.com/catppuccin/vscode) 完全一致，所以 Xshell 里的效果
和你本地终端、编辑器是同一套颜色。

Catppuccin **没有官方 Xshell 移植**（没有 `catppuccin/xshell` 仓库，
[netsarang/Xshell-ColorScheme](https://github.com/netsarang/Xshell-ColorScheme) 的 250+ 套方案里也没有），
本仓库补上这个空缺。

## 四套配色

| Flavor | 背景 | 前景 | 适合 |
| --- | --- | --- | --- |
| **Latte** | `#EFF1F5` | `#4C4F69` | 明亮环境、白天 |
| **Frappé** | `#303446` | `#C6D0F5` | 光线较暗 |
| **Macchiato** | `#24273A` | `#CAD3F5` | 介于两者之间 |
| **Mocha** | `#1E1E2E` | `#CDD6F4` | 暗环境、夜间 |

## 安装

### 方式 A — 脚本（推荐）

```powershell
git clone https://github.com/<you>/Catppuccin-Xshell.git
cd Catppuccin-Xshell
powershell -ExecutionPolicy Bypass -File .\install.ps1
```

脚本会自动找到
`%USERPROFILE%\Documents\NetSarang Computer\<版本>\Xshell\ColorScheme Files`
（包括被 OneDrive 重定向的「文档」），把四个 `.scs` 复制进去并打印结果。

```powershell
.\install.ps1 -Destination 'D:\backup\xshell-schemes'   # 装到指定目录
.\install.ps1 -Uninstall                                # 卸载
```

Xshell 至少要先启动过一次，否则这个目录还不存在。

### 方式 B — 手动复制

把四个 `Catppuccin *.scs` 复制到：

```
%USERPROFILE%\Documents\NetSarang Computer\<版本>\Xshell\ColorScheme Files\
```

Xshell 8 就是 `8`，Xshell 7 就是 `7`。**注意不是程序安装目录**（`Xshell.exe` 所在的地方）——
用户配色存在「文档」里，升级 Xshell 不会丢。

### 方式 C — 从界面导入

`工具 → 配色方案 → 导入`，选中 `.scs` 文件即可。

## 启用

1. 重启 Xshell（配色列表在启动时构建）。
2. `工具 → 配色方案`，选中 **Catppuccin Mocha**（或其它 flavor），确定。
3. 只给单个会话用：右键会话 → `属性 → 外观 → 配色方案`。

列表里显示的名字就是文件名，所以文件保留了 `Catppuccin ` 前缀。

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

## 自制 flavor

复制一个文件，改小写十六进制值（不带 `#`），保留 19 个键，再存成 UTF-16：

```powershell
$path = '.\Catppuccin Mocha.scs'
$text = Get-Content -LiteralPath $path -Raw
[System.IO.File]::WriteAllText($path, $text, (New-Object System.Text.UnicodeEncoding($false, $true)))
```

所有颜色的十六进制值见
[调色板表](https://github.com/catppuccin/catppuccin#-palette)。放进 `ColorScheme Files` 后重启即出现在列表里。

## 排错

| 现象 | 处理 |
| --- | --- |
| 列表里找不到方案 | 放错目录（放进了程序目录而不是「文档」）、版本号目录不对、或者没重启 Xshell。 |
| 名字乱码 / 方案被拒绝 | 文件存成了 UTF-8，重新存为 UTF-16 LE + BOM。 |
| 粗体看起来发灰 | 正常现象：粗体走 bright 槽位，Catppuccin 的 bright 与普通色很接近。想更分明就改 `*(bold)` 键。 |
| TUI 程序颜色发暗、像 256 色 | Xshell 没开真彩色（`Xshell.ini` 里 `TrueColorTerminal=1`，或会话里的对应选项）。 |
| 只想改某个会话 | 在那一个会话的属性里选配色方案，不要动全局列表。 |

## 兼容性

在 Windows 11 + **Xshell 8.0.0099** 上验证。`.scs` 是 Xshell 8 自带的格式；部分旧版本和大多数
社区包用的是 `.xcs`，结构不同（方案名作节标题，另加 `[Names]` 块）。如果你的 Xshell 只认 `.xcs`：

```ini
[Catppuccin Mocha]
; ...同样这 19 个键...
[Names]
count=1
name0=Catppuccin Mocha
```

## 致谢

- 调色板：[Catppuccin Org](https://github.com/catppuccin/catppuccin)，MIT。
- 槽位映射参考 [catppuccin/windows-terminal](https://github.com/catppuccin/windows-terminal)
  与 [catppuccin/vscode](https://github.com/catppuccin/vscode)。
- 非官方移植，与 Catppuccin、NetSarang 均无隶属关系。

MIT 协议，见 [LICENSE](LICENSE)。

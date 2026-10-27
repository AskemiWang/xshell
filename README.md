<h1 align="center">Catppuccin for Xshell</h1>

<p align="center">
  Soothing pastel colour schemes for <a href="https://www.netsarang.com/en/xshell/">NetSarang Xshell</a><br/>
  Latte · Frappé · Macchiato · Mocha
</p>

<p align="center">
  <b>English</b> · <a href="README.zh-CN.md">简体中文</a>
</p>

---

Four ready-to-use Xshell colour schemes built from the official
[Catppuccin](https://github.com/catppuccin/catppuccin) palette. The 16 ANSI slots are taken from
Catppuccin's terminal mapping — the exact values shipped by
[Catppuccin for Windows Terminal](https://github.com/catppuccin/windows-terminal) — and it is the
same palette [Catppuccin for VS Code](https://github.com/catppuccin/vscode) puts in its integrated
terminal, so an Xshell session looks like your local terminal and your editor.

Catppuccin has **no official Xshell port** (there is no `catppuccin/xshell` repository, and the
250+ schemes in [netsarang/Xshell-ColorScheme](https://github.com/netsarang/Xshell-ColorScheme)
do not include it). This repository fills that gap.

## Before you start: TERM and 256 colours

Xshell 8 introduces itself to the server as a plain `xterm`, and under `xterm` the terminfo
database says **8 colours**. The schemes still paint all 16 slots — the 16-colour test below shows
every one of them — but well-behaved programs (`ls`, `git`, `vim`, `htop`) obey terminfo and simply
never ask for slots 8–15, so the brighter half of the palette goes unused.

You have two options.

### Option A — declare 256 colours (recommended)

Add this to `~/.bashrc` **on the server**:

```bash
case "$TERM" in
  xterm) export TERM=xterm-256color ;;
esac
```

Reconnect, or `source ~/.bashrc`, then check:

```bash
echo $TERM      # xterm-256color
tput colors     # 256
```

**Why the shell profile and not Xshell's setting:** Xshell's *Terminal Type* list usually only
offers legacy values (`xterm`, `vt100`, `vt220`, …), and some servers overwrite `TERM` in
`/etc/profile`; `~/.bashrc` runs after that and wins.

**Why the `case` guard:** inside `tmux` or `screen`, `TERM` is `screen-256color`. Overwriting it
unconditionally makes those programs misread the terminal; the guard upgrades only a plain `xterm`.

### Option B — change nothing

Everything here still works: all four flavours render exactly as specified (see
[Compatibility](#compatibility)). The consequence is only that programs which consult terminfo stay
in 8-colour mode:

| | `TERM=xterm` | `TERM=xterm-256color` |
|---|---|---|
| `ls --color` | the basic 8-colour set | also uses the bright slots |
| `git log --graph` | fine | same colours, slightly more contrast |
| `vim` | `t_Co=8` | `t_Co=256` |
| the 16-slot test (explicit `90`–`97` SGR) | all 16 slots | all 16 slots |

The practical loss is small: Catppuccin maps slots 9–14 to the same hex as 1–6, so only `black` /
`brightBlack` and `white` / `brightWhite` actually differ. If you have never missed bright colours,
Option B costs you nothing — just know that `tput colors` reporting `8` is expected, not a broken
install.

![Catppuccin palettes for Xshell: Latte, Frappé, Macchiato and Mocha](assets/preview.svg)

## Flavours

| Flavour | Background | Foreground | Use it for |
| --- | --- | --- | --- |
| **Latte** | `#EFF1F5` | `#4C4F69` | light rooms, bright screens |
| **Frappé** | `#303446` | `#C6D0F5` | dim rooms |
| **Macchiato** | `#24273A` | `#CAD3F5` | the middle ground |
| **Mocha** | `#1E1E2E` | `#CDD6F4` | dark rooms, night work |

## Install

Xshell imports colour schemes directly, so there is only one step.

1. Download this repository — green **Code** button → **Download ZIP**, or `git clone` — and unpack it.
2. In Xshell open `Tools → Color Schemes…`
3. Click **Import**, pick `Catppuccin Mocha.scs` (or another flavour).
4. Repeat for the remaining flavours — one import per file.
5. The schemes are now in the list; select one and confirm.

## Apply

- **All sessions:** `Tools → Color Schemes`, select the flavour, confirm.
- **One session only:** right-click the session → `Properties → Appearance → Color scheme`.

The name in the list is the file name, which is why the files keep the `Catppuccin ` prefix.

## Verify

Paste this into the session to confirm the 16 slots are live:

```bash
printf 'TERM=%s  colors=%s\n\n' "$TERM" "$(tput colors 2>/dev/null)"
i=0
while [ $i -le 15 ]; do
  if [ $i -lt 8 ]; then fg=$((30+i)); bg=$((40+i)); else fg=$((90+i-8)); bg=$((100+i-8)); fi
  printf '\033[%sm%-14s\033[0m \033[%sm              \033[0m \033[1;%smBOLD\033[0m\n' "$fg" "ANSI $i" "$bg" "$fg"
  i=$((i+1))
done
```

You should get 16 labelled rows, each with a solid block behind the label; those block colours must
match the palette table. The bright rows still render when `tput colors` reports `8` — that number
describes what programs *ask for*, not what the terminal *can show*.

## Palette

Every scheme defines 16 ANSI slots plus a background and a foreground. Bold uses the "bright"
variants, exactly like Windows Terminal's `brightBlack` … `brightWhite`.

| ANSI | Role | Latte | Frappé | Macchiato | Mocha |
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
| 9–14 | bright red … bright cyan | same as 1–6 | same as 1–6 | same as 1–6 | same as 1–6 |
| 15 | bright white | `#BCC0CC` | `#A5ADCE` | `#A5ADCB` | `#A6ADC8` |

The foreground (`text`) is Latte `#4C4F69`, Frappé `#C6D0F5`, Macchiato `#CAD3F5`,
Mocha `#CDD6F4`.

## What is inside the file

Each `.scs` is a tiny INI file with exactly 19 keys — no more, no less:

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

Two details matter if you edit them:

- **Encoding is UTF-16 LE with a BOM and CRLF line endings.** That is what Xshell 8's own schemes
  use; a file saved as UTF-8 shows up garbled or is rejected. Every file here is exactly 676 bytes.
- **No cursor, selection or tab colours.** The format has no keys for them; Xshell controls those
  separately in the session properties.

## Known behaviour (not bugs)

- **ANSI 1–6 and their bright variants are identical.** Catppuccin maps `brightRed` to the same hex
  as `red`, so bold red is bold, not brighter.
- **On the dark flavours `brightWhite` is darker than `white`.** The bright slots follow the
  palette's Overlay/Subtext ordering rather than "brighter".
- **Latte's `white` is the same colour as `brightBlack` (`#ACB0BE`)** — 1.91:1 against `#EFF1F5`.
  ANSI white text is therefore deliberately faint; override that single key if a TUI uses white
  for body text.
- **Contrast is low by design.** The pastel accents sit around 2–3:1 on their own background
  (Latte's yellow is 2.31:1, Mocha's bright black 2.46:1). These are the upstream values, not a
  conversion mistake.

## Troubleshooting

| Symptom | Fix |
| --- | --- |
| Imported, but the scheme is not in the list | Restart Xshell, then check that the import actually completed (`Tools → Color Schemes`). Xshell stores schemes under `%USERPROFILE%\Documents\NetSarang Computer\<version>\Xshell\ColorScheme Files`; the folder is created the first time Xshell runs. |
| Garbled name / scheme rejected | File was saved as UTF-8. Re-save as UTF-16 LE with BOM. |
| Bold text looks washed out | By design: bold maps to the bright slots, which Catppuccin keeps close to the normal ones. Edit the `*(bold)` keys if you want more separation. |
| TUI apps look 256-colour | Xshell's true-colour mode is off (`TrueColorTerminal=1` in `Xshell.ini`, or the matching session option). |
| A run of text suddenly gets a cyan background | True-colour is off and the terminal parses `48;2;r;g;b` piecewise — the trailing `46` is read as "cyan background". Same fix as above. |
| `tput colors` says 8 / bright colours seem missing | See [Before you start](#before-you-start-term-and-256-colours). |
| Only one session should change | Set the scheme in that session's properties instead of the global list. |

## Compatibility

Tested with **Xshell 8.0.0099** on Windows 11. All four flavours were pixel-sampled from real
Xshell windows: every one of the 16 slots rendered exactly the hex value in the file, with no
colour-management shift. The `.scs` format is what Xshell 8 ships; some older builds and most
community packs use `.xcs` instead, which is a different layout (the scheme name is the section
header, plus a `[Names]` block). If your Xshell only accepts `.xcs`, rename the section and append
the names block:

```ini
[Catppuccin Mocha]
; ...the same 19 keys...
[Names]
count=1
name0=Catppuccin Mocha
```

## Credits

- Palette: [Catppuccin Org](https://github.com/catppuccin/catppuccin), MIT — the required
  copyright and permission notice is reproduced in [LICENSE-Catppuccin](LICENSE-Catppuccin).
- Slot mapping follows [catppuccin/windows-terminal](https://github.com/catppuccin/windows-terminal);
  the palette is shared with [catppuccin/vscode](https://github.com/catppuccin/vscode).
- This is an unofficial port, not affiliated with Catppuccin or NetSarang. The Catppuccin name and
  logo belong to the Catppuccin Org; the name is used here only to say what is being ported, and no
  logo is bundled.

MIT licensed — see [LICENSE](LICENSE).

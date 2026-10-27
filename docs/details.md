# Catppuccin for Xshell — everything else

The [README](../README.md) is just the install steps. This file has the rest: why half the palette
can go missing, what the numbers mean, and what to check when something looks wrong.

## 1. TERM, and why half the palette can go unused

When Xshell connects, it introduces itself as a plain `xterm`. In the terminfo database, `xterm`
means **8 colours**.

So here's the odd part: our schemes define all 16 slots and Xshell draws every one of them (see
[section 4](#4-check-that-it-actually-worked)). But programs like `ls`, `git`, `vim` and `htop`
trust terminfo, so they never ask for slots 8–15. Half the palette just sits there unused.

Two ways to deal with it.

### 1.1 Tell the server it has 256 colours (recommended)

Add this to `~/.bashrc` **on the server**:

```bash
case "$TERM" in
  xterm) export TERM=xterm-256color ;;
esac
```

Reconnect (or `source ~/.bashrc`) and check:

```bash
echo $TERM      # xterm-256color
tput colors     # 256
```

Why not set it in Xshell? Its *Terminal Type* dropdown usually only has `xterm`, `vt100`, `vt220`
and friends. And plenty of servers rewrite `TERM` in `/etc/profile` anyway — `~/.bashrc` runs after
that, so it wins.

Why the `case`? Inside tmux or screen, `TERM` is `screen-256color`. Overwriting that blindly makes
those programs misread the terminal. The guard only upgrades a plain `xterm`.

### 1.2 Leave it alone

Nothing breaks. All four flavours still render exactly as specified.

| | `TERM=xterm` | `TERM=xterm-256color` |
|---|---|---|
| `ls --color` | the basic 8 colours | also uses the bright slots |
| `git log --graph` | fine | same colours, a bit more contrast |
| `vim` | `t_Co=8` | `t_Co=256` |
| 16-slot test (explicit `90`–`97`) | all 16 | all 16 |

Honestly, the loss is small: slots 9–14 use the same hex as 1–6, so only `black` / `brightBlack`
and `white` / `brightWhite` really differ. If `tput colors` says 8 and you're happy with it, that's
a perfectly valid setup.

## 2. The palette

Every scheme has 16 ANSI slots plus a background and a foreground. Bold uses the "bright" variants,
same as Windows Terminal's `brightBlack` … `brightWhite`.

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

Foreground (`text`): Latte `#4C4F69`, Frappé `#C6D0F5`, Macchiato `#CAD3F5`, Mocha `#CDD6F4`.

These are the same values [catppuccin/windows-terminal](https://github.com/catppuccin/windows-terminal)
ships, so an Xshell session matches your local terminal.

## 3. What's inside a .scs

A plain INI file with exactly 19 keys. That's the whole format.

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

Two things to know if you edit one:

- **UTF-16 LE with a BOM, CRLF line endings.** That's what Xshell 8 writes itself. Save as UTF-8 and
  the scheme shows up garbled or gets rejected. Every file here is exactly 676 bytes.
- **No cursor, selection or tab colours.** The format simply has no keys for them — Xshell handles
  those in the session properties.

## 4. Check that it actually worked

Paste this into a session:

```bash
printf 'TERM=%s  colors=%s\n\n' "$TERM" "$(tput colors 2>/dev/null)"
i=0
while [ $i -le 15 ]; do
  if [ $i -lt 8 ]; then fg=$((30+i)); bg=$((40+i)); else fg=$((90+i-8)); bg=$((100+i-8)); fi
  printf '\033[%sm%-14s\033[0m \033[%sm              \033[0m \033[1;%smBOLD\033[0m\n' "$fg" "ANSI $i" "$bg" "$fg"
  i=$((i+1))
done
```

You should get 16 rows, each with a solid block behind the label. Compare those blocks with the
table above — they must match exactly. The bright rows still draw even when `tput colors` says 8;
that number is about what programs *ask for*, not what the terminal *can show*.

## 5. Things that look broken but aren't

- **Bold looks the same as normal.** Catppuccin maps `brightRed` to the same hex as `red`, so bold
  is just bold — not brighter.
- **On the dark flavours `brightWhite` is darker than `white`.** The bright slots follow the
  palette's Overlay/Subtext order, not "brighter is later".
- **Latte's `white` is the same as `brightBlack`** (`#ACB0BE`), which is 1.91:1 against `#EFF1F5`.
  White text is meant to be faint there. If some TUI uses white for body text, change that one key.
- **Contrast is low, on purpose.** The pastel accents sit around 2–3:1 (Latte yellow 2.31:1, Mocha
  bright black 2.46:1). Those are upstream values, not a conversion mistake.

## 6. Troubleshooting

| Symptom | What to do |
| --- | --- |
| Imported, but it's not in the list | Restart Xshell. If it's still missing, check that the import finished. Xshell keeps schemes in `%USERPROFILE%\Documents\NetSarang Computer\<version>\Xshell\ColorScheme Files`; that folder appears the first time Xshell runs. |
| Garbled name, or the scheme is rejected | The file was saved as UTF-8. Re-save as UTF-16 LE with BOM. |
| Bold text looks washed out | That's the design (see section 5). Edit the `*(bold)` keys if you want more separation. |
| A block of text suddenly has a cyan background | True-colour is off and the terminal parses `48;2;r;g;b` piece by piece — the trailing `46` becomes "cyan background". Set `TrueColorTerminal=1` in `Xshell.ini`, or the matching session option. |
| TUI apps look 256-colour-ish | Same as above: true-colour is off. |
| `tput colors` says 8 | See section 1. |
| Only one session should change | Set the scheme in that session's properties, not the global list. |

## 7. Compatibility

Tested on **Xshell 8.0.0099** (Windows 11). All four flavours were pixel-sampled from real Xshell
windows: all 16 slots rendered exactly the hex in the file, no colour-management shift.

`.scs` is what Xshell 8 ships. Some older builds and most community packs use `.xcs`, which is a
different layout — the scheme name is the section header, plus a `[Names]` block. If yours only
accepts `.xcs`, rename the section and append the block:

```ini
[Catppuccin Mocha]
; ...the same 19 keys...
[Names]
count=1
name0=Catppuccin Mocha
```

## 8. Credits

- Palette: [Catppuccin Org](https://github.com/catppuccin/catppuccin), MIT. The required copyright
  and permission notice is reproduced in [LICENSE-Catppuccin](../LICENSE-Catppuccin).
- Slot mapping follows [catppuccin/windows-terminal](https://github.com/catppuccin/windows-terminal);
  the palette is shared with [catppuccin/vscode](https://github.com/catppuccin/vscode).
- Unofficial port. Not affiliated with Catppuccin or NetSarang. The Catppuccin name and logo belong
  to the Catppuccin Org; the name is used only to say what is being ported, and no logo is bundled.

MIT licensed — see [LICENSE](../LICENSE).

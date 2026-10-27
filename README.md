# Catppuccin for Xshell

<p align="center">
  <b>English</b> · <a href="README.zh-CN.md">简体中文</a>
</p>

Catppuccin in four flavours for NetSarang Xshell — Latte, Frappé, Macchiato and Mocha.

| Latte | Frappé |
|:--:|:--:|
| <img src="assets/screenshots/latte.png" width="420"> | <img src="assets/screenshots/frappe.png" width="420"> |

| Macchiato | Mocha |
|:--:|:--:|
| <img src="assets/screenshots/macchiato.png" width="420"> | <img src="assets/screenshots/mocha.png" width="420"> |

## 1. Grab the files

Hit the green **Code** button → **Download ZIP**, or just `git clone` it. Unzip or clone it wherever
you like.

## 2. Import them

Open Xshell, go to `Tools → Color Schemes…`, click **Import** and pick
`Catppuccin Mocha.scs`.

Want all four? Import the other three the same way, one file at a time.

## 3. Pick one

Still in that window — select a scheme, hit OK.

Only want it for a single session? Right-click the session →
`Properties → Appearance → Color scheme`.

## 4. Recommended: let the bright colours through

When Xshell connects, it reports an old name for itself: `xterm`. In the system's records, `xterm`
has **8 colours**.

But Xshell can show 16, and the schemes here define 16. The catch is that `ls`, `git`, `vim` and
friends are well-behaved: if the terminal says 8, they pick from the first 8 and never touch the
brighter half.

| | leave it alone | set it |
|---|---|---|
| what programs think they have | 8 colours | 256 colours |
| our 16 slots | still displayed | still displayed |
| `vim`, `htop` and other full-screen apps | 8-colour mode, plain highlighting | 256-colour mode, more depth |

Add three lines to `~/.bashrc` **on the server**:

```bash
case "$TERM" in
  xterm) export TERM=xterm-256color ;;
esac
```

Reconnect, then run `tput colors` — it should print `256`.

Skipping it is not broken. It just means buying a box of 16 crayons and using 8 of them.

---

Palette tables, troubleshooting and compatibility notes live in [docs/details.md](docs/details.md).

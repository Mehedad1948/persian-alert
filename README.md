# Persian Alert

A tiny Windows tray app that **beeps when you start typing in Persian**, so you notice before you've written a whole sentence in the wrong keyboard layout.

- Beeps **once** when Persian typing starts, then stays quiet until you type in another language or switch to a different window.
- Never beeps in apps where Persian is expected (Telegram by default — configurable).
- Turn it on/off with **Ctrl+Alt+P** or by clicking the tray icon.

Windows only.

## Privacy

Persian Alert only looks at each typed character in memory to decide whether it is Persian. It **never stores, logs, or sends** what you type, and it has no network code. The whole app is one readable file: [`src/PersianAlert.ahk`](src/PersianAlert.ahk).

## Install

1. Download `PersianAlert.exe` from the [latest release](../../releases/latest).
2. Put it in a permanent folder, for example `C:\Users\<you>\Apps\PersianAlert\`. Its `settings.ini` is created next to it.
3. Double-click it. A notification confirms it is running; the icon sits in the tray (click **^** next to the clock if you don't see it).
4. Right-click the tray icon → **Start with Windows** to launch it automatically.

### Windows or antivirus warnings

The exe is not code-signed, and it watches keystrokes (needed to detect Persian typing), so Windows SmartScreen or antivirus may warn about it:

- **SmartScreen** ("Windows protected your PC"): click **More info → Run anyway**.
- **Antivirus**: this is a known false positive for apps built with AutoHotkey. If you'd rather not allow an exe, [run it from source](#run-from-source) instead.

To check that your download is exactly the file built by this repository's GitHub Actions, compare its hash with `PersianAlert.exe.sha256` from the same release:

```powershell
Get-FileHash .\PersianAlert.exe -Algorithm SHA256
```

## Use

| Action | How |
|---|---|
| Turn on/off | **Ctrl+Alt+P**, or click the tray icon. The icon shows **S** while off. |
| Change settings | Tray menu → **Edit settings**, save, then **Reload settings** |
| Start with Windows | Tray menu → **Start with Windows** |
| Quit | Tray menu → **Exit** |

## Settings

`settings.ini` sits next to the app:

```ini
[General]
ToggleHotkey=^!p

[Beep]
Frequency=1500
DurationMs=150

[Apps]
Ignore=Telegram.exe
Only=
```

| Setting | Meaning |
|---|---|
| `ToggleHotkey` | On/off shortcut. `^` = Ctrl, `!` = Alt, `+` = Shift, `#` = Win |
| `Frequency` | Beep pitch in Hz (37–32767) |
| `DurationMs` | Beep length in milliseconds (1–2000) |
| `Ignore` | Comma-separated apps that never beep |
| `Only` | If set, only these apps beep |

Keep comments on their own lines starting with `;` — a comment after a value becomes part of the value.

Find an app's program name in **Task Manager → Details → Name** (for example `chrome.exe`, `Code.exe`, `WhatsApp.exe`).

## Uninstall

Tray menu → uncheck **Start with Windows** → **Exit**, then delete the folder.

## Run from source

1. Install [AutoHotkey v2](https://www.autohotkey.com/) (`winget install AutoHotkey.AutoHotkey`).
2. Double-click `src/PersianAlert.ahk`.

## Build

```powershell
./build.ps1
```

This downloads pinned versions of AutoHotkey and its compiler (Ahk2Exe) into `.tools/`, verifies their SHA-256 hashes, and writes `dist/PersianAlert.exe` plus its `.sha256` file.

## Release

1. Update the version in both `APP_VERSION` and `;@Ahk2Exe-SetVersion` in `src/PersianAlert.ahk`.
2. Commit, then tag and push:
   ```powershell
   git tag v1.0.1
   git push origin main v1.0.1
   ```
3. GitHub Actions builds the exe from the tagged source and publishes the release with its SHA-256 file.

## License

[MIT](LICENSE)

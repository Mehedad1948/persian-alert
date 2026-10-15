# Persian Alert

**English** | [فارسی](README.fa.md)

Beeps once when you start typing in Persian, so you can switch to English in time. Windows only.

## Install

1. Download `PersianAlert.exe` from the [latest release](https://github.com/Mehedad1948/persian-alert/releases/latest).
2. Put it in a permanent folder and run it.
3. Right-click the tray icon → **Start with Windows**.

If Windows shows "Windows protected your PC", click **More info → Run anyway**. The app isn't code-signed.

## Use

- **Ctrl+Alt+P** or click the tray icon: turn on/off.
- Tray menu → **Edit settings**, then **Reload settings**.
- Uninstall: uncheck **Start with Windows**, click **Exit**, delete the folder.

## Settings

`settings.ini` is created next to the app:

- `Ignore=Telegram.exe`: apps that never beep, comma-separated. Find names in Task Manager → Details.
- `Only=`: if set, only these apps beep.
- `ToggleHotkey=^!p`: on/off shortcut. `^` Ctrl, `!` Alt, `+` Shift, `#` Win.
- `Frequency=1500`, `DurationMs=150`: beep pitch and length.

## Privacy and safety

- Typed characters are checked in memory only. Nothing is saved or sent, and there is no network code.
- All the code is in [`src/PersianAlert.ahk`](src/PersianAlert.ahk).
- v1.0.0 scan: [VirusTotal](https://www.virustotal.com/gui/file/7bc4e97504a7260b590dc4dd1fee0798a12f0b35072074025b23f1b499570ce3), no engine flagged it.
- Some antivirus may still flag it, which is common for AutoHotkey apps. To avoid the exe, install [AutoHotkey v2](https://www.autohotkey.com/) and run `src/PersianAlert.ahk` instead.
- To verify a download, compare `Get-FileHash PersianAlert.exe` with the release's `.sha256` file.

## Develop

- Build: `./build.ps1` creates `dist/PersianAlert.exe` using pinned, hash-verified tools.
- Release: update `APP_VERSION` and `;@Ahk2Exe-SetVersion`, then run `git tag vX.Y.Z` and `git push origin main vX.Y.Z`. GitHub Actions builds and publishes it.

## License

[MIT](LICENSE)

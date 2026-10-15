<div dir="rtl">

# Persian Alert (هشدار تایپ فارسی)

[English](README.md) | **فارسی**

وقتی شروع به تایپ فارسی می‌کنید، یک بار بوق می‌زند تا به‌موقع به انگلیسی برگردید. فقط برای ویندوز.

## نصب

1. فایل `PersianAlert.exe` را از [آخرین نسخه](https://github.com/Mehedad1948/persian-alert/releases/latest) دانلود کنید.
2. آن را در یک پوشه‌ی ثابت بگذارید و اجرا کنید.
3. روی آیکون کنار ساعت راست‌کلیک کنید ← **Start with Windows**.

اگر ویندوز پیام «Windows protected your PC» را نشان داد، روی **More info** و بعد **Run anyway** کلیک کنید. برنامه امضای دیجیتال ندارد.

## استفاده

- **Ctrl+Alt+P** یا کلیک روی آیکون: روشن یا خاموش کردن.
- منوی آیکون ← **Edit settings**، سپس **Reload settings**.
- حذف: تیک **Start with Windows** را بردارید، **Exit** را بزنید و پوشه را پاک کنید.

## تنظیمات

فایل `settings.ini` کنار برنامه ساخته می‌شود:

- `Ignore=Telegram.exe`: برنامه‌هایی که هرگز بوق نمی‌زنند، با کاما جدا شوند. نام‌ها را در Task Manager ← Details پیدا کنید.
- `Only=`: اگر پر شود، فقط همین برنامه‌ها بوق می‌زنند.
- `ToggleHotkey=^!p`: میان‌بر روشن/خاموش. `^` یعنی Ctrl، `!` یعنی Alt، `+` یعنی Shift و `#` یعنی Win.
- `Frequency=1500` و `DurationMs=150`: زیر و بمی و مدت بوق.

## حریم خصوصی و امنیت

- حروف تایپ‌شده فقط در حافظه بررسی می‌شوند. چیزی ذخیره یا ارسال نمی‌شود و برنامه کدی برای اتصال به اینترنت ندارد.
- کل کد در [`src/PersianAlert.ahk`](src/PersianAlert.ahk) است.
- ممکن است آنتی‌ویروس هشدار بدهد؛ این برای برنامه‌های AutoHotkey رایج است. اگر نمی‌خواهید exe را اجرا کنید، [AutoHotkey v2](https://www.autohotkey.com/) را نصب کنید و `src/PersianAlert.ahk` را اجرا کنید.
- برای بررسی فایل دانلودشده، خروجی `Get-FileHash PersianAlert.exe` را با فایل `.sha256` همان نسخه مقایسه کنید.

## توسعه

- ساخت: `./build.ps1` فایل `dist/PersianAlert.exe` را با ابزارهای نسخه‌ثابت و بررسی‌شده می‌سازد.
- انتشار: `APP_VERSION` و `;@Ahk2Exe-SetVersion` را به‌روز کنید، بعد `git tag vX.Y.Z` و `git push origin main vX.Y.Z` را اجرا کنید. GitHub Actions آن را می‌سازد و منتشر می‌کند.

## مجوز

[MIT](LICENSE)

</div>

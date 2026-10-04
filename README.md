# Synaptics Virus Remover: Easy Guide

> **This tool was written by [SineStriker](https://github.com/SineStriker).**
> Original project: **https://github.com/SineStriker/synaptics-recover**
>
> All of the virus-removal code is SineStriker's work. This repository does **not** change that code.
> It only adds an easy way to build the program yourself and step-by-step guides for beginners.
> It uses the same license as the original: **GPL-3.0** (see [LICENSE](LICENSE)).

This tool cleans the **"Synaptics" virus** out of infected programs (`.exe`) and Excel files.
The infected programs then work again, without the virus.

The virus often comes with cracked or "loader" software for car diagnostic tools,
for example VCDS loaders for cloned HEX-V2 cables or software from cheap OBD scanner CDs.

---

## Do I have this virus?

You probably have it if:

- Your antivirus says a file is infected with **Synaptics**, **Zegost** or **Backdoor.Synaptics**.
- There is a file named **`C:\ProgramData\Synaptics\Synaptics.exe`**.
  (`ProgramData` is hidden. Type `C:\ProgramData` into the File Explorer address bar to open it.)
- Task Manager shows a process called **"Synaptics Pointing Device Driver"** that runs from `C:\ProgramData\Synaptics`.

> ⚠️ **Do not confuse it with the real touchpad driver.** Many laptops have a genuine Synaptics
> touchpad driver in `C:\Program Files\Synaptics\` (files like `SynTPEnh.exe`). That one is safe.
> The virus lives in **`C:\ProgramData\Synaptics`**.

## What the tool does

1. **Stops the virus:** it kills the virus process, deletes its folder and removes it from Windows startup.
2. **Repairs infected programs:** it takes the original, clean program out of the infected `.exe`.
3. **Repairs infected Excel files:** it removes the virus macro from them.

---

## Step 1: Get the program (pick ONE option)

### Option A: Build it yourself (recommended, about 10 minutes)

Why trust a stranger's `.exe`? You don't have to. You can turn the public source code into the
program yourself, on your own PC, without installing anything.

👉 **Follow [HOW-TO-BUILD.md](HOW-TO-BUILD.md).**

### Option B: Download the ready-made program

Go to the [**Releases**](../../releases/latest) page and download:

| File | For |
|---|---|
| `synaptics-recover-64bit.exe` | 64-bit Windows (almost all PCs and laptops) |
| `synaptics-recover-32bit.exe` | 32-bit Windows only (very old PCs) |
| `HOW-TO-USE.txt` | The instructions, so you can carry them on a USB stick |

The release page lists a **SHA256** checksum for each file. You can check that your download
matches it. Open PowerShell in your Downloads folder and run:

```
Get-FileHash .\synaptics-recover-64bit.exe
```

Not sure which Windows you have? Press **Windows key + Pause/Break**, or go to
**Settings → System → About** and look at **"System type"**.

## Step 2: Use it

👉 **Follow [HOW-TO-USE.txt](HOW-TO-USE.txt).** Here is the short version:

1. **Back up** the infected program first.
2. Open **Command Prompt as administrator**, then go to the folder with the tool.
3. Stop the virus, then **restart** the PC:
   ```
   synaptics-recover-64bit.exe -k
   ```
4. Clean your program:
   ```
   synaptics-recover-64bit.exe "C:\path\to\infected.exe" "C:\path\to\clean.exe"
   ```
5. Optional: scan a whole drive, or your USB stick, and repair everything on it:
   ```
   synaptics-recover-64bit.exe C:\
   ```

The tool does **not** need internet and does not install anything.
It works on a PC that is offline. Just copy it over on a USB stick.

---

## Why does my antivirus complain about this tool?

This is on purpose, and it comes from the original design. The virus does not infect programs
it thinks are already infected. So the tool contains the same "Synaptics Pointing Device Driver"
markers as an infected file. The virus then skips the tool, but some antivirus programs flag
it for the same reason. The tool does **not** contain any virus code. You can read every line of it
in the [`src`](src) folder.

If your antivirus deletes it, allow the file or pause real-time protection while you use it.

## Why should I trust this repository?

- **The source code is public.** It is SineStriker's original code, unchanged. You can compare the
  [`src`](src) folder with the [original repository](https://github.com/SineStriker/synaptics-recover).
  The full commit history from SineStriker is kept here.
- **You can build it yourself** ([HOW-TO-BUILD.md](HOW-TO-BUILD.md)), so you never have to trust a download.
- **GitHub builds it too.** Every change is built automatically on GitHub's own servers
  (see the [**Actions**](../../actions) tab), with the full log visible to everyone.

## What this repository adds to the original

| File | What it is |
|---|---|
| `README.md` | This page |
| `HOW-TO-BUILD.md` | Beginner guide to build the program yourself |
| `HOW-TO-USE.txt` | Beginner guide to use the program |
| `build-windows.bat` | Double-click build for Windows (uses w64devkit, nothing to install) |
| `build.sh` | The actual build script (MinGW, no CMake or Visual Studio needed) |
| `build-linux-docker.sh` | Build on Linux inside a temporary Docker container |
| `.github/workflows/build-easy.yml` | Lets GitHub build the program with the same script |
| `ORIGINAL-README.md` | The original README by SineStriker (renamed from `README.md`) |

The original build method (CMake + Visual Studio, described in `ORIGINAL-README.md`) still works too.

## Credits

- **[SineStriker](https://github.com/SineStriker)**: author of
  [synaptics-recover](https://github.com/SineStriker/synaptics-recover), the tool itself.
- Libraries used by the original tool: [pugixml](https://github.com/zeux/pugixml),
  [Boost.Nowide](https://github.com/boostorg/nowide) and [Zippy](https://github.com/troldal/Zippy).
- [w64devkit](https://github.com/skeeto/w64devkit) by skeeto: the portable compiler used in the build guide.
- Easy build scripts and guides: [victorodriguezram](https://github.com/victorodriguezram).

## License

**GPL-3.0**, the same as the original project. The original author chose it because
*"The source code is highly relevant to Synaptics Virus, it is basically useless in other projects,
so release under GPL 3.0."* See [LICENSE](LICENSE).

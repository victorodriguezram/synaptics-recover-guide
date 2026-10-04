# How to build the program yourself

There are 3 ways. **Pick one.** If you are not sure, use **Option A**.

| Option | You need | Time |
|---|---|---|
| **A. On your Windows PC** | Internet once, about 100 MB download | ~10 min |
| **B. On GitHub's servers** | A free GitHub account | ~5 min |
| **C. On Linux** | Docker, or MinGW | ~5 min |

> 💡 **Tip:** if possible, build on a **clean PC** (not the infected one), then copy the program
> to the infected PC with a USB stick. The 64-bit program cannot be infected by this virus, because
> the virus only infects 32-bit programs, so building on the infected PC also works.

---

## Option A: Build on your Windows PC (nothing gets installed)

### Step 1: Download this project

1. At the top of this repository's page, click the green **`<> Code`** button, then click **Download ZIP**.
2. Find the ZIP in your **Downloads** folder. Right-click it, choose **Extract All...**, then click **Extract**.
3. Open the extracted folder. **You should see `build-windows.bat` in it.**
   (Sometimes there is a folder inside a folder. Open folders until you see `build-windows.bat`.)

### Step 2: Download the compiler (w64devkit)

A "compiler" turns source code into a program. **w64devkit** is a free, portable one.
It runs from a folder, so you never install it. When you are done, just delete the folder.

1. Go to **https://github.com/skeeto/w64devkit/releases**
2. On the newest release, open **Assets** and download:
   - **`w64devkit-x64-….7z.exe`**: makes the **64-bit** program (choose this one)
   - `w64devkit-x86-….7z.exe`: only if you need the **32-bit** program
3. Double-click the downloaded file. If Windows says "Windows protected your PC",
   click **More info**, then **Run anyway**.
4. A small window asks **where to extract**. Click the **`...`** button and choose
   **the folder from Step 1** (the one with `build-windows.bat`). Then click **Extract**.
5. Check: next to `build-windows.bat` there is now a folder named **`w64devkit`**.

```
synaptics-recover-guide-main\
├── w64devkit\            ← the folder you just extracted
├── build-windows.bat     ← you will double-click this next
├── build.sh
├── src\
└── ...
```

### Step 3: Build

1. **Double-click `build-windows.bat`.**
2. A black window opens. Wait 1–2 minutes. Some lines that say "warning" are normal.
3. When you see **`SUCCESS!`**, a folder named **`out`** opens. Your program is in it:
   **`synaptics-recover-64bit.exe`** (or `-32bit.exe`).

That's it. Now read **[HOW-TO-USE.txt](HOW-TO-USE.txt)**.

You can delete the `w64devkit` folder, the downloaded `.7z.exe` and the `build` folder afterwards.

### Something went wrong?

| Message | Fix |
|---|---|
| `ERROR: The compiler was not found.` | The `w64devkit` folder is not next to `build-windows.bat`. Repeat Step 2.4. Choose the folder that contains `build-windows.bat`. |
| The window closes immediately | Open the project folder, click the address bar at the top, type `cmd` and press Enter. In the black window, type `build-windows.bat` and press Enter. Now the error stays on screen. |
| Antivirus deletes the new `.exe` | This is expected (see "Why does my antivirus complain" in [README.md](README.md)). Allow the file in your antivirus. |
| `g++: ... No such file` or other errors | Move the project to a short path without special characters, such as `C:\synfix`, and try again. |

---

## Option B: Build on GitHub's servers (nothing on your PC)

GitHub can build the program for you, with the **same** `build-windows.bat`, on a fresh Windows
machine. You can read the full log of everything it did.

1. Sign in to GitHub (a free account is enough).
2. On this repository's page, click **Fork** (top right), then **Create fork**.
3. In **your** fork, click the **Actions** tab. If asked, click
   **"I understand my workflows, go ahead and enable them"**.
4. On the left, click **build**. On the right, click **Run workflow**, then the green **Run workflow** button.
5. Wait about 3–5 minutes until the run gets a green ✓. Click on the run.
6. Scroll down to **Artifacts** and download **`synaptics-recover-x64`** (64-bit) or
   **`synaptics-recover-x86`** (32-bit). It is a ZIP with the `.exe` inside.

---

## Option C: Build on Linux

**With Docker** (nothing is installed on your system, everything happens in a temporary container):

```sh
sh build-linux-docker.sh
# Result: out/synaptics-recover-64bit.exe and out/synaptics-recover-32bit.exe
docker rmi debian:bookworm-slim   # optional: remove the downloaded image afterwards
```

**With MinGW installed** (for example `sudo apt install mingw-w64`):

```sh
sh build.sh x86_64-w64-mingw32-   # 64-bit
sh build.sh i686-w64-mingw32-     # 32-bit
```

---

## For advanced users

- `build.sh` does what the original CMake + Visual Studio build does, but with plain MinGW `g++` and `windres`.
  It embeds the same resources and the same manifest, which asks for Administrator.
  It reads the version and the "disguise" string from the original `CMakeLists.txt` files.
- The original build (CMake + MSVC + VC-LTL5) is described in
  [ORIGINAL-README.md](ORIGINAL-README.md) and `.github/workflows/win-build.yml`.
- The program only links against DLLs that come with Windows
  (kernel32, advapi32, msvcrt, shell32, shlwapi, version), so it runs on an offline PC.

#!/bin/sh
# Builds synaptics-recover-64bit.exe or -32bit.exe into the "out" folder.
# Needs only a MinGW-w64 compiler (no CMake, no Visual Studio).
#   Windows: double-click build-windows.bat (uses w64devkit)
#   Linux:   sh build.sh x86_64-w64-mingw32-   or   sh build.sh i686-w64-mingw32-
set -e
cd "$(dirname "$0")"
P=${1:-}

# Read version and disguise string from the original CMake files so they never drift apart.
VER=$(sed -n 's/^project(synaptics-recover VERSION \([0-9.]*\).*/\1/p' CMakeLists.txt)
DISGUISE=$(sed -n 's/^set(SYNAPTICS_DISGUISE_STRING "\(.*\)")$/\1/p' src/CMakeLists.txt)
case $("${P}gcc" -dumpmachine) in x86_64*) BITS=64bit ;; *) BITS=32bit ;; esac
echo "Building synaptics-recover $VER ($BITS)..."

mkdir -p build/compat out
# The source uses MSVC-style header names (Windows.h); Linux file systems are case-sensitive.
for h in Windows ShlObj TlHelp32 Shlwapi; do
    l=$(echo $h | tr A-Z a-z)
    printf '#pragma once\n#include_next <%s.h>\n' "$l" > build/compat/$h.h
done

# Same values as src/app/CMakeLists.txt + winrc.cmake, plus the manifest MSVC embeds.
sed -e 's|@RC_ICON_COMMENT@|//|' -e 's|@RC_ICON_PATH@||' \
    -e "s|@RC_VERSION@|$(echo "$VER" | tr . ,)|" -e "s|@RC_VERSION_STRING@|$VER|" \
    -e 's|@RC_DESCRIPTION@|Anti-Synaptics CLI Tool|' -e 's|@RC_APPLICATION_NAME@|synaptics-recover|' \
    -e 's|@RC_COPYRIGHT@|Copyright 2023 SineStriker|' -e "s|@RC_DISGUISE_STRING@|$DISGUISE|" \
    src/app/WinResource.rc.in > build/res.rc
echo '1 24 "WinManifest.exe.manifest"' >> build/res.rc
"${P}windres" --include-dir src/app build/res.rc -O coff -o build/res.o

# _WIN32_WINNT=0x0600: Vista+, same minimum as the original VC-LTL build (needed for GetTickCount64).
# -include: MSVC pulls in <utility> (std::as_const) and <cstdint> (uint32_t) implicitly, newer GCC does not.
"${P}g++" -std=c++17 -O2 -s -static -include utility -include cstdint \
    -D_WIN32_WINNT=0x0600 -DUNICODE -D_UNICODE -DAPP_VERSION="\"$VER\"" -DAPP_DISGUISE_STRING="\"$DISGUISE\"" \
    -Ibuild/compat -Isrc/winutils -Isrc/synare \
    -Isrc/synare/external -Isrc/synare/external/nowide -Isrc/synare/external/pugixml -Isrc/synare/external/zippy \
    src/app/main.cpp src/winutils/winutils.cpp src/synare/synare.cpp src/synare/external/pugixml/pugixml.cpp \
    build/res.o -lshlwapi -lversion -lpsapi \
    -o out/synaptics-recover-$BITS.exe

echo "Done: out/synaptics-recover-$BITS.exe"

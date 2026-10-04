#!/bin/sh
# Builds both .exe files on Linux inside a temporary Docker container (nothing is installed on your PC).
# Usage: sh build-linux-docker.sh      Afterwards you can remove the image: docker rmi debian:bookworm-slim
set -e
cd "$(dirname "$0")"
docker run --rm -v "$PWD":/w -w /w debian:bookworm-slim sh -c '
    apt-get update -qq && apt-get install -y -qq --no-install-recommends mingw-w64 >/dev/null
    sh build.sh x86_64-w64-mingw32-
    sh build.sh i686-w64-mingw32-
    chown -R '"$(id -u):$(id -g)"' build out'

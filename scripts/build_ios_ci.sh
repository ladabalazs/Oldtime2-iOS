#!/usr/bin/env bash
set -Eeuo pipefail
mkdir -p ci-logs
exec > >(tee ci-logs/ios-build.log) 2>&1
sw_vers
xcodebuild -version
cmake --version
test -f CMakeLists.iOS.txt || { echo "Missing CMakeLists.iOS.txt"; exit 2; }
test -d clientsource || { echo "Missing clientsource"; exit 2; }
cmake -S . -B build-ios -G Xcode -DCMAKE_SYSTEM_NAME=iOS -DCMAKE_OSX_SYSROOT=iphoneos -DCMAKE_OSX_ARCHITECTURES=arm64 -DCMAKE_XCODE_ATTRIBUTE_CODE_SIGNING_ALLOWED=NO
cmake --build build-ios --config Release -- -jobs 2 CODE_SIGNING_ALLOWED=NO

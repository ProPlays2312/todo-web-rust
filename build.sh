#!/bin/bash

targets=(
    "x86_64-pc-windows-gnu"
    "x86_64-unknown-linux-gnu"
    "i686-pc-windows-gnu"
    # "i686-unknown-linux-gnu"
)
binaries=(
    "todo/target/x86_64-pc-windows-gnu/release/todo.exe"
    "todo/target/x86_64-unknown-linux-gnu/release/todo"
    "todo/target/i686-pc-windows-gnu/release/todo.exe"
    # "todo/target/i686-unknown-linux-gnu/release/todo"
)

build_targets() {
    arr=("$@")
    for target in "${arr[@]}"; do
        cargo build --target "$target" --release > /dev/null 2>&1
    done
    echo "-------------------------------------------"
    echo "[+] Build completed for all targets."
    echo "-------------------------------------------"
}
copy_binaries() {
    binaries=("$@")
    for binary in "${binaries[@]}"; do
        if [[ -f "$binary" ]]; then
            if [[ "$binary" == *x86_64* ]]; then
                cp "$binary" "builds/x64/"
            elif [[ "$binary" == *i686* ]]; then
                cp "$binary" "builds/x86/"
            fi
            echo "[+] Copied $binary to builds directory."
        else
            echo "[-] $binary not found."
        fi
    done
    echo "-------------------------------------------"
    echo "[+] All binaries copied to builds directory."
}
cleanup() {
    echo "-------------------------------------------"
    echo "[+] Cleaning up build artifacts..."
    rm -rf todo/target
    echo "[+] Cleaned up build artifacts."
    echo "-------------------------------------------"
}

build_targets "${targets[@]}"
copy_binaries "${binaries[@]}"
cleanup
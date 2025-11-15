# tasker

## Service

```
sudo ln -s /opt/tasker/tasker.service /etc/systemd/system/tasker.service
sudo systemctl daemon-reload
sudo systemctl enable tasker.service
sudo systemctl start tasker.service


sudo journalctl -u tasker.service -n 50
sudo journalctl -u tasker.service -f
```

## Tauri

```
cd client/
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
sudo apt update
sudo apt install libwebkit2gtk-4.1-dev build-essential curl wget file libssl-dev libgtk-3-dev libayatana-appindicator3-dev librsvg2-dev
source $HOME/.cargo/env
sudo apt install mingw-w64
sudo apt install llvm
rustup target add x86_64-pc-windows-msvc
rustup target add x86_64-pc-windows-gnu
npm run tauri build -- --target x86_64-pc-windows-gnu
cp src-tauri/target/x86_64-pc-windows-gnu/release/app.exe /mnt/c/Users/Louis/Desktop/tasker.exe

WebView2Loader.dll
https://developer.microsoft.com/en-us/microsoft-edge/webview2/#download-section
"Evergreen Standalone Installer"
```

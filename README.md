把 Flutter 嵌入到 Web 應用程式
=======

參考 [Evolving Flutter's support for the web](https://www.youtube.com/watch?v=PY42FysQTgw&t=157)
和 [Adding Flutter to any web application](https://docs.flutter.dev/platform-integration/web/embedding-flutter-web#embedded-mode)
資訊，並以 Flutter v3.29.2 版本製作。


## 實測紀錄

- 使用體驗
  - `flutter create -e --platforms web`：
    - 載入時間 (Chrome 3G 網速)： 86 秒
    - 載入資源大小： 9.8 MB
  - (this project) 單一頁面：
    - 載入時間 (Chrome 3G 網速)： 86 秒
    - 載入資源大小： 9.8 MB
  - (this project) 多頁面：
    - 載入時間 (Chrome 3G 網速)： 78 秒
    - 載入資源大小： 8.5 MB
- 備註
  - 如果資源不放在首頁，Flutter 的建議是使用 `<base>` 標籤。
    (`flutter build web --base-href "/subpath/"`)


## 文件大小紀錄

`flutter create -e --platforms web && flutter build web --release`:

```
28M     build/web
8.0K    build/web/flutter.js
8.0K    build/web/flutter_bootstrap.js
8.0K    build/web/flutter_service_worker.js
1.6M    build/web/main.dart.js
1.7M    build/web/assets/NOTICES
1.3M    build/web/canvaskit/canvaskit.js.symbols
6.7M    build/web/canvaskit/canvaskit.wasm
1.2M    build/web/canvaskit/chromium/canvaskit.js.symbols
5.4M    build/web/canvaskit/chromium/canvaskit.wasm
1.4M    build/web/canvaskit/skwasm.js.symbols
3.3M    build/web/canvaskit/skwasm.wasm
1.4M    build/web/canvaskit/skwasm_st.js.symbols
3.3M    build/web/canvaskit/skwasm_st.wasm
        ...
```

`(this project) && flutter build web --release`:

```
28M     build/web
8.0K    build/web/flutter.js
8.0K    build/web/flutter_bootstrap.js
12K     build/web/flutter_service_worker.js
1.6M    build/web/main.dart.js
1.7M    build/web/assets/NOTICES
1.3M    build/web/canvaskit/canvaskit.js.symbols
6.7M    build/web/canvaskit/canvaskit.wasm
1.2M    build/web/canvaskit/chromium/canvaskit.js.symbols
5.4M    build/web/canvaskit/chromium/canvaskit.wasm
1.4M    build/web/canvaskit/skwasm.js.symbols
3.3M    build/web/canvaskit/skwasm.wasm
1.4M    build/web/canvaskit/skwasm_st.js.symbols
3.3M    build/web/canvaskit/skwasm_st.wasm
        ...
```

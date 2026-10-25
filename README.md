# Malèna

基于 Pixso「Malèna」22 个参考界面开发的 Flutter 时尚购物应用，包含可操作的本地购物流程。

- [项目结构、架构与主要界面](docs/PROJECT.md)
- [全部界面截图索引](docs/SCREENSHOTS.md)
- [Pixso 原稿参考图](docs/design/)
- [Android ARM64 演示安装包](artifacts/malena-android-arm64.apk)

```bash
flutter pub get
flutter run
```

开发环境：Flutter 3.41.6 / Dart 3.11.4。已提供 Android、iOS、Web 工程。

```bash
flutter analyze
flutter test
# 在已启动的 Android 模拟器上测试完整流程并重新生成截图
./tool/capture_screenshots.sh emulator-5554
# 构建 Android 安装包
flutter build apk --release
# 构建 Web
flutter build web --release
```

演示登录可填写任意用户名和至少 6 位密码；也可从欢迎页以访客身份进入。结账时点击「Use demo card」填入演示卡。商品、购物车、账户设置和订单保存在本次运行的内存中，重启会重置。支付、扫码和通知开关为本地演示，没有接入远程服务。

# Android 演示安装包

`malena-android-arm64.apk` 是 Flutter release 模式构建的 ARM64 Android 安装包，约 23 MB。适用于 arm64-v8a 设备和 ARM64 模拟器。

```bash
adb install -r artifacts/malena-android-arm64.apk
```

包名：`com.malena.malena`。版本：`1.0.0+1`。

当前使用 Flutter 模板的开发签名，仅用于本地演示安装；上架时需要配置自有 release 签名。

重建：

```bash
flutter build apk --release --target-platform android-arm64
```

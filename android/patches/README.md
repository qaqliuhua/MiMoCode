# Android Patches

这些补丁用于修复 Android 特定问题。

## 当前需要的补丁

### 1. ripgrep Android binary

MiMoCode 内置 ripgrep binary。需要为 Android 提供：

```bash
# 从源码编译
cargo build --target aarch64-linux-android --release

# 或者下载预编译版本
# https://github.com/BurntSushi/ripgrep/releases
```

### 2. @parcel/watcher fallback

如果 Android 上 @parcel/watcher 不可用，需要确保 fallback 正常工作。

### 3. 环境变量适配

Android 上可能需要设置：
- HOME
- TMPDIR
- MIMOCODE_HOME

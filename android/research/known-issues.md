# Android 已知问题

## 已解决

| 问题 | 状态 | 说明 |
|------|------|------|
| glibc 依赖 | ✅ 已解决 | Android Bun 不需要 glibc |
| musl 依赖 | ✅ 已解决 | Android Bun 不需要 musl |
| PTY 依赖 | ✅ 已解决 | Bun 内置 bun-pty |
| ELF 格式 | ✅ 已解决 | 使用 /system/bin/linker64 |
| PIE 格式 | ✅ 已解决 | DYN 类型 |
| XDG 路径 | ✅ 已解决 | MIMOCODE_HOME 支持 |

## 未解决

| 问题 | 状态 | 说明 |
|------|------|------|
| Bun Runtime crash | ❌ 阻塞 | Segfault at 0x5730000 |
| @parcel/watcher | ⚠️ 无 Android binding | 有 fallback |
| ripgrep | ⚠️ 需提供 Android binary | 可 cargo build |
| clipboard | ⚠️ 需适配 | termux-clipboard-set |
| voice | ⚠️ 需适配 | Android API |

## 依赖项

### Bun Runtime

- 版本：1.3.14
- Android target：bun-linux-arm64-android
- 状态：编译成功，运行时 crash
- Issue：#29675 (closed), #33621 (open)

### @parcel/watcher

- 需要：@parcel/watcher-linux-arm64-android
- 状态：不存在
- 降级方案：polling 或禁用

### ripgrep

- 需要：rg-android-arm64
- 方案：cargo build --target aarch64-linux-android
- 或：使用 grep/find 降级

## 环境变量

Android 上需要设置：
- HOME=/data/local/tmp
- TMPDIR=/data/local/tmp
- MIMOCODE_HOME=/data/local/mimocode-data
- LD_LIBRARY_PATH（如果使用 patchelf）

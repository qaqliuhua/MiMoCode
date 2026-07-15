# Android Runtime Crash 分析

## 现象

```
Bun v1.3.14 (0d9b296a) Linux arm64
Android Kernel v6.1.118 | bionic
CPU: neon fp aes crc32 atomics
Elapsed: 20ms | User: 5ms | Sys: 29ms
RSS: 4.78MB | Peak: 8.66MB | Commit: 4.78MB | Faults: 45

panic(main thread): Segmentation fault at address 0x5730000
```

## 分析

### Crash 特征

1. **发生位置**：Bun 初始化阶段，用户代码未执行
2. **crash 地址**：0x5730000 ≈ 88MB ≈ binary 大小
3. **稳定复现**：每次都在同一地址 crash
4. **无 backtrace**：Trap 信号直接终止

### 可能原因

| 可能性 | 说明 |
|--------|------|
| mmap 问题 | Bun mmap embedded files 在 Android 上失败 |
| 交叉编译 | 在 x86_64 PRoot 中编译 arm64 Android binary |
| Android 限制 | mmap/ASLR/内存布局限制 |
| Bun bug | Android target 的 runtime 初始化 bug |

### 未确定

- relocation
- page alignment
- PIE/RELRO
- Android linker 行为
- embedded snapshot 加载

### 已排除

- MiMoCode 代码问题（Hello World 也 crash）
- ELF 格式问题（linker64 正确识别）
- NEEDED 库问题（libc.so/libm.so/libdl.so 都存在）

## 关联 Issue

- #29675 "Add aarch64-linux-android target" — 已合并，47 个修复
- #33621 "bun build --compile: mmap the source executable" — open
- Bun 1.3.14 是最新版，理论上包含 Android 修复

## 结论

问题在 Bun Runtime，非 MiMoCode。等待 Bun 后续版本修复。

## 重新验证条件

当 Bun 发布新版本时，用以下命令快速验证：

```bash
# 编译
bun build --compile --target=bun-linux-arm64-android test.ts --outfile test-android

# 在设备上运行
chmod +x test-android
./test-android
```

如果能打印 "Hello" 而不 crash，说明 Runtime 修复了。

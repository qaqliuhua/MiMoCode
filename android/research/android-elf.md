# Android ELF 研究

## 验证结果

### bun build --compile --target=bun-linux-arm64-android

✅ 编译成功

```
ELF64 AArch64 DYN (PIE)
Interpreter: /system/bin/linker64
NEEDED: libc.so, libm.so, libdl.so
Size: 88MB
```

### ELF 属性

| 属性 | Android | glibc | musl |
|------|---------|-------|------|
| Interpreter | /system/bin/linker64 ✅ | /lib/ld-linux-aarch64.so.1 | /lib/ld-musl-aarch64.so.1 |
| Type | DYN (PIE) ✅ | EXEC (非 PIE) | EXEC (非 PIE) |
| NEEDED | libc.so, libm.so, libdl.so | 5 个 glibc .so | 3 个 musl .so + libgcc_s |
| GLIBC 依赖 | 无 ✅ | 需要 GLIBC_2.17 | 需要 GLIBC_2.0 (via libgcc_s) |
| RPATH/RUNPATH | 无 | 无 | 无 |

### VERNEED 对比

Android binary 使用 Bionic 版本标签：
- LIBC, LIBC_N, LIBC_O, LIBC_P
- 不需要任何 GLIBC 版本

glibc binary 需要：GLIBC_2.17
musl binary 需要：GLIBC_2.0 (via libgcc_s)

### 关键发现

1. Android Bun compile 输出真正的 Android 原生 binary
2. 使用 Bionic linker，不需要 glibc/musl
3. 是 PIE 格式，符合 Android 要求
4. 只需要 Android 标准库

## 状态

- 编译链：✅ 成立
- 运行时：❌ Segfault
- 责任方：Bun Runtime bug，非 MiMoCode 问题

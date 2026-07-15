# Android Native 研究存档

## 状态：实验性（等待 Bun Runtime 修复）

### 已证明

- ✅ Android Target 存在 (bun-linux-arm64-android)
- ✅ 能生成 /system/bin/linker64 的 Android ELF
- ✅ MiMoCode 无 Android 平台硬编码
- ✅ PTY 方案可行 (bun-pty)

### 未证明

- ❌ Android Compile Binary 可稳定运行
- ❌ Bun Runtime 在 Android 上不 crash

### 责任边界

```
MiMoCode
    ↓
Bun Compile ✅
    ↓
Android Runtime ❌ (Segfault)
    ↓
用户代码 (未执行)
```

问题在 Bun Runtime，非 MiMoCode。

## 文件索引

| 文件 | 内容 |
|------|------|
| android-elf.md | ELF 格式分析 |
| crash.md | Runtime crash 分析 |
| compile.md | Build pipeline 研究 |
| known-issues.md | 已知问题清单 |

## 重新验证流程

当 Bun 发布新版本时：

```bash
# 1. 更新 Bun
bun upgrade

# 2. 编译测试
echo 'console.log("Hello")' > test.ts
bun build --compile --target=bun-linux-arm64-android test.ts --outfile test-android

# 3. 传到设备执行
chmod +x test-android
./test-android

# 4. 如果通过，编译完整 MiMoCode
cd packages/opencode
bun build --compile --target=bun-linux-arm64-android --conditions=browser --outfile=dist/android-arm64/bin/mimo ./src/index.ts
```

## 相关资源

- Bun Android Target: #29675
- Bun mmap issue: #33621
- Bun Android runtime fixes: 47 个 (epoll, DNS, TLS, temp dir, shell spawn)

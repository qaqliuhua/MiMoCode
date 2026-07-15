# Android Build Pipeline 研究

## Build.ts 修改分析

### 当前 target 定义

```typescript
// packages/opencode/script/build.ts
const allTargets: { os: string; arch: "arm64" | "x64"; abi?: "musl"; avx2?: false }[] = [
  { os: "linux", arch: "arm64" },           // glibc
  { os: "linux", arch: "arm64", abi: "musl" }, // musl
  // ... darwin, win32
]
```

### 添加 Android Target 所需修改

```typescript
// 1. allTargets 新增
{ os: "linux", arch: "arm64", abi: "android" }

// 2. 类型定义扩展
abi?: "musl" | "android"

// 3. 生成的构建目标
name: mimocode-linux-arm64-android
bun target: bun-linux-arm64-android
```

**总计：约 5-10 行代码修改**

### 构建命令

```bash
bun build --compile --target=bun-linux-arm64-android \
    --conditions=browser \
    --outfile=dist/android-arm64/bin/mimo \
    ./src/index.ts
```

### MiMoCode 源码中的平台特定代码

| 文件 | 代码 | Android 兼容性 |
|------|------|----------------|
| cron-lock.ts | /proc/pid/stat, /proc/uptime | ✅ |
| clipboard.ts | linux -> xsel | ⚠️ 需适配 |
| voice.ts | linux 录音候选 | ⚠️ 需适配 |
| watcher.ts | inotify | ✅ |
| ripgrep.ts | arm64-linux binary | ⚠️ 需提供 |

### Bun 内置替代

| 依赖 | 替代方案 |
|------|----------|
| @lydell/node-pty | bun-pty (Bun 内置) ✅ |
| @parcel/watcher | 有 fallback，可降级 |
| @opentui/core | 纯 JS/WASM，兼容 |

## 状态

- 构建链：✅ 成立
- 运行时：❌ 被 Bun Runtime bug 阻塞
- 修改量：约 5-10 行

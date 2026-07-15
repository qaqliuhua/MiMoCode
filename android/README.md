# MiMoCode Android Port

## 状态

**Main Branch: chroot + glibc（当前推进）**

**Experimental: Android Native（等待 Bun Runtime 修复）**

## 架构

```
android/
├── build.sh                    # 构建脚本
├── patches/
│   └── README.md               # 补丁说明
├── research/                   # 研究存档
│   ├── README.md               # 研究总览
│   ├── android-elf.md          # ELF 分析
│   ├── crash.md                # Runtime crash 分析
│   ├── compile.md              # Build pipeline 研究
│   └── known-issues.md         # 已知问题
├── scripts/
│   └── setup-device.sh         # 设备端设置
└── README.md                   # 本文件
```

## 路线

### Plan B（当前）：chroot + glibc

直接可用，马上推进。

### Plan A（长期）：Android Native

等待 Bun 修复 Android Compile Runtime 后重新验证。

### Plan C（过渡）：patchelf

减少 chroot 依赖，待 Plan B 跑通后研究。

## 快速验证（Bun 新版本发布时）

```bash
# 更新 Bun
bun upgrade

# 测试 Android compile
echo 'console.log("Hello")' > test.ts
bun build --compile --target=bun-linux-arm64-android test.ts --outfile test-android

# 在设备上执行
chmod +x test-android
./test-android

# 如果通过，编译 MiMoCode
cd packages/opencode
bun build --compile --target=bun-linux-arm64-android --conditions=browser --outfile=dist/android-arm64/bin/mimo ./src/index.ts
```

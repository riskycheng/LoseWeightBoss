# LoseWeightBoss - 体重管理应用

![LoseWeightBoss Banner](./prototypes/docs/Screenshot%202025-04-28%20at%2008.02.53.png)

LoseWeightBoss 是一款专注于体重管理的 iOS 应用，帮助用户通过记录每日体重和身体照片来追踪减重进度。应用提供直观的数据可视化和进度分析，让用户能够清晰地了解自己的减重历程。

## 主要功能

- **每日体重记录**：轻松记录每日体重数据，查看体重变化趋势
- **身体照片记录**：拍摄并保存身体照片，直观对比身体变化
- **历史记录查看**：通过日历和列表查看历史记录
- **数据统计分析**：查看详细的体重趋势图表和数据洞察
- **个人资料管理**：设置个人信息和目标体重

## 应用截图

### 首页/仪表盘
显示用户当前体重、目标进度和照片对比，一目了然地了解减重进度。

![首页/仪表盘](prototypes/docs/Screenshot%202025-04-28%20at%2008.02.53.png)

### 记录页面
用户可以在此记录每日体重和身体照片，界面简洁易用。

![记录页面](prototypes/docs/Screenshot%202025-04-28%20at%2008.03.06.png)

### 历史记录
通过日历和列表形式查看过去的体重和照片记录，轻松追踪历史变化。

![历史记录](prototypes/docs/Screenshot%202025-04-28%20at%2008.03.16.png)

### 统计分析
提供详细的体重趋势图表和数据分析，帮助用户了解减重效果。

![统计分析](prototypes/docs/Screenshot%202025-04-28%20at%2008.03.34.png)

### 个人资料
管理用户信息和应用设置，包括目标体重、个人信息等。

![个人资料](prototypes/docs/Screenshot%202025-04-28%20at%2008.03.43.png)

## 技术实现

- **前端框架**：使用 SwiftUI 构建现代化、流畅的用户界面
- **数据存储**：本地数据存储使用 UserDefaults
- **图像处理**：支持照片拍摄和保存功能
- **数据可视化**：自定义图表组件展示体重趋势
- **状态管理**：采用 ObservableObject 模式管理应用状态

## 项目结构

```
LoseWeightBoss/
├── LoseWeightBoss/           # 主项目文件夹
│   ├── Models/               # 数据模型
│   │   └── WeightRecord.swift
│   ├── Views/                # 视图组件
│   │   ├── MainTabView.swift
│   │   ├── HomeView.swift
│   │   ├── RecordView.swift
│   │   ├── HistoryView.swift
│   │   ├── ProgressView.swift
│   │   └── ProfileView.swift
│   ├── LoseWeightBossApp.swift
│   └── ContentView.swift
└── prototypes/               # 原型设计文件
    ├── docs/                 # 截图和文档
    ├── home.html
    ├── record.html
    ├── history.html
    ├── progress.html
    ├── profile.html
    └── index.html
```

## 开发与安装

### 开发环境要求
- Xcode 15.0 或更高版本
- iOS 17.0 或更高版本
- Swift 5.9 或更高版本

### 安装步骤
1. 克隆或下载项目代码
2. 使用 Xcode 打开 `LoseWeightBoss.xcodeproj` 文件
3. 选择目标设备或模拟器
4. 点击运行按钮或使用快捷键 `Cmd+R` 构建并运行应用

## 设计说明

本项目基于高保真原型设计实现，原型文件位于项目根目录的 `prototypes` 文件夹中。设计遵循 iOS 人机界面指南，提供直观、易用的用户体验。

## 未来计划

- 添加数据云同步功能
- 支持社交分享和挑战功能
- 集成健康数据（如步数、卡路里等）
- 提供更多数据分析和健康建议
- 支持自定义主题和界面定制

## 许可证

本项目采用 MIT 许可证。详情请参阅 LICENSE 文件。

---

© 2025 LoseWeightBoss. 保留所有权利。

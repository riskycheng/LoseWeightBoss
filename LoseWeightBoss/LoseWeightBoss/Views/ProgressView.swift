import SwiftUI

struct ProgressView: View {
    @EnvironmentObject var weightManager: WeightManager
    @State private var selectedPeriod: TimePeriod = .month
    
    enum TimePeriod: String, CaseIterable {
        case week = "周"
        case month = "月"
        case year = "年"
        case all = "全部"
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Header
                    Text("统计分析")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.top)
                    
                    // Time period selector
                    periodSelector
                    
                    // Summary card
                    summaryCard
                    
                    // Weight trend chart
                    weightTrendChart
                    
                    // Body measurements
                    bodyMeasurementsCard
                    
                    // Photo progress
                    photoProgressCard
                    
                    // Insights
                    insightsCard
                    
                    // Export data
                    exportDataCard
                }
                .padding(.horizontal)
                .padding(.bottom, 20)
            }
            .background(Color(UIColor.systemGroupedBackground))
            .navigationBarHidden(true)
        }
    }
    
    var periodSelector: some View {
        HStack {
            ForEach(TimePeriod.allCases, id: \.self) { period in
                Button(action: {
                    selectedPeriod = period
                }) {
                    Text(period.rawValue)
                        .fontWeight(.medium)
                        .padding(.vertical, 8)
                        .frame(maxWidth: .infinity)
                        .background(selectedPeriod == period ? Color.white : Color.clear)
                        .foregroundColor(selectedPeriod == period ? .blue : .gray)
                        .cornerRadius(8)
                }
            }
        }
        .padding(4)
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)
    }
    
    var summaryCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("\(periodTitle)概览")
                .font(.headline)
                .padding(.bottom, 4)
            
            // Weight comparison
            HStack(spacing: 12) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("起始体重")
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    Text("\(String(format: "%.1f", weightManager.userProfile.startWeight))")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text("4月1日")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.blue.opacity(0.1))
                .cornerRadius(10)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("当前体重")
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    Text("\(String(format: "%.1f", weightManager.getCurrentWeight() ?? 0.0))")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text("4月27日")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.green.opacity(0.1))
                .cornerRadius(10)
            }
            
            // Stats grid
            HStack {
                StatView(
                    title: "减重",
                    value: String(format: "%.1f", (weightManager.userProfile.startWeight - (weightManager.getCurrentWeight() ?? 0.0))),
                    unit: "kg",
                    color: .green
                )
                
                StatView(
                    title: "平均每日",
                    value: "-0.14",
                    unit: "kg",
                    color: .green
                )
                
                StatView(
                    title: "记录天数",
                    value: "27",
                    unit: "天"
                )
            }
            
            // Progress bar
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text("目标进度")
                        .font(.caption)
                    
                    Spacer()
                    
                    Text("\(Int(weightManager.getWeightProgress() * 100))%")
                        .font(.caption)
                }
                
                ProgressBar(value: weightManager.getWeightProgress())
                    .frame(height: 8)
                
                HStack {
                    Text("起点: \(String(format: "%.1f", weightManager.userProfile.startWeight))kg")
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    Spacer()
                    
                    Text("目标: \(String(format: "%.1f", weightManager.userProfile.targetWeight))kg")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
    }
    
    var weightTrendChart: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("体重趋势")
                    .font(.headline)
                
                Spacer()
                
                Text("2025年4月")
                    .font(.caption)
                    .foregroundColor(.blue)
            }
            
            // Chart
            WeightTrendChart(weightRecords: weightManager.weightRecords)
                .frame(height: 200)
                .padding(.top, 8)
            
            // Best and worst days
            HStack(spacing: 12) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("最大减重日")
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    Text("-0.5")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.green)
                    
                    Text("4月12日")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.gray.opacity(0.05))
                .cornerRadius(10)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("最大增重日")
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    Text("+0.3")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.red)
                    
                    Text("4月8日")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.gray.opacity(0.05))
                .cornerRadius(10)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
    }
    
    var bodyMeasurementsCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("身体指标")
                .font(.headline)
                .padding(.bottom, 4)
            
            // BMI and body fat
            HStack(spacing: 12) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("BMI 指数")
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    Text("23.7")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text("正常范围")
                        .font(.caption)
                        .foregroundColor(.green)
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.gray.opacity(0.05))
                .cornerRadius(10)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("体脂率")
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    Text("22.3%")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text("正常范围")
                        .font(.caption)
                        .foregroundColor(.green)
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.gray.opacity(0.05))
                .cornerRadius(10)
            }
            
            // Body measurements
            HStack {
                StatView(title: "腰围", value: "82", unit: "cm")
                StatView(title: "胸围", value: "98", unit: "cm")
                StatView(title: "臀围", value: "94", unit: "cm")
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
    }
    
    var photoProgressCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("照片进度")
                .font(.headline)
                .padding(.bottom, 4)
            
            // Photo timeline
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(0..<5) { index in
                        VStack(spacing: 4) {
                            Text(index == 4 ? "4月27日" : "4月\(index * 7 + 1)日")
                                .font(.caption)
                                .foregroundColor(.gray)
                            
                            Image(systemName: "person.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 80, height: 80)
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(8)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(index == 4 ? Color.blue : Color.clear, lineWidth: 2)
                                )
                        }
                    }
                }
                .padding(.vertical, 8)
            }
            
            Button(action: {
                // View full photo comparison
            }) {
                Text("查看完整照片对比")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .foregroundColor(.blue)
                    .cornerRadius(10)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
    }
    
    var insightsCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("数据洞察")
                .font(.headline)
                .padding(.bottom, 4)
            
            InsightView(
                icon: "lightbulb.fill",
                title: "减重速度适中",
                message: "您的平均每日减重0.14kg，这是健康的减重速度。保持这个节奏可以更好地维持减重效果。",
                color: .blue
            )
            
            InsightView(
                icon: "checkmark.circle.fill",
                title: "记录习惯良好",
                message: "本月您已记录27天，坚持记录是成功减重的关键。继续保持这个好习惯！",
                color: .green
            )
            
            InsightView(
                icon: "exclamationmark.circle.fill",
                title: "周末波动较大",
                message: "数据显示您在周末体重波动较大，建议周末也保持规律的饮食和运动习惯。",
                color: .yellow
            )
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
    }
    
    var exportDataCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("数据导出")
                .font(.headline)
                .padding(.bottom, 4)
            
            HStack(spacing: 12) {
                Button(action: {
                    // Export CSV
                }) {
                    HStack {
                        Image(systemName: "doc.text")
                        Text("导出CSV")
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .foregroundColor(.blue)
                    .cornerRadius(10)
                }
                
                Button(action: {
                    // Export PDF
                }) {
                    HStack {
                        Image(systemName: "doc.richtext")
                        Text("导出PDF报告")
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .foregroundColor(.blue)
                    .cornerRadius(10)
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
    }
    
    // MARK: - Helper Properties
    
    var periodTitle: String {
        switch selectedPeriod {
        case .week:
            return "本周"
        case .month:
            return "本月"
        case .year:
            return "今年"
        case .all:
            return "全部"
        }
    }
}

struct StatView: View {
    let title: String
    let value: String
    let unit: String
    var color: Color = .primary
    
    var body: some View {
        VStack(spacing: 4) {
            Text(title)
                .font(.caption)
                .foregroundColor(.gray)
            
            HStack(alignment: .bottom, spacing: 0) {
                Text(value)
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(color)
                
                Text(unit)
                    .font(.caption)
                    .foregroundColor(color)
            }
        }
        .frame(maxWidth: .infinity)
    }
}

struct InsightView: View {
    let icon: String
    let title: String
    let message: String
    let color: Color
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(color)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                
                Text(message)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(color.opacity(0.1))
        .cornerRadius(10)
    }
}

struct WeightTrendChart: View {
    let weightRecords: [WeightRecord]
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Grid lines
                VStack(spacing: 0) {
                    ForEach(0..<6) { _ in
                        Divider()
                        Spacer()
                    }
                }
                
                // Y-axis labels
                VStack(alignment: .leading, spacing: 0) {
                    ForEach(0..<6) { index in
                        Text("\(73 - index)kg")
                            .font(.caption)
                            .foregroundColor(.gray)
                            .frame(height: geometry.size.height / 6)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 4)
                
                // Chart line
                Path { path in
                    let points = chartPoints(in: geometry.size)
                    if points.isEmpty { return }
                    
                    path.move(to: points[0])
                    for index in 1..<points.count {
                        path.addLine(to: points[index])
                    }
                }
                .stroke(Color.blue, lineWidth: 2)
                
                // Data points
                ForEach(0..<chartPoints(in: geometry.size).count, id: \.self) { index in
                    let point = chartPoints(in: geometry.size)[index]
                    Circle()
                        .fill(Color.blue)
                        .frame(width: 6, height: 6)
                        .position(point)
                }
            }
            .padding(.leading, 30) // Space for Y-axis labels
        }
    }
    
    func chartPoints(in size: CGSize) -> [CGPoint] {
        let sortedRecords = weightRecords.sorted { $0.date < $1.date }
        guard !sortedRecords.isEmpty else { return [] }
        
        // Find min and max weights for scaling
        let minWeight = sortedRecords.map { $0.weight }.min() ?? 65.0
        let maxWeight = sortedRecords.map { $0.weight }.max() ?? 73.0
        let range = max(maxWeight - minWeight, 1.0) // Prevent division by zero
        
        // Calculate points
        let width = size.width - 40 // Adjust for Y-axis labels
        let height = size.height - 10 // Margin
        
        return sortedRecords.enumerated().map { index, record in
            let x = 40 + (width * CGFloat(index) / CGFloat(max(sortedRecords.count - 1, 1)))
            let normalizedWeight = (record.weight - minWeight) / range
            let y = height - (normalizedWeight * height) + 5 // Invert Y and add margin
            return CGPoint(x: x, y: y)
        }
    }
}

#Preview {
    ProgressView()
        .environmentObject(WeightManager())
}

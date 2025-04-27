import SwiftUI

struct HomeView: View {
    @EnvironmentObject var weightManager: WeightManager
    @State private var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy年MM月dd日 EEEE"
        formatter.locale = Locale(identifier: "zh_CN")
        return formatter
    }()
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    // Header with greeting and date
                    HStack {
                        VStack(alignment: .leading) {
                            Text("你好，\(weightManager.userProfile.name)")
                                .font(.title)
                                .fontWeight(.bold)
                            Text(dateFormatter.string(from: Date()))
                                .foregroundColor(.gray)
                        }
                        
                        Spacer()
                        
                        // User avatar
                        Image(systemName: "person.crop.circle.fill")
                            .resizable()
                            .frame(width: 48, height: 48)
                            .foregroundColor(.blue)
                            .background(Color.white)
                            .clipShape(Circle())
                    }
                    .padding(.horizontal)
                    
                    // Today's Summary Card
                    VStack(spacing: 12) {
                        HStack {
                            Text("今日概览")
                                .font(.headline)
                            
                            Spacer()
                            
                            Text("查看详情")
                                .font(.subheadline)
                                .foregroundColor(.blue)
                        }
                        
                        // Weight stats
                        HStack(spacing: 0) {
                            WeightStatView(
                                title: "当前体重",
                                value: weightManager.getCurrentWeight() ?? 0.0,
                                unit: "kg"
                            )
                            
                            WeightStatView(
                                title: "目标体重",
                                value: weightManager.userProfile.targetWeight,
                                unit: "kg"
                            )
                            
                            WeightStatView(
                                title: "剩余",
                                value: (weightManager.getCurrentWeight() ?? 0.0) - weightManager.userProfile.targetWeight,
                                unit: "kg",
                                valueColor: .blue
                            )
                        }
                        
                        // Progress bar
                        VStack(alignment: .leading, spacing: 4) {
                            HStack {
                                Text("进度")
                                    .font(.caption)
                                
                                Spacer()
                                
                                Text("\(Int(weightManager.getWeightProgress() * 100))%")
                                    .font(.caption)
                            }
                            
                            ProgressBar(value: weightManager.getWeightProgress())
                                .frame(height: 8)
                        }
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(12)
                    .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
                    .padding(.horizontal)
                    
                    // Weight Trend Chart
                    VStack(spacing: 12) {
                        HStack {
                            Text("体重趋势")
                                .font(.headline)
                            
                            Spacer()
                            
                            HStack(spacing: 8) {
                                FilterPill(text: "周", isSelected: true)
                                FilterPill(text: "月", isSelected: false)
                                FilterPill(text: "年", isSelected: false)
                            }
                        }
                        
                        // Simplified chart
                        WeeklyWeightChart(weightRecords: weightManager.weightRecords)
                            .frame(height: 160)
                            .padding(.vertical, 8)
                        
                        HStack {
                            Text("本周减重: ")
                                .font(.caption)
                                .foregroundColor(.gray)
                            Text("-1.2kg")
                                .font(.caption)
                                .foregroundColor(.green)
                                .fontWeight(.bold)
                            
                            Spacer()
                            
                            Text("平均每日: ")
                                .font(.caption)
                                .foregroundColor(.gray)
                            Text("-0.17kg")
                                .font(.caption)
                                .foregroundColor(.green)
                                .fontWeight(.bold)
                        }
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(12)
                    .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
                    .padding(.horizontal)
                    
                    // Photo Comparison
                    VStack(spacing: 12) {
                        Text("照片对比")
                            .font(.headline)
                        
                        HStack(spacing: 12) {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("开始 (4月1日)")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                
                                Image(systemName: "person.fill")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 150, height: 150)
                                    .background(Color.gray.opacity(0.2))
                                    .cornerRadius(8)
                            }
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("现在 (4月27日)")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                
                                Image(systemName: "person.fill")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 150, height: 150)
                                    .background(Color.gray.opacity(0.2))
                                    .cornerRadius(8)
                            }
                        }
                        
                        Button(action: {
                            // View full photo history
                        }) {
                            Text("查看完整照片历史")
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
                    .padding(.horizontal)
                    
                    // Quick Actions
                    VStack(spacing: 12) {
                        Text("快捷操作")
                            .font(.headline)
                        
                        HStack(spacing: 12) {
                            Button(action: {
                                // Record today's photo
                            }) {
                                HStack {
                                    Image(systemName: "camera.fill")
                                    Text("记录今日照片")
                                }
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                            }
                            
                            Button(action: {
                                // Record today's weight
                            }) {
                                HStack {
                                    Image(systemName: "scalemass.fill")
                                    Text("记录今日体重")
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
                    .padding(.horizontal)
                }
                .padding(.vertical)
            }
            .background(Color(UIColor.systemGroupedBackground))
            .navigationBarHidden(true)
        }
    }
}

struct WeightStatView: View {
    let title: String
    let value: Double
    let unit: String
    var valueColor: Color = .black
    
    var body: some View {
        VStack {
            Text(title)
                .font(.caption)
                .foregroundColor(.gray)
            
            HStack(alignment: .bottom, spacing: 0) {
                Text(String(format: "%.1f", value))
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(valueColor)
                
                Text(unit)
                    .font(.caption)
                    .foregroundColor(valueColor)
            }
        }
        .frame(maxWidth: .infinity)
    }
}

struct ProgressBar: View {
    var value: Double // 0.0 to 1.0
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .opacity(0.2)
                    .foregroundColor(.gray)
                    .cornerRadius(4)
                
                Rectangle()
                    .frame(width: min(CGFloat(self.value) * geometry.size.width, geometry.size.width), height: geometry.size.height)
                    .foregroundColor(.green)
                    .cornerRadius(4)
            }
        }
    }
}

struct FilterPill: View {
    let text: String
    let isSelected: Bool
    
    var body: some View {
        Text(text)
            .font(.caption)
            .padding(.horizontal, 12)
            .padding(.vertical, 4)
            .background(isSelected ? Color.blue : Color.gray.opacity(0.2))
            .foregroundColor(isSelected ? .white : .gray)
            .cornerRadius(20)
    }
}

struct WeeklyWeightChart: View {
    let weightRecords: [WeightRecord]
    let calendar = Calendar.current
    
    var weeklyData: [(day: String, height: CGFloat)] {
        let today = Date()
        var result: [(day: String, height: CGFloat)] = []
        
        // Get the last 7 days
        for dayOffset in (0..<7).reversed() {
            if let date = calendar.date(byAdding: .day, value: -dayOffset, to: today) {
                let dayFormatter = DateFormatter()
                dayFormatter.dateFormat = "E"
                dayFormatter.locale = Locale(identifier: "zh_CN")
                let dayName = dayFormatter.string(from: date)
                
                // Find weight record for this day
                let dayStart = calendar.startOfDay(for: date)
                let dayEnd = calendar.date(byAdding: .day, value: 1, to: dayStart)!
                
                let recordForDay = weightRecords.first { record in
                    record.date >= dayStart && record.date < dayEnd
                }
                
                // Calculate height based on weight (normalized between 0.1 and 1.0)
                var height: CGFloat
                if let record = recordForDay {
                    // Simple normalization for demo purposes
                    height = CGFloat((record.weight - 65.0) / 10.0)
                    // Ensure height is between 0.1 and 1.0
                    height = min(max(height, 0.1), 1.0)
                } else {
                    height = 0.1 // Default height if no data
                }
                
                result.append((day: dayName, height: height))
            }
        }
        
        return result
    }
    
    var body: some View {
        HStack(alignment: .bottom, spacing: 8) {
            ForEach(0..<weeklyData.count, id: \.self) { index in
                let isToday = index == weeklyData.count - 1
                
                VStack {
                    Text(weeklyData[index].day)
                        .font(.caption)
                        .foregroundColor(isToday ? .blue : .gray)
                        .fontWeight(isToday ? .bold : .regular)
                    
                    Rectangle()
                        .fill(isToday ? Color.blue : Color.gray.opacity(0.3))
                        .frame(height: 100 * weeklyData[index].height)
                        .cornerRadius(4)
                }
                .frame(maxWidth: .infinity)
            }
        }
        .padding(.top, 20) // Space for day labels
    }
}

#Preview {
    HomeView()
        .environmentObject(WeightManager())
}

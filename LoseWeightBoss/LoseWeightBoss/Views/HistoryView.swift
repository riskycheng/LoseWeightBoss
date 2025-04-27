import SwiftUI

struct HistoryView: View {
    @EnvironmentObject var weightManager: WeightManager
    @State private var selectedFilter: RecordType = .all
    @State private var selectedDate = Date()
    @State private var calendarMonthOffset = 0
    
    enum RecordType: String, CaseIterable {
        case all = "全部"
        case weight = "体重"
        case photo = "照片"
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Header
                    Text("历史记录")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.top)
                    
                    // Filter tabs
                    filterTabs
                    
                    // Calendar view
                    calendarView
                    
                    // History list
                    historyList
                }
                .padding(.horizontal)
            }
            .background(Color(UIColor.systemGroupedBackground))
            .navigationBarHidden(true)
        }
    }
    
    var filterTabs: some View {
        HStack {
            ForEach(RecordType.allCases, id: \.self) { type in
                Button(action: {
                    selectedFilter = type
                }) {
                    Text(type.rawValue)
                        .fontWeight(.medium)
                        .padding(.vertical, 8)
                        .frame(maxWidth: .infinity)
                        .background(selectedFilter == type ? Color.white : Color.clear)
                        .foregroundColor(selectedFilter == type ? .blue : .gray)
                        .cornerRadius(8)
                }
            }
        }
        .padding(4)
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)
    }
    
    var calendarView: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Month header
            HStack {
                Text(monthYearString(from: currentMonthDate))
                    .font(.headline)
                
                Spacer()
                
                HStack(spacing: 8) {
                    Button(action: {
                        calendarMonthOffset -= 1
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.gray)
                            .padding(8)
                            .background(Color.gray.opacity(0.1))
                            .clipShape(Circle())
                    }
                    
                    Button(action: {
                        calendarMonthOffset += 1
                    }) {
                        Image(systemName: "chevron.right")
                            .foregroundColor(.gray)
                            .padding(8)
                            .background(Color.gray.opacity(0.1))
                            .clipShape(Circle())
                    }
                }
            }
            
            // Weekday headers
            HStack {
                ForEach(weekdaySymbols, id: \.self) { symbol in
                    Text(symbol)
                        .font(.caption)
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity)
                }
            }
            
            // Calendar grid
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 4) {
                ForEach(daysInMonth, id: \.self) { date in
                    if let date = date {
                        CalendarDayView(
                            date: date,
                            isSelected: Calendar.current.isDate(date, inSameDayAs: selectedDate),
                            hasWeightRecord: hasWeightRecord(on: date),
                            hasPhotoRecord: hasPhotoRecord(on: date),
                            isToday: Calendar.current.isDateInToday(date)
                        )
                        .onTapGesture {
                            selectedDate = date
                        }
                    } else {
                        // Empty cell for days outside current month
                        Text("")
                            .frame(height: 40)
                    }
                }
            }
            
            // Legend
            HStack(spacing: 16) {
                HStack(spacing: 4) {
                    Circle()
                        .fill(Color.green)
                        .frame(width: 8, height: 8)
                    Text("体重记录")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                
                HStack(spacing: 4) {
                    Circle()
                        .fill(Color.blue)
                        .frame(width: 8, height: 8)
                    Text("照片记录")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
            .frame(maxWidth: .infinity, alignment: .center)
            .padding(.top, 8)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
    }
    
    var historyList: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("详细记录")
                .font(.headline)
            
            ForEach(filteredRecords, id: \.date) { day in
                DayRecordView(
                    date: day.date,
                    weightRecord: day.weightRecord,
                    photoRecord: day.photoRecord,
                    isToday: Calendar.current.isDateInToday(day.date)
                )
            }
            
            if !filteredRecords.isEmpty {
                Button(action: {
                    // Load more records
                }) {
                    Text("加载更多")
                        .fontWeight(.medium)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .foregroundColor(.blue)
                        .cornerRadius(10)
                }
                .padding(.vertical, 8)
            } else {
                Text("没有记录")
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding()
            }
        }
    }
    
    // MARK: - Helper Properties
    
    var currentMonthDate: Date {
        let calendar = Calendar.current
        var dateComponents = calendar.dateComponents([.year, .month], from: Date())
        dateComponents.month! += calendarMonthOffset
        return calendar.date(from: dateComponents) ?? Date()
    }
    
    var weekdaySymbols: [String] {
        let symbols = Calendar.current.shortWeekdaySymbols
        // Reorder to start with Monday (assuming Sunday is at index 0)
        return Array(symbols[1...]) + [symbols[0]]
    }
    
    var daysInMonth: [Date?] {
        let calendar = Calendar.current
        let monthStart = calendar.date(from: calendar.dateComponents([.year, .month], from: currentMonthDate))!
        
        let monthStartWeekday = calendar.component(.weekday, from: monthStart)
        // Adjust to make Monday the first day (1 -> 0, 2 -> 1, ..., 7 -> 6)
        let adjustedMonthStartWeekday = (monthStartWeekday + 5) % 7
        
        let daysInMonth = calendar.range(of: .day, in: .month, for: monthStart)?.count ?? 30
        
        var days = [Date?](repeating: nil, count: adjustedMonthStartWeekday)
        
        for day in 1...daysInMonth {
            if let date = calendar.date(byAdding: .day, value: day - 1, to: monthStart) {
                days.append(date)
            }
        }
        
        // Fill remaining cells to complete the grid
        let remainingCells = (7 - (days.count % 7)) % 7
        days.append(contentsOf: [Date?](repeating: nil, count: remainingCells))
        
        return days
    }
    
    struct DayRecord: Identifiable {
        var id: String { date.description }
        let date: Date
        let weightRecord: WeightRecord?
        let photoRecord: PhotoRecord?
    }
    
    var filteredRecords: [DayRecord] {
        let calendar = Calendar.current
        let today = Date()
        var result: [DayRecord] = []
        
        // Get records for the past 30 days
        for dayOffset in 0..<30 {
            if let date = calendar.date(byAdding: .day, value: -dayOffset, to: today) {
                let dayStart = calendar.startOfDay(for: date)
                let dayEnd = calendar.date(byAdding: .day, value: 1, to: dayStart)!
                
                let weightRecord = weightManager.weightRecords.first { record in
                    record.date >= dayStart && record.date < dayEnd
                }
                
                let photoRecord = weightManager.photoRecords.first { record in
                    record.date >= dayStart && record.date < dayEnd
                }
                
                // Filter based on selected type
                if selectedFilter == .all && (weightRecord != nil || photoRecord != nil) {
                    result.append(DayRecord(date: date, weightRecord: weightRecord, photoRecord: photoRecord))
                } else if selectedFilter == .weight && weightRecord != nil {
                    result.append(DayRecord(date: date, weightRecord: weightRecord, photoRecord: nil))
                } else if selectedFilter == .photo && photoRecord != nil {
                    result.append(DayRecord(date: date, weightRecord: nil, photoRecord: photoRecord))
                }
            }
        }
        
        return result
    }
    
    // MARK: - Helper Methods
    
    func monthYearString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy年MM月"
        formatter.locale = Locale(identifier: "zh_CN")
        return formatter.string(from: date)
    }
    
    func hasWeightRecord(on date: Date) -> Bool {
        let calendar = Calendar.current
        let dayStart = calendar.startOfDay(for: date)
        let dayEnd = calendar.date(byAdding: .day, value: 1, to: dayStart)!
        
        return weightManager.weightRecords.contains { record in
            record.date >= dayStart && record.date < dayEnd
        }
    }
    
    func hasPhotoRecord(on date: Date) -> Bool {
        let calendar = Calendar.current
        let dayStart = calendar.startOfDay(for: date)
        let dayEnd = calendar.date(byAdding: .day, value: 1, to: dayStart)!
        
        return weightManager.photoRecords.contains { record in
            record.date >= dayStart && record.date < dayEnd
        }
    }
}

struct CalendarDayView: View {
    let date: Date
    let isSelected: Bool
    let hasWeightRecord: Bool
    let hasPhotoRecord: Bool
    let isToday: Bool
    
    var body: some View {
        VStack {
            Text("\(Calendar.current.component(.day, from: date))")
                .font(.system(size: 14))
                .fontWeight(isToday ? .bold : .regular)
                .foregroundColor(isSelected ? .white : (isToday ? .blue : .primary))
                .frame(width: 36, height: 36)
                .background(isSelected ? Color.blue : Color.clear)
                .clipShape(Circle())
            
            // Record indicators
            HStack(spacing: 2) {
                if hasWeightRecord {
                    Circle()
                        .fill(Color.green)
                        .frame(width: 4, height: 4)
                }
                
                if hasPhotoRecord {
                    Circle()
                        .fill(Color.blue)
                        .frame(width: 4, height: 4)
                }
            }
            .frame(height: 4)
        }
        .frame(height: 40)
    }
}

struct DayRecordView: View {
    let date: Date
    let weightRecord: WeightRecord?
    let photoRecord: PhotoRecord?
    let isToday: Bool
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "M月d日"
        formatter.locale = Locale(identifier: "zh_CN")
        return formatter
    }
    
    var weekdayFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        formatter.locale = Locale(identifier: "zh_CN")
        return formatter
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Date header
            HStack {
                VStack(alignment: .leading) {
                    Text(isToday ? "今天" : (Calendar.current.isDateInYesterday(date) ? "昨天" : ""))
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    Text("\(dateFormatter.string(from: date)) \(weekdayFormatter.string(from: date))")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                if isToday {
                    Text("今天")
                        .font(.caption)
                        .fontWeight(.medium)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.blue.opacity(0.1))
                        .foregroundColor(.blue)
                        .cornerRadius(20)
                }
            }
            
            // Weight record
            if let record = weightRecord {
                HStack {
                    Circle()
                        .fill(Color.green.opacity(0.2))
                        .frame(width: 40, height: 40)
                        .overlay(
                            Image(systemName: "scalemass.fill")
                                .foregroundColor(.green)
                        )
                    
                    VStack(alignment: .leading) {
                        HStack {
                            Text("体重记录")
                                .fontWeight(.medium)
                            
                            Spacer()
                            
                            Text("\(String(format: "%.1f", record.weight))")
                                .font(.title3)
                                .fontWeight(.bold)
                            
                            Text("kg")
                                .font(.caption)
                        }
                        
                        HStack {
                            Text(record.timeOfDay.rawValue)
                                .font(.caption)
                                .foregroundColor(.gray)
                            
                            Spacer()
                            
                            if let change = record.change {
                                Text(String(format: "%+.1fkg", change))
                                    .font(.caption)
                                    .fontWeight(.bold)
                                    .foregroundColor(change < 0 ? .green : .red)
                            }
                        }
                    }
                    .padding(.leading, 8)
                }
                .padding(.vertical, 8)
                
                if photoRecord != nil {
                    Divider()
                }
            }
            
            // Photo record
            if let record = photoRecord {
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Circle()
                            .fill(Color.blue.opacity(0.2))
                            .frame(width: 40, height: 40)
                            .overlay(
                                Image(systemName: "camera.fill")
                                    .foregroundColor(.blue)
                            )
                        
                        VStack(alignment: .leading) {
                            Text("照片记录")
                                .fontWeight(.medium)
                            
                            Text(record.timeOfDay)
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        .padding(.leading, 8)
                    }
                    
                    // Photo thumbnails
                    HStack(spacing: 8) {
                        // In a real app, you would load the actual images
                        // For this prototype, we'll use placeholders
                        if record.frontImagePath != nil {
                            Image(systemName: "person.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 120, height: 120)
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(8)
                        }
                        
                        if record.sideImagePath != nil {
                            Image(systemName: "person.fill.turn.right")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 120, height: 120)
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(8)
                        }
                    }
                    .padding(.leading, 48)
                }
                .padding(.vertical, 8)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
    }
}

#Preview {
    HistoryView()
        .environmentObject(WeightManager())
}

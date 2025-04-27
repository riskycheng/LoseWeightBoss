import Foundation

struct WeightRecord: Identifiable, Codable {
    var id = UUID()
    var weight: Double
    var date: Date
    var timeOfDay: TimeOfDay
    var note: String?
    var change: Double?
    
    enum TimeOfDay: String, Codable, CaseIterable {
        case morning = "早晨空腹"
        case beforeLunch = "午餐前"
        case afterLunch = "午餐后"
        case beforeDinner = "晚餐前"
        case afterDinner = "晚餐后"
        case beforeSleep = "睡前"
    }
}

struct PhotoRecord: Identifiable, Codable {
    var id = UUID()
    var date: Date
    var frontImagePath: String?
    var sideImagePath: String?
    var note: String?
    var timeOfDay: String
}

struct UserProfile: Codable {
    var name: String = "李明"
    var gender: Gender = .male
    var age: Int = 32
    var height: Double = 175.0
    var startWeight: Double = 72.3
    var targetWeight: Double = 65.0
    var startDate: Date = Date()
    
    enum Gender: String, Codable, CaseIterable {
        case male = "男"
        case female = "女"
    }
}

class WeightManager: ObservableObject {
    @Published var weightRecords: [WeightRecord] = []
    @Published var photoRecords: [PhotoRecord] = []
    @Published var userProfile = UserProfile()
    
    private let weightRecordsKey = "weightRecords"
    private let photoRecordsKey = "photoRecords"
    private let userProfileKey = "userProfile"
    
    init() {
        loadData()
    }
    
    func addWeightRecord(_ record: WeightRecord) {
        var newRecord = record
        if let lastRecord = weightRecords.sorted(by: { $0.date > $1.date }).first {
            newRecord.change = record.weight - lastRecord.weight
        }
        weightRecords.append(newRecord)
        saveData()
    }
    
    func addPhotoRecord(_ record: PhotoRecord) {
        photoRecords.append(record)
        saveData()
    }
    
    func updateUserProfile(_ profile: UserProfile) {
        userProfile = profile
        saveData()
    }
    
    func getCurrentWeight() -> Double? {
        return weightRecords.sorted(by: { $0.date > $1.date }).first?.weight
    }
    
    func getWeightProgress() -> Double {
        guard let currentWeight = getCurrentWeight() else { return 0 }
        let totalToLose = userProfile.startWeight - userProfile.targetWeight
        let currentLost = userProfile.startWeight - currentWeight
        if totalToLose <= 0 { return 0 }
        return min(max(currentLost / totalToLose, 0), 1)
    }
    
    private func saveData() {
        if let encoded = try? JSONEncoder().encode(weightRecords) {
            UserDefaults.standard.set(encoded, forKey: weightRecordsKey)
        }
        
        if let encoded = try? JSONEncoder().encode(photoRecords) {
            UserDefaults.standard.set(encoded, forKey: photoRecordsKey)
        }
        
        if let encoded = try? JSONEncoder().encode(userProfile) {
            UserDefaults.standard.set(encoded, forKey: userProfileKey)
        }
    }
    
    private func loadData() {
        if let data = UserDefaults.standard.data(forKey: weightRecordsKey),
           let decoded = try? JSONDecoder().decode([WeightRecord].self, from: data) {
            weightRecords = decoded
        } else {
            // Sample data for preview
            let calendar = Calendar.current
            let today = Date()
            
            // Create sample weight records for the past week
            for day in 0..<7 {
                if let date = calendar.date(byAdding: .day, value: -day, to: today) {
                    let sampleWeight = 68.5 + Double.random(in: -0.5...0.5) + Double(day) * 0.2
                    let record = WeightRecord(
                        weight: sampleWeight,
                        date: date,
                        timeOfDay: .morning,
                        note: day == 0 ? "今天感觉不错" : nil,
                        change: day == 0 ? -0.2 : (day == 1 ? 0.1 : -0.3)
                    )
                    weightRecords.append(record)
                }
            }
        }
        
        if let data = UserDefaults.standard.data(forKey: photoRecordsKey),
           let decoded = try? JSONDecoder().decode([PhotoRecord].self, from: data) {
            photoRecords = decoded
        }
        
        if let data = UserDefaults.standard.data(forKey: userProfileKey),
           let decoded = try? JSONDecoder().decode(UserProfile.self, from: data) {
            userProfile = decoded
        }
    }
}

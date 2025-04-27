import SwiftUI

struct RecordView: View {
    @EnvironmentObject var weightManager: WeightManager
    @State private var weight: Double = 68.5
    @State private var timeOfDay: WeightRecord.TimeOfDay = .morning
    @State private var note: String = ""
    @State private var showingImagePicker = false
    @State private var inputImage: UIImage?
    @State private var currentImageType: ImageType = .front
    @State private var frontImage: UIImage?
    @State private var sideImage: UIImage?
    @State private var photoNote: String = ""
    
    enum ImageType {
        case front, side
    }
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy年MM月dd日 EEEE"
        formatter.locale = Locale(identifier: "zh_CN")
        return formatter
    }
    
    var lastWeight: Double? {
        weightManager.weightRecords.sorted(by: { $0.date > $1.date }).first?.weight
    }
    
    var weightChange: Double {
        guard let last = lastWeight else { return 0 }
        return weight - last
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Header
                    Text("今日记录")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Text(dateFormatter.string(from: Date()))
                        .foregroundColor(.gray)
                    
                    // Weight Recording Section
                    recordWeightSection
                    
                    // Photo Recording Section
                    recordPhotoSection
                    
                    // Quick Actions
                    quickActionsSection
                }
                .padding()
            }
            .background(Color(UIColor.systemGroupedBackground))
            .navigationBarHidden(true)
            .sheet(isPresented: $showingImagePicker) {
                ImagePicker(image: $inputImage)
            }
            .onChange(of: inputImage) { newImage in
                guard let image = newImage else { return }
                
                switch currentImageType {
                case .front:
                    frontImage = image
                case .side:
                    sideImage = image
                }
            }
        }
    }
    
    var recordWeightSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("记录体重")
                .font(.headline)
                .padding(.bottom, 4)
            
            // Weight display
            HStack {
                Spacer()
                Text(String(format: "%.1f", weight))
                    .font(.system(size: 40, weight: .bold))
                Text("kg")
                    .font(.title)
                    .foregroundColor(.gray)
                    .padding(.top, 8)
                Spacer()
            }
            
            // Weight slider
            VStack {
                Slider(value: $weight, in: 40...120, step: 0.1)
                    .accentColor(.blue)
                
                HStack {
                    Text("40kg")
                        .font(.caption)
                        .foregroundColor(.gray)
                    Spacer()
                    Text("80kg")
                        .font(.caption)
                        .foregroundColor(.gray)
                    Spacer()
                    Text("120kg")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
            
            // Fine adjustment and time selection
            HStack(spacing: 12) {
                VStack(alignment: .leading) {
                    Text("精确调整")
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    HStack {
                        Button(action: {
                            weight = max(40, weight - 0.1)
                        }) {
                            Text("-")
                                .font(.title)
                                .frame(width: 44, height: 44)
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(8)
                        }
                        
                        TextField("Weight", value: $weight, formatter: NumberFormatter())
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.center)
                            .frame(height: 44)
                            .background(Color.white)
                            .cornerRadius(8)
                        
                        Button(action: {
                            weight = min(120, weight + 0.1)
                        }) {
                            Text("+")
                                .font(.title)
                                .frame(width: 44, height: 44)
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(8)
                        }
                    }
                }
                
                VStack(alignment: .leading) {
                    Text("记录时间")
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    Picker("时间", selection: $timeOfDay) {
                        ForEach(WeightRecord.TimeOfDay.allCases, id: \.self) { time in
                            Text(time.rawValue).tag(time)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .frame(height: 44)
                    .frame(maxWidth: .infinity)
                    .background(Color.white)
                    .cornerRadius(8)
                }
            }
            
            // Notes
            VStack(alignment: .leading) {
                Text("备注（可选）")
                    .font(.caption)
                    .foregroundColor(.gray)
                
                TextEditor(text: $note)
                    .frame(height: 80)
                    .padding(4)
                    .background(Color.white)
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                    )
            }
            
            // Previous weight comparison
            if let last = lastWeight {
                HStack {
                    Text("上次记录: ")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    Text("\(String(format: "%.1f", last))kg (昨天)")
                        .font(.subheadline)
                    
                    Spacer()
                    
                    Text(String(format: "%+.1fkg", weightChange))
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .foregroundColor(weightChange < 0 ? .green : .red)
                }
            }
            
            // Save button
            Button(action: {
                saveWeightRecord()
            }) {
                Text("保存体重记录")
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
    }
    
    var recordPhotoSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("记录身体照片")
                .font(.headline)
                .padding(.bottom, 4)
            
            // Photo selection grid
            HStack(spacing: 12) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("正面照")
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    ZStack {
                        if let image = frontImage {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 150, height: 150)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        } else {
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray.opacity(0.3), style: StrokeStyle(lineWidth: 2, dash: [5]))
                                .frame(width: 150, height: 150)
                                .background(Color.gray.opacity(0.1))
                                .overlay(
                                    VStack {
                                        Image(systemName: "camera")
                                            .font(.system(size: 30))
                                            .foregroundColor(.gray)
                                        Text("点击添加照片")
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                    }
                                )
                        }
                    }
                    .onTapGesture {
                        currentImageType = .front
                        showingImagePicker = true
                    }
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("侧面照")
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    ZStack {
                        if let image = sideImage {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 150, height: 150)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        } else {
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray.opacity(0.3), style: StrokeStyle(lineWidth: 2, dash: [5]))
                                .frame(width: 150, height: 150)
                                .background(Color.gray.opacity(0.1))
                                .overlay(
                                    VStack {
                                        Image(systemName: "camera")
                                            .font(.system(size: 30))
                                            .foregroundColor(.gray)
                                        Text("点击添加照片")
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                    }
                                )
                        }
                    }
                    .onTapGesture {
                        currentImageType = .side
                        showingImagePicker = true
                    }
                }
            }
            
            // Photo tips
            VStack(alignment: .leading, spacing: 4) {
                Text("拍摄提示")
                    .font(.caption)
                    .foregroundColor(.gray)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("• 穿着相同或相似的衣物")
                    Text("• 在相同的位置和光线条件下拍摄")
                    Text("• 保持相同的姿势和角度")
                    Text("• 尽量在同一时间段拍摄（如早晨）")
                }
                .font(.caption)
                .foregroundColor(.blue)
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.blue.opacity(0.1))
                .cornerRadius(8)
            }
            
            // Photo notes
            VStack(alignment: .leading) {
                Text("照片备注（可选）")
                    .font(.caption)
                    .foregroundColor(.gray)
                
                TextEditor(text: $photoNote)
                    .frame(height: 80)
                    .padding(4)
                    .background(Color.white)
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                    )
            }
            
            // Save button
            Button(action: {
                savePhotoRecord()
            }) {
                Text("保存照片记录")
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .disabled(frontImage == nil && sideImage == nil)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
    }
    
    var quickActionsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("快速记录")
                .font(.headline)
                .padding(.bottom, 4)
            
            HStack(spacing: 12) {
                Button(action: {
                    // Record food
                }) {
                    HStack {
                        Image(systemName: "fork.knife")
                        Text("记录饮食")
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .foregroundColor(.blue)
                    .cornerRadius(10)
                }
                
                Button(action: {
                    // Record exercise
                }) {
                    HStack {
                        Image(systemName: "figure.run")
                        Text("记录运动")
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
    
    func saveWeightRecord() {
        let record = WeightRecord(
            weight: weight,
            date: Date(),
            timeOfDay: timeOfDay,
            note: note.isEmpty ? nil : note,
            change: weightChange
        )
        
        weightManager.addWeightRecord(record)
        
        // Reset form
        note = ""
        
        // Show success feedback
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
    
    func savePhotoRecord() {
        // In a real app, you would save the images to disk and store the file paths
        // For this prototype, we'll just create the record
        let record = PhotoRecord(
            date: Date(),
            frontImagePath: frontImage != nil ? "front_\(Date().timeIntervalSince1970).jpg" : nil,
            sideImagePath: sideImage != nil ? "side_\(Date().timeIntervalSince1970).jpg" : nil,
            note: photoNote.isEmpty ? nil : photoNote,
            timeOfDay: timeOfDay.rawValue
        )
        
        weightManager.addPhotoRecord(record)
        
        // Reset form
        frontImage = nil
        sideImage = nil
        photoNote = ""
        
        // Show success feedback
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
}

// Image Picker
struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    @Environment(\.presentationMode) var presentationMode
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.image = image
            }
            
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}

#Preview {
    RecordView()
        .environmentObject(WeightManager())
}

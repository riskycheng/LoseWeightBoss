import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var weightManager: WeightManager
    @State private var showingEditProfile = false
    @State private var showingPrivacySettings = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Header
                    Text("个人资料")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.top)
                    
                    // Profile card
                    profileCard
                    
                    // Personal information
                    personalInfoCard
                    
                    // Goals section
                    goalsCard
                    
                    // App settings
                    appSettingsCard
                    
                    // Support section
                    supportCard
                    
                    // About section
                    aboutCard
                }
                .padding(.horizontal)
                .padding(.bottom, 20)
            }
            .background(Color(UIColor.systemGroupedBackground))
            .navigationBarHidden(true)
            .sheet(isPresented: $showingEditProfile) {
                EditProfileView(profile: weightManager.userProfile) { updatedProfile in
                    weightManager.updateUserProfile(updatedProfile)
                }
            }
        }
    }
    
    var profileCard: some View {
        VStack(spacing: 16) {
            HStack(spacing: 16) {
                // Avatar
                Image(systemName: "person.crop.circle.fill")
                    .resizable()
                    .frame(width: 80, height: 80)
                    .foregroundColor(.blue)
                    .background(Color.white)
                    .clipShape(Circle())
                
                // User info
                VStack(alignment: .leading, spacing: 4) {
                    Text(weightManager.userProfile.name)
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text("减重中 · 已坚持27天")
                        .foregroundColor(.gray)
                    
                    HStack(spacing: 8) {
                        Text("初级减重者")
                            .font(.caption)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 2)
                            .background(Color.green.opacity(0.1))
                            .foregroundColor(.green)
                            .cornerRadius(20)
                        
                        Text("连续打卡7天")
                            .font(.caption)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 2)
                            .background(Color.blue.opacity(0.1))
                            .foregroundColor(.blue)
                            .cornerRadius(20)
                    }
                }
            }
            
            HStack(spacing: 12) {
                Button(action: {
                    showingEditProfile = true
                }) {
                    HStack {
                        Image(systemName: "pencil")
                        Text("编辑资料")
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .foregroundColor(.blue)
                    .cornerRadius(10)
                }
                
                Button(action: {
                    // Share progress
                }) {
                    HStack {
                        Image(systemName: "square.and.arrow.up")
                        Text("分享进度")
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
    
    var personalInfoCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("个人信息")
                .font(.headline)
            
            ForEach(personalInfoItems, id: \.title) { item in
                HStack {
                    Text(item.title)
                        .foregroundColor(.gray)
                    
                    Spacer()
                    
                    Text(item.value)
                }
                .padding(.vertical, 8)
                
                if item.title != "开始日期" {
                    Divider()
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
    }
    
    var goalsCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("我的目标")
                .font(.headline)
            
            // Progress bar
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text("减重目标")
                        .font(.subheadline)
                    
                    Spacer()
                    
                    Text("\(Int(weightManager.getWeightProgress() * 100))% 完成")
                        .font(.subheadline)
                }
                
                ProgressBar(value: weightManager.getWeightProgress())
                    .frame(height: 8)
                
                HStack {
                    Text("当前: \(String(format: "%.1f", weightManager.getCurrentWeight() ?? 0.0))kg")
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    Spacer()
                    
                    Text("目标: \(String(format: "%.1f", weightManager.userProfile.targetWeight))kg")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
            
            // Weekly goal
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("每周减重目标")
                        .font(.subheadline)
                    
                    Text("健康减重速度")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                Text("0.5kg/周")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.blue)
            }
            .padding()
            .background(Color.gray.opacity(0.05))
            .cornerRadius(10)
            
            Button(action: {
                // Adjust goals
            }) {
                Text("调整我的目标")
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
    
    var appSettingsCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("应用设置")
                .font(.headline)
            
            ForEach(settingsItems, id: \.title) { item in
                HStack {
                    HStack(spacing: 12) {
                        Image(systemName: item.icon)
                            .foregroundColor(.gray)
                            .frame(width: 20)
                        
                        Text(item.title)
                    }
                    
                    Spacer()
                    
                    if item.isToggle {
                        Toggle("", isOn: .constant(true))
                            .labelsHidden()
                    } else if item.hasValue {
                        Text(item.value ?? "")
                            .foregroundColor(.gray)
                    } else {
                        Image(systemName: "chevron.right")
                            .foregroundColor(.gray)
                    }
                }
                .padding(.vertical, 8)
                
                if item.title != "语言" {
                    Divider()
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
    }
    
    var supportCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("支持与帮助")
                .font(.headline)
            
            ForEach(supportItems, id: \.title) { item in
                HStack {
                    HStack(spacing: 12) {
                        Image(systemName: item.icon)
                            .foregroundColor(.gray)
                            .frame(width: 20)
                        
                        Text(item.title)
                    }
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .foregroundColor(.gray)
                }
                .padding(.vertical, 8)
                
                if item.title != "推荐给朋友" {
                    Divider()
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
    }
    
    var aboutCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("关于")
                .font(.headline)
            
            ForEach(aboutItems, id: \.title) { item in
                HStack {
                    HStack(spacing: 12) {
                        Image(systemName: item.icon)
                            .foregroundColor(.gray)
                            .frame(width: 20)
                        
                        Text(item.title)
                    }
                    
                    Spacer()
                    
                    if item.hasValue {
                        Text(item.value ?? "")
                            .foregroundColor(.gray)
                    } else {
                        Image(systemName: "chevron.right")
                            .foregroundColor(.gray)
                    }
                }
                .padding(.vertical, 8)
                
                if item.title != "版本信息" {
                    Divider()
                }
            }
            
            Button(action: {
                // Logout
            }) {
                Text("退出登录")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .foregroundColor(.red)
                    .cornerRadius(10)
            }
            .padding(.top, 8)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
    }
    
    // MARK: - Data
    
    struct InfoItem {
        let title: String
        let value: String
    }
    
    var personalInfoItems: [InfoItem] {
        [
            InfoItem(title: "性别", value: weightManager.userProfile.gender.rawValue),
            InfoItem(title: "年龄", value: "\(weightManager.userProfile.age)岁"),
            InfoItem(title: "身高", value: "\(Int(weightManager.userProfile.height))cm"),
            InfoItem(title: "起始体重", value: "\(String(format: "%.1f", weightManager.userProfile.startWeight))kg"),
            InfoItem(title: "目标体重", value: "\(String(format: "%.1f", weightManager.userProfile.targetWeight))kg"),
            InfoItem(title: "开始日期", value: "2025年4月1日")
        ]
    }
    
    struct SettingsItem {
        let icon: String
        let title: String
        let isToggle: Bool
        let hasValue: Bool
        let value: String?
    }
    
    var settingsItems: [SettingsItem] {
        [
            SettingsItem(icon: "bell.fill", title: "提醒通知", isToggle: true, hasValue: false, value: nil),
            SettingsItem(icon: "lock.fill", title: "隐私设置", isToggle: false, hasValue: false, value: nil),
            SettingsItem(icon: "arrow.clockwise", title: "数据同步", isToggle: true, hasValue: false, value: nil),
            SettingsItem(icon: "scalemass.fill", title: "体重单位", isToggle: false, hasValue: true, value: "千克 (kg)"),
            SettingsItem(icon: "ruler.fill", title: "身高单位", isToggle: false, hasValue: true, value: "厘米 (cm)"),
            SettingsItem(icon: "globe", title: "语言", isToggle: false, hasValue: true, value: "简体中文")
        ]
    }
    
    var supportItems: [SettingsItem] {
        [
            SettingsItem(icon: "questionmark.circle.fill", title: "常见问题", isToggle: false, hasValue: false, value: nil),
            SettingsItem(icon: "headphones", title: "联系客服", isToggle: false, hasValue: false, value: nil),
            SettingsItem(icon: "star.fill", title: "评价应用", isToggle: false, hasValue: false, value: nil),
            SettingsItem(icon: "square.and.arrow.up", title: "推荐给朋友", isToggle: false, hasValue: false, value: nil)
        ]
    }
    
    var aboutItems: [SettingsItem] {
        [
            SettingsItem(icon: "info.circle.fill", title: "关于 LoseWeightBoss", isToggle: false, hasValue: false, value: nil),
            SettingsItem(icon: "shield.fill", title: "隐私政策", isToggle: false, hasValue: false, value: nil),
            SettingsItem(icon: "doc.text.fill", title: "用户协议", isToggle: false, hasValue: false, value: nil),
            SettingsItem(icon: "hammer.fill", title: "版本信息", isToggle: false, hasValue: true, value: "v1.0.0")
        ]
    }
}

struct EditProfileView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var profile: UserProfile
    let onSave: (UserProfile) -> Void
    
    init(profile: UserProfile, onSave: @escaping (UserProfile) -> Void) {
        _profile = State(initialValue: profile)
        self.onSave = onSave
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("基本信息")) {
                    TextField("姓名", text: $profile.name)
                    
                    Picker("性别", selection: $profile.gender) {
                        ForEach(UserProfile.Gender.allCases, id: \.self) { gender in
                            Text(gender.rawValue).tag(gender)
                        }
                    }
                    
                    Stepper("年龄: \(profile.age)岁", value: $profile.age, in: 18...100)
                }
                
                Section(header: Text("身体数据")) {
                    HStack {
                        Text("身高")
                        Spacer()
                        TextField("身高", value: $profile.height, formatter: NumberFormatter())
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                        Text("cm")
                    }
                    
                    HStack {
                        Text("起始体重")
                        Spacer()
                        TextField("起始体重", value: $profile.startWeight, formatter: NumberFormatter())
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                        Text("kg")
                    }
                    
                    HStack {
                        Text("目标体重")
                        Spacer()
                        TextField("目标体重", value: $profile.targetWeight, formatter: NumberFormatter())
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                        Text("kg")
                    }
                }
            }
            .navigationTitle("编辑个人资料")
            .navigationBarItems(
                leading: Button("取消") {
                    presentationMode.wrappedValue.dismiss()
                },
                trailing: Button("保存") {
                    onSave(profile)
                    presentationMode.wrappedValue.dismiss()
                }
            )
        }
    }
}

#Preview {
    ProfileView()
        .environmentObject(WeightManager())
}

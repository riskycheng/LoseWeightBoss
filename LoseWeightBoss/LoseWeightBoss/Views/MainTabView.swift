import SwiftUI

struct MainTabView: View {
    @StateObject private var weightManager = WeightManager()
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .environmentObject(weightManager)
                .tabItem {
                    Label("首页", systemImage: "house.fill")
                }
                .tag(0)
            
            RecordView()
                .environmentObject(weightManager)
                .tabItem {
                    Label("记录", systemImage: "plus.circle.fill")
                }
                .tag(1)
            
            HistoryView()
                .environmentObject(weightManager)
                .tabItem {
                    Label("历史", systemImage: "calendar")
                }
                .tag(2)
            
            ProgressView()
                .environmentObject(weightManager)
                .tabItem {
                    Label("统计", systemImage: "chart.line.uptrend.xyaxis")
                }
                .tag(3)
            
            ProfileView()
                .environmentObject(weightManager)
                .tabItem {
                    Label("我的", systemImage: "person.fill")
                }
                .tag(4)
        }
        .accentColor(Color.blue)
    }
}

#Preview {
    MainTabView()
}

import SwiftUI

class TabSelection: ObservableObject {
    @Published var selectedTab: Int = 0
}

@main
struct final_alarm_testApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var tabSelection = TabSelection()

    var body: some Scene {
        WindowGroup {
            TabView(selection: $tabSelection.selectedTab) {
                ContentView()
                    .tabItem {
                        Label("ホーム", systemImage: "house.fill")
                    }
                    .tag(0)

                ChatView()
                    .tabItem {
                        Label("チャット", systemImage: "message.fill")
                    }
                    .tag(1)

                OptionView()
                    .tabItem {
                        Label("設定", systemImage: "gear")
                    }
                    .tag(2)
            }
        }
        .environmentObject(tabSelection)
    }
}

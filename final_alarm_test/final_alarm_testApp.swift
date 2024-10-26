import SwiftUI

@main
struct final_alarm_testApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            TabView {
                ContentView() // ここで表示する最初のビュー
                    .tabItem {
                        Label("ホーム", systemImage: "house.fill")
                    }

                ChatView()
                    .tabItem {
                        Label("チャット", systemImage: "message.fill")
                    }

                OptionView()
                    .tabItem {
                        Label("設定", systemImage: "gear")
                    }
            }
        }
    }
}

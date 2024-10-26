import SwiftUI
import UserNotifications

struct ContentView: View {
    @AppStorage("num") private var num: Int = 0

    var body: some View {
        VStack {
            Text("カウント数: \(num)")
                .padding()
            Button(action: {
                scheduleLocalNotification()
            }) {
                Text("アラームを3秒後にかける")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
    }
}

// ローカル通知をスケジュールする関数
func scheduleLocalNotification() {
    let content = UNMutableNotificationContent()
    content.title = "アラーム"
    content.body = "タップしてもどろう！！"
    content.sound = UNNotificationSound(named: UNNotificationSoundName("alarm_ap.mp3"))

    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3, repeats: false)
    let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

    UNUserNotificationCenter.current().add(request) { error in
        if error != nil {
            print("通知のスケジュールに失敗しました: \(error?.localizedDescription ?? "")")
        } else {
            print("通知がスケジュールされました")
        }
    }
}

import SwiftUI
import UserNotifications
import FirebaseFirestore

struct ContentView: View {
    @EnvironmentObject var tabSelection: TabSelection
    @State private var alarmTime = Date()
    @State private var isNavigationActive = false
    @State private var postContent: String = "読み込み中..."
    @AppStorage("showStopButton") private var showStopButton: Bool = false
    @AppStorage("notificationID1") private var notification1UUIDString: String = ""
    @AppStorage("notificationID2") private var notification2UUIDString: String = ""
    @AppStorage("notificationID3") private var notification3UUIDString: String = ""
    
    var body: some View {
        NavigationView{
            VStack {
                DatePicker("時間を選択", selection: $alarmTime, displayedComponents: .hourAndMinute)
                    .datePickerStyle(WheelDatePickerStyle())
                    .labelsHidden()
                    .padding()
                Button(action: {
                    scheduleLocalNotification(for: alarmTime)
                    isNavigationActive = true
                    //セットのタイミングでボタンを隠す
                    showStopButton = false
                }) {
                    Text("セット")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                
                NavigationLink(destination: CheckView(), isActive: $isNavigationActive){
                    EmptyView()
                }
            }
            .navigationTitle("アラーム設定")
            .onAppear {
                fetchPostContent() // 画面表示時にFirestoreからデータを取得
            }
        }
    }

    // ローカル通知をスケジュールする関数
    func scheduleLocalNotification(for date: Date) {
        let content = UNMutableNotificationContent()
        let intervals = [5.0, 10.0, 15]
        let notificationTitles = ["アラーム","1回目の通知だよ","2回目の通知だよ"]
        let notificationMessages = ["アラームを止める","起きてるかな？","間に合うかな？"]
        //二つ目と三つ目のはわざと名前を間違えてデフォルトを読んでいる
        let notificationSounds = ["alarm_app.mp3","alarm_ap.mp3","alarm_ap.mp3"]
        var UUIDlist : [String] = []
        let calendar = Calendar.current
//        let dateComponents = calendar.dateComponents([.hour, .minute], from: date)

        //テストのために時間指定じゃなくて強制的に5秒後に通知が来るようにしています
//        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        
        for i in 0...2{
            content.title = notificationTitles[i]
            content.body = notificationMessages[i]
            content.sound = UNNotificationSound(named: UNNotificationSoundName(notificationSounds[i]))
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: intervals[i], repeats: false)
            //UUID()で識別子を生成している
            let newUUID = UUID().uuidString
            UUIDlist.append(newUUID)
            let request = UNNotificationRequest(identifier: newUUID, content: content, trigger: trigger)

            UNUserNotificationCenter.current().add(request) { error in
                if error != nil {
                    print("通知のスケジュールに失敗しました: \(error?.localizedDescription ?? "")")
                } else {
                    print("通知がスケジュールされました")
                }
            }
        }
        //これによってアラーム設定時にかけられた通知にそれぞれアクセスできる
        notification1UUIDString = UUIDlist[0]
        notification2UUIDString = UUIDlist[1]
        notification3UUIDString = UUIDlist[2]
        
        
    }

    // Firestoreからデータを取得してpostContentに保存する関数
    func fetchPostContent() {
        let db = Firestore.firestore()
        let documentRef = db.collection("A").document("B")
        documentRef.getDocument { (document, error) in
            if let error = error {
                print("ドキュメントの取得に失敗しました: \(error.localizedDescription)")
                self.postContent = "エラーが発生しました"
            } else if let document = document, document.exists {
                let data = document.data()
                self.postContent = data?["C"] as? String ?? "データがありません"
            } else {
                print("ドキュメントは存在しません")
                self.postContent = "ドキュメントが存在しません"
            }
        }
    }

}

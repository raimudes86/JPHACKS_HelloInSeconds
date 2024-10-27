//
//  WriteView.swift
//  final_alarm_test
//
//  Created by Raimu Kinoshita on 2024/10/26.
//

import SwiftUI
import FirebaseFirestore
struct WriteView: View {
    @Binding var showwritepage: Bool
    @EnvironmentObject var tabSelection: TabSelection // 環境オブジェクトを取得
    @State private var message: String = "今日も一日頑張ろう"
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State private var currentDate = Date()
    @State private var showchatView = false
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("おはようございます！")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top, 50)
            
            Text("今日の目標や一言を投稿しよう")
                .font(.subheadline)
                .padding(.bottom, 10)
            
            TextField("ここに入力してください", text: $message)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(5)
                .padding(.bottom, 20)
            
            Button(action: {
                print("投稿ボタンが押されました: \(message)")
                Task {
                    await post(message: message, currentDate: currentDate)
                }
                tabSelection.selectedTab = 1
                showwritepage = false
            }) {
                Text("投稿！")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.red.opacity(0.8))
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.horizontal, 50)
            
            Spacer()
        }
        .padding()
    }
}

func post(message: String, currentDate: Date) async {
    let db = Firestore.firestore()
    do {
        let ref = try await db.collection("posts").addDocument(data: [
            "content": message,
            "date": Timestamp(date: currentDate), // Date型をTimestampに変換
            "userID": "abc"
        ])
        print("Document added with ID: \(ref.documentID)")
    } catch {
        print("Error adding document: \(error)")
    }
}

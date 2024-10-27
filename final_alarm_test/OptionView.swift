//
//  OptionView.swift
//  final_alarm_test
//
//  Created by 和田一真 on 2024/10/26.
//

import SwiftUI
import FirebaseFirestore

struct OptionView: View {
    @AppStorage("myUID") var myUID: String = "testID"
    @AppStorage("myName") private var myName: String = "名無し"
    @State private var targetUID: String = "" // フォローしたいユーザーのUIDを保存するための状態変数
    let db = Firestore.firestore()
    @State private var showAlert: Bool = false // コピー成功を知らせるアラート
    @State private var tmpName: String = ""
    
    var body: some View {
        // ユーザーIDを表示するテキストとボタンを重ねる
        VStack(spacing: 20) {
            HStack{
                Text("ユーザID")
                    .font(.headline)
                    .padding(.top, 50)
                Spacer()
            }
            HStack {
                // ユーザーIDを表示するテキストボックス
                Text(myUID)
                    .font(.title)
                    .padding()
                    .frame(maxWidth: .infinity) // 横幅を画面全体に広げる
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
                
                // コピーするボタン
                Button(action: {
                    copyToClipboard(myUID)
                    showAlert = true // コピー成功のアラートを表示
                }) {
                    Text("コピー")
                        .padding(8) // ボタンの内側のパディング
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding(.trailing, 10) // ボタンの右側のマージン
            }
            Text("フォローするユーザーのUIDを入力")
                .font(.headline)
                .padding(.top, 50)
            TextField("ユーザーUIDをここに入力", text: $targetUID)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(5)
                .padding(.bottom, 20)
            Button(action: {
                if !targetUID.isEmpty {
                    addFollowUser(targetUID: targetUID)
                } else {
                    print("UIDが空です。")
                }
            }) {
                Text("フォローする")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue.opacity(0.8))
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.horizontal, 50)
            Text("ユーザー名を入力")
                .font(.headline)
                .padding(.top, 50)
            TextField("ユーザー名をここに入力", text: $tmpName)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(5)
                .padding(.bottom, 20)
            Button(action: {
                myName = tmpName
                changeName(name: tmpName)
            }) {
                Text("変更する")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue.opacity(0.8))
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.horizontal, 50)
            Spacer()
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("コピー成功"), message: Text("ユーザーIDがクリップボードにコピーされました。"), dismissButton: .default(Text("OK")))
        }
        .padding()
    }
    
    // クリップボードにコピーする関数
    private func copyToClipboard(_ string: String) {
        let pasteboard = UIPasteboard.general
        pasteboard.string = string
    }
    private func addFollowUser(targetUID: String) {
        guard !myUID.isEmpty else {
            print("自分のUIDが存在しません")
            return
        }
        
        // フォローリストに新しいUIDを追加
        let followingRef = db.collection("Users").document(myUID).collection("following").document(targetUID)
        followingRef.setData(["followed_at": Timestamp(date: Date())]) { error in
            if let error = error {
                print("フォローリストに追加できませんでした: \(error.localizedDescription)")
            } else {
                print("ユーザー \(targetUID) をフォローしました")
            }
        }
    }
    private func changeName(name: String) {
        let nameRef = db.collection("Users").document(myUID)
        nameRef.updateData(["name": name]) { error in
            if let error = error {
                print("名前の変更できませんでした: \(error.localizedDescription)")
            }else {
                print("名前が正常に変更されました: \(name)")
            }
        }
    }
}

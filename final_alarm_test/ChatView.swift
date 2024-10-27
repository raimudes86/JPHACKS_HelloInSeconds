//
//  ChatView.swift
//  final_alarm_test
//
//  Created by 和田一真 on 2024/10/26.
//

import SwiftUI
import FirebaseFirestore

// Postモデル
struct Post: Identifiable {
    let id: String // ドキュメントID
    let content: String
    let date: String
    let userID: String
}

// PostModelクラス
class PostModel: ObservableObject {
    @Published var postContents: [Post] = []
    private var db = Firestore.firestore()
    private var listenerRegistration: ListenerRegistration?
    private var fetchedDocumentIDs: Set<String> = [] // 取得済みドキュメントIDを保持するセット

    func fetchPostContents() {
        listenerRegistration = db.collection("posts").addSnapshotListener { [weak self] (snapshot, error) in
            guard let self = self else { return }

            if let error = error {
                print("ドキュメントの取得に失敗しました: \(error.localizedDescription)")
                self.postContents = []
            } else if let snapshot = snapshot {
                var updatedPosts: [Post] = []

                for document in snapshot.documents {
                    // ドキュメントIDが既に取得済みか確認
                    if self.fetchedDocumentIDs.contains(document.documentID) {
                        continue // 取得済みならスキップ
                    }
                    
                    let data = document.data()
                    let content = data["content"] as? String ?? "No Content"
                    let date = data["date"] as? String ?? "No Date"
                    let userID = data["userID"] as? String ?? "Unknown User"
                    
                    // 新しいポストを生成し追加
                    let post = Post(id: document.documentID, content: content, date: date, userID: userID)
                    updatedPosts.append(post)
                    
                    // 取得済みIDとしてセットに追加
                    self.fetchedDocumentIDs.insert(document.documentID)
                }

                // 新しいポストを既存の配列に追加
                self.postContents.append(contentsOf: updatedPosts)
            }
        }
    }
    
    deinit {
        listenerRegistration?.remove()
    }
}

struct ChatView: View {
    @EnvironmentObject var tabSelection: TabSelection
    @StateObject private var contents = PostModel() // @StateObjectを使ってPostModelを保持

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                ForEach(contents.postContents) { post in
                    VStack(alignment: .leading, spacing: 10) {
                        Text(post.userID)
                            .font(.headline)
                            .padding(.bottom, 2)
                        Text(post.content)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color.cyan))
                    .shadow(radius: 5)
                    .padding(.horizontal)
                }
            }
            .padding(.vertical)
        }
        .onAppear {
            contents.fetchPostContents() // ビューが表示されたときにデータを取得
        }
    }
}

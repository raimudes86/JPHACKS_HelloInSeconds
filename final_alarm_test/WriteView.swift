//
//  WriteView.swift
//  final_alarm_test
//
//  Created by Raimu Kinoshita on 2024/10/26.
//

import SwiftUI
struct WriteView: View {
    @State private var message: String = "今日も一日頑張ろう"
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
                    Text("おはよう！")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.top, 50)

                    Text("今日の目標や一言")
                        .font(.subheadline)
                        .padding(.bottom, 10)

                    TextField("今日も一日頑張ろう", text: $message)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(5)
                        .padding(.bottom, 20)

                    Button(action: {
                        print("投稿ボタンが押されました: \(message)")
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

//
//  ChatView.swift
//  final_alarm_test
//
//  Created by 和田一真 on 2024/10/26.
//

import SwiftUI

struct CardView: View {
    var title: String
    var description: String

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(description)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(RoundedRectangle(cornerRadius: 10).fill(Color.cyan))
        .shadow(radius: 5)
    }
}

struct ChatView: View {
    var cards = [
        ("カード1", "これは1枚目のカードの説明です。"),
        ("カード2", "これは2枚目のカードの説明です。"),
        ("カード3", "これは3枚目のカードの説明です。"),
        ("カード4", "これは4枚目のカードの説明です。")
    ]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                ForEach(cards, id: \.0) { card in
                    CardView(title: card.0, description: card.1)
                        .padding(.horizontal)
                }
            }
            .padding(.vertical)
        }
    }
}

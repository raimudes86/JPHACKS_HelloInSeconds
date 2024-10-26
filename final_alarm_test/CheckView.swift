//
//  CheckView.swift
//  final_alarm_test
//
//  Created by Raimu Kinoshita on 2024/10/26.
//

import SwiftUI

struct CheckView: View {
    @State private var colorIndex: Int = 0
    @State private var showwritepage = false
    var body: some View {
        VStack {
            Text("適当なページ")
                .font(.largeTitle)
                .padding()

            Text("ここは画面遷移先の適当なページです。")
                .font(.body)
                .padding()
            
            Spacer() // 空白を追加して見た目を整える
            HStack{
                VStack{
                    Text("一回目")
                    Circle()
                        .fill(getColorleft(for: colorIndex))
                        .frame(width: 100, height: 100)
                        .padding()
                }
                VStack{
                    Text("二回目")
                    Circle()
                        .fill(getColorcenter(for: colorIndex))
                        .frame(width: 100, height: 100)
                        .padding()
                }
                VStack{
                    Text("三回目")
                    Circle()
                        .fill(getColorright(for: colorIndex))
                        .frame(width: 100, height: 100)
                        .padding()
                }
            }
            Spacer()
            if colorIndex <= 2{
                Button {
                    colorIndex += 1
                } label: {
                    Text("とめる")
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }else{
                Button {
                    showwritepage = true
                } label: {
                    Text("タイムラインへ一言投稿！")
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }

            }

        }
        .fullScreenCover(isPresented: $showwritepage) {
            WriteView()
        }
    }
    
    func getColorleft(for index: Int) -> Color {
        switch index {
        case 0: return Color.red
        default: return Color.blue
        }
    }
    func getColorcenter(for index: Int) -> Color {
        switch index {
        case 0: return Color.red
        case 1: return Color.red
        default: return Color.blue
        }
    }
    func getColorright(for index: Int) -> Color {
        switch index {
        case 0: return Color.red
        case 1: return Color.red
        case 2: return Color.red
        default: return Color.blue
        }
    }
}

struct CheckView_Previews: PreviewProvider {
    static var previews: some View {
        CheckView()
    }
}

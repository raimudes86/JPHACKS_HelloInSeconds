//
//  CheckView.swift
//  final_alarm_test
//
//  Created by Raimu Kinoshita on 2024/10/26.
//

import SwiftUI


struct CheckView: View {
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State private var currentDate = Date()
    @State private var colorIndex: Int = 0
    @State private var showwritepage = false
    var body: some View {
        VStack {
            Text("\(currentDate, formatter: dateFormatter)")
                    .onReceive(timer) { input in
                      currentDate = input
                    }
                    .font(.system(size: 100))
            
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
                        .padding(.horizontal,70)
                        .padding(.vertical, 40)
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .frame(width: 400, height: 200)
                }
            }else{
                Button {
                    showwritepage = true
                } label: {
                    Text("タイムラインへ一言投稿！")
                        .padding(.horizontal,70)
                        .padding(.vertical, 40)
                        .background(Color.red)
                        .foregroundColor(.white)
                        .frame(width: 400, height: 200)
                }

            }

        }
        .fullScreenCover(isPresented: $showwritepage) {
            WriteView()
        }
        var dateFormatter: DateFormatter {
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm"
            return formatter
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

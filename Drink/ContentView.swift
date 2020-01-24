//
//  ContentView.swift
//  Drink
//
//  Created by Tony on 1/14/20.
//  Copyright © 2020 Tony. All rights reserved.
//

import SwiftUI
import Foundation
import AVFoundation

struct ContentView: View {
    var timer: MyTimer = MyTimer()
    @State var remindedTimes: Int = 0
    @State var isReminding: Bool = false

    @State var inputString: String = ""
    @State var remainingTime: String = ""
    @State var temp: Bool = true

    var body: some View {
        VStack(alignment: .leading) {
            if !isReminding {
                HStack {
                    Text("启动喝水提醒")
                        .font(.headline)
                        .fixedSize()
                    Spacer()
                        .frame(maxWidth: 80)
                    MenuButton("􀍟") {
                        Button("Quit Drink") {
                            NSApplication.shared.terminate(self)
                        }
                    }
                        .frame(width: 16)
                        .menuButtonStyle(BorderlessButtonMenuButtonStyle())
                }
                HStack{
                    Text("间隔时间:").fixedSize()
                    TextField("", text: $inputString)
                        .frame(maxWidth: 30)
                    Text("分钟").fixedSize()
                    Button("启动", action: {
                        if self.inputString != "" && Int(self.inputString) != nil {
                            print("Starting Reminding!!!!!")
                            self.isReminding = true
                            self.timer.start(Int(self.inputString)!*60, action: {
                                (_ repeatedTimes: Int) in
                                self.remindedTimes += 1
                                self.remind()
                            }, remainUpdater: {
                                (remainingSecond: Int) in
                                if remainingSecond < 60 {
                                    self.remainingTime = "\(remainingSecond)秒"
                                } else if remainingSecond < 3600 {
                                    self.remainingTime = "\(remainingSecond/60):\(remainingSecond%60)"
                                } else {
                                    self.remainingTime = "\(remainingSecond/3600):\(remainingSecond%3600/60):\(remainingSecond%3600%60)"
                                }
                            })
                        }
                    })
                        .padding(.leading)
                        .disabled(self.inputString == "" || Int(self.inputString) == nil)
                        
                }
                if inputString != "" && Int(inputString) == nil {
                    Text("只能输入整数")
                        .font(.caption)
                        .foregroundColor(Color.red)
                }
            } else {
                HStack {
                    Text("喝水提醒")
                        .font(.headline)
                        .fixedSize()
                    Spacer()
                    MenuButton("􀍟") {
                        Button("Quit Drink") {
                            NSApplication.shared.terminate(self)
                        }
                    }
                    .frame(width: 16)
                    .padding(.leading)
                    .menuButtonStyle(BorderlessButtonMenuButtonStyle())
                }
                HStack {
                    Text("距离下次提醒: ").fixedSize()
                    Text(remainingTime).fixedSize()
                    Button("立即提醒", action: timer.immediateDo)
                }
                Button("停止提醒") {
                    self.isReminding = false
                    self.remindedTimes = self.timer.stop()
                }
            }
            
        }.padding(.all)
    }
    
    func remind() {
        let utterance = AVSpeechUtterance(string: "喝水提醒, 这是您喝的第\(remindedTimes)杯水")
        utterance.voice = AVSpeechSynthesisVoice(language: "zh-Hans")
        AVSpeechSynthesizer().speak(utterance)
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
            ContentView(inputString: "text")
            ContentView(isReminding: true)
        }
    }
}


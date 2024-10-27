//
//  ContentView.swift
//  AzooKeyKanaKanjiConverter-demo-2
//
//  Created by blueken on 2024/10/24.
//

import SwiftUI
import RealityKit
import RealityKitContent
import KanaKanjiConverterModuleWithDefaultDictionary

struct ContentView: View {
    @State var inputStr = ""
    @State var conversionResults = [""]
    @State var conversionResultsIndex = 0
    
    @State var complateStr = ""
    @State var complateStrs = [""]
    
    var body: some View {
        VStack {
            Model3D(named: "Scene", bundle: realityKitContentBundle)
                .padding(.bottom, 50)

            Text("Hello, world!")
            
            
            // 変換結果を出力
            Text(complateStr)
            
            
            TextField("変換する文字列を入力",text: $inputStr)
                .onChange(of: inputStr) {
                    // 変換器を初期化する
                    let converter = KanaKanjiConverter()
                    // 入力を初期化する
                    var c = ComposingText()
                    // 変換したい文章を追加する
                    c.insertAtCursorPosition(inputStr, inputStyle: .direct)
                    // 変換を行う
                    let results = converter.requestCandidates(c, options: .withDefaultDictionary(requireJapanesePrediction: true, requireEnglishPrediction: false, keyboardLanguage: .ja_JP, learningType: .nothing, memoryDirectoryURL: .cachesDirectory, sharedContainerURL: .cachesDirectory, metadata: .init(appVersionString: "0.0.0")))

                    // 結果の一番目を表示
                    print(results.mainResults.first?.text ?? "No results")
                    // 変換後の文字列を格納する
                    conversionResults = results.mainResults.map(\.text)
                }
            
            HStack{
                // 10個まで表示
                Picker("Select", selection: $conversionResultsIndex) {
                    let segmentedLengh = conversionResultsIndex < 10 ? 10 : 9
                    
                    ForEach(0..<min(conversionResults.count, segmentedLengh), id: \.self) { index in
                        Text(conversionResults[index]).tag(index)
                    }
                    if (conversionResultsIndex > 10) {
                        Text(conversionResults[conversionResultsIndex]).tag(conversionResultsIndex)
                    }
                }
                
                .pickerStyle(.segmented)
                if conversionResults.count > 10 {
                    Picker("More", selection: $conversionResultsIndex) {
                        ForEach(0..<conversionResults.count, id: \.self) { index in
                            Text(conversionResults[index])
                        }
                    }
                }
            }
            
            Button(action:{
                if !conversionResults.isEmpty {
                    complateStr = conversionResults[conversionResultsIndex]
                    // 入力関係の初期化
                    inputStr = ""
                    conversionResults = [""]
                    conversionResultsIndex = 0
                }
            }){
                Text("確定")
            }

            ToggleImmersiveSpaceButton()
        }
        .padding()
    }
}

#Preview(windowStyle: .automatic) {
    ContentView()
        .environment(AppModel())
}

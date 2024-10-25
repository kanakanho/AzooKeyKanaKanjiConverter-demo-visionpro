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
    @State var conversionBefore = "変換前の文字列が表示されます"
    @State var conversionResults = ["変換後の文字列が表示されます"]
    @State var conversionResultsIndex = 0
    
    var body: some View {
        VStack {
            Model3D(named: "Scene", bundle: realityKitContentBundle)
                .padding(.bottom, 50)

            Text("Hello, world!")
            
            TextField("変換する文字列を入力",text: $inputStr)
            
            Button(action: {
                // 変換器を初期化する
                let converter = KanaKanjiConverter()
                // 入力を初期化する
                var c = ComposingText()
                // 変換したい文章を追加する
                c.insertAtCursorPosition(inputStr, inputStyle: .direct)
                // 変換前の文字列を格納する
                conversionBefore = inputStr
                // 変換を行う
                let results = converter.requestCandidates(c, options: .withDefaultDictionary(requireJapanesePrediction: true, requireEnglishPrediction: false, keyboardLanguage: .ja_JP, learningType: .nothing, memoryDirectoryURL: .cachesDirectory, sharedContainerURL: .cachesDirectory, metadata: .init(appVersionString: "0.0.0")))

                // 結果の一番目を表示
                print(results.mainResults.first!.text)
                // 変換後の文字列を格納する
                conversionResults = results.mainResults.map(\.text)
            }) {
                Text("Button")
            }
            
            HStack {
                VStack{
                    Text("変換前")
                    Text(conversionBefore)
                }
                .padding(.trailing, 50)
                VStack{
                    Text("変換後")
                    Text(conversionResults[conversionResultsIndex])
                    HStack{
                        Button(action: {
                            conversionResultsIndex = max(conversionResultsIndex - 1, 0)
                        }) {
                            Text("前")
                        }
                        Button(action: {
                            conversionResultsIndex = min(conversionResultsIndex + 1, conversionResults.count - 1)
                        }) {
                            Text("次")
                        }
                    }
                }
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

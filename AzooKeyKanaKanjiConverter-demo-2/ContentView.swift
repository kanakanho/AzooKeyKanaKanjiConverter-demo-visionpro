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
    @State var conversionResults = [String]()
    @State var viewConversionResults = [String]()
    @State var conversionResultsIndex = 0
    @State var complateStr = ""
    
    var body: some View {
        VStack {
            TextField("変換する文字列を入力", text: $inputStr)
                .onChange(of: inputStr) {
                    guard !inputStr.isEmpty else { return }
                    
                    let converter = KanaKanjiConverter()
                    var c = ComposingText()
                    c.insertAtCursorPosition(inputStr, inputStyle: .direct)
                    
                    let results = converter.requestCandidates(
                        c,
                        options: .withDefaultDictionary(
                            requireJapanesePrediction: true,
                            requireEnglishPrediction: false,
                            keyboardLanguage: .ja_JP,
                            learningType: .nothing,
                            memoryDirectoryURL: .cachesDirectory,
                            sharedContainerURL: .cachesDirectory,
                            metadata: .init(appVersionString: "0.0.0")
                        )
                    )
                    
                    conversionResults = results.mainResults.map(\.text)
                    updateViewConversionResults()
                }
            
            Button("前") {
                if conversionResults.firstIndex(of: viewConversionResults[0]) == 0 {
                    return
                }
                navigateResults(offset: -10)
            }.disabled(conversionResults.isEmpty || conversionResults.firstIndex(of: viewConversionResults.first ?? "") == 0)
            
            HStack {
                List {
                    Picker("", selection: $conversionResultsIndex) {
                        ForEach(0..<viewConversionResults.count/2, id: \.self) { index in
                            Text("\(conversionResults.firstIndex(of: viewConversionResults[index]) ?? 0)  \(  viewConversionResults[index])").tag(index).lineLimit(1)
                            
                        }
                    }
                    .pickerStyle(.inline)
                }
                List {
                    Picker("", selection: $conversionResultsIndex) {
                        ForEach(viewConversionResults.count/2..<viewConversionResults.count, id: \.self) { index in
                            Text("\(conversionResults.firstIndex(of: viewConversionResults[index]) ?? 0)  \(  viewConversionResults[index])").tag(index).lineLimit(1)
                        }
                    }
                    .pickerStyle(.inline)
                }
            }
            
            Button("次") {
                if viewConversionResults.count < 10 {
                    return
                }
                navigateResults(offset: 10)
            }.disabled(viewConversionResults.count < 10 )
            
            Button("確定") {
                if !conversionResults.isEmpty {
                    complateStr = conversionResults[conversionResultsIndex]
                    resetInput()
                }
            }
            
            Text(complateStr)
        }
        .padding()
    }
    
    private func navigateResults(offset: Int) {
        let startIndex = (conversionResults.firstIndex(of: viewConversionResults.first ?? "") ?? 0) + offset
        updateViewConversionResults(startIndex: startIndex)
    }
    
    private func updateViewConversionResults(startIndex: Int = 0) {
        let start = max(0, min(startIndex, conversionResults.count - 1))
        let end = min(start + 10, conversionResults.count)
        viewConversionResults = Array(conversionResults[start..<end])
    }
    
    private func resetInput() {
        inputStr = ""
        conversionResults = []
        conversionResultsIndex = 0
        viewConversionResults = []
    }
}

#Preview(windowStyle: .automatic) {
    ContentView()
        .environment(AppModel())
}

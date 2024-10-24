# AzooKeyKanaKanjiConverter-demo-visionpro

## アプリの動作説明

> `ContentView.swift` 以外でデフォルトのアプリからソースコードの変更は行なっていません

### フィールド

| フィールド名       | 役割                                 |
| ------------------ | ------------------------------------ |
| `inputStr`         | 入力されている最中の文字列を保持する |
| `conversionBefore` | 変換前の文字列を保持する             |
| `conversionBefore` | 変換後の文字列を保持する             |

```swift:ContentView.swift
struct ContentView: View {
    @State var inputStr = ""
    @State var conversionBefore = "変換前の文字列が表示されます"
    @State var conversionResults = "変換後の文字列が表示されます"
    ...
```

### 入力

ユーザーからのテキストの入力を受け付ける. 入力されたテキストは `inputStr` に格納する

```swift:ContentView.swift
struct ContentView: View {
    var body: some View {
        VStack {
            ...
            TextField("変換する文字列を入力",text: $inputStr)
    ...
```

### 変換

ボタンが押された時に変換を行う  
処理内容はコメントに従う

```swfit:ContentView.swift
struct ContentView: View {
    ...
    var body: some View {
        VStack {
            ...
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
                conversionResults = results.mainResults.first!.text
            }) {
                Text("Button")
            }
        ...
```

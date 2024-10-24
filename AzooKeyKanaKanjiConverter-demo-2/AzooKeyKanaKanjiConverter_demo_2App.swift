//
//  AzooKeyKanaKanjiConverter_demo_2App.swift
//  AzooKeyKanaKanjiConverter-demo-2
//
//  Created by blueken on 2024/10/24.
//

import SwiftUI

@main
struct AzooKeyKanaKanjiConverter_demo_2App: App {

    @State private var appModel = AppModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(appModel)
        }

        ImmersiveSpace(id: appModel.immersiveSpaceID) {
            ImmersiveView()
                .environment(appModel)
                .onAppear {
                    appModel.immersiveSpaceState = .open
                }
                .onDisappear {
                    appModel.immersiveSpaceState = .closed
                }
        }
        .immersionStyle(selection: .constant(.mixed), in: .mixed)
     }
}

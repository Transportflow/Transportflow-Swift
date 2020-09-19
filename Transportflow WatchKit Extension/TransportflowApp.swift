//
//  TransportflowApp.swift
//  Transportflow WatchKit Extension
//
//  Created by Adrian Böhme on 19.09.20.
//

import SwiftUI

@main
struct TransportflowApp: App {
    @SceneBuilder var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
            }
        }

        WKNotificationScene(controller: NotificationController.self, category: "myCategory")
    }
}

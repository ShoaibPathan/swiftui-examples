//
//  NavigationApp.swift
//  Navigation
//
//  Created by Hao Luo on 12/7/20.
//

import SwiftUI

@main
struct NavigationApp: App {
    private let authStore: AuthenticationStore = .init()
    var body: some Scene {
        WindowGroup {
            ContentView(
                authStateStore: authStore,
                auth: MockAuthenticationService(storeWriter: authStore)
            )
        }
    }
}

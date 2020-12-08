//
//  ContentView.swift
//  Navigation
//
//  Created by Hao Luo on 12/7/20.
//

import Combine
import SwiftUI

struct ContentView: View {
    @ObservedObject private var authStateStore: AuthenticationStore
    private let auth: AuthenticationService
    init(
        authStateStore: AuthenticationStore,
        auth: AuthenticationService
    ) {
        self.authStateStore = authStateStore
        self.auth = auth
    }
    
    var body: some View {
        switch authStateStore.state {
        case .unauthenticated:
            SignUpView(auth: auth)
        case let .authenticated(user):
            HomeView(user: user)
        }
    }
}

struct SignUpView: View {
    let auth: AuthenticationService
    @State private var signInTapped: Bool = false
    
    var body: some View {
        NavigationView {
            VStack {
                Button("Sign Up") {
                    auth.signUp()
                }
                
                HStack {
                    Text("Already have an account?")
                    NavigationLink(
                        destination: SignInView(auth: auth),
                        isActive: $signInTapped
                    ){
                        Button("Sign in") {
                            signInTapped = true
                        }
                    }
                }.font(.subheadline)
            }
        }
    }
}

struct SignInView: View {
    let auth: AuthenticationService
    
    var body: some View {
        Button("Sign In") {
            auth.signIn()
        }
    }
}

struct HomeView: View {
    let user: User
    var body: some View {
        Text("Hello \(user.username)!")
    }
}

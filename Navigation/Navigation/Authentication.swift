//
//  Authentication.swift
//  Navigation
//
//  Created by Hao Luo on 12/7/20.
//

import Combine

struct User {
    var username: String
}

enum AuthenticationState {
    case unauthenticated
    case authenticated(User)
}

protocol AuthenticationService {
    func signUp()
    func signIn()
}

protocol AuthenticationStoreWriter {
    func update(_ newState: AuthenticationState)
}

final class AuthenticationStore: ObservableObject, AuthenticationStoreWriter {
    @Published private(set) var state: AuthenticationState = .unauthenticated
    
    func update(_ newState: AuthenticationState) {
        state = newState
    }
}

final class MockAuthenticationService: AuthenticationService {
    private let storeWriter: AuthenticationStoreWriter
    init(storeWriter: AuthenticationStoreWriter) {
        self.storeWriter = storeWriter
    }
    
    func signUp() {
        storeWriter.update(.authenticated(.init(username: "haoluo")))
    }
    
    func signIn() {
        storeWriter.update(.authenticated(.init(username: "haoluo")))
    }
}

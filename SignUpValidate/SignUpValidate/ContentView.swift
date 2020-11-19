//
//  ContentView.swift
//  SignUpValidate
//
//  Created by Hao Luo on 11/18/20.
//

import Combine
import SwiftUI

final class UserViewModel: ObservableObject {
    
    private enum ValidationResult<E> where E: Error {
        case valid
        case invalid(E)
    }
    
    private enum UsernameError: Error {
        case empty
    }
    
    private enum PasswordError: Error {
        case empty
        case notMatch
    }
    
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""
    
    @Published private(set) var usernameErrorMessage: String = ""
    @Published private(set) var passwordErrorMessage: String = ""
    @Published private(set) var isValid: Bool = false
    
    private var usernameValidationResult: AnyPublisher<ValidationResult<UsernameError>, Never> {
        return $username
            .debounce(for: 0.8, scheduler: RunLoop.main)
            .map { username -> ValidationResult<UsernameError> in
                if username.isEmpty {
                    return .invalid(.empty)
                }
                return .valid
            }
            .eraseToAnyPublisher()
    }
    
    private var passwordValidationResult: AnyPublisher<ValidationResult<PasswordError>, Never> {
        return Publishers.CombineLatest($password, $confirmPassword)
            .debounce(for: 0.2, scheduler: RunLoop.main)
            .map { (password, confirmPassword) -> ValidationResult<PasswordError> in
                if password.isEmpty {
                    return .invalid(.empty)
                }
                if password != confirmPassword {
                    return .invalid(.notMatch)
                }
                return .valid
            }
            .eraseToAnyPublisher()
    }
    
    private var cancellables: Set<AnyCancellable> = .init()
    
    init() {
        usernameValidationResult
            .map { result -> String in
                switch result {
                case .valid: return ""
                case let .invalid(error):
                    switch error {
                    case .empty: return "Username can't be empty"
                    }
                }
            }
            .assign(to: \.usernameErrorMessage, on: self)
            .store(in: &cancellables)
        
        passwordValidationResult
            .map { result -> String in
                switch result {
                case .valid: return ""
                case let .invalid(error):
                    switch error {
                    case .empty: return "Password can't be empty"
                    case .notMatch: return "Passwords don't match"
                    }
                }
            }
            .assign(to: \.passwordErrorMessage, on: self)
            .store(in: &cancellables)
        
        Publishers.CombineLatest(usernameValidationResult, passwordValidationResult)
            .map { (usernameResult, passwordResult) -> Bool in
                switch (usernameResult, passwordResult) {
                case (.valid, .valid): return true
                default: return false
                }
            }
            .assign(to: \.isValid, on: self)
            .store(in: &cancellables)
    }
}

struct ContentView: View {
    @ObservedObject var viewModel: UserViewModel
    @State private var signUpCompleted: Bool = false
    
    var body: some View {
        NavigationView {
            Form {
                Section(footer: Text(viewModel.usernameErrorMessage).foregroundColor(.red)) {
                    TextField("Username", text: $viewModel.username)
                }
                
                Section(footer: Text(viewModel.passwordErrorMessage).foregroundColor(.red)) {
                    SecureField("Password", text: $viewModel.password)
                        .textContentType(.oneTimeCode) // disable strong password autofill
                    SecureField("Confirm Password", text: $viewModel.confirmPassword)
                        .textContentType(.oneTimeCode)
                }
                
                Section {
                    NavigationLink(
                        destination: Text("Hello \(viewModel.username)!"),
                        isActive: $signUpCompleted,
                        label: {
                            Button(action: {
                                signUpCompleted = true
                            }, label: {
                                Text("Sign Up")
                                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
                            })
                            .disabled(!viewModel.isValid)
                        })
                }
            }
        }
    }
}

//
//  SignInWithApple.swift
//  Demo
//
//  Created by 黃崇漢 on 2020/4/14.
//  Copyright © 2020 Tony Huang (黃崇漢). All rights reserved.
//

import UIKit
import AuthenticationServices

@objc protocol SignInWithAppleDelegate: AnyObject {
    @objc optional func success()
    @objc optional func failure(_ error: Error)
}

class SignInWithApple: NSObject {
    private enum SignInWithAppleCredential {
        case user
        case givenName
        case familyName
        case email
        
        var value: String? {
            switch self {
            case .user:
                return UserDefaults.standard.string(forKey: self.key)
            case .givenName:
                return UserDefaults.standard.string(forKey: self.key)
            case .familyName:
                return UserDefaults.standard.string(forKey: self.key)
            case .email:
                return UserDefaults.standard.string(forKey: self.key)
            }
        }
        
        var key: String {
            let IDFV = UIDevice.current.identifierForVendor?.uuidString ?? UUID().uuidString
            
            switch self {
            case .user:
                return IDFV + "_user"
            case .givenName:
                return IDFV + "_givenName"
            case .familyName:
                return IDFV + "_givenName"
            case .email:
                return IDFV + "_email"
            }
        }
    }
    
    weak var delegate: SignInWithAppleDelegate?
    
    func authorizationButton(frame: CGRect, type: ASAuthorizationAppleIDButton.ButtonType, style: ASAuthorizationAppleIDButton.Style) -> UIControl {
        let button = ASAuthorizationAppleIDButton(authorizationButtonType: type, authorizationButtonStyle: style)
        
        button.frame = frame
        button.addTarget(self, action: #selector(signInRequest), for: .touchUpInside)
        
        return button
    }
    
    @objc private func signInRequest() {
        let provider = ASAuthorizationAppleIDProvider()
        let request = provider.createRequest()
        request.requestedScopes = [.email, .fullName]
        
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.presentationContextProvider = self
        controller.performRequests()
    }
    
    func isSignIn(isSignIn: @escaping (Bool) -> Void) {
        guard let userID = SignInWithAppleCredential.user.value, !userID.isEmpty else {
            isSignIn(false)
            
            return
        }
        
        self.getCredentialState(withUserID: userID) { (credentialState, error) in
            if credentialState == .authorized {
                isSignIn(true)
            }
            else {
                isSignIn(false)
            }
        }
    }
    
    func performExistingAccountSetupFlows() {
        let requests = [ASAuthorizationAppleIDProvider().createRequest(),
                       ASAuthorizationPasswordProvider().createRequest()]
        
        let controller = ASAuthorizationController(authorizationRequests: requests)
        controller.delegate = self
        controller.presentationContextProvider = self
        controller.performRequests()
    }
    
    private func getCredentialState(withUserID userID: String, completion: @escaping (ASAuthorizationAppleIDProvider.CredentialState, Error?) -> Void) {
        let provider = ASAuthorizationAppleIDProvider()
        provider.getCredentialState(forUserID: userID, completion: completion)
    }
    
    func getUser() -> String {
        return SignInWithAppleCredential.user.value ?? ""
    }
    
    func getGivenName() -> String {
        return SignInWithAppleCredential.givenName.value ?? ""
    }
    
    func getFamilyName() -> String {
        return SignInWithAppleCredential.familyName.value ?? ""
    }
    
    func getEmail() -> String {
        return SignInWithAppleCredential.email.value ?? ""
    }
}

extension SignInWithApple: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        guard let credential = authorization.credential as? ASAuthorizationAppleIDCredential else {
            return
        }
        
        if !credential.user.isEmpty {
            UserDefaults.standard.set(credential.user, forKey: SignInWithAppleCredential.user.key)
        }
        
        if let fullName = credential.fullName {
            if let givenName = fullName.givenName, !givenName.isEmpty {
                UserDefaults.standard.set(givenName, forKey: SignInWithAppleCredential.givenName.key)
            }
            
            if let familyName = fullName.familyName, !familyName.isEmpty {
                UserDefaults.standard.set(familyName, forKey: SignInWithAppleCredential.givenName.key)
            }
        }
        
        if let email = credential.email, !email.isEmpty {
            UserDefaults.standard.set(email, forKey: SignInWithAppleCredential.email.key)
        }
        
        self.delegate?.success?()
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        self.delegate?.failure?(error)
    }
}

extension SignInWithApple: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return (UIApplication.shared.delegate?.window)!!
    }
}

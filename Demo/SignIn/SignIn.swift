//
//  SignIn.swift
//  Demo
//
//  Created by 黃崇漢 on 2020/4/13.
//  Copyright © 2020 Tony Huang (黃崇漢). All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import FBSDKLoginKit

class SignIn: UIViewController {

    @IBOutlet weak var signInWithAppleButtonView: UIView!
    @IBOutlet weak var signInButton: GIDSignInButton!
    @IBOutlet weak var signInFBButton: UIView!
    
    let signInWithApple = SignInWithApple()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GIDSignIn.sharedInstance()?.presentingViewController = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.signInWithApple.delegate = self
        self.signInWithAppleButtonView.addSubview(self.signInWithApple.authorizationButton(frame: self.signInWithAppleButtonView.bounds, type: .signIn, style: .whiteOutline))
        
        let fbLoginButton = FBLoginButton(frame: self.signInFBButton.bounds)
        fbLoginButton.permissions = ["public_profile", "email"]
        self.signInFBButton.addSubview(fbLoginButton)
    }
    
    @IBAction func signInButtonClick(_ sender: Any) {
        GIDSignIn.sharedInstance().signIn()
    }
    
    @IBAction func signInFBClick(_ sender: Any) {
        if let token = AccessToken.current {
            self.getFBDetails()
        }
        else {
            self.signInFB()
        }
    }
    
    func signInFB() {
        let loginManager = LoginManager()
        loginManager.logIn(permissions: ["public_profile", "email"], from: self) { (loginResult, error) in
            if error == nil {
                self.getFBDetails()
            }
        }
    }
    
    func getFBDetails() {
        let param = ["fields":"name, email, gender, age_range, birthday, first_name"]
        let graphRequest = GraphRequest(graphPath: "me", parameters: param)
        graphRequest.start { (connection, result, error) in
            print("=====> \(String(describing: result))")
        }
    }
}

extension SignIn: SignInWithAppleDelegate {
    func success() {
        print("=====> SignInWithApple success")
        print("=====> user: \(self.signInWithApple.getUser())")
        print("=====> givenName: \(self.signInWithApple.getGivenName())")
        print("=====> familyName: \(self.signInWithApple.getFamilyName())")
        print("=====> email: \(self.signInWithApple.getEmail())")
    }
    
    func failure(_ error: Error) {
        print("=====> SignInWithApple failure \(error)")
    }
}

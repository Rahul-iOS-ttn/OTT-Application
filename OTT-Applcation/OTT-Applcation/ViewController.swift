//
//  ViewController.swift
//  OTT-Applcation
//
//  Created by TTN on 23/06/21.
//

import UIKit
import SocialLogin
import AuthenticationServices

@available(iOS 13.0, *)
class ViewController: UIViewController {
    
    @IBOutlet weak var loginWithFbButton: UIButton!
    @IBOutlet weak var loginWithGoogleButton: UIButton!
    @IBOutlet weak var loginWithAppleButton: ASAuthorizationAppleIDButton!
    
    @IBOutlet weak var signOut: UIButton!
    @IBOutlet weak var tokenLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    
    @IBOutlet weak var loggedInView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        Validator.sayHello()
        print("This email is valid: ", Validator.validEmail("rahul@rahul.com"))
        prepareViewOnLoad()
    }
    
    var observerToken: NSObjectProtocol?
}

// MARK: - View Setup

@available(iOS 13.0, *)
extension ViewController {
    func prepareViewOnLoad () {
        view.backgroundColor = .white
        
        
        observeCredential()
        loginWithFbButton.setTitle("Connect with Facebook", for: .normal)
        
        
        loginWithGoogleButton.setTitle("Connect with Google", for: .normal)
        
        loginWithAppleButton.addTarget(self, action: #selector(handleAuthorizationAppleIDButtonPress), for: .touchUpInside)
        loginWithFbButton.addTarget(self, action: #selector(didTapFacebook), for: .touchUpInside)
        loginWithGoogleButton.addTarget(self, action: #selector(didTapGoogle), for: .touchUpInside)
        
        signOut.addTarget(self, action: #selector(didTapSignOut), for: .touchUpInside)
        
        
        ANAuthService.shared.hasPreviousSignIn { [weak self] signedIn in
            if signedIn {
                
                ANAuthService.shared.restoreUserSession {[weak self] (result) in
                    
                    switch result {
                    case .success(let successObj):
                        print("login via sucessfull \(String(describing: successObj.authToken))")
                        self?.updateView(auth: successObj)
                        
                    case .failure(let error):
                        print("Login Failed: \(error.localizedDescription)")
                    }
                }
                
            }else {
                
                ANAuthService.shared.restoreUserSessionExplicit(with: .apple) {[weak self] (result) in
                    
                    switch result {
                    case .success(let successObj):
                        print("login via sucessfull \(String(describing: successObj.authToken))")
                        self?.updateView(auth: successObj)
                        
                    case .failure(let error):
                        print("Login Failed: \(error.localizedDescription)")
                    }
                }
                
                self?.loggedInView.isHidden = true
            }
        }
    }
}


// MARK: Actions
@available(iOS 13.0, *)
extension ViewController: CredentialRevokedObservable {
    
    
    func credentialRevoked() {
        
        ANAuthService.shared.signOut() { [self] result in
            switch result {
            case .success:
                self.cleanView()
            case .failure(let error):
                print("Could not logout with error - \(error.localizedDescription)")
            }
        }
    }
    
    
    @objc func close() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func didTapFacebook() {
        
        ANAuthService.shared.signIn(with: .facebook, fromView: self) {[weak self] (result) in
            
            switch result {
            case .success(let successObj):
                print("login via Facebook sucessfull \(String(describing: successObj.authToken))")
                self?.updateView(auth: successObj)
                
            case .failure(let error):
                print("Login Failed: \(error.localizedDescription)")
            }
        }
    }
    
    @objc func didTapGoogle() {
        
        ANAuthService.shared.signIn(with: .google, fromView: self) {[weak self] (result) in
            
            switch result {
            case .success(let successObj):
                print("login via google sucessfull \(String(describing: successObj.authToken))")
                self?.updateView(auth: successObj)
                
            case .failure(let error):
                print("Login Failed: \(error.localizedDescription)")
            }
        }
    }
    
    /// - Tag: perform_applied_request
    @objc
    func handleAuthorizationAppleIDButtonPress() {
        
        ANAuthService.shared.signIn(with: .apple, fromView: self) {[weak self] (result) in
            
            switch result {
            case .success(let successObj):
                print("login via apple sucessfull \(String(describing: successObj.authToken))")
                self?.updateView(auth: successObj)
                
            case .failure(let error):
                print("Login Failed: \(error.localizedDescription)")
            }
        }
    }
    
    @objc func didTapSignOut() {
        
        ANAuthService.shared.signOut() { [self] _ in
            self.cleanView()
        }
        
    }
    
    
    func updateView(auth : ANUserAuth) {
        loggedInView.isHidden = false
        nameLabel.text = auth.anUser?.profileName
        tokenLabel.text = auth.authToken
        idLabel.text = auth.anUser?.userId
    }
    
    func cleanView() {
        loggedInView.isHidden = true
        nameLabel.text = nil
        tokenLabel.text = nil
        idLabel.text = nil
    }
    
}


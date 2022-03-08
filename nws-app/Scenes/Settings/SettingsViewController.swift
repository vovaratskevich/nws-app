//
//  SettingsViewController.swift
//  nws-app
//
//  Created by Vladimir Ratskevich on 21.01.22.
//

import UIKit
import FirebaseAuth

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var loginStackView: UIStackView!
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var logoutButton: UIButton!
    
    @IBOutlet weak var succesLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setStrings()
        setupElements()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let userDefault = UserDefaults.standard
        userDefault.synchronize()
        let savedData = userDefault.bool(forKey: "isLoggedIn")
        if(savedData){
            loginStackView.isHidden = true
            succesLabel.isHidden = false
            logoutButton.isHidden = false
        }else{
            loginStackView.isHidden = false
            succesLabel.isHidden = true
            logoutButton.isHidden = true
        }
    }
    
    private func validateFields() {
        if emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            errorLabel.text = "Заполните поля!"
            errorLabel.alpha = 1
        } else {
            errorLabel.text = "Неверная почта или пароль."
            errorLabel.alpha = 1
        }
    }
    
    private func setupElements() {
        errorLabel.alpha = 0
        Utilities.styleTextField(emailTextField)
        Utilities.styleTextField(passwordTextField)
        Utilities.styleFilledButton(loginButton)
    }
    
    @IBAction func loginTapped(_ sender: Any) {
        
        // Create cleaned version of the TextField
        let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        //Sign in the user
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            
            if error != nil {
                self.validateFields()
            } else {
                let userDefault = UserDefaults.standard
                userDefault.set(true, forKey: "isLoggedIn")
                userDefault.synchronize()
                //Transition to Welcome screen
                self.transitionToWelcomes()
            }
        }
    }
    
    @IBAction func logoutButtonTapped(_ sender: Any) {
        let userDefault = UserDefaults.standard
        userDefault.set(false, forKey: "isLoggedIn")
        userDefault.synchronize()
        
        loginStackView.isHidden = false
        succesLabel.isHidden = true
        logoutButton.isHidden = true
        
        viewWillAppear(true)
    }
    
    private func transitionToWelcomes() {
//        let welcomeViewController = storyboard?.instantiateViewController(identifier: Constants.Storyboard.welcomeViewController)
//
//        view.window?.rootViewController = welcomeViewController
//        view.window?.makeKeyAndVisible()
        emailTextField.text = ""
        passwordTextField.text = ""
        
        loginStackView.isHidden = true
        succesLabel.isHidden = false
        logoutButton.isHidden = false
    }
}

extension SettingsViewController {
    
    private func setStrings() {
        navigationItem.title = "Аторизация"
    }
}


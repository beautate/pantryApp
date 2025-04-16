//
//  HomeViewController.swift
//  PantryApp
//
//  Created by Beau Tate on 4/15/25.
//

import UIKit

class HomeViewController: UIViewController {
    //MARK: -Outlets and actions
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set system background color
        view.backgroundColor = .systemBackground
    }
    
    @IBAction func signInTapped(_ sender: UIButton) {
        // Validate input
        guard let username = usernameTextField.text, !username.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else {
            showAlert(message: "Please enter a username and password.")
            return
        }
        
        //Store credentials to persistent memory without any authentication
        //TO DO: If we develop app further add user authentication
        UserDefaults.standard.set(username, forKey: "username")
        UserDefaults.standard.set(password, forKey: "password")
        UserDefaults.standard.set(true, forKey: "isSignedIn")
        
        // Transition to the tab bar controller
        transitionToTabBarController()
    }
    
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    // Segue from log-in screen to tab bar controller
    private func transitionToTabBarController() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let tabBarController = storyboard.instantiateViewController(withIdentifier: "TabBarController") as? UITabBarController {
            // Set TBC as root view controller
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let sceneDelegate = windowScene.delegate as? SceneDelegate,
               let window = sceneDelegate.window {
                window.rootViewController = tabBarController
                window.makeKeyAndVisible()
            }
        }
    }
}

 


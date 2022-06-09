//
//  ViewController.swift
//  ProyectoIOS1
//
//  Created by proximo on 7/19/20.
//  Copyright © 2020 proximo. All rights reserved.
//

import UIKit
import FirebaseAnalytics
import FirebaseAuth

class AuthViewController: UIViewController {

    @IBOutlet weak var authStackView: UIStackView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Autenticacion"
        // Analytics Event
        Analytics.logEvent("InitScreen", parameters: ["message" : "Integracion de Firebase completa"])
        
        // Comprobar la sesion del usuario autenticado
        let defaults = UserDefaults.standard
        if let email = defaults.value(forKey: "email") as? String,
            let provider = defaults.value(forKey: "provider") as? String{
            
            authStackView.isHidden = true
            
            navigationController?.pushViewController(HomeViewController(email : email, provider: ProviderType.init(rawValue: provider)!), animated: false)
        }
    }

    @IBAction func signUpButtonAction(_ sender: Any) {
        
        if let email = emailTextField.text,let password = passwordTextField.text{
            Auth.auth().createUser(withEmail: email, password: password)
            {
              (result,error)in
                if let result = result, error == nil{
                    self.navigationController?.pushViewController(HomeViewController(email : result.user.email!, provider: .basic), animated: true)
                    
                }else{
                    let alertController = UIAlertController(title: "Error", message: "se ha producido un error registrando el usuario", preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title:"Aceptar", style: .default))
                    
                    self.present(alertController, animated: true, completion: nil)
                }
            }     }
    }
    
    @IBAction func loginButtonAction(_ sender: Any) {
        if let email = emailTextField.text,let password = passwordTextField.text{
            Auth.auth().signIn(withEmail: email, password: password)
            {
                (result,error)in
                if let result = result, error == nil{
                    self.navigationController?.pushViewController(HomeViewController(email : result.user.email!, provider: .basic), animated: true)
                    
                }else{
                    let alertController = UIAlertController(title: "Error", message: "se ha producido un error registrando el usuario", preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title:"Aceptar", style: .default))
                    
                    self.present(alertController, animated: true, completion: nil)
                }
            }     }
    }
}


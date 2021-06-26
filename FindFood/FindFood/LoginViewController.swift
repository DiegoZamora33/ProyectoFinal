//
//  LoginViewController.swift
//  FindFood
//
//  Created by Diego Zamora on 24/06/21.
//

import UIKit
import LoadingAlert

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        /// Mostramos Loading Nice
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: LoadingAlert.bind {
            
        })
    }
    
    @IBAction func btnLogin(_ sender: UIButton) {
        
        performSegue(withIdentifier: "Home", sender: self)
        
    }
    
    

}

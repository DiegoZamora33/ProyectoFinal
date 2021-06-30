//
//  LoginViewController.swift
//  FindFood
//
//  Created by Diego Zamora on 24/06/21.
//

import UIKit
import LoadingAlert
import HideKeyboardTapGestureManager
import Firebase

class LoginViewController: UIViewController {

    //MARK: - Variables y Outlets
    @IBOutlet weak var inicioGoogle: UIButton!
    @IBOutlet weak var singIn: UIButton!
    @IBOutlet var superView: UIView!
    @IBOutlet weak var miEmail: UITextField!
    @IBOutlet weak var miPass: UITextField!
    
    
    let hideKeyboardTapGestureManager = HideKeyboardTapGestureManager()
    
    
    //MARK: - DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// Agregamos Gesture Taps para ocultar Teclado
        hideKeyboardTapGestureManager.add(targets: [superView])
        
        /// Le damos estilo a mi boton Google
        inicioGoogle.setTitleColor(.black, for: .normal)
        inicioGoogle.titleLabel?.font = UIFont.systemFont(ofSize: 22.0, weight: .semibold)
        inicioGoogle.titleLabel?.textColor = .black
        inicioGoogle.backgroundColor = .white
        inicioGoogle.layer.cornerRadius = inicioGoogle.bounds.height / 2.0
        inicioGoogle.contentEdgeInsets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        inicioGoogle.layer.shadowColor = UIColor.black.cgColor
        inicioGoogle.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        inicioGoogle.layer.shadowRadius = 2.0
        inicioGoogle.layer.shadowOpacity = 0.2
        
        /// Le damos estilo a mi boton SingIn
        singIn.setTitleColor(.black, for: .normal)
        singIn.titleLabel?.font = UIFont.systemFont(ofSize: 22.0, weight: .semibold)
        singIn.titleLabel?.textColor = .black
        singIn.backgroundColor = .white
        singIn.layer.cornerRadius = singIn.bounds.height / 2.0
        singIn.contentEdgeInsets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        singIn.layer.shadowColor = UIColor.black.cgColor
        singIn.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        singIn.layer.shadowRadius = 2.0
        singIn.layer.shadowOpacity = 0.2
        
        
        /// Mostramos mi Loading
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: LoadingAlert.bind {
            
            /// Verificamos si ya esta guardada la sesion
            let defaults = UserDefaults.standard
            if (defaults.value(forKey: "email") as? String) != nil{
                
                /// Nos vamos hata HOME
                //self.performSegue(withIdentifier: "Home", sender: self)
                
                print("DALE AL HOME")
            }
            else
            {
                /// Mostramos mi Onboarding
                
                print("AQUI TE QUEDAS")
            }
            
        })
    }
    
    
    //MARK: - WILL APEAR
    override func viewDidAppear(_ animated: Bool) {
        /// Mostramos mi Loading
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: LoadingAlert.bind {
            
            /// Verificamos si ya esta guardada la sesion
            let defaults = UserDefaults.standard
            if (defaults.value(forKey: "email") as? String) != nil{
                
                /// Nos vamos hata HOME
                //self.performSegue(withIdentifier: "Home", sender: self)
                
                print("DALE AL HOME")
            }
            else
            {
                /// Mostramos mi Onboarding
                
                print("AQUI TE QUEDAS")
            }
            
        })
    }
    
    //MARK: - Mis Funciones
    @IBAction func btnGoogleGo(_ sender: UIButton) {
        
        performSegue(withIdentifier: "Home", sender: self)
        
    }
    
    
    @IBAction func btnSingIn(_ sender: UIButton) {
        
        /// Mostramos mi Loading
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: LoadingAlert.bind {
            if let email = self.miEmail.text, let password = self.miPass.text {
                Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                 
                    if let e = error {
                        /// Error
                        self.alertaMensaje(msj: e.localizedDescription)
                        
                    } else {
                        // Guardamos mi Email
                        let defaults = UserDefaults.standard
                        defaults.set(email, forKey: "email")
                        defaults.synchronize()
                        
                        /// Navegar al Home
                        //self.performSegue(withIdentifier: "Home", sender: self)
                        
                        self.navigationController?.popToRootViewController(animated: true)
                    }
                    
                }
            }
        })
    }
    
    
    /// Para Mostrar Errores ALerta
    func alertaMensaje(msj: String) {
        let alerta = UIAlertController(title: "FindFood", message: msj, preferredStyle: .alert)
        alerta.addAction(UIAlertAction(title: "Aceptar", style: .cancel, handler: nil))
        present(alerta, animated: true, completion: nil)
    }
    
}

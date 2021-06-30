//
//  CrearCuentaViewController.swift
//  FindFood
//
//  Created by Diego Zamora on 29/06/21.
//

import UIKit
import LoadingAlert
import HideKeyboardTapGestureManager
import Firebase
import FirebaseFirestore

class CrearCuentaViewController: UIViewController {
    
    //MARK: - Variables y Outlets
    @IBOutlet weak var singUp: UIButton!
    @IBOutlet var superView: UIView!
    @IBOutlet weak var miEmail: UITextField!
    @IBOutlet weak var miPass: UITextField!
    @IBOutlet weak var miNombre: UITextField!
    
    let hideKeyboardTapGestureManager = HideKeyboardTapGestureManager()
    
    let db = Firestore.firestore()

    
    
    //MARK: - DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        /// Agregamos Gesture Taps para ocultar Teclado
        hideKeyboardTapGestureManager.add(targets: [superView])
        
        /// Le damos estilo a mi boton SingIn
        singUp.setTitleColor(.black, for: .normal)
        singUp.titleLabel?.font = UIFont.systemFont(ofSize: 22.0, weight: .semibold)
        singUp.titleLabel?.textColor = .black
        singUp.backgroundColor = .white
        singUp.layer.cornerRadius = singUp.bounds.height / 2.0
        singUp.contentEdgeInsets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        singUp.layer.shadowColor = UIColor.black.cgColor
        singUp.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        singUp.layer.shadowRadius = 2.0
        singUp.layer.shadowOpacity = 0.2

    }
    

    //MARK: - Mis Funciones

    /// Vamos a crear una nueva cuenta
    @IBAction func btnCrearCuenta(_ sender: UIButton) {
        /// Mostramos mi Loading
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: LoadingAlert.bind {
            if let email = self.miEmail.text, let password = self.miPass.text {
                
                if (self.miNombre.text != nil) && self.miNombre.text!.lengthOfBytes(using: String.Encoding.ascii) > 0 {
                    Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                        if let e = error {
                            print("Error al crear usuario \(e.localizedDescription)")
                            
                            if e.localizedDescription == "The email address is already in use by another account." {
                                self.alertaMensaje(msj: "Lo sentimos el correo '\(email)' ya esta en uso ☹️")
                            } else if e.localizedDescription == "The email address is badly formatted." {
                                self.alertaMensaje(msj: "Prfavor verifica que estas escribien un coreo valido. 🙂")
                            } else if e.localizedDescription == "The password must be 6 characters long or more." {
                                self.alertaMensaje(msj: "Tu contraseña debe de ser de 6 caracteres o mas 🧐")
                            }
                            
                        } else {
                            
                            /// Guardamos mi Email
                            let defaults = UserDefaults.standard
                            defaults.set(email, forKey: "email")
                            defaults.synchronize()
                            
                            /// Creamos el Perfil del Usuario
                            let documentoNombre = email
                            self.db.collection("perfiles").document(documentoNombre).setData(["usuario": email, "nombre": self.miNombre.text ?? "\(email)"]) { (error) in
                                
                                //En caso de error
                                if let e = error {
                                    self.alertaMensaje(msj: "Error al guardar en Firestore \(e.localizedDescription)")
                                } else {
                                    /// En caso de enviar
                                    print("Se guardo la info en firestore")
                                }
                            }
                            
                            /// Navegar al siguiente VC
                            //self.performSegue(withIdentifier: "Home", sender: self)
                            
                            
                                self.performSegue(withIdentifier: "Home", sender: LoginViewController.self)
                            
                        }
                        
                    }
                }else
                {
                    self.alertaMensaje(msj: "Porfavor Introduce un Nombre, asi es como Apareceras en FindFood")
                }
                
            }
            else
            {
                self.alertaMensaje(msj: "Porfavor llena todo los campos es necesario en FindFood")
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

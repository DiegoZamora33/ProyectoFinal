//
//  LoginViewController.swift
//  FindFood
//
//  Created by Diego Zamora on 24/06/21.
//

import UIKit
import LoadingAlert
import HideKeyboardTapGestureManager

class LoginViewController: UIViewController {

    //MARK: - Variables y Outlets
    @IBOutlet weak var txtInicioSesion: UILabel!
    @IBOutlet weak var inicioGoogle: UIButton!
    @IBOutlet weak var singIn: UIButton!
    @IBOutlet var superView: UIView!
    
    
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

    }
    
    //MARK: - Mis Funciones
    @IBAction func btnGoogleGo(_ sender: UIButton) {
        
        performSegue(withIdentifier: "Home", sender: self)
        
    }
    
}

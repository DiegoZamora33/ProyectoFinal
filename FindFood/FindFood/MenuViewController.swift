//
//  MenuViewController.swift
//  FindFood
//
//  Created by Diego Zamora on 24/06/21.
//

import UIKit
class MenuViewController: UIViewController {
    
    //MARK: - Variables y Outlets
    @IBOutlet weak var btnSalir: UIButton!
    @IBOutlet weak var txtUser: UIButton!
    @IBOutlet weak var btnFavoritos: UIButton!
    
    
    //MARK: - DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        /// Le damos un estilo Nice al Btn SAlir
        btnSalir.setTitleColor(.white, for: .normal)
        btnSalir.titleLabel?.font = UIFont.systemFont(ofSize: 18.0, weight: .semibold)
        btnSalir.titleLabel?.textColor = .white
        btnSalir.backgroundColor = .systemRed
        btnSalir.layer.cornerRadius = btnSalir.bounds.height / 2.0
        btnSalir.contentEdgeInsets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        btnSalir.layer.shadowColor = UIColor.label.cgColor
        btnSalir.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        btnSalir.layer.shadowRadius = 2.0
        btnSalir.layer.shadowOpacity = 0.2
        
        
        /// Le damos un estilo al txtUser
        txtUser.setTitleColor(.black, for: .normal)
        txtUser.titleLabel?.font = UIFont.systemFont(ofSize: 18.0, weight: .semibold)
        txtUser.titleLabel?.textColor = .black
        txtUser.backgroundColor = .white
        txtUser.layer.cornerRadius = txtUser.bounds.height / 2.0
        txtUser.contentEdgeInsets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        txtUser.layer.shadowColor = UIColor.label.cgColor
        txtUser.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        txtUser.layer.shadowRadius = 2.0
        txtUser.layer.shadowOpacity = 0.2
        
        /// Le damos un estilo al txtUser
        btnFavoritos.setTitleColor(.black, for: .normal)
        btnFavoritos.titleLabel?.font = UIFont.systemFont(ofSize: 15.0, weight: .semibold)
        btnFavoritos.titleLabel?.textColor = .black
        btnFavoritos.backgroundColor = .white
        btnFavoritos.layer.cornerRadius = btnFavoritos.bounds.height / 2.0
        btnFavoritos.contentEdgeInsets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        btnFavoritos.layer.shadowColor = UIColor.label.cgColor
        btnFavoritos.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        btnFavoritos.layer.shadowRadius = 2.0
        btnFavoritos.layer.shadowOpacity = 0.2
    }
    
    
    //MARK - mis Funciones
    @IBAction func btnSalir(_ sender: UIButton) {
        
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: "email")
        defaults.synchronize()
        
        performSegue(withIdentifier: "SingOut", sender: self)
        
    }
    
}

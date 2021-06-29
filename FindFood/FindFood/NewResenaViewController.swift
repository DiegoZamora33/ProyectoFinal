//
//  NewResenaViewController.swift
//  FindFood
//
//  Created by Diego Zamora on 26/06/21.
//

import UIKit
import CoreLocation
import HideKeyboardTapGestureManager

class NewResenaViewController: UIViewController {
    
    //MARK: - Variables y Outlets
    @IBOutlet weak var myRateView: RateView!
    @IBOutlet weak var btnEnviar: UIButton!
    @IBOutlet var superView: UIView!
    
    var miUbicacion: CLLocationCoordinate2D?
    let hideKeyboardTapGestureManager = HideKeyboardTapGestureManager()
    
    
    //MARK: - DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// Agregamos Gesture Taps para ocultar Teclado
        hideKeyboardTapGestureManager.add(targets: [superView])
        
        /// Valor Default a mi StarView
        myRateView.rating = 1
        
        // Le damos un estilo Nice al btnEnviar
        btnEnviar.setTitleColor(.label, for: .normal)
        btnEnviar.titleLabel?.font = UIFont.systemFont(ofSize: 22.0, weight: .semibold)
        btnEnviar.titleLabel?.textColor = .label
        btnEnviar.backgroundColor = .systemBackground
        btnEnviar.layer.cornerRadius = btnEnviar.bounds.height / 2.0
        btnEnviar.contentEdgeInsets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        btnEnviar.layer.shadowColor = UIColor.label.cgColor
        btnEnviar.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        btnEnviar.layer.shadowRadius = 2.0
        btnEnviar.layer.shadowOpacity = 0.2
        
    }
    
    //MARK: - Mis Funciones
}

//
//  VerResenaViewController.swift
//  FindFood
//
//  Created by Diego Zamora on 26/06/21.
//

import UIKit
import Firebase
import FirebaseFirestore
import HideKeyboardTapGestureManager


class VerResenaViewController: UIViewController {

    //MARK: - Variables y Outlets
    @IBOutlet weak var rateView: RateView!
    @IBOutlet weak var miRestaurant: UILabel!
    @IBOutlet weak var miPlatillo: UILabel!
    @IBOutlet weak var miTexto: UITextView!
    @IBOutlet var superView: UIView!
    @IBOutlet weak var miUsuario: UILabel!
    
    var miResena: Resena?
    let hideKeyboardTapGestureManager = HideKeyboardTapGestureManager()
    
    //MARK: - DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        /// Agregamos Gesture Taps para ocultar Teclado
        hideKeyboardTapGestureManager.add(targets: [superView])
        
        /// Set Value RateView
        rateView.rating = (miResena?.puntuacion)!
        
        miRestaurant.text = miResena?.restaurant
        miPlatillo.text = miResena?.platillo
        miTexto.text = miResena?.texto
        miUsuario.text = miResena?.usuario
    }
  
}

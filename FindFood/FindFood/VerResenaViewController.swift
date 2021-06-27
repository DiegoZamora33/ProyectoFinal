//
//  VerResenaViewController.swift
//  FindFood
//
//  Created by Diego Zamora on 26/06/21.
//

import UIKit

class VerResenaViewController: UIViewController {

    //MARK: - Variables y Outlets
    @IBOutlet weak var rateView: RateView!
    
    
    //MARK: - DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()

        /// Set Value RateView
        rateView.rating = 3
    }
    

    //MARK: - Mis Funciones
}

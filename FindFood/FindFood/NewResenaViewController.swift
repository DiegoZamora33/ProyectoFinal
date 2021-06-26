//
//  NewResenaViewController.swift
//  FindFood
//
//  Created by Diego Zamora on 26/06/21.
//

import UIKit

class NewResenaViewController: UIViewController {
    
    //MARK: - Variables y Outlets
    
    @IBOutlet weak var myRateView: RateView!
    
    //MARK: - DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        myRateView.rating = 1
        
    }
    

}

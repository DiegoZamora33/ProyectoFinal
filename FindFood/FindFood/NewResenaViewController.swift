//
//  NewResenaViewController.swift
//  FindFood
//
//  Created by Diego Zamora on 26/06/21.
//

import UIKit
import CoreLocation
import HideKeyboardTapGestureManager
import FirebaseFirestore

class NewResenaViewController: UIViewController {
    
    //MARK: - Variables y Outlets
    @IBOutlet weak var myRateView: RateView!
    @IBOutlet weak var btnEnviar: UIButton!
    @IBOutlet var superView: UIView!
    @IBOutlet weak var miRestaurant: UITextField!
    @IBOutlet weak var miPlatillo: UITextField!
    @IBOutlet weak var miResena: UITextView!
    
    var miUbicacion: CLLocationCoordinate2D?
    let hideKeyboardTapGestureManager = HideKeyboardTapGestureManager()
    
    var laResena: Resena?
    
    /// Agregar la referencia a la BD Firestore
    let db = Firestore.firestore()
    
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
        
        if(laResena != nil)
        {
            miRestaurant.text = laResena?.restaurant!
            miPlatillo.text = laResena?.platillo!
            myRateView.rating = (laResena?.puntuacion)!
        }
        
    }
    
    //MARK: - Mis Funciones
    @IBAction func btnNewResena(_ sender: UIButton) {
        let defaults = UserDefaults.standard
        
        if laResena != nil {
            if let resena = miResena.text, let usuario = defaults.value(forKey: "email") {
                /// Resena
                self.db.collection("resenas").addDocument(data: [
                    "restaurant": (laResena?.restaurant!)! as String,
                    "platillo": (laResena?.platillo!)! as String,
                    "texto": resena,
                    "puntuacion": self.myRateView.rating,
                    "usuario": usuario,
                    "fechaCreacion": Date().timeIntervalSince1970
                ]) { (error) in
                    /// Si hubo errro
                    if let e = error {
                        print("Error al guardar Resena \(e.localizedDescription)")
                        self.alertaMensaje(msj: "Error al guardar Reseña \(e.localizedDescription)")
                    } else {
                        
                        print("Se guardo Resena")
                        
                        
                        let alerta = UIAlertController(title: "FindFood", message: "Se ha Guarado tu Reseña ", preferredStyle: .alert)
                        
                        alerta.addAction(UIAlertAction(title: "Aceptar", style: .cancel){_ in
                            self.navigationController?.popToRootViewController(animated: true)
                        })
                        
                        self.present(alerta, animated: true, completion: nil)
                        
                    }
                }
            }
        }
        else
        {
            if let restaurant = miRestaurant.text, let platillo = miPlatillo.text, let resena = miResena.text, let usuario = defaults.value(forKey: "email") {
                
                /// Restaurant
                db.collection("retaurantes").addDocument(data: [
                    "restaurant": restaurant,
                    "lat": miUbicacion?.latitude ?? 0.0,
                    "lon": miUbicacion?.longitude ?? 0.0,
                    "fechaCreacion": Date().timeIntervalSince1970
                ]) { (error) in
                    /// Si hubo errro
                    if let e = error {
                        print("Error al guardar Restaurant \(e.localizedDescription)")
                        self.alertaMensaje(msj: "Error al guardar Restaurant \(e.localizedDescription)")
                    } else
                    {
                        
                        print("Se guardo Restaurant")
                        
                        
                        /// Resena
                        self.db.collection("resenas").addDocument(data: [
                            "restaurant": restaurant,
                            "platillo": platillo,
                            "texto": resena,
                            "puntuacion": self.myRateView.rating,
                            "usuario": usuario,
                            "fechaCreacion": Date().timeIntervalSince1970
                        ]) { (error) in
                            /// Si hubo errro
                            if let e = error {
                                print("Error al guardar Resena \(e.localizedDescription)")
                                self.alertaMensaje(msj: "Error al guardar Reseña \(e.localizedDescription)")
                            } else {
                                
                                print("Se guardo Resena")
                                
                                
                                let alerta = UIAlertController(title: "FindFood", message: "Se ha Guarado tu Reseña ", preferredStyle: .alert)
                                
                                alerta.addAction(UIAlertAction(title: "Aceptar", style: .cancel){_ in
                                    self.navigationController?.popToRootViewController(animated: true)
                                })
                                
                                self.present(alerta, animated: true, completion: nil)
                                
                            }
                        }
                    }
                }
                
                
                
            }
        }
    }
    
    /// Para Mostrar Errores ALerta
    func alertaMensaje(msj: String) {
        let alerta = UIAlertController(title: "FindFood", message: msj, preferredStyle: .alert)
        alerta.addAction(UIAlertAction(title: "Aceptar", style: .cancel, handler: nil))
        present(alerta, animated: true, completion: nil)
    }
}

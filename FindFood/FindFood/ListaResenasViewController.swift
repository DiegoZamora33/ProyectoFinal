//
//  ListaResenasViewController.swift
//  FindFood
//
//  Created by Diego Zamora on 29/06/21.
//

import UIKit
import Firebase
import FirebaseFirestore
import CoreLocation

struct Resena {
    var platillo: String?
    var puntuacion: Int?
    var texto: String?
    var usuario: String?
    var restaurant: String?
}

class ListaResenasViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    
    // MARK: - Variables y Outlets
    @IBOutlet weak var miTitulo: UILabel!
    @IBOutlet weak var miTabla: UITableView!
    
    var miRestaurant: String?
    
    var misResenas = [Resena]()
    
    var indexResena: Int?
    var miResena: Resena?
    
    
    var ubicacion: CLLocationCoordinate2D?
    
    //Agregar la referencia a la BD Firestore
    let db = Firestore.firestore()
    
    //MARK: - DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        
        miTitulo.text = miRestaurant!

        /// Delegado Tabla
        miTabla.delegate = self
        miTabla.dataSource = self
        
        /// Cargando mis Resenas
        cargarResenas()
    }
    
    
    //MARK: - Mis Funciones
    func cargarResenas() {
        db.collection("resenas").order(by: "fechaCreacion").addSnapshotListener() { (querySnapshot, err) in
            
            /// Limpiamos mi Arreglo
            self.misResenas = []
            
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                
                /// Recorriendo mis Documentos
                if let snapshotDocumentos = querySnapshot?.documents{
                    
                    for document in snapshotDocumentos {
                        /// Llenando mi Arreglo de Chats
                        let datos = document.data()
                        
                        guard let platillo = datos["platillo"] as? String  else {
                            return
                        }
                        
                        guard let puntuacion = datos["puntuacion"] as? Int  else {
                            return
                        }
                        
                        guard let restaurant = datos["restaurant"] as? String  else {
                            return
                        }
                        
                        guard let texto = datos["texto"] as? String  else {
                            return
                        }
                        
                        guard let usuario = datos["usuario"] as? String  else {
                            return
                        }
                        
                        if restaurant == self.miRestaurant {
                            
                            self.misResenas.append(Resena(platillo: platillo, puntuacion: puntuacion, texto: texto, usuario: usuario, restaurant: restaurant))
                        }
                        
                        DispatchQueue.main.async {
                            self.miTabla.reloadData()
                        }
                        
                    }
                    
                }
                
                
            }
        }
    }
    
    /// Protocolos de la Tabla
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        /// Numero de Objetos in Array (array.count)
        return misResenas.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let objCelda = miTabla.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
            objCelda.textLabel?.text = misResenas[indexPath.row].platillo
        objCelda.detailTextLabel?.text = "\(misResenas[indexPath.row].puntuacion ?? 1) Stars"
            
            return objCelda
        
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return "\(misResenas.count) Reseñas..."
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        indexResena = indexPath.row
        miResena = misResenas[indexPath.row]
        performSegue(withIdentifier: "openResena", sender: self)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "openResena"
        {
            let verCV = segue.destination as! VerResenaViewController
            
            verCV.miResena = miResena
        }
        
        
        if segue.identifier == "addResena"
        {
            let addCV = segue.destination as! NewResenaViewController
            
            addCV.laResena = miResena
            addCV.miUbicacion = ubicacion
        }
    }
    
    
    
    
    @IBAction func goAdd(_ sender: UIButton) {
        performSegue(withIdentifier: "addResena", sender: self)
    }
}

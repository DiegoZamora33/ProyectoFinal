//
//  ViewController.swift
//  FindFood
//
//  Created by Diego Zamora on 22/06/21.
//

import UIKit
import MapKit
import CoreLocation
import HideKeyboardTapGestureManager
import SideMenu


class ViewController: UIViewController, MKMapViewDelegate {
    
    //MARK: - Variables y Outlets
    @IBOutlet weak var miMapa: MKMapView!
    @IBOutlet weak var boxSearch: UISearchBar!
    @IBOutlet weak var btnAddResena: UIButton!
    
    var miUbicacion: CLLocation?
    var newUbicacion: CLLocationCoordinate2D?
    let hideKeyboardTapGestureManager = HideKeyboardTapGestureManager()
    
    let etaAnnotations = [EtaAnnotation(title: "Paris", subtitle: "Capital City of France", coordinate: CLLocationCoordinate2D(latitude: 19.72372871622358, longitude: -101.17804168611394)), EtaAnnotation(title: "Prague", subtitle: "Capital City of Czechia", coordinate: CLLocationCoordinate2D(latitude: 19.7125186216248, longitude: -101.20178701162467))]

   
    
    
    //MARK: - Managers
    var coreLocation = CLLocationManager()
    
    
    
    //MARK: - DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// Le damos un estilo Nice al ADD Resena
        btnAddResena.setTitleColor(.label, for: .normal)
        btnAddResena.titleLabel?.font = UIFont.systemFont(ofSize: 22.0, weight: .semibold)
        btnAddResena.titleLabel?.textColor = .label
        btnAddResena.backgroundColor = .systemBackground
        btnAddResena.layer.cornerRadius = btnAddResena.bounds.height / 2.0
        btnAddResena.contentEdgeInsets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        btnAddResena.layer.shadowColor = UIColor.black.cgColor
        btnAddResena.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        btnAddResena.layer.shadowRadius = 2.0
        btnAddResena.layer.shadowOpacity = 0.2
        
        /// Agregamos Gesture Taps para ocultar Teclado
        hideKeyboardTapGestureManager.add(targets: [miMapa])
        
        /// MKMapViewDelegate
        miMapa.delegate = self
        
        /// Search Bar Delegate
        boxSearch.delegate = self
        
        /// CoreLocation Delegate
        coreLocation.delegate = self
        
        /// Permiso de Ubicacion
        coreLocation.requestWhenInUseAuthorization()
        coreLocation.requestLocation()
        
        /// La mejor presicion porfis
        coreLocation.desiredAccuracy = kCLLocationAccuracyBest
        
        /// Iniciar la actualizacino de Localizacion
        coreLocation.startUpdatingLocation()
        
        
        /// Cargamos mis Annotatios
        DispatchQueue.main.async(execute: {
                    //Placing toilets on the map
                    self.miMapa.addAnnotations(self.etaAnnotations)
                })
        
        /// Vamos A Carvar el Evento On Long Press
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(addResena))
        longPress.minimumPressDuration = 1.2
        
        miMapa.addGestureRecognizer(longPress)
        
        
    }
    
    //MARK: - ADD RESEÑA
    @objc func addResena(gestureRecognizer:UIGestureRecognizer){
        if gestureRecognizer.state == UIGestureRecognizer.State.began
        {
            let touchPoint = gestureRecognizer.location(in: miMapa)
            let newCoordinates = miMapa.convert(touchPoint, toCoordinateFrom: miMapa)
            let annotation = MKPointAnnotation()
            annotation.coordinate = newCoordinates

            CLGeocoder().reverseGeocodeLocation(CLLocation(latitude: newCoordinates.latitude, longitude: newCoordinates.longitude), completionHandler: {(placemarks, error) -> Void in
                if error != nil {
                    print("Reverse geocoder failed with error" + error!.localizedDescription)
                    return
                }

                if placemarks!.count > 0
                {
                    let pm = placemarks![0]

                    // not all places have thoroughfare & subThoroughfare so validate those values
                    annotation.title = pm.thoroughfare! + ", " + pm.subThoroughfare!
                        
                    annotation.subtitle = pm.subLocality
                    self.miMapa.addAnnotation(annotation)
                    print(pm)
                }
                else {
                    annotation.title = "Unknown Place"
                    self.miMapa.addAnnotation(annotation)
                    print("Problem with the data received from geocoder")
                }
                
                /// Ya tenemos la Coordenada
                self.sendNewResena(ubicacion: newCoordinates)
                
            })
        }
    }
    
    //MARK: - Send New Reseña
    func sendNewResena(ubicacion: CLLocationCoordinate2D?) {
        newUbicacion = ubicacion
        performSegue(withIdentifier: "newResena", sender: self)
        
    }
    
    
    //MARK: - Prepare For Segue To NewResena
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "newResena")
        {
            if let newResenaVC = segue.destination as? NewResenaViewController
            {
                newResenaVC.miUbicacion = newUbicacion
            }
        }
    }

    
    //MARK: - Get GPS Button
    @IBAction func getGPD(_ sender: UIButton) {
        print("Lat: \(miUbicacion?.coordinate.latitude ?? 0) - Long: \(miUbicacion?.coordinate.longitude ?? 0)")
        
        let spanMapa = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        
        let region = MKCoordinateRegion(center: miUbicacion!.coordinate, span: spanMapa)
        
        miMapa.setRegion(region, animated: true)
        miMapa.showsUserLocation = true
        
        let alert = UIAlertController(title: "Tu estas Aqui!!!", message: "Se Ecuentran 4 Restaurantes cerca de ti", preferredStyle: .alert)
        
        let actionMas = UIAlertAction(title: "Ver mas...", style: .default, handler: nil)
        let actionLuego = UIAlertAction(title: "Despues", style: .destructive, handler: nil)
        
        alert.addAction(actionLuego)
        alert.addAction(actionMas)
        
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Renderizamos mis Annotations
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?
    {
            
        if annotation is MKUserLocation {return nil}
        
        var annotationView = MKAnnotationView()
        
        if let reusableAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "etaAnnotation") {
            annotationView = reusableAnnotationView
        }
        else {
            let annotationEtaView = EtaAnnotationView(annotation: annotation, reuseIdentifier: "etaAnnotation")
            ///annotationEtaView.pinColor = UIColor(red: 1.00, green: 0.50, blue: 0.00, alpha: 1.0)
            
            annotationEtaView.image = UIImage(named: "iconFindFood")
            
            annotationEtaView.setDetailShowButton()
            annotationEtaView.rightButton?.addTarget(self, action: #selector(detailButtonTapped), for: .touchUpInside)
            annotationEtaView.leftButton?.addTarget(self, action: #selector(navigateTo), for: .touchUpInside)
            
            annotationView = annotationEtaView
        }
        
        return annotationView
    }
    
    //MARK: - Navegamos a una Ubicacion
    @objc func navigateTo()
    {
        print("NAVIGATE \(miMapa.selectedAnnotations[0].title! ?? "SOME")")
    }
    
    //MARK: - Abrimos una Ubicacion
    @objc func detailButtonTapped()
    {
        print("OPEN \(miMapa.selectedAnnotations[0].title! ?? "SOME")")
    }
    
    //MARK: - DID SELECT ANNOTATION
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView)
    {
        guard let annotation = view.annotation else {return}
        if annotation is MKUserLocation {return}
        
        print("Touch: \(annotation.title! ?? "SOME")")
    }
    
}

//MARK: - Extension CLLocationManagerDelegate
extension ViewController: CLLocationManagerDelegate{
    
    /// Did Update Locations
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let ubicacion = locations.first {
            self.miUbicacion = ubicacion
        }
        
    }
    
    
    /// Did Fail with Error
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error al obtener coordenadas \(error.localizedDescription)")
    }
}

//MARK: - Extension para UISearchBar
extension ViewController: UISearchBarDelegate
{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        boxSearch.resignFirstResponder()
        
    }
}

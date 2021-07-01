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
import LoadingAlert
import Firebase
import FirebaseFirestore


class ViewController: UIViewController, MKMapViewDelegate {
    
    //MARK: - Variables y Outlets
    @IBOutlet weak var miMapa: MKMapView!
    @IBOutlet weak var boxSearch: UISearchBar!
    @IBOutlet weak var btnAddResena: UIButton!
    @IBOutlet weak var miSol: UIImageView!
    @IBOutlet weak var miClima: UILabel!
    
    var miUbicacion: CLLocation?
    var newUbicacion: CLLocationCoordinate2D?
    let hideKeyboardTapGestureManager = HideKeyboardTapGestureManager()
    
    var etaAnnotations = [EtaAnnotation]()
    var miRestaurant: String?
    
    /// Agregar la referencia a la BD Firestore
    let db = Firestore.firestore()
    
    var myWeather = iWeatherManager()
    
    
    
    
    //MARK: - Managers
    var coreLocation = CLLocationManager()
    
    
    
    //MARK: - DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// Delegate iWeatherManager
        myWeather.delegate = self
        
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
        
        /// Vamos A Carvar el Evento On Long Press
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(addResena))
        longPress.minimumPressDuration = 1.2
        
        miMapa.addGestureRecognizer(longPress)
        
        
        /// Cargando mis Lugares
        DispatchQueue.main.async {
            self.cargarLugares()
        }
        
    }
    
    //MARK: - Cargar mis Lugares
    func cargarLugares() {
        db.collection("retaurantes").order(by: "fechaCreacion").addSnapshotListener() { (querySnapshot, err) in
            
            /// Limpiamos mi Arreglo
            self.etaAnnotations = []
            
            if let err = err {
                print("Error getting documents: \(err)")
                self.alertaMensaje(msj: "Error getting documents: \(err) 🙁")
            } else {
                /// Recorriendo mis Documentos
                if let snapshotDocumentos = querySnapshot?.documents{
                    
                    print(snapshotDocumentos.count)
                    
                    for document in snapshotDocumentos {
                        
                        print("AAJJJEJJEJEJE")
                        /// Llenando mi Arreglo de Chats
                        let datos = document.data()
                        
                        guard let miRestaurant = datos["restaurant"] as? String  else {
                            return
                        }
                        
                        guard let miLat = datos["lat"] as? Double  else {
                            return
                        }
                        
                        guard let miLon = datos["lon"] as? Double  else {
                            return
                        }
                        
                        self.etaAnnotations.append(EtaAnnotation(title: miRestaurant, subtitle: "FindFood", coordinate: CLLocationCoordinate2D(latitude: miLat, longitude: miLon)))
                        
                        //DispatchQueue.main.async {
                            //self.miMapa.addAnnotations(self.etaAnnotations)
                        //}
                        
                        print("\n\n\nAAAAAAA \(miRestaurant) \(miLat) \(miLon)")
                    }
                    
                    self.miMapa.addAnnotations(self.etaAnnotations)
                }
            }
        }
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
                    
                    self.alertaMensaje(msj: "Reverse geocoder failed with error" + error!.localizedDescription)
                    
                    return
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
        
        if(segue.identifier == "listResena")
        {
            if let listResenaVC = segue.destination as? ListaResenasViewController
            {
                listResenaVC.ubicacion = newUbicacion
                listResenaVC.miRestaurant = miRestaurant
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
        
        let alert = UIAlertController(title: "Tu estas Aqui!!!", message: "FindFood accedió a tu Ubicacion Actual", preferredStyle: .alert)
        
        let actionMas = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alert.addAction(actionLuego)
        alert.addAction(actionMas)
        
        present(alert, animated: true, completion: nil)
    }
    
    /// Funcion para trazar Ruta
    func trazarRuta(destino: CLLocationCoordinate2D) {
        guard let origen = coreLocation.location?.coordinate else { return }
        
        /// Crear PlaceMarks
        let origenPlaceMark = MKPlacemark(coordinate: origen)
        let destinoPlaceMark = MKPlacemark(coordinate: destino)
        
        /// Crear ITEMs
        let origenItem = MKMapItem(placemark: origenPlaceMark)
        let destinoItem = MKMapItem(placemark: destinoPlaceMark)
        
        /// Solicitud de Ruta
        let solicitudDestino = MKDirections.Request()
        solicitudDestino.source = origenItem
        solicitudDestino.destination = destinoItem
        
        /// Medio de Transporte
        solicitudDestino.transportType = .automobile
        solicitudDestino.requestsAlternateRoutes = true
        
        /// Calcular la Ruta
        let address = MKDirections(request: solicitudDestino)
        address.calculate { (respuesta: MKDirections.Response?, error: Error?) in
            
            /// Variable Segura
            guard let respuestaSegura = respuesta else {
                if let error = error {
                    print("Sucedió un Error: \(error.localizedDescription)")
                }
                return
            }
            
            /// Si todo sale bien
            let ruta = respuestaSegura.routes[0]
            
            /// Agregar Anotation Punto Medio
            let routeAnnotation = MKPointAnnotation()
            
            let middlePoint = ruta.polyline.points()[ruta.polyline.pointCount/2].coordinate
            
            
            routeAnnotation.coordinate = middlePoint
            routeAnnotation.title = "Distancia"
            routeAnnotation.subtitle = "\(ruta.distance/1000) KM"
            
            
            self.miMapa.addAnnotation(routeAnnotation)

            
            /// Agregar al Mapa una Superposicion
            self.miMapa.addOverlay(ruta.polyline)
            self.miMapa.setVisibleMapRect(ruta.polyline.boundingMapRect, animated: true)
            
        }
    }
    
    
    /// Funcion para Agregar la SuperPosicion al Mapa
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        let renderizado = MKPolylineRenderer(overlay: overlay as! MKPolyline)
        
        renderizado.strokeColor = .systemBlue
        
        
        return renderizado
    }
    
    //MARK: - Renderizamos mis Annotations
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?
    {
            
        if annotation is MKUserLocation {
            let view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: nil)
            
            view.pinTintColor = UIColor.blue
            view.animatesDrop = true
            view.canShowCallout = true
            
            
            view.isSelected = true
            
            
            return view
            
        }
        
        if annotation.title == "Distancia"
        {
            let view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: nil)
                
            view.pinTintColor = UIColor.red
            view.animatesDrop = true
            view.canShowCallout = true
            
            
            view.isSelected = true
            
            
            return view;
        }
        else
        {
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
        
        
    }
    
    //MARK: - Navegamos a una Ubicacion
    @objc func navigateTo()
    {
        print("NAVIGATE \(miMapa.selectedAnnotations[0].title! ?? "SOME")")
        trazarRuta(destino: miMapa.selectedAnnotations[0].coordinate)
    }
    
    //MARK: - Abrimos una Ubicacion
    @objc func detailButtonTapped()
    {
        print("OPEN \(miMapa.selectedAnnotations[0].title! ?? "SOME")")
        
        performSegue(withIdentifier: "listResena", sender: self)
        
    }
    
    //MARK: - DID SELECT ANNOTATION
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView)
    {
        guard let annotation = view.annotation else {return}
        if annotation is MKUserLocation {return}
        
        print("Touch: \(annotation.title! ?? "SOME")")
        miRestaurant = annotation.title!
        
    }
    
    /// Para Mostrar Errores ALerta
    func alertaMensaje(msj: String) {
        let alerta = UIAlertController(title: "FindFood", message: msj, preferredStyle: .alert)
        alerta.addAction(UIAlertAction(title: "Aceptar", style: .cancel, handler: nil))
        present(alerta, animated: true, completion: nil)
    }
}

//MARK: - Extension CLLocationManagerDelegate
extension ViewController: CLLocationManagerDelegate{
    
    /// Did Update Locations
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let coordenadas = locations.first {
            coreLocation.stopUpdatingLocation()
            self.miUbicacion = coordenadas
            
            let latitud = coordenadas.coordinate.latitude
            let longitud = coordenadas.coordinate.longitude
            
            print("Lat: \(latitud)  :  \(longitud)")
            
            myWeather.searchCity(lat: latitud, lon: longitud)
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


//MARK: - Extension para consumir API Clima
extension ViewController: iWeatherDelegate
{
    /// Mi Protocolo iWeather
    func getWeather(weatherData: iWeatherData?, httpResponse: URLResponse?, error: Error?) {
        
        /// Esperamos a la Tarea Asincrona
        DispatchQueue.main.async {
            if(weatherData != nil)
            {
                print("City: \(String(describing: weatherData!.name))")
                
                /// Pintamos mis datos
                
                self.miClima.text = "\(weatherData!.name), \(weatherData!.weather[0].description.capitalized) \(String(format: "%0.0f", weatherData!.main.temp)) °C (Min: \(String(format: "%0.1f", weatherData!.main.temp_min)) °C - Max: \(String(format: "%0.1f", weatherData!.main.temp_max)) °C"

                
                let urlImage = "https://openweathermap.org/img/wn/\(String(weatherData!.weather[0].icon))@4x.png"
                
                self.cargarImagen(urlString: urlImage)
                
                self.miSol.contentMode = UIView.ContentMode.scaleAspectFill
                self.miSol.sizeToFit()
            }
            else
            {
                /// Alert para notificar algun error
                var miError: String
                var title: String
                
                if(error != nil)
                {
                    print("City: \(String(describing: error!.localizedDescription))")
                    
                    title = "Fatal Error"
                    miError = error!.localizedDescription
                }
                else
                {
                    title = "Error"
                    miError = "Ciudad no Encontrada"
                }
                
                
                let alert = UIAlertController(title: title, message: miError, preferredStyle: .alert)
                
                let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                
                alert.addAction(action)
                
                self.present(alert, animated: true, completion: nil)
                
                /// Obtener ciudad Actual GPS
                self.coreLocation.startUpdatingLocation()
                
            }
            
            if(httpResponse != nil)
            {
                print("Response: \(httpResponse!)")
            }
            
            
        }
    }
    
    // MARK: - Cargar Imagen desde API
    func cargarImagen(urlString: String) {

            //1.- Obtener los datos

            guard let url = URL(string: urlString) else {

                return

            }

            let tareaObtenerDatos = URLSession.shared.dataTask(with: url) { (datos, _, error) in

                guard let datosSeguros = datos, error == nil else {

                    return

                }

                DispatchQueue.main.async {

                    //2.- Convertir los datos en imagen

                    let imagen = UIImage(data: datosSeguros)

                    //3.- Asignar la imagen a la imagen previamente creada

                    self.miSol.image = imagen

                }

            }

            tareaObtenerDatos.resume()

        }
}

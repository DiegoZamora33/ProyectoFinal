//
//  EtaAnnotation.swift
//  FindFood
//
//  Created by Diego Zamora on 25/06/21.
//

import Foundation
import MapKit


class EtaAnnotation: NSObject, MKAnnotation {
    //Annotation properties
    
    public var title: String?
    public var subtitle: String?
    public let coordinate: CLLocationCoordinate2D
    
    public init(title: String?, subtitle: String?, coordinate: CLLocationCoordinate2D) {
        
        //Coordinate
        self.coordinate = coordinate
        
        //Safely unwrap title and subtitle (they could be nil)
        if let title = title {
            self.title = title
        }
        
        if let subtitle = subtitle {
            self.subtitle = subtitle
        }
    }
}

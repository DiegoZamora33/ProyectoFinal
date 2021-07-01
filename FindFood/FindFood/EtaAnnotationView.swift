//
//  EtaAnnotationView.swift
//  FindFood
//
//  Created by Diego Zamora on 25/06/21.
//


import Foundation
import MapKit

class EtaAnnotationView: MKAnnotationView {
    
    open var pinColor = UIColor(red: 1.00, green: 0.50, blue: 0.00, alpha: 1.0)
    open var pinSecondaryColor = UIColor.white
    open var rightButton: UIButton?
    open var leftButton: UIButton?
    
    public override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        
        self.annotation = annotation
        self.canShowCallout = true
        self.frame = CGRect(origin: self.frame.origin, size: CGSize(width: 29, height: 43))
        //Bottom part of the pin is on the location, not the center, offset needed
        self.centerOffset = CGPoint(x: 0, y: -(self.frame.height)/2)
        self.backgroundColor = UIColor.clear
        
        
    }
    
    
    
    public func setDetailShowButton() {
        //Detailed toilet info button
        rightButton = UIButton.init(type: .detailDisclosure)
        rightButton?.tintColor = pinColor
        
        rightCalloutAccessoryView = rightButton
        
        
        //Detailed toilet info button
        leftButton = UIButton.init(type: .detailDisclosure)
        leftButton?.tintColor = .systemPurple
        leftButton?.setImage(UIImage(systemName: "location"), for: .normal)
        
        leftCalloutAccessoryView = leftButton

    }
    
    
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

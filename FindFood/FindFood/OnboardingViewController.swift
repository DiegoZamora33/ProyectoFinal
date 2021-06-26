//
//  OnboardingViewController.swift
//  FindFood
//
//  Created by Diego Zamora on 24/06/21.
//

import UIKit
import OnboardKit
import LoadingAlert
import CoreLocation

class OnboardingViewController: UIViewController {
    
    //MARK: - Managers
    var coreLocation = CLLocationManager()
    var miUbicacion: CLLocation?
    
    //MARK: - PAGES ONBOARDING
    lazy var onboardingPages: [OnboardPage] = {
       let pageOne = OnboardPage(title: "Welcome to Habitat",
                                 imageName: "Onboarding1",
                                 description: "Habitat is an easy to use productivity app designed to keep you motivated.")

       let pageTwo = OnboardPage(title: "Habit Entries",
                                 imageName: "Onboarding2",
                                 description: "An entry is created for every day you need to complete each habit.")

       let pageThree = OnboardPage(title: "Marking and Tracking",
                                   imageName: "Onboarding3",
                                   description: "By marking entries as Done you can track your progress.")

        let pageFour = OnboardPage(title: "Notifications",
                                       imageName: "Onboarding4",
                                       description: "Turn on notifications to get reminders and keep up with your goals.",
                                       advanceButtonTitle: "Decide Later",
                                       actionButtonTitle: "Enable Notifications",
                                       action: { [weak self] completion in
                                        self?.showAlert(completion)
            })

       let pageFive = OnboardPage(title: "All Ready",
                                  imageName: "Onboarding5",
                                  description: "You are all set up and ready to use Habitat. Adding your first habit.",
                                  advanceButtonTitle: "Done")

       return [pageOne, pageTwo, pageThree, pageFour, pageFive]
     }()
    
    //MARK: - Render de Onboarding
    func renderOnboarding() {
        
            let actionButtonStyling: OnboardViewController.ButtonStyling = { button in
              button.setTitleColor(.black, for: .normal)
              button.titleLabel?.font = UIFont.systemFont(ofSize: 22.0, weight: .semibold)
              button.backgroundColor = UIColor(white: 0.95, alpha: 1.0)
              button.layer.cornerRadius = button.bounds.height / 2.0
              button.contentEdgeInsets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
              button.layer.shadowColor = UIColor.black.cgColor
              button.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
              button.layer.shadowRadius = 2.0
              button.layer.shadowOpacity = 0.2
            }
            let appearance = OnboardViewController.AppearanceConfiguration(advanceButtonStyling: actionButtonStyling,
                                                                            actionButtonStyling: actionButtonStyling)
        
        
            let onboardingVC = OnboardViewController(pageItems: onboardingPages,
                                                     appearanceConfiguration: appearance, completion: {
                                                        self.performSegue(withIdentifier: "Login", sender: self)
                                                    })
        
            //onboardingVC.modalPresentationStyle = .formSheet
        
        onboardingVC.modalPresentationStyle = .fullScreen
            onboardingVC.presentFrom(self, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        /// CoreLocation Delegate
        coreLocation.delegate = self
        
        
        /// Mostramos mi Onboarding
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: LoadingAlert.bind {
            self.renderOnboarding()
        })
        
    }

    @IBAction func btnBoard(_ sender: UIButton) {
        
        performSegue(withIdentifier: "Login", sender: self)
        
    }
    
    private func showAlert(_ completion: @escaping (_ success: Bool, _ error: Error?) -> Void) {
        /// Permiso de Ubicacion
        coreLocation.requestWhenInUseAuthorization()
        coreLocation.requestLocation()
        
        completion(true, nil)
      }
    
}

//MARK: - Extension CLLocationManagerDelegate
extension OnboardingViewController: CLLocationManagerDelegate{
    
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

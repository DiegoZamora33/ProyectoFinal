//
//  RateView.swift
//  FindFood
//
//  Created by Diego Zamora on 26/06/21.
//

import Foundation
import UIKit

public class RateView: UIView {
    // MARK: Properties
    public var rating = 0 {
        didSet {
            setNeedsLayout()
        }
    }
    
    var ratingButtons = [UIButton]()
    var spacing = 5
    var stars = 5
    
    // MARK: Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        addComponents()
    }
    
    // MARK: Storyboard Initialization
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        addComponents()
    }
    
    func addComponents()
    {
        var bundle = Bundle(for: self.classForCoder)
        if let bundlePath = Bundle(for: self.classForCoder).resourcePath?.appending("/RateStarsSwift.bundle"), let resourceBundle = Bundle(path: bundlePath) {
            bundle = resourceBundle
        }
        
        let filledStarImage = UIImage(named: "star_full.png", in: bundle, compatibleWith: nil)
        let emptyStarImage = UIImage(named: "star_empty.png", in: bundle, compatibleWith: nil)
        
        for _ in 0..<stars {
            let rateButton = UIButton()
            rateButton.setImage(emptyStarImage, for: .normal)
            rateButton.setImage(filledStarImage, for: .selected)
            rateButton.setImage(filledStarImage, for: [.highlighted, .selected])
            rateButton.adjustsImageWhenHighlighted = false
            rateButton.addTarget(self, action:#selector(ratingButtonTapped(button:)), for: .touchUpInside)
            ratingButtons += [rateButton]
            addSubview(rateButton)
        }
    }
    
    override public func layoutSubviews() {
        let buttonSize = Int(frame.size.height)
        var buttonFrame = CGRect(x: 0, y: 0, width: buttonSize, height: buttonSize)
        for (index, button) in ratingButtons.enumerated() {
            buttonFrame.origin.x = CGFloat(index * (buttonSize + spacing))
            button.frame = buttonFrame
        }
        updateButtonSelectionStates()
    }
    
    // MARK: Button Action
    @objc func ratingButtonTapped(button: UIButton) {
        rating = ratingButtons.firstIndex(of: button)! + 1
        updateButtonSelectionStates()
    }
    
    func updateButtonSelectionStates() {
        for (index, button) in ratingButtons.enumerated() {
            button.isSelected = index < rating
        }
    }
}

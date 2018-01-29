//
//  CityView.swift
//  YourJourney
//
//  Created by Apple on 14.12.2017.
//  Copyright © 2017 md. All rights reserved.
//

import Foundation
import SVProgressHUD

enum CityViewState {
    case loading
    case displayCity
    case changingCity
}

class CityView : UIView {
    
    var changeCityActivityIndicator : UIActivityIndicatorView?
    var changeCityButton : UIButton?
    var changeCityTriangle : UIImageView?
    
    var state : CityViewState {
        get{
            return .loading
        }
        
        set(newState) {
            DispatchQueue.main.async {
                if newState == .loading {
                    self.changeCityActivityIndicator?.isHidden = false
                    self.changeCityTriangle?.isHidden = true
                    self.changeCityButton?.setTitle("Город", for: .normal)
                } else if newState == .changingCity {
                    self.changeCityActivityIndicator?.isHidden = true
                    self.changeCityTriangle?.isHidden = false
                    
                    UIView.animate(withDuration: 0.3) {
                        self.changeCityTriangle!.transform = CGAffineTransform.identity.rotated(by: 3.14)
                    }
                } else if newState == .displayCity {
                    self.changeCityActivityIndicator?.isHidden = true
                    self.changeCityTriangle?.isHidden = false
                    
                    UIView.animate(withDuration: 0.3) {
                        self.changeCityTriangle?.transform = .identity
                    }
                }
            }
        }
    }
    
    override init(frame: CGRect) {
        changeCityButton = UIButton(type: .custom)
        changeCityButton!.translatesAutoresizingMaskIntoConstraints = false
        changeCityButton!.setTitle("Город", for: .normal)
        
        changeCityTriangle = UIImageView(image: #imageLiteral(resourceName: "Triangle"))
        changeCityTriangle!.translatesAutoresizingMaskIntoConstraints = false
        
        changeCityActivityIndicator = UIActivityIndicatorView()
        changeCityActivityIndicator!.translatesAutoresizingMaskIntoConstraints = false
        changeCityActivityIndicator!.startAnimating()
        
        super.init(frame: frame)
        
        self.translatesAutoresizingMaskIntoConstraints = true
        self.addSubview(changeCityButton!)
        self.addSubview(changeCityTriangle!)
        self.addSubview(changeCityActivityIndicator!)
    }
    
    convenience init () {
        self.init(frame: CGRect.zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateConstraints() {
        self.removeConstraints(self.constraints)
        
        changeCityButton!.heightAnchor.constraint(equalToConstant: 40).isActive = true
        changeCityButton!.widthAnchor.constraint(equalToConstant: 110).isActive = true
        changeCityButton!.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        changeCityButton!.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        changeCityTriangle!.heightAnchor.constraint(equalToConstant: 7).isActive = true
        changeCityTriangle!.widthAnchor.constraint(equalToConstant: 11).isActive = true
        changeCityTriangle!.leftAnchor.constraint(equalTo: changeCityButton!.rightAnchor, constant: 5).isActive = true
        changeCityTriangle!.centerYAnchor.constraint(equalTo: changeCityButton!.centerYAnchor).isActive = true
        
        changeCityActivityIndicator!.leftAnchor.constraint(equalTo: changeCityButton!.rightAnchor).isActive = true
        changeCityActivityIndicator!.centerYAnchor.constraint(equalTo: changeCityButton!.centerYAnchor).isActive = true
        
        super.updateConstraints()
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        return CGSize(width: 100, height: 40)
    }
    
    @objc func click(){
        
    }
}

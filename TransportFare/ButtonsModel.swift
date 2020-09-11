//
//  ButtonsModel.swift
//  TransportFare
//
//  Created by TheMacUser on 18.07.2020.
//  Copyright © 2020 TheMacUser. All rights reserved.
//

import Foundation
import UIKit
protocol Buttons: class {
    func butonTapped(sender: UIButton)
}
class ButtonsModel {
    weak var delegate: Buttons?
    var route = String()
    var arrayOfButton = [UIButton]()
    var arrayOfButtons = [[UIButton]]()
    var arrayOfButtonCount = 0
    @objc func routeButtonTapped (sender: UIButton){
        delegate?.butonTapped(sender: sender)
    }
    func arrangedButtons(routes: [String], numberOfHorizontalCells: Int) {
    for arrayButton in routes {
           let button = UIButton()
        button.setTitle(arrayButton, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 25)
        button.backgroundColor = UIColor.systemBlue
        //button.frame = CGRect(x: 150, y: 150, width: 40, height: 50)
        button.heightAnchor.constraint(equalToConstant: 40).isActive = true
        button.widthAnchor.constraint(greaterThanOrEqualToConstant: 40).isActive = true
        //button.widthAnchor.constraint(equalToConstant: 40).isActive = true
        button.layer.cornerRadius = 5
        if UITraitCollection.current.userInterfaceStyle == .dark {
            button.setTitleColor(.white, for: .normal)
            print("Dark")
        } else {
        button.setTitleColor(.systemBackground, for: .normal)
        }
        button.addTarget(self, action: #selector(routeButtonTapped), for: .touchUpInside)
        if arrayOfButton.count < numberOfHorizontalCells {
                arrayOfButton.append(button)
            } else {
                arrayOfButton.append(button)
                arrayOfButtons.append(arrayOfButton)
                arrayOfButton.removeAll()
            }
            arrayOfButtonCount += 1
        }
        if !arrayOfButton.isEmpty {
            arrayOfButtons.append(arrayOfButton)
            arrayOfButton.removeAll()
            
        }
        
    }

}

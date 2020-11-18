//
//  CityDropDownView.swift
//  TransportFare
//
//  Created by TheMacUser on 20.08.2020.
//  Copyright © 2020 TheMacUser. All rights reserved.
//

import UIKit
import Foundation
protocol CityDropDown: class {

func menuButtonTapped()
func cityDropDownButtonTapped(sender: UIButton)
}
class CityDropDownView: UIView {
weak var delegate: CityDropDown?
    var citiesButtonsArray: [UIButton] = []
    var cities: [City] = []
    @IBOutlet var cityStackView: UIStackView!

    @IBAction func dropDownMenuButtonTapped (_ sender: UIButton){
        delegate?.menuButtonTapped()
    }
    @objc func cytiButtonTapped(sender: UIButton){
        delegate?.cityDropDownButtonTapped(sender: sender)
    }

    func updateCityDropDownButtons(){
        for (index, city) in cities.enumerated() {
            let button = UIButton()
            button.setTitle(city.name, for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 17)
            print(index)
            if index == 3 {
                button.backgroundColor = UIColor(red: (0/255.0), green: (122/255.0), blue: (255/255.0), alpha: 1)
            }
            button.addTarget(self, action: #selector(cytiButtonTapped), for: .touchUpInside)
            citiesButtonsArray.append(button)
        }

    }
    
   func updateCityDropDownMenu(){
//    cityStackView.addBackground(color: UIColor(red: (0/255.0), green: (122/255.0), blue: (255/255.0), alpha: 1))
    for button in citiesButtonsArray {
            //cityStackView.addArrangedSubview(button)
            cityStackView.insertArrangedSubview(button, at: 0)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.trailingAnchor.constraint(equalTo: cityStackView.trailingAnchor).isActive = true
            button.leadingAnchor.constraint(equalTo: cityStackView.leadingAnchor).isActive = true
        button.heightAnchor.constraint(equalToConstant: 33).isActive = true
        }
    cityStackView.backgroundColor = UIColor(red: (0/255.0), green: (122/255.0), blue: (255/255.0), alpha: 0.5)
    cityStackView.layer.cornerRadius = 5
    }

}

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
        for city in cities {
            let button = UIButton()
            button.setTitle(city.name, for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 17)
            citiesButtonsArray.append(button)
            button.addTarget(self, action: #selector(cytiButtonTapped), for: .touchUpInside)
        }
//        for button in citiesButtonsArray {
  //          cityStackView.addArrangedSubview(button)
 //       }
    }
    
   func updateCityDropDownMenu(){
//    cityStackView.addBackground(color: UIColor(red: (0/255.0), green: (122/255.0), blue: (255/255.0), alpha: 1))
        for button in citiesButtonsArray {
            cityStackView.addArrangedSubview(button)
        }
    }

}

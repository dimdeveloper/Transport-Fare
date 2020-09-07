//
//  InformationViewController.swift
//  TransportFare
//
//  Created by TheMacUser on 08.08.2020.
//  Copyright © 2020 TheMacUser. All rights reserved.
//

import UIKit

class InformationView: UIView {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var informationCheckMark: UIButton!
    @IBAction func informationButtonTapped(_ sender: UIButton){
        informationCheckMark.isSelected = !informationCheckMark.isSelected
        MainViewController.shared.defaults.set(informationCheckMark.isSelected, forKey: "InformationButtoncheckMark")
    }
    
        // Do any additional setup after loading the view.

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

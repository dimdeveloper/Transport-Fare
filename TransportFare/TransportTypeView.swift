//
//  TransportTypeView.swift
//  TransportFare
//
//  Created by TheMacUser on 09.07.2020.
//  Copyright © 2020 TheMacUser. All rights reserved.
//

import UIKit

protocol TransportType: class {
    func informationButtonTapped()
    func shareButtonTapped()
}
class TransportTypeView: UIView {
    weak var delegate: TransportType?
    @IBOutlet var transportTypeCollectionView: UICollectionView!
    @IBOutlet var dovidka: UIButton!
    @IBOutlet weak var transportTypeCollectionViewHeight:NSLayoutConstraint!
    @IBOutlet var transportTypeButtons: [UIButton]!
    @IBOutlet weak var checkBill: UIButton!
    @IBAction func informationButtonTapped(_ sender: UIButton) {
        delegate?.informationButtonTapped()
    }
    @IBAction func shareButtonTapped(_ sender: UIButton) {
        delegate?.shareButtonTapped()
    }
    @IBAction func checkBillButtonTapped(_ sender: Any) {
         if let url = URL(string: "tel://*111#"),
           UIApplication.shared.canOpenURL(url) {
              if #available(iOS 10, *) {
                UIApplication.shared.open(url, options: [:], completionHandler:nil)
               } else {
                   UIApplication.shared.openURL(url)
               }
           } else {
                    // add error message here
           }
        
    }

}

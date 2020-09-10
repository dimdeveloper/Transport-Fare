//
//  PaymentView.swift
//  TransportFare
//
//  Created by TheMacUser on 09.07.2020.
//  Copyright © 2020 TheMacUser. All rights reserved.
//

import UIKit
protocol PaymentViewProtocol: class {
    func sendSms (textMsg: String)
}
class PaymentView: UIView {
    weak var delegate: PaymentViewProtocol?
    var numberOfTickets: Int = 1
    var ticketPrice: Int?
    var smsTextCode: String?
    @IBOutlet weak var routeNumber: UILabel!
    @IBOutlet weak var routeDescription: UILabel!
    @IBOutlet weak var transportType: UILabel!
    @IBOutlet weak var farePaymentButton: UIButton!
    @IBOutlet weak var ticketPriceLabel: UILabel!
    @IBAction func farePayment(_ sender: UIButton) {
        delegate?.sendSms(textMsg: smsTextCode!)
    }


    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    func updateUI(transport: TransportModel, route: String) {
        
        let currentTransport = transport.transportType
        farePaymentButton.setTitle(" Оплатити ", for: .normal)
        farePaymentButton.layer.cornerRadius = 5
        transportType.text = currentTransport
        routeDescription.text = transport.routeInfo[route]
        ticketPriceLabel.text = "\(transport.ticketPrice) грн."
        routeNumber.text = "Маршрут №" + route
        smsTextCode = transport.routeFareCode[route]

    }


}

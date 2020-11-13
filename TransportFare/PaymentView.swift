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
    var ticketPrice: Int?
    var smsTextCode: String?
    var reducedPriceSmsTextCode: String?
    @IBOutlet weak var routeNumber: UILabel!
    @IBOutlet weak var routeDescription: UILabel!
    @IBOutlet weak var transportType: UILabel!
    @IBOutlet weak var priceTypeDescription: UILabel!
    @IBOutlet weak var farePaymentButton: UIButton!
    @IBOutlet weak var reducedFarePaymentButton: UIButton!
    @IBOutlet weak var ticketPriceLabel: UILabel!
    @IBOutlet weak var reducedPriceTicketLabel: UILabel!
    @IBOutlet weak var usualPriceStackView: UIStackView!
    @IBOutlet weak var reducedPriceStackView: UIStackView!
    @IBAction func reducedPriceFarePayment(_ sender: UIButton){
        delegate?.sendSms(textMsg: reducedPriceSmsTextCode!)
    }
    @IBAction func farePayment(_ sender: UIButton) {
        delegate?.sendSms(textMsg: smsTextCode!)
    }

    func updateUI(transport: TransportModel, route: String, nightTime: Bool) {
        if let _ = transport.reducedPrice {
            reducedPriceStackView.isHidden = false
            priceTypeDescription.isHidden = false
            priceTypeDescription.text = "Звичайний"
            ticketPriceLabel.text = "\(transport.ticketPrice) грн."
            if let reducedPriceLabel = transport.reducedPrice {
            reducedPriceTicketLabel.text = "\(reducedPriceLabel) грн."
            }
        } else if nightTime == true && transport.nightTimeTicketPrice != nil, let nightTimePrice = transport.nightTimeTicketPrice {
            priceTypeDescription.isHidden = false
            priceTypeDescription.text = "Нічний час"
            reducedPriceStackView.isHidden = true
            ticketPriceLabel.text = "\(nightTimePrice) грн."
        } else {
            reducedPriceStackView.isHidden = true
            priceTypeDescription.isHidden = true
            ticketPriceLabel.text = "\(transport.ticketPrice) грн."
        }

        let currentTransport = transport.transportType
        farePaymentButton.setTitle(" Оплатити ", for: .normal)
        farePaymentButton.layer.cornerRadius = 5
        reducedFarePaymentButton.layer.cornerRadius = 5
        transportType.text = currentTransport
        routeDescription.text = transport.routeInfo[route]
        reducedPriceSmsTextCode = transport.reducedPriceFareCode[route]
        smsTextCode = transport.routeFareCode[route]
        routeNumber.text = "Маршрут №" + route
    }

}

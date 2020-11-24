//
//  MainViewController.swift
//  TransportFare
//
//  Created by TheMacUser on 09.07.2020.
//  Copyright © 2020 TheMacUser. All rights reserved.
//

import UIKit
import MessageUI
class MainViewController: UIViewController, TransportType, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, PaymentViewProtocol, CityDropDown, MFMessageComposeViewControllerDelegate {

    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        controller.dismiss(animated: true, completion: nil)
    }

    static let shared = MainViewController()
    var backButtonHelpShowing = true
    var vinnitsa: City?
    var lviv: City?
    var zhytomyr: City?
    var ivanoFrankivsk: City?
    var tram: TransportModel?
    var trolleybus : TransportModel?
    var autobus: TransportModel?
    let defaults = UserDefaults.standard
    var transport: TransportModel?
    var city: City?
    var cities: [City] = []
    var isDropDownCitiesMenuHidden = true
    var nightTime: Bool = false
    @IBOutlet weak var transportTypeView: TransportTypeView!
    @IBOutlet var routesCollectionView: UICollectionView!
    @IBOutlet var backButtonHelpView: UIView!
    @IBOutlet var backButtonHelpStackView: UIStackView!
    @IBOutlet weak var informationView: InformationView!
    @IBOutlet var backButtonHelp: UIButton!
    @IBOutlet var cityDropDownView: CityDropDownView!
    @IBOutlet weak var paymentView: PaymentView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet var mainBackButton: UIButton!
    @IBOutlet var routesCollectionViewHeightConstraint: NSLayoutConstraint!
    @IBAction func backButtonHelp(_ sender: UIButton) {
        backButtonHelpView.isHidden = true
        routesCollectionView.unblur()
        backButtonHelpShowing = false
    }
    @IBAction func backButton(_ sender: UIButton) {
        if paymentView.isHidden == false {
            paymentView.isHidden = true
            routesCollectionView.isHidden = false
        } else if paymentView.isHidden == true {
            routesCollectionView.isHidden = true
            backButton.isHidden = true
            mainBackButton.isHidden = true
            informationView.isHidden = true
            cityDropDownView.unblur()
            transportTypeView.unblur()
            transport = nil
            
        }
       if isDropDownCitiesMenuHidden == false {
            isDropDownCitiesMenuHidden = true
            updateDropDownMenuOfCyties()
        }
    }
    

    let vinnitsaTram = TransportModel(transportName: "tram", transportType: "Трамвай", routeNumbers: ["1", "2", "3", "4", "5", "6"], ticketPrice: 4, nightTimeTicketPrice: nil, reducedPrice: nil, transportRoutes: ["Залізничний вокзал - Електромережа", "Барське шосе - Вишенька", "Вишенька - Електромережа", "Барське шосе - Залізничний вокзал", "Барське шосе - Електромережа", "Залізничний вокзал - Вишенька"], routeTextCodes: ["SAC1", "SAC2", "SAC3", "SAC4", "SAC5", "SAC6"], reducedPriceRouteTextCodes: nil)
    let vinnitsaTrolleybus = TransportModel(transportName: "trolleybus", transportType: "Тролейбус", routeNumbers: ["1", "2", "3", "4", "5", "6", "6A", "7", "8", "9", "10", "11", "12", "13", "14", "15"], ticketPrice: 4, nightTimeTicketPrice: nil, reducedPrice: nil, transportRoutes: ["Лугова - ВПЗ", "Меморіал Визволення - Чехова", "Вишенька - ВПЗ", "Вишенька - Лугова", "Залізничний вокзал - Вишенька", "Меморіал Визволення - Залізничний вокзал", "ВПЗ - Залізничний вокзал", "Залізничний вокзал - Лугова", "Вишенька - Меморіал Визволення", "Меморіал Визволення - Князів Коріатовичів", "Вишенька - Чехова", "Залізничний вокзал - Князів Коріатовичів", "Аграрний університет - Чехова", "Меморіал Визволення - Аграрний університет", "Залізничний вокзал - Аграрний університет", "Вишенька - Муніципальний ринок"], routeTextCodes: ["SAB1", "SAB2", "SAB3", "SAB4", "SAB5", "SAB6", "SAB6A", "SAB7", "SAB8", "SAB9", "SAB10", "SAB11", "SAB12", "SAB13", "SAB14", "SAB15"], reducedPriceRouteTextCodes: nil)
    let vinnitsaAutobus = TransportModel(transportName: "autobus", transportType: "Автобус", routeNumbers: ["1", "2", "5", "6", "7", "8", "11", "14", "16", "17", "19", "20", "21", "22", "24", "27", "30"], ticketPrice: 5, nightTimeTicketPrice: nil, reducedPrice: nil, transportRoutes: ["Залізничний вокзал - Педучилище", "Вул. Сергія Зулінського - Площа Шкільна", "П'ятничани - Вул. Комарова", "Олієжиркомбінат - Площа Перемоги", "Вул. Якова Шепеля - Пирогово", "Залізничний вокзал - Вул. Бучми (ліс)", "Вул. Ботанічна - Сабарів", "Залізничний вокзал - Будинок відпочинку", "Меморіал Визволення - Барське шосе" + "\n" + " - Аграрний університет", "Залізничний вокзал - Тяжилів \n (Вінниччина-Авто)", "Вишенька - Немирівське шосе", "Меморіал Визволення - Хутір Шевченка", "Барське шосе - Педучилище", "Залізничний вокзал - Мікрорайон \n 'Академічний'", "Вишенька - Вул. Бучми (ліс)", "Залізничний вокзал - Тиврівське шосе", "смт. Десна - Будинок відпочинку"], routeTextCodes: ["SAA1", "SAA2", "SAA5", "SAA6", "SAA7", "SAA8", "SAA11", "SAA14", "SAA16", "SAA17", "SAA19", "SAA20", "SAA21", "SAA22", "SAA24", "SAA27", "SAA30"], reducedPriceRouteTextCodes: nil)
    let lvivTram = TransportModel(transportName: "tram", transportType: "Трамвай", routeNumbers: ["1", "2", "3", "4", "5", "6", "7", "8", "9"], ticketPrice: 6, nightTimeTicketPrice: nil, reducedPrice: 3, transportRoutes: ["Залізничний вокзал – Центр", "вул. Коновальця – вул. Пасічна", "Аквапарк – пл. Соборна", "Залізничний вокзал - вул. Вернадського", "вул. Торфяна - вул. Княгині Ольги", "Залізничний вокзал – вул. Миколайчука", "вул. Татарбунарська – Погулянка", "пл. Соборна – вул. Вернадського", "Залізничний вокзал – Центр"], routeTextCodes: ["SN1", "SN2", "SN3", "SN4", "SN5", "SN6", "SN7", "SN8", "SN9"], reducedPriceRouteTextCodes: ["PN1", "PN2", "PN3", "PN4", "PN5", "PN6", "PN7", "PN8", "PN9"])
    let lvivTrolleybus = TransportModel(transportName: "trolleybus", transportType: "Тролейбус", routeNumbers: ["22", "23", "24", "25", "27", "29", "30", "31", "32", "33"], ticketPrice: 6, nightTimeTicketPrice: nil, reducedPrice: 3, transportRoutes: ["Університет — вул. Академіка Підстригача", "Автовокзал — вул. Ряшівська", "вул. Шота Руставелі — Санта Барбара", "вул. Шота Руставелі — Автовокзал", "станція Скнилів — пл. Кропивницького", "Університет — Аеропорт", "вул. Ряшівська - Університет", "пл. Петрушевича — Сихівське кладовище", "Університет — вул. Суботівська", "пл. Івана Підкови — вул. Грінченка"], routeTextCodes: ["SN22", "SN23", "SN24", "SN25", "SN27", "SN29", "SN30", "SN31", "SN32", "SN33"], reducedPriceRouteTextCodes: ["PN22", "PN23", "PN24", "PN25", "PN27", "PN29", "PN30", "PN31", "PN32", "PN33"])

    let zhytomyrTram = TransportModel(transportName: "tram", transportType: "Трамвай", routeNumbers: ["91", "ДЕПО"], ticketPrice: 4, nightTimeTicketPrice: 10, reducedPrice: nil, transportRoutes: ["Майдан Перемоги - Льогокомбінат", "ДЕПО"], routeTextCodes: ["SEC91", "SEC0"], reducedPriceRouteTextCodes: nil)
    let zhytomyrTrolleybus = TransportModel(transportName: "trolleybus", transportType: "Тролейбус", routeNumbers: ["1A", "1Б", "2", "3", "4", "4А", "6", "7", "7А", "8", "9", "10", "15А", "ДЕПО"], ticketPrice: 4, nightTimeTicketPrice: 10, reducedPrice: nil, transportRoutes: ["Вокзал - Центр - \n Смолянка - Вокзал (кільцевий)", "Вокзал - Смолянка - \n Центр - Вокзал (кільцевий)", "Богунія - Вокзал - Смолянка", "Богунія - Смолянка - Вокзал", "Крошня - Залізничний вокзал", "Крошня - майдан Станишівський", "Крошня - ЗОК", "Маликова - Залізничний вокзал", "Маликова - Промислова", "Маликова - майдан Станишівський", "Гідропарк - Космонавтів", "Богунія - Промислова", "Гідропарк - Селецька", "ДЕПО"], routeTextCodes: ["SEB1A", "SEB1B", "SEB2", "SEB3", "SEB4", "SEB4A", "SEB6", "SEB7", "SEB7A", "SEB8", "SEB9", "SEB10", "SEB15A", "SEB0"], reducedPriceRouteTextCodes: nil)
    let zhytomyrAutobus = TransportModel(transportName: "autobus", transportType: "Автобус", routeNumbers: ["3", "4", "ДЕПО"], ticketPrice: 6, nightTimeTicketPrice: nil, reducedPrice: 3, transportRoutes: ["Богунія - Корбутівка", "Крошня(ТЦ \"Ринг\" - Комбінат силікатних виробів)", "ДЕПО"], routeTextCodes: ["SEA3", "SEA4", "SEA0"], reducedPriceRouteTextCodes: ["PEA3", "PEA4", "PEA0"])

    let ivanoFrankivskTrolleybus = TransportModel(transportName: "trolleybus", transportType: "Тролейбус", routeNumbers: ["2", "3", "4", "5", "6", "7", "10"], ticketPrice: 5, nightTimeTicketPrice: nil, reducedPrice: nil, transportRoutes: ["Вокзал - вул. Юності \"Пресмаш\"", "АТ \"Родон\" - Обласна лікарня", "вул. Дністровська - фірма \"Барва\"", "вул. Дністровська - Тролейбусне депо", "Радіозавод - Європейська площа", "м-н \"Каскад\" - Європейська площа", "вул. Симоненка - вул. Юності \"Пресмаш\""], routeTextCodes: ["SHB2", "SHB3", "SHB4", "SHB5", "SHB6", "SHB7", "SHB10"], reducedPriceRouteTextCodes: nil)
    let ivanoFrankivskAutobus = TransportModel(transportName: "autobus", transportType: "Автобус", routeNumbers: ["27", "40", "41", "45", "47", "49", "55"], ticketPrice: 5, nightTimeTicketPrice: nil, reducedPrice: nil, transportRoutes: ["м-н \"Каскад\" - вул. І Пулюя", "м-н \"Каскад\"  - АС-3", "Онкодиспансер - м-н \"Каскад\"", "с. Підлужжя - вул. Набережна", "Вокзал - Братківці", "АС-4 - вул Набережна", "Хоткевича - с.Черніїв", "Хоткевича - с. Хриплин", "с. Крихівці - АС-2", "Вокзал - с. Черніїв"], routeTextCodes: ["SHA27", "SHA40", "SHA41", "SHA45", "SHA47", "SHA49", "SHA55"], reducedPriceRouteTextCodes: nil)
    
    // Flayout for Transport Type Tile and Routes Collection buttons, centering
    let transportTypeColumnLayout = FlowLayout()
    let routesViewColumnLayout = FlowLayout()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkTimeOfDay()
        let ivanoFrankivskCityTransport: [TransportModel] = [ivanoFrankivskTrolleybus, ivanoFrankivskAutobus]
        let zhitomirCityTransport: [TransportModel] = [zhytomyrTram, zhytomyrTrolleybus, zhytomyrAutobus]
        let vinnitsaCityTransport: [TransportModel] = [vinnitsaTram, vinnitsaTrolleybus, vinnitsaAutobus]
        let lvivCityTransport:[TransportModel] = [lvivTram, lvivTrolleybus]
        vinnitsa = City(name: "Вінниця", cityTransport: vinnitsaCityTransport, cityEmblemName: "Vinnitsa")
        lviv = City(name: "Львів", cityTransport: lvivCityTransport, cityEmblemName: "Lviv")
        zhytomyr = City(name: "Житомир", cityTransport: zhitomirCityTransport, cityEmblemName: "Zhytomir" )
        ivanoFrankivsk = City(name: "Івано-Франківськ", cityTransport: ivanoFrankivskCityTransport, cityEmblemName: "Ivano-Frankivsk1")
        cities = Array(arrayLiteral: vinnitsa!, lviv!, zhytomyr!, ivanoFrankivsk!)
        backButtonHelpStackView.backgroundColor()
        backButtonHelpView.isHidden = true
        backButtonHelp.layer.cornerRadius = 5
        paymentView.isHidden = true
        routesCollectionView.isHidden = true
        routesCollectionView.layer.cornerRadius = 5
        // make shadow is awailable
        routesCollectionView.layer.masksToBounds = false
        shadowForView(shadowView: routesCollectionView)
        paymentView.layer.cornerRadius = 10
        informationView.layer.cornerRadius = 10
        informationView.scrollView.layer.cornerRadius = 10
        informationView.scrollView.layer.borderWidth = 1
        informationView.scrollView.layer.borderColor = UIColor.gray.cgColor
        transportTypeView.delegate = self
        transportTypeColumnLayout.minimumLineSpacing = 18
        transportTypeColumnLayout.minimumInteritemSpacing = 20
        paymentView.delegate = self
        cityDropDownView.delegate = self
        loadUserDefaults()
        updateCityDropDown()
        updateDropDownMenuOfCyties()
        updateInformationView()
        updateCollectionView(collectionView: transportTypeView.transportTypeCollectionView) {
            updateCollectionViewLayout(currentCollectionView: transportTypeView.transportTypeCollectionView, layout: transportTypeColumnLayout, collectionViewHeightConstraint: transportTypeView.transportTypeCollectionViewHeight)
        }
        traitCollectionDidChange(UIScreen.main.traitCollection)

    }
    func updateViewAfterRotateScreen(){
        transportTypeView.transportTypeCollectionView.reloadData()
        routesCollectionView.reloadData()
    }
    func updateCollectionViewAfterScreenRotate(){
        self.routesCollectionViewHeightConstraint.constant = self.routesCollectionView.collectionViewLayout.collectionViewContentSize.height
                    self.transportTypeView.transportTypeCollectionViewHeight.constant = self.transportTypeView.transportTypeCollectionView.collectionViewLayout.collectionViewContentSize.height
    }
    // setup variations in addition to change screen orienation
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        transportTypeView.unblur()
        updateViewAfterRotateScreen()
        routesCollectionView.unblur()
        UIView.animate(withDuration: 0.0) { [self] in
            updateViewAfterRotateScreen()
        } completion: { _ in
            UIView.animate(withDuration: 0.0) {
                self.updateCollectionViewAfterScreenRotate()
            } completion: { [self] _ in
                if !informationView.isHidden || !isDropDownCitiesMenuHidden {
                        transportTypeView.blur(2.0)
                } else if backButtonHelpView.isHidden == false {
                    UIView.animate(withDuration: 0.0) {
                    } completion: { _ in
                        routesCollectionView.blur(2.0)
                    }

                }
            }
        }
        guard transport != nil else {return}
        UIView.animate(withDuration: 0.0, animations: {
        }) { (_) in
            self.transportTypeView.blur(2.0)
        }
    }
    func updateCollectionViewLayout(currentCollectionView: UICollectionView, layout: UICollectionViewLayout, collectionViewHeightConstraint: NSLayoutConstraint){
           currentCollectionView.collectionViewLayout = layout
        collectionViewHeightConstraint.constant = currentCollectionView.collectionViewLayout.collectionViewContentSize.height
    }
    
    // starting setup CollectionView for Transport Type Tile
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == routesCollectionView {
            return transport?.routeNumbers.count ?? 0
        } else {
        return (city?.cityTransport.count)!
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == transportTypeView.transportTypeCollectionView {
        let transportTypeCell = transportTypeView.transportTypeCollectionView.dequeueReusableCell(withReuseIdentifier: "TransportTypeCell", for: indexPath) as! TransportTypeCollectionViewCell
       transportTypeCell.transportTypeLabel.text = city?.cityTransport[indexPath.row].transportType
        transportTypeCell.transportTypeImage.image = UIImage(named: (city?.cityTransport[indexPath.row].transportName)!)
            transportTypeCell.layer.cornerRadius = 5
            return transportTypeCell
        } else {
        let routeCell = routesCollectionView.dequeueReusableCell(withReuseIdentifier: "RoutesCollectionViewCell", for: indexPath) as! RoutesCollectionViewCell
            routeCell.layer.cornerRadius = 5
            routeCell.routesCollectionViewCellLabel.text = transport?.routeNumbers[indexPath.row]
        return routeCell
    }
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if collectionView == transportTypeView.transportTypeCollectionView {
            return UIEdgeInsets(top: 30, left: 10, bottom: 10, right: 10)
        } else {
            return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        }

    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == transportTypeView.transportTypeCollectionView {
            return CGSize(width: 92, height: 107)
        } else {
            if transport?.routeNumbers[indexPath.row] == "ДЕПО" {
                return CGSize(width: 80, height: 45)
            } else {
            return CGSize(width: 45, height: 45)
            }
        }
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let deviceScreen = UIScreen.main.bounds
        if collectionView == transportTypeView.transportTypeCollectionView {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "TransportTypeCollectionViewHeader", for: indexPath)
            if traitCollection.verticalSizeClass == .compact {
                transportTypeColumnLayout.headerReferenceSize = CGSize(width: 0, height: 28)
            } else if deviceScreen.height < 660 {
                transportTypeColumnLayout.headerReferenceSize = CGSize(width: 0, height: 65)
            } else {
                transportTypeColumnLayout.headerReferenceSize = CGSize(width: 0, height: 55)
            }
           return headerView
        } else {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "RoutesCollectionViewHeader", for: indexPath) as! RoutesHeaderCollectionReusableView
            headerView.routesViewTransportTypeTyle.isHidden = false
            if traitCollection.verticalSizeClass == .compact {
                if deviceScreen.height < 370 {
                    routesViewColumnLayout.headerReferenceSize = CGSize(width: 0, height: 100)
                    headerView.routesViewTransportTypeTyle.isHidden = true
                } else {
            routesViewColumnLayout.headerReferenceSize = CGSize(width: 0, height: 150)
                }
            } else {
                if deviceScreen.height < 660 {
                    routesViewColumnLayout.headerReferenceSize = CGSize(width: 0, height: 150)
                } else {
                routesViewColumnLayout.headerReferenceSize = CGSize(width: 0, height: 180)
                }
            }

                if let transport = transport {
                headerView.routesViewTransportTypeTyle.image = UIImage(named: transport.transportName)
                    headerView.routesCollectionViewTransportTypeName.text = transport.transportType
                }
                return headerView
            }
       }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == transportTypeView.transportTypeCollectionView {
        let transportTypeCell = collectionView.cellForItem(at: indexPath) as! TransportTypeCollectionViewCell
        let nameOfSelectedTransport = transportTypeCell.transportTypeLabel.text
            UIView.animate(withDuration: 0.0) {
                self.updateRouteView(transportType: nameOfSelectedTransport!)
            } completion: { _ in
                if self.backButtonHelpShowing == true {
                        self.routesCollectionView.blur()
                        self.backButtonHelpView.isHidden = false
                }
            }

        
            
        } else {
            let routeNumberCell = collectionView.cellForItem(at: indexPath) as! RoutesCollectionViewCell
            let selectedRouteNumber = routeNumberCell.routesCollectionViewCellLabel.text!
            checkTimeOfDay()
            routeButonTapped(routeNumber: selectedRouteNumber)
            
        }
    }
    // ending setup CollectionView for Transport Type Tile
    
    // update Route View
    func updateRouteView(transportType: String) {
        for transportModel in city!.cityTransport {
            if transportType == transportModel.transportType {
                transport = transportModel
                mainBackButton.isHidden = false
                transportTypeView.blur(2.0)
                cityDropDownView.blur(2.0)
                updateCollectionView(collectionView: routesCollectionView) {
                    updateCollectionViewLayout(currentCollectionView: routesCollectionView, layout: routesViewColumnLayout, collectionViewHeightConstraint: routesCollectionViewHeightConstraint)
                }
                routesCollectionView.isHidden = false
        }
        }
    }
    
    // route button tapped
    func routeButonTapped(routeNumber: String) {
        guard let transport = transport else {print("there is no transport"); return}
        paymentView.updateUI(transport: transport, route: routeNumber, nightTime: nightTime)
        routesCollectionView.isHidden = true
        shadowForView(shadowView: paymentView)
        paymentView.isHidden = false
    }

    func sendSms(textMsg: String) {
        //makePayment(textMsg: textMsg)
        if !MFMessageComposeViewController.canSendText() {
            print("SMS services are not available")
        } else {
            let composeVC = MFMessageComposeViewController()
            composeVC.messageComposeDelegate = self
            // Configure the fields of the interface.
            composeVC.recipients = ["827"]
            composeVC.body = textMsg
            // Present the view controller modally.
            self.present(composeVC, animated: true, completion: nil)
        }
    }
    
    func shadowForView(shadowView: UIView){
        shadowView.layer.shadowColor = UIColor.black.cgColor
        shadowView.layer.shadowOpacity = 0.5
        shadowView.layer.shadowOffset = .zero
        shadowView.layer.shadowRadius = 10
    }
    func updateInformationView(){
        if !informationView.informationCheckMark.isSelected {
            informationView.isHidden = false
            mainBackButton.isHidden = false
            UIView.animate(withDuration: 0.0, animations: {
                
            }) { _ in
                self.cityDropDownView.blur()
            }
        } else  {
            informationView.isHidden = true
            mainBackButton.isHidden = true
            backButton.isHidden = true
        }
    }

    func informationButtonTapped (){
        transportTypeView.blur()
        cityDropDownView.blur()
        informationView.isHidden = false
        mainBackButton.isHidden = false
    }
    func shareButtonTapped() {
                if let transportFare = URL(string: "https://itunes.apple.com/us/app/myapp/idxxxxxxxx?ls=1&mt=8"), !transportFare.absoluteString.isEmpty {
            let objectsToShare = [transportFare]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)

            present(activityVC, animated: true, completion: nil)

        } else {
            print("the URL is not available!")
        }
    }
    
    func updateDropDownMenuOfCyties(){
        if isDropDownCitiesMenuHidden == false {
            UIView.animate(withDuration: 0.1) {
                self.cityDropDownView.cityStackView.spacing = 10
            }
            transportTypeView.blur()
            backButton.isHidden = false
        } else {
            UIView.animate(withDuration: 0.1) {
                self.cityDropDownView.cityStackView.spacing = -32
            }
            transportTypeView.unblur()
            backButton.isHidden = true
        }
    }
    func menuButtonTapped() {
        isDropDownCitiesMenuHidden = !isDropDownCitiesMenuHidden
        updateDropDownMenuOfCyties()
    }
    func updateCollectionView(collectionView: UICollectionView, completion: () -> Void){
        collectionView.reloadData()
        completion()
    }
    @objc func cityDropDownButtonTapped(sender: UIButton) {
        for city in cities {
            let index = cities.firstIndex(of: city)
            if city.name == sender.titleLabel?.text {
                let cityChoosen = cities.remove(at: index!)
                cities.insert(cityChoosen, at: 3)
                self.city = cityChoosen
                updateCollectionView(collectionView: transportTypeView.transportTypeCollectionView) {
                        updateCollectionViewLayout(currentCollectionView: transportTypeView.transportTypeCollectionView, layout: transportTypeColumnLayout, collectionViewHeightConstraint: transportTypeView.transportTypeCollectionViewHeight)
                    }

                let jsonEncoder = JSONEncoder()
                if let data = try? jsonEncoder.encode(self.city) {
                    let userDefaults = UserDefaults.standard
                    userDefaults.set(data, forKey: "CityChoosen")
                }
                break
            }
        }
        clearCityStackView()
        updateCityDropDown()
        UIView.animate(withDuration: 0.0, animations: {
        }) { _ in
            self.isDropDownCitiesMenuHidden = true
            self.updateDropDownMenuOfCyties()
        }
        
    }
    func loadUserDefaults(){
        informationView.informationCheckMark.isSelected = defaults.object(forKey: "InformationButtoncheckMark") as? Bool ?? false
        if let decodedData = UserDefaults.standard.object(forKey: "CityChoosen") as? Data, let city = try? JSONDecoder().decode(City.self, from: decodedData){
            self.city = city
            } else {city = vinnitsa}
        let index = cities.firstIndex(of: city!)
        let savedCity = cities.remove(at: index!)
        cities.insert(savedCity, at: 3)
    }
    func clearCityStackView(){
        cityDropDownView.citiesButtonsArray.removeAll()
        for subview in cityDropDownView.cityStackView.arrangedSubviews {
            subview.removeFromSuperview()
        }
    }

    func updateCityDropDown(){
        cityDropDownView.cities = cities
        cityDropDownView.updateCityDropDownButtons()
        cityDropDownView.updateCityDropDownMenu()
        updateDropDownMenuOfCyties()
    }
    
    func  verifyTimeOfDay(currentDate: Date){
        let nightTimeBegin = "22:00:00"
        let nightTimeEnd = "06:00:00"
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.dateFormat = "HH:mm:ss"
        let dateNightBeginTime = dateFormatter.date(from: nightTimeBegin)
        let dateNightEndTime = dateFormatter.date(from: nightTimeEnd)
        let calendar = Calendar.current
        let componentsNightTimeBegin = calendar.dateComponents([.hour, .minute], from: dateNightBeginTime!)
        let componentsNightTimeEnd = calendar.dateComponents([.hour, .minute], from: dateNightEndTime!)
        
        let nightPriceBeginTime = Calendar.current.date(from: componentsNightTimeBegin)
        let nightPriceEndTime = Calendar.current.date(from: componentsNightTimeEnd)
        if (currentDate < nightPriceBeginTime!) && (currentDate > nightPriceEndTime!) {
            nightTime = false
        } else {
            nightTime = true
        }
    }
    func checkTimeOfDay(){
        let currentTime = Calendar.current.dateComponents([.hour, .minute], from: Date())
        if let currentTimeDate = Calendar.current.date(from: currentTime){
            verifyTimeOfDay(currentDate: currentTimeDate)
        } else {
            nightTime = false
        }
    }
    


}

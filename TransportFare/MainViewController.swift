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
    func delegateWithTransportType(sender: UIButton) {
        print("Hello")
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        controller.dismiss(animated: true, completion: nil)
    }

    static let shared = MainViewController()
    var buttonsModel = ButtonsModel()
    var routeNumber: String?
    var widthOfVerticalStack: Int = 0
    var dropDownMenuOfcitysIsHidden = false
    var nightTime: Bool?
    @IBOutlet weak var transportTypeView: TransportTypeView!
    @IBOutlet weak var routesView: RoutesView!
    
    @IBOutlet var routesCollectionView: UICollectionView!
    @IBOutlet weak var informationView: InformationView!
    
    @IBOutlet var cityDropDownView: CityDropDownView!
    @IBOutlet weak var paymentView: PaymentView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet var mainBackButton: UIButton!
    @IBOutlet weak var paymentViewBackButton: UIButton!
    @IBOutlet var paymentTransparentView: UIView!
    @IBAction func paymentViewBackButton(_ sender: UIButton) {
        print("PaymentBackButtonIsTapped")
        paymentView.isHidden = true
        //routesCollectionView.unblur()
        routesCollectionView.isHidden = false
        
    }
    @IBOutlet var routesCollectionViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet var routesCollectionViewWidth: NSLayoutConstraint!
    @IBAction func backButton(_ sender: UIButton) {
        if paymentView.isHidden == false {
            paymentView.isHidden = true
            routesView.isHidden = false
            routesCollectionView.isHidden = false
        } else if paymentView.isHidden == true {
            routesCollectionView.isHidden = true
            routesView.isHidden = true
            backButton.isHidden = true
            mainBackButton.isHidden = true
            informationView.isHidden = true
            cityDropDownView.unblur()
            transportTypeView.unblur()
//            clearButtonsAndStack()
         transport = nil
            
        }
       if dropDownMenuOfcitysIsHidden == false {
            dropDownMenuOfcitysIsHidden = true
            updateDropDownMenuOfCyties()
        }
    }
    var vinnitsa: City?
    var lviv: City?
    var zhytomyr: City?
    var ivanoFrankivsk: City?
    var tram: TransportModel?
    var trolleybus : TransportModel?
    var autobus: TransportModel?
    let defaults = UserDefaults.standard
    var transport: TransportModel?
    var route: String!
    var city: City?
    var cities: [City] = []
    var citiesDropDownMenuButtons: [UIButton] = []
    let vinnitsaTram = TransportModel(transportName: "tram", transportType: "Трамвай", routeNumbers: ["1", "2", "3", "4", "5", "6"], ticketPrice: 4, nightTimeTicketPrice: nil, reducedPrice: nil, transportRoutes: ["Залізничний вокзал - Електромережа", "Барське шосе - Вишенька", "Вишенька - Електромережа", "Барське шосе - Залізничний вокзал", "Барське шосе - Електромережа", "Залізничний вокзал - Вишенька"], routeTextCodes: ["SAC1", "SAC2", "SAC3", "SAC4", "SAC5", "SAC6"], reducedPriceRouteTextCodes: nil)
    let vinnitsaTrolleybus = TransportModel(transportName: "trolleybus", transportType: "Тролейбус", routeNumbers: ["1", "2", "3", "4", "5", "6", "6A", "7", "8", "9", "10", "11", "12", "13", "14", "15"], ticketPrice: 4, nightTimeTicketPrice: nil, reducedPrice: nil, transportRoutes: ["Лугова - ВПЗ", "Меморіал Визволення - Чехова", "Вишенька - ВПЗ", "Вишенька - Лугова", "Залізничний вокзал - Вишенька", "Меморіал Визволення - Залізничний вокзал", "ВПЗ - Залізничний вокзал", "Залізничний вокзал - Лугова", "Вишенька - Меморіал Визволення", "Меморіал Визволення - Князів Коріатовичів", "Вишенька - Чехова", "Залізничний вокзал - Князів Коріатовичів", "Аграрний університет - Чехова", "Меморіал Визволення - Аграрний університет", "Залізничний вокзал - Аграрний університет", "Вишенька - Муніципальний ринок"], routeTextCodes: ["SAB1", "SAB2", "SAB3", "SAB4", "SAB5", "SAB6", "SAB6A", "SAB7", "SAB8", "SAB9", "SAB10", "SAB11", "SAB12", "SAB13", "SAB14", "SAB15"], reducedPriceRouteTextCodes: nil)
    let vinnitsaAutobus = TransportModel(transportName: "autobus", transportType: "Автобус", routeNumbers: ["1", "2", "5", "6", "7", "8", "11", "14", "16", "17", "19", "20", "21", "22", "24", "27", "30"], ticketPrice: 5, nightTimeTicketPrice: nil, reducedPrice: nil, transportRoutes: ["Залізничний вокзал - Педучилище", "Вул. Сергія Зулінського - Площа Шкільна", "П'ятничани - Вул. Комарова", "Олієжиркомбінат - Площа Перемоги", "Вул. Якова Шепеля - Пирогово", "Залізничний вокзал - Вул. Бучми (ліс)", "Вул. Ботанічна - Сабарів", "Залізничний вокзал - Будинок відпочинку", "Меморіал Визволення - Барське шосе" + "\n" + " - Аграрний університет", "Залізничний вокзал - Тяжилів \n (Вінниччина-Авто)", "Вишенька - Немирівське шосе", "Меморіал Визволення - Хутір Шевченка", "Барське шосе - Педучилище", "Залізничний вокзал - Мікрорайон \n 'Академічний'", "Вишенька - Вул. Бучми (ліс)", "Залізничний вокзал - Тиврівське шосе", "смт. Десна - Будинок відпочинку"], routeTextCodes: ["SAA1", "SAA2", "SAA5", "SAA6", "SAA7", "SAA8", "SAA11", "SAA14", "SAA16", "SAA17", "SAA19", "SAA20", "SAA21", "SAA22", "SAA24", "SAA27", "SAA30"], reducedPriceRouteTextCodes: nil)
    let lvivTram = TransportModel(transportName: "tram", transportType: "Трамвай", routeNumbers: ["1", "2", "3", "4", "5", "6", "7", "8", "9"], ticketPrice: 6, nightTimeTicketPrice: nil, reducedPrice: 3, transportRoutes: ["Залізничний вокзал – Центр", "вул. Коновальця – вул. Пасічна", "Аквапарк – пл. Соборна", "Залізничний вокзал - вул. Вернадського", "вул. Торфяна - вул. Княгині Ольги", "Залізничний вокзал – вул. Миколайчука", "вул. Татарбунарська – Погулянка", "пл. Соборна – вул. Вернадського", "Залізничний вокзал – Центр"], routeTextCodes: ["SN1", "SN2", "SN3", "SN4", "SN5", "SN6", "SN7", "SN8", "SN9"], reducedPriceRouteTextCodes: ["PN1", "PN2", "PN3", "PN4", "PN5", "PN6", "PN7", "PN8", "PN9"])
    let lvivTrolleybus = TransportModel(transportName: "trolleybus", transportType: "Тролейбус", routeNumbers: ["22", "23", "24", "25", "27", "29", "30", "31", "32", "33"], ticketPrice: 6, nightTimeTicketPrice: nil, reducedPrice: 3, transportRoutes: ["Університет — вул. Академіка Підстригача", "Автовокзал — вул. Ряшівська", "вул. Шота Руставелі — Санта Барбара", "вул. Шота Руставелі — Автовокзал", "станція Скнилів — пл. Кропивницького", "Університет — Аеропорт", "вул. Ряшівська - Університет", "пл. Петрушевича — Сихівське кладовище", "Університет — вул. Суботівська", "пл. Івана Підкови — вул. Грінченка"], routeTextCodes: ["SN22", "SN23", "SN24", "SN25", "SN27", "SN29", "SN30", "SN31", "SN32", "SN33"], reducedPriceRouteTextCodes: ["PN22", "PN23", "PN24", "PN25", "PN27", "PN29", "PN30", "PN31", "PN32", "PN33"])
//    let lvivAutobus = TransportModel(transportName: "autobus", transportType: "Автобус", routeNumbers: ["1", "2", "5", "6", "7", "8", "11", "14", "16", "17", "19", "20", "21", "22", "24", "27", "30"], ticketPrice: 5, nightTimeTicketPrice: 5, transportRoutes: ["Залізничний вокзал - Педучилище", "Вул. Сергія Зулінського - Площа Шкільна", "П'ятничани - Вул. Комарова", "Олієжиркомбінат - Площа Перемоги", "Вул. Якова Шепеля - Пирогово", "Залізничний вокзал - Вул. Бучми (ліс)", "Вул. Ботанічна - Сабарів", "Залізничний вокзал - Будинок відпочинку", "Меморіал Визволення - Барське шосе" + "\n" + " - Аграрний університет", "Залізничний вокзал - Тяжилів \n (Вінниччина-Авто)", "Вишенька - Немирівське шосе", "Меморіал Визволення - Хутір Шевченка", "Барське шосе - Педучилище", "Залізничний вокзал - Мікрорайон \n 'Академічний'", "Вишенька - Вул. Бучми (ліс)", "Залізничний вокзал - Тиврівське шосе", "смт. Десна - Будинок відпочинку"], routeTextCodes: ["SAA1", "SAA2", "SAA5", "SAA6", "SAA7", "SAA8", "SAA11", "SAA14", "SAA16", "SAA17", "SAA19", "SAA20", "SAA21", "SAA22", "SAA24", "SAA27", "SAA30"])
    let zhytomyrTram = TransportModel(transportName: "tram", transportType: "Трамвай", routeNumbers: ["91", "ДЕПО"], ticketPrice: 4, nightTimeTicketPrice: 10, reducedPrice: nil, transportRoutes: ["Майдан Перемоги - Льогокомбінат", "ДЕПО"], routeTextCodes: ["SEC91", "SEC0"], reducedPriceRouteTextCodes: nil)
    let zhytomyrTrolleybus = TransportModel(transportName: "trolleybus", transportType: "Тролейбус", routeNumbers: ["1A", "1Б", "2", "3", "4", "4А", "6", "7", "7А", "8", "9", "10", "15А", "ДЕПО"], ticketPrice: 4, nightTimeTicketPrice: 10, reducedPrice: nil, transportRoutes: ["Вокзал - Центр - Смолянка - Вокзал (кільцевий)", "Вокзал - Смолянка - Центр - Вокзал (кільцевий)", "Богунія - Вокзал - Смолянка", "Богунія - Смолянка - Вокзал", "Крошня - Залізничний вокзал", "Крошня - майдан Станишівський", "Крошня - ЗОК", "Маликова - Залізничний вокзал", "Маликова - Промислова", "Маликова - майдан Станишівський", "Гідропарк - Космонавтів", "Богунія - Промислова", "Гідропарк - Селецька", "ДЕПО"], routeTextCodes: ["SEB1A", "SEB1B", "SEB2", "SEB3", "SEB4", "SEB4A", "SEB6", "SEB7", "SEB7A", "SEB8", "SEB9", "SEB10", "SEB15A", "SEB0"], reducedPriceRouteTextCodes: nil)
    let zhytomyrAutobus = TransportModel(transportName: "autobus", transportType: "Автобус", routeNumbers: ["3", "4", "ДЕПО"], ticketPrice: 6, nightTimeTicketPrice: nil, reducedPrice: 3, transportRoutes: ["Богунія - Корбутівка", "Крошня(ТЦ \"Ринг\" - Комбінат силікатних виробів)", "ДЕПО"], routeTextCodes: ["SEA3", "SEA4", "SEA0"], reducedPriceRouteTextCodes: ["PEA3", "PEA4", "PEA0"])
//    let ivanoFrankivskTram = TransportModel(transportName: "tram", transportType: "Трамвай", routeNumbers: ["1", "2", "3", "4", "5", "6"], ticketPrice: 4, nightTimeTicketPrice: 4, transportRoutes: ["Залізничний вокзал - Електромережа", "Барське шосе - Вишенька", "Вишенька - Електромережа", "Барське шосе - Залізничний вокзал", "Барське шосе - Електромережа", "Залізничний вокзал - Вишенька"], routeTextCodes: ["SAC1", "SAC2", "SAC3", "SAC4", "SAC5", "SAC6"])
    
    let ivanoFrankivskTrolleybus = TransportModel(transportName: "trolleybus", transportType: "Тролейбус", routeNumbers: ["2", "3", "4", "5", "6", "7", "10"], ticketPrice: 5, nightTimeTicketPrice: nil, reducedPrice: nil, transportRoutes: ["Вокзал - вул. Юності \"Пресмаш\"", "АТ \"Родон\" - Обласна лікарня", "вул. Дністровська - фірма \"Барва\"", "вул. Дністровська - Тролейбусне депо", "Радіозавод - Європейська площа", "м-н \"Каскад\" - Європейська площа", "вул. Симоненка - вул. Юності \"Пресмаш\""], routeTextCodes: ["SHB2", "SHB3", "SHB4", "SHB5", "SHB6", "SHB7", "SHB10"], reducedPriceRouteTextCodes: nil)
    let ivanoFrankivskAutobus = TransportModel(transportName: "autobus", transportType: "Автобус", routeNumbers: ["27", "40", "41", "45", "47", "49", "55"], ticketPrice: 5, nightTimeTicketPrice: nil, reducedPrice: nil, transportRoutes: ["м-н \"Каскад\" - вул. І Пулюя", "м-н \"Каскад\"  - АС-3", "Онкодиспансер - м-н \"Каскад\"", "с. Підлужжя - вул. Набережна", "Вокзал - Братківці", "АС-4 - вул Набережна", "Хоткевича - с.Черніїв", "Хоткевича - с. Хриплин", "с. Крихівці - АС-2", "Вокзал - с. Черніїв"], routeTextCodes: ["SHA27", "SHA40", "SHA41", "SHA45", "SHA47", "SHA49", "SHA55"], reducedPriceRouteTextCodes: nil)
    // Flayout for Transport Type Tile centering
   let transportTypeColumnLayout = FlowLayout()
    let routesViewColumnLayout = FlowLayout()
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkTimeOfDay()
        let ivanoFrankivskCityTransport: [TransportModel] = [ivanoFrankivskTrolleybus, ivanoFrankivskAutobus]
        let zhitomirCityTransport: [TransportModel] = [zhytomyrTram, zhytomyrTrolleybus, zhytomyrAutobus]
        let vinnitsaCityTransport: [TransportModel] = [vinnitsaTram, vinnitsaTrolleybus, vinnitsaAutobus]
        let lvivCityTransport:[TransportModel] = [lvivTram, lvivTrolleybus]
        vinnitsa = City(name: "Вінниця", cityTransport: vinnitsaCityTransport)
        lviv = City(name: "Львів", cityTransport: lvivCityTransport)
        zhytomyr = City(name: "Житомир", cityTransport: zhitomirCityTransport )
        ivanoFrankivsk = City(name: "Івано-Франківськ", cityTransport: ivanoFrankivskCityTransport)
        cities = Array(arrayLiteral: vinnitsa!, lviv!, zhytomyr!, ivanoFrankivsk!)
        paymentView.isHidden = true
        routesView.isHidden = true
        routesCollectionView.isHidden = true
        routesCollectionView.layer.cornerRadius = 5
        informationView.scrollView.layer.cornerRadius = 10
        informationView.scrollView.layer.borderWidth = 1
        informationView.scrollView.layer.borderColor = UIColor.gray.cgColor
        transportTypeView.delegate = self
        paymentView.delegate = self
        cityDropDownView.delegate = self
        transportTypeView.transportTypeCollectionView.dataSource = self
        transportTypeView.transportTypeCollectionView.delegate = self
        routesCollectionView.delegate = self
        routesCollectionView.dataSource = self
        
        loadUserDefaults()
        updateCityDropDown()
        dropDownMenuOfcitysIsHidden = true
        updateDropDownMenuOfCyties()
        updateInformationView()
        updateCollectionView(collectionView: transportTypeView.transportTypeCollectionView) {
            updateCollectionViewLayout(currentCollectionView: transportTypeView.transportTypeCollectionView, layout: transportTypeColumnLayout, collectionViewHeightConstraint: transportTypeView.transportTypeCollectionViewHeight)
            
        }

//        transportTypeView.transportTypeCollectionView.register(TransportTypeCollectionViewCell.self, forCellWithReuseIdentifier: "TransportTypeCell")
        routesView.layer.cornerRadius = 10
        paymentView.layer.cornerRadius = 10
        informationView.layer.cornerRadius = 10
        traitCollectionDidChange(UIScreen.main.traitCollection)
        
        for button in transportTypeView.transportTypeButtons {
            button.layer.cornerRadius = 10
        }

    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        clearButtonsAndStack()
        transportTypeView.unblur()
        
        
        UIView.animate(withDuration: 0.0) { [self] in
            transportTypeView.transportTypeCollectionView.reloadData()
            routesCollectionView.reloadData()
        } completion: { _ in
            UIView.animate(withDuration: 0.0) {
                self.routesCollectionViewHeightConstraint.constant = self.routesCollectionView.collectionViewLayout.collectionViewContentSize.height
                            self.transportTypeView.transportTypeCollectionViewHeight.constant = self.transportTypeView.transportTypeCollectionView.collectionViewLayout.collectionViewContentSize.height
            } completion: { [self] _ in
                if !informationView.isHidden || dropDownMenuOfcitysIsHidden == false {
                    
                    UIView.animate(withDuration: 0.0) {
                        
                    } completion: { _ in
                        self.transportTypeView.blur(2.0)
                    }

                }
                
            }
        }

        

       
        
        if traitCollection.horizontalSizeClass == .compact && traitCollection.verticalSizeClass == .regular {
            widthOfVerticalStack = 3
            if let transport = transport {
            updateRouteStackView(transport: transport, widthOfVerticalStack: widthOfVerticalStack)
                UIView.animate(withDuration: 0.0, animations: {
                }) { (_) in
                    self.transportTypeView.blur(2.0)
                }
            }
        } else {
            print("Its in Album mode!")
            widthOfVerticalStack = 4
            if let transport = transport {
                updateRouteStackView(transport: transport, widthOfVerticalStack: widthOfVerticalStack)
                UIView.animate(withDuration: 0.0, animations: {
                }) { (_) in
                    self.transportTypeView.blur(2.0)
                }
        }
        }
    }
    func updateCollectionViewLayout(currentCollectionView: UICollectionView, layout: UICollectionViewLayout, collectionViewHeightConstraint: NSLayoutConstraint){
        
           currentCollectionView.collectionViewLayout = layout
        
        
       //collectionView.contentInsetAdjustmentBehavior = .always
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
        //cell.layer.bounds.size.height = 120
            transportTypeCell.layer.cornerRadius = 5
            return transportTypeCell
        } else {
        let routeCell = routesCollectionView.dequeueReusableCell(withReuseIdentifier: "RoutesCollectionViewCell", for: indexPath) as! RoutesCollectionViewCell
            routeCell.layer.cornerRadius = 5
            if transport?.routeNumbers[indexPath.row] == "ДЕПО" {
                //routeCell.frame.size.width = 80

             }
            
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
            print("DEvice Screen Size: \(deviceScreen)")
            if traitCollection.verticalSizeClass == .compact {
                print("DeviceScreenHeigth: \(deviceScreen.height)")
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
                } else {
                    //headerView.routesViewTransportTypeTyle.image = nil
                }
            
                return headerView
            }
       }
    
        

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == transportTypeView.transportTypeCollectionView {
        let transportTypeCell = collectionView.cellForItem(at: indexPath) as! TransportTypeCollectionViewCell
        let nameOfSelectedTransport = transportTypeCell.transportTypeLabel.text
        updateRouteView(transportType: nameOfSelectedTransport!)
        } else {
            let routeNumberCell = collectionView.cellForItem(at: indexPath) as! RoutesCollectionViewCell
            let selectedRouteNumber = routeNumberCell.routesCollectionViewCellLabel.text!
            checkTimeOfDay()
            routeButonTapped(routeNumber: selectedRouteNumber)
            
        }
    }
    // ending setup CollectionView for Transport Type Tile
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
//            switch  transportType {
//            case "Тролейбус":
//                //transport = city?.trolleybus
//                mainBackButton.isHidden = false
//                transportTypeView.blur(2.0)
//                cityDropDownView.blur(2.0)
//                updateRouteStackView(transport: transport!, widthOfVerticalStack: widthOfVerticalStack)
//                routesView.isHidden = false
//                //animateRouteViewApper(sender: sender)
//            case "Трамвай":
//                //transport = city?.tram
//                mainBackButton.isHidden = false
//                cityDropDownView.blur(2.0)
//                transportTypeView.blur(2.0)
//                updateRouteStackView(transport: transport!, widthOfVerticalStack: widthOfVerticalStack)
//                routesView.isHidden = false
//                //animateRouteViewApper(sender: sender)
//            case "Автобус":
//                //transport = city?.autobus
//                mainBackButton.isHidden = false
//                transportTypeView.blur(2.0)
//                cityDropDownView.blur(2.0)
//                updateRouteStackView(transport: transport!, widthOfVerticalStack: widthOfVerticalStack)
//                routesView.isHidden = false
//                //animateRouteViewApper(sender: sender)
//            default:
//                break
//            }
        }
        }
    }
    
//    func delegateWithTransportType(sender: UIButton) {
//        updateRouteView(sender: sender)
//    }
    func animateRouteViewApper(sender: UIButton){
        UIView.animate(withDuration: 0.0, animations: {
        }, completion: { _ in
            UIView.animate(withDuration: 0.0, animations: {

                let globalFrameSender = sender.convert(sender.frame, to: self.view)
                self.routesView.transform = CGAffineTransform(scaleX: sender.frame.size.width/self.routesView.frame.size.width, y: sender.frame.size.height/self.routesView.frame.size.height)
                self.routesView.frame.origin.y = globalFrameSender.origin.y
                self.routesView.frame.origin.x = globalFrameSender.origin.x
            }, completion: { _ in
                UIView.animate(withDuration: 0.2, animations: {
                    self.routesView.transform = .identity
                    self.routesView.center = self.view.center
                }, completion: nil)
            })
        }
        )
    }
    // route button tapped
    func routeButonTapped(routeNumber: String) {
        guard let transport = transport else {print("there is no transport"); return}
        paymentView.updateUI(transport: transport, route: routeNumber, nightTime: nightTime!)
        routesCollectionView.isHidden = true
        shadowForView(shadowView: paymentView)

        //routesCollectionView.blur(2.0)
        paymentView.isHidden = false
    }
//    func makePayment(textMsg: String){
//        let sms = textMsg
//        let activityController = UIActivityViewController(activityItems: [sms], applicationActivities: nil)
//        present(activityController, animated: true, completion: nil)
//    }
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
    func updateRouteStackView(transport: TransportModel, widthOfVerticalStack: Int){
        if routesView.vertikalStack.subviews.count == 0 {
            buttonsModel.arrangedButtons(routes: transport.routeNumbers, numberOfHorizontalCells: widthOfVerticalStack)
        routesView.transportName.text = transport.transportType
            for array in buttonsModel.arrayOfButtons {
            // horizontal Array
                    let horizontalStackView = UIStackView(arrangedSubviews: array)
                        routesView.vertikalStack.addArrangedSubview(horizontalStackView)
                        horizontalStackView.axis = NSLayoutConstraint.Axis.horizontal
                        horizontalStackView.alignment = UIStackView.Alignment.center
                horizontalStackView.distribution = UIStackView.Distribution.equalCentering
                        horizontalStackView.spacing = 20
                
            }
        }

    }
    func clearButtonsAndStack(){
        buttonsModel.arrayOfButtons.removeAll()
        for subview in routesView.vertikalStack.arrangedSubviews {
            subview.removeFromSuperview()
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
            print("the URL is not avaolable!")
        }
    }
    
    
    func updateDropDownMenuOfCyties(){
        if dropDownMenuOfcitysIsHidden == false {
            cityDropDownView.cityStackView.removeBackground()
            cityDropDownView.cityStackView.spacing = 10
            hideCytiesDropDownMenu(isHidden: false)
            // add opacity backGround
            cityDropDownView.cityStackView.addBackground(color: UIColor(red: (0/255.0), green: (122/255.0), blue: (255/255.0), alpha: 0.5))
            transportTypeView.blur()
            backButton.isHidden = false
        } else {
            cityDropDownView.cityStackView.removeBackground()
            cityDropDownView.cityStackView.spacing = -33
            hideCytiesDropDownMenu(isHidden: dropDownMenuOfcitysIsHidden)
            // adding nonOpacity background
            cityDropDownView.cityStackView.addBackground(color: UIColor(red: (0/255.0), green: (122/255.0), blue: (255/255.0), alpha: 1))
            transportTypeView.unblur()
            backButton.isHidden = true
        }
    }
    func menuButtonTapped() {
        dropDownMenuOfcitysIsHidden = !dropDownMenuOfcitysIsHidden
        updateDropDownMenuOfCyties()
    }
    func updateCollectionView(collectionView: UICollectionView, completion: () -> Void){
        collectionView.reloadData()
        completion()
    }
    @objc func cityDropDownButtonTapped(sender: UIButton) {
        for city in cities {
            //var city = cities[index]
            let index = cities.firstIndex(of: city)
            if city.name == sender.titleLabel?.text {
                let cityChoosen = cities.remove(at: index!)
                cities.insert(cityChoosen, at: 0)
                //saving city choosing
                self.city = cityChoosen
                
                
                    updateCollectionView(collectionView: transportTypeView.transportTypeCollectionView) {
                        updateCollectionViewLayout(currentCollectionView: transportTypeView.transportTypeCollectionView, layout: transportTypeColumnLayout, collectionViewHeightConstraint: transportTypeView.transportTypeCollectionViewHeight)
                    
                    }

                

                
                    
                
                
                
               
                
                

                
                    
                
                
                let jsonEncoder = JSONEncoder()
                if let data = try? jsonEncoder.encode(cityChoosen) {
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
            self.dropDownMenuOfcitysIsHidden = true
            self.updateDropDownMenuOfCyties()
        }
        
    }
    func loadUserDefaults(){
        informationView.informationCheckMark.isSelected = defaults.object(forKey: "InformationButtoncheckMark") as? Bool ?? false
        if let decodedData = UserDefaults.standard.object(forKey: "CityChoosen") as? Data, let city = try? JSONDecoder().decode(City.self, from: decodedData){
//                    print(decodedData)
//                    print(":)")
            self.city = city
            
            
                } else {city = vinnitsa}
        
            let index = cities.firstIndex(of: city!)
        let savedCity = cities.remove(at: index!)
        cities.insert(savedCity, at: 0)
        
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
    func hideCytiesDropDownMenu(isHidden: Bool){
        for index in 1...(cityDropDownView.cityStackView.subviews.count-1) {
            cityDropDownView.cityStackView.subviews[index].isHidden = isHidden
        }
       // cityDropDownView.cityStackView.addBackground(color: UIColor(red: (0/255.0), green: (122/255.0), blue: (255/255.0), alpha: 1))
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
            print("It is day")
        } else {
            nightTime = true
        print("Is is night")
        }
    }
    func checkTimeOfDay(){
        let currentTime = Calendar.current.dateComponents([.hour, .minute], from: Date())
        if let currentTimeDate = Calendar.current.date(from: currentTime){
            verifyTimeOfDay(currentDate: currentTimeDate)
            print("\(nightTime)")
        } else {
            print("There is no data")
            nightTime = false
        }
    }
    


}

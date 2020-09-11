//
//  TransportModel.swift
//  TransportFare
//
//  Created by TheMacUser on 09.07.2020.
//  Copyright © 2020 TheMacUser. All rights reserved.
//

import Foundation
struct City: Codable, Equatable {
    static func == (lhs: City, rhs: City) -> Bool {
        return lhs.name == rhs.name
    }
    
    
    let name: String
    let tram: TransportModel?
    let trolleybus: TransportModel?
    let autobus: TransportModel?
}
struct TransportModel: Codable {
    let transportType: String
    let routeNumbers: [String]
    let ticketPrice: Int
    let transportRoutes: [String]
    let routeTextCodes: [String]
    var routeInfo: [String : String] {
        var computedDictionary: [String : String] = [:]
        for (index, element) in routeNumbers.enumerated() { computedDictionary[element] = transportRoutes[index] }
        return computedDictionary }
    var routeFareCode: [String : String] {
        var computedDictionary: [String : String] = [:]
        for (index, element) in routeNumbers.enumerated() {
            computedDictionary[element] = routeTextCodes[index] }
        return computedDictionary}
    
}

//
//  SaveData.swift
//  TransportFare
//
//  Created by TheMacUser on 13.08.2020.
//  Copyright © 2020 TheMacUser. All rights reserved.
//

import Foundation
struct SaveData: Codable {
    static var informationButtonState: Bool?
    static var documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    static let archiveURL = documentsDirectory.appendingPathComponent("information_message").appendingPathExtension("plist")
    static func saveData(){
        print()
        let propertyListEncoder = PropertyListEncoder()
        if let codedInformationButtonState = try? propertyListEncoder.encode(SaveData.informationButtonState){
            try? codedInformationButtonState.write(to: archiveURL, options: .noFileProtection)
            print(codedInformationButtonState)
        }
        
        
    }
    static func loadData() -> Bool? {
        guard let codedInformationButtonState = try? Data(contentsOf: archiveURL) else {return nil}
        print(codedInformationButtonState)
        let propertyListDecoder = PropertyListDecoder()
        return try? propertyListDecoder.decode(Bool.self, from: codedInformationButtonState)
    }
}

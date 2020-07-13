//
//  Settings.swift
//  TipR
//
//  Created by Taran Nulu on 6/12/20.
//  Copyright © 2020 Taran Nulu. All rights reserved.
//

import Foundation
import XMLParsing

let myCurrencyKey = "myCurrency"
let isConversionEnabledKey = "isConversionEnabled"
let foreignCurrencyKey = "foreignCurrency"
let isMyCurrencyFirstKey = "isMyCurrencyFirst"
let ratioKey = "ratio"

let usaIndex = 243

class Settings: ObservableObject {
    init() {
        if let data = UserDefaults.standard.object(forKey: myCurrencyKey) as? Data {
            self.myCurrency = (try? JSONDecoder().decode(Currency.self, from: data)) ?? Settings.currencies.table[usaIndex]
        } else {
            self.myCurrency = Settings.currencies.table[usaIndex]
        }

        self.isConversionEnabled = UserDefaults.standard.object(forKey: isConversionEnabledKey) as? Bool ?? false

        if let data = UserDefaults.standard.object(forKey: foreignCurrencyKey) as? Data {
            self.foreignCurrency = (try? JSONDecoder().decode(Currency.self, from: data)) ?? Settings.currencies.table.first!
        } else {
            self.foreignCurrency = Settings.currencies.table.first!
        }

        self.isMyCurrencyFirst = UserDefaults.standard.object(forKey: isMyCurrencyFirstKey) as? Bool ?? true
        self.ratio = UserDefaults.standard.object(forKey: ratioKey) as? String ?? ""
    }
    
    @Published var myCurrency: Currency {
        didSet {
            if let encoded = try? JSONEncoder().encode(myCurrency) {
                UserDefaults.standard.set(encoded, forKey: myCurrencyKey)
            }
        }
    }
    
    @Published var isConversionEnabled: Bool {
        didSet {
            UserDefaults.standard.set(isConversionEnabled, forKey: isConversionEnabledKey)
        }
    }
    
    @Published var foreignCurrency: Currency {
        didSet {
            if let encoded = try? JSONEncoder().encode(foreignCurrency) {
                UserDefaults.standard.set(encoded, forKey: foreignCurrencyKey)
            }
        }
    }
    
    @Published var isMyCurrencyFirst: Bool {
        didSet {
            UserDefaults.standard.set(isMyCurrencyFirst, forKey: isMyCurrencyFirstKey)
        }
    }
    
    @Published var ratio: String {
        didSet {
            UserDefaults.standard.set(ratio, forKey: ratioKey)
        }
    }
    
    static let currencies = getCurrencyTableFromFile()
    
    static func getCurrencyTableFromFile() -> CurrencyTable {
        if let fileURL = Bundle.main.url(forResource: "iso-currency", withExtension: "xml") {
            if let fileContents = try? String(contentsOf: fileURL) {
                if let fileData = fileContents.data(using: .utf8) {
                    let decoder = XMLDecoder()
                    if let currencyTable = try? decoder.decode(CurrencyTable.self, from: fileData) {
                        return currencyTable
                    }
                }
            }
        }
        return CurrencyTable(table: [])
    }
}

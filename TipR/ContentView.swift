//
//  ContentView.swift
//  TipR
//
//  Created by Taran Nulu on 9/3/19.
//  Copyright © 2019 Taran Nulu. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var settings = Settings()
    
    @State private var subTotal = ""
    @State private var tax = ""
    @State private var numberOfPeopleIndex = 0
    @State private var tipPercentage = 15
    
    @State private var showSettings = false
    //    @ObservedObject var settings = Settings
    
    var localCurrency: Currency {
        settings.isConversionEnabled ? settings.foreignCurrency : settings.myCurrency
    }
    
    var currencyExchangeRatio: Double {
        let settingsRatioAmount = Double(settings.ratio) ?? 1.0
        if settings.isMyCurrencyFirst {
            return 1/settingsRatioAmount
        } else {
            return settingsRatioAmount
        }
    }
    
    var myCurrencySubtotal: Double {
        let subtotalAmount = Double(subTotal) ?? 0
        return subtotalAmount * currencyExchangeRatio
    }
    
    var myCurrencyTax: Double {
        let taxAmount = Double(tax) ?? 0
        return taxAmount * currencyExchangeRatio
    }
    
    var tipAmount: Double {
        let tipSelection = Double(tipPercentage)
        let subtotalAmount = Double(subTotal) ?? 0
        
        let tipValue = subtotalAmount / 100 * tipSelection
        
        return tipValue
    }
    
    var myCurrencyTipAmount: Double {
        return tipAmount * currencyExchangeRatio
    }
    
    var grandTotal: Double {
        let subtotalAmount = Double(subTotal) ?? 0
        let taxAmount = Double(tax) ?? 0
        
        let grandTotal = subtotalAmount + taxAmount + tipAmount
        
        return grandTotal
    }
    
    var myCurrencyGrandTotal: Double {
        return grandTotal * currencyExchangeRatio
    }
    
    var totalPerPerson: Double {
        let peopelCount = Double(numberOfPeopleIndex + 1)
        
        let amountPerPerson = grandTotal / peopelCount
        
        return amountPerPerson
    }
    
    var myCurrencyTotalPerPerson: Double {
        return totalPerPerson * currencyExchangeRatio
    }
    
    var inputSection: some View {
        Section {
            HStack {
                TextField("Subtotal", text: $subTotal)
                    .keyboardType(.decimalPad)
                Text(localCurrency.code)
            }
            if settings.isConversionEnabled {
                HStack {
                    Text("\(myCurrencySubtotal, specifier: "%.2f")")
                    Text(settings.myCurrency.code)
                }
            }
            HStack {
                TextField("Tax", text: $tax)
                    .keyboardType(.decimalPad)
                Text(localCurrency.code)
            }
            if settings.isConversionEnabled {
                HStack {
                    Text("\(myCurrencyTax, specifier: "%.2f")")
                    Text(settings.myCurrency.code)
                }
            }
        }
    }
    
    var tipSection: some View {
        Section {
            Picker("Tip %", selection: $tipPercentage) {
                ForEach(0..<101) {
                    Text("\($0)%")
                }
            }
            HStack {
                Text("Tips: \(tipAmount, specifier: "%.2f")")
                Text(localCurrency.code)
            }
            HStack {
                Text("\(myCurrencyTipAmount, specifier: "%.2f")")
                Text(settings.myCurrency.code)
            }
        }
    }
    
    var totalSection: some View {
        Section {
            HStack {
                Text("Grand total: \(grandTotal, specifier: "%.2f")")
                Text(localCurrency.code)
            }
            HStack {
                Text("\(myCurrencyGrandTotal, specifier: "%.2f")")
                Text(settings.myCurrency.code)
            }
        }
    }
    
    var peopleSection: some View {
        Section {
            Picker("Number of People", selection: $numberOfPeopleIndex) {
                ForEach(1..<100) {
                    Text("\($0) people")
                }
            }
            HStack {
                Text("Total per person: \(totalPerPerson, specifier: "%.2f")")
                Text(localCurrency.code)
            }
            HStack {
                Text("\(myCurrencyTotalPerPerson, specifier: "%.2f")")
                Text(settings.myCurrency.code)
            }
            
        }
    }
    
    var body: some View {
        NavigationView {
            Form {
                inputSection
                tipSection
                totalSection
                peopleSection
            }
            .navigationBarTitle("Tip₹")
            .navigationBarItems(
                trailing: Button(
                    action: { self.showSettings = true }
                ) {
                    Image(systemName: "ellipsis.circle.fill")
                        .imageScale(.large)
                }
            )
                .sheet(isPresented: $showSettings) {
                    SettingsView(show: self.$showSettings, settings: self.settings)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


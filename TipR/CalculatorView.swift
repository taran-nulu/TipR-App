//
//  CalculatorView.swift
//  TipR
//
//  Created by Taran Nulu on 8/14/20.
//  Copyright © 2020 Taran Nulu. All rights reserved.
//

import SwiftUI

struct CalculatorView: View {
    @ObservedObject var settings: Settings
    
    @State private var subTotal = ""
    @State private var tax = ""
    @State private var numberOfPeopleIndex = 0
    @State private var tipPercentage = 15
    
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
                Image(systemName: "circle.fill")
                    .imageScale(.small).foregroundColor(.red)
                TextField("Subtotal", text: $subTotal, onEditingChanged: { (editing) in
                    if editing {
                        print("editing")
                    } else {
                        print("### editing ended")
                    }
                })
                    .keyboardType(.decimalPad)
                Text(localCurrency.code)
            }
            if settings.isConversionEnabled {
                HStack {
                    Image(systemName: "circle.fill")
                        .imageScale(.small).foregroundColor(.clear)
                    Text("\(myCurrencySubtotal, specifier: "%.2f")")
                    Text(settings.myCurrency.code)
                }
            }
            HStack {
                Image(systemName: "circle.fill")
                    .imageScale(.small).foregroundColor(.red)
                TextField("Tax", text: $tax)
                    .keyboardType(.decimalPad)
                Text(localCurrency.code)
            }
            if settings.isConversionEnabled {
                HStack {
                    Image(systemName: "circle.fill")
                        .imageScale(.small).foregroundColor(.clear)
                    Text("\(myCurrencyTax, specifier: "%.2f")")
                    Text(settings.myCurrency.code)
                }
            }
        }
    }
    
    var tipSection: some View {
        Section {
            HStack {
                Image(systemName: "circle.fill")
                    .imageScale(.small).foregroundColor(.green)
                Picker("Tip %", selection: $tipPercentage) {
                    ForEach(0..<101) {
                        Text("\($0)%")
                    }
                }
            }
            HStack {
                Image(systemName: "circle.fill")
                    .imageScale(.small).foregroundColor(.green)
                Text("Tips: \(tipAmount, specifier: "%.2f")")
                Text(localCurrency.code)
            }
            if settings.isConversionEnabled {
                HStack {
                    Image(systemName: "circle.fill")
                        .imageScale(.small).foregroundColor(.clear)
                    Text("\(myCurrencyTipAmount, specifier: "%.2f")")
                    Text(settings.myCurrency.code)
                }
            }
        }
    }
    
    var totalSection: some View {
        Section {
            HStack {
                Image(systemName: "circle.fill")
                    .imageScale(.small).foregroundColor(.purple)
                Text("Grand total: \(grandTotal, specifier: "%.2f")")
                Text(localCurrency.code)
            }
            if settings.isConversionEnabled {
                HStack {
                    Image(systemName: "circle.fill")
                        .imageScale(.small).foregroundColor(.clear)
                    Text("\(myCurrencyGrandTotal, specifier: "%.2f")")
                    Text(settings.myCurrency.code)
                }
            }
        }
    }
    
    var peopleSection: some View {
        Section {
            HStack {
                Image(systemName: "circle.fill")
                    .imageScale(.small).foregroundColor(.yellow)
                Picker("Number of People", selection: $numberOfPeopleIndex) {
                    ForEach(1..<100) {
                        Text("\($0) people")
                    }
                }
            }
            HStack {
                Image(systemName: "circle.fill")
                    .imageScale(.small).foregroundColor(.yellow)
                Text("Total per person: \(totalPerPerson, specifier: "%.2f")")
                Text(localCurrency.code)
            }
            if settings.isConversionEnabled {
                HStack {
                    Image(systemName: "circle.fill")
                        .imageScale(.small).foregroundColor(.clear)
                    Text("\(myCurrencyTotalPerPerson, specifier: "%.2f")")
                    Text(settings.myCurrency.code)
                }
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
            .navigationBarTitle(settings.isConversionEnabled ? "Tip₹" : "TipR")
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct CalculatorView_Previews: PreviewProvider {
    @ObservedObject static var settings = Settings()
    
    static var previews: some View {
        CalculatorView(settings: settings)
    }
}

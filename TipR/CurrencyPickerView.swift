//
//  CurrencyPickerView.swift
//  TipR
//
//  Created by Taran Nulu on 6/6/20.
//  Copyright © 2020 Taran Nulu. All rights reserved.
//

import SwiftUI

struct CurrencyPickerView: View {
    @Binding var currency: Currency
    
    var body: some View {
        Picker("", selection: $currency) {
            ForEach(Settings.currencies.table) { currency in
                HStack {
                    VStack(alignment: .leading) {
                        Text(currency.country.capitalized).font(.headline)
                        Text(currency.name)
                    }
                    Spacer()
                    Text(currency.code).font(.callout)
                }.tag(currency)
            }
        }
    }
}

struct CurrencyPickerView_Previews: PreviewProvider {
    @State static var currency: Currency = Settings.currencies.table.first!
    
    static var previews: some View {
        CurrencyPickerView(currency: $currency)
    }
}

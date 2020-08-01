//
//  Settings.swift
//  TipR
//
//  Created by Taran Nulu on 5/3/20.
//  Copyright © 2020 Taran Nulu. All rights reserved.
//

import SwiftUI

struct CurrencyTable: Codable {
    let table: [Currency]
    
    enum CodingKeys: String, CodingKey {
        case table = "CcyNtry"
    }
}

struct Currency: Codable, Hashable, Identifiable {
    var id: String { country }
    
    let code: String
    let name: String
    let country: String
    
    enum CodingKeys: String, CodingKey {
        case code = "Ccy"
        case name = "CcyNm"
        case country = "CtryNm"
    }
}

struct SettingsView: View {
    @Binding var show: Bool
    @ObservedObject var settings: Settings
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("My Currency").font(.subheadline)) {
                    HStack {
                        Image(systemName: "square.fill")
                            .imageScale(.small).foregroundColor(.red)
                        CurrencyPickerView(currency: $settings.myCurrency)
                    }
                }
                Section(header: Text("Foreign Currency").font(.subheadline)) {
                    HStack {
                        Image(systemName: "square.fill")
                            .imageScale(.small).foregroundColor(.green)
                        Toggle(isOn: $settings.isConversionEnabled) {
                            Text("Enable")
                        }
                    }
                    HStack {
                        Image(systemName: "square.fill")
                            .imageScale(.small).foregroundColor(.green)
                        CurrencyPickerView(currency: $settings.foreignCurrency)
                            .disabled(!settings.isConversionEnabled)
                    }
                }
                Section(header: Text("Conversion").font(.subheadline)) {
                    HStack {
                        Image(systemName: "square.fill")
                            .imageScale(.small).foregroundColor(.purple)
                        Text("1")                    .foregroundColor(settings.isConversionEnabled ? Color.primary : Color.gray)
                        Text(settings.isMyCurrencyFirst ? settings.myCurrency.code : settings.foreignCurrency.code)                    .foregroundColor(settings.isConversionEnabled ? Color.primary : Color.gray)
                        Button(action: {
                            self.settings.isMyCurrencyFirst.toggle()
                        }) {
                            Image(systemName: "arrow.right.arrow.left.circle.fill")
                                .imageScale(.large)
                        }
                        TextField("Decimal Ratio", text: $settings.ratio)
                            .keyboardType(.decimalPad) .foregroundColor(settings.isConversionEnabled ? Color.primary : Color.gray)
                        Text(settings.isMyCurrencyFirst ? settings.foreignCurrency.code : settings.myCurrency.code)                    .foregroundColor(settings.isConversionEnabled ? Color.primary : Color.gray)
                    }
                }.disabled(!settings.isConversionEnabled)
            }
            .navigationBarTitle("Settings")
            .navigationBarItems(
                trailing: Button(
                    action: {self.show = false}
                ) {
                    Image(systemName: "xmark.circle.fill")
                        .imageScale(.large)
                }
            )
        }
    }
}

struct Settings_Previews: PreviewProvider {
    @State static var showSettings = true
    @ObservedObject static var settings = Settings()
    
    static var previews: some View {
        SettingsView(show: $showSettings, settings: settings)
    }
}

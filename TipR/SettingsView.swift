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
                    CurrencyPickerView(currency: $settings.myCurrency)
                }
                Section(header: Text("Foreign Currency").font(.subheadline)) {
                    Toggle(isOn: $settings.isConversionEnabled) {
                        Text("Enable")
                        
                    }
                    CurrencyPickerView(currency: $settings.foreignCurrency)
                        .disabled(!settings.isConversionEnabled)
                }
                Section(header: Text("Conversion").font(.subheadline)) {
                    HStack {
                        Text("1")                    .foregroundColor(settings.isConversionEnabled ? Color.black : Color.gray)
                        Text(settings.isMyCurrencyFirst ? settings.myCurrency.code : settings.foreignCurrency.code)                    .foregroundColor(settings.isConversionEnabled ? Color.black : Color.gray)
                        Button(action: {
                            self.settings.isMyCurrencyFirst.toggle()
                        }) {
                            Image(systemName: "arrow.right.arrow.left.circle.fill")
                                .imageScale(.medium)
                        }
                        TextField("Decimal Ratio", text: $settings.ratio)
                            .keyboardType(.decimalPad)
                        Text(settings.isMyCurrencyFirst ? settings.foreignCurrency.code : settings.myCurrency.code)                    .foregroundColor(settings.isConversionEnabled ? Color.black : Color.gray)
                    }
                }
                    // TODO: Change disabled color to same gray as foreign currency picker.
                    .disabled(!settings.isConversionEnabled)
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

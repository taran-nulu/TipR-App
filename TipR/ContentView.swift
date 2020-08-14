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
    @ObservedObject var keyboardResponder = KeyboardResponder()
    @State private var showSettings = false

    var body: some View {
        NavigationView {
            CalculatorView(settings: settings)
            .navigationBarTitle(settings.isConversionEnabled ? "Tip₹" : "TipR")
            .navigationBarItems(
                trailing: Button(
                    action: { self.showSettings = true }
                ) {
                    Text("Settings")
                }
            )
                .sheet(isPresented: $showSettings) {
                    SettingsView(show: self.$showSettings, settings: self.settings, keyboardResponder: self.keyboardResponder)
            }
        }.navigationViewStyle(StackNavigationViewStyle())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


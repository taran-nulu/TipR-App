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
    @State private var showSettings = true
    
    var body: some View {
        TabView {
            CalculatorView(settings: settings)
                .tabItem {
                    Image(systemName: "percent")
                    Text("Calculator")
            }
            SettingsView(show: self.$showSettings, settings: self.settings, keyboardResponder: self.keyboardResponder)
                .tabItem {
                    Image(systemName: "gear")
                    Text("Settings")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

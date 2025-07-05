//
//  FooterBar.swift
//  HealthSharing
//
//  Created by Margi Shah on 2025-06-29.
//

import Foundation
import SwiftUI

struct FooterBar: View {
    var body: some View {
        HStack {
            Spacer()
            Button(action:{
                //Home action
            }){
                VStack{
                    Image(systemName: "house")
                    Text("Home")
                }
            }
            Spacer()
            Button(action:{
                //Home action
            }){
                VStack{
                    Image(systemName: "person.2.fill")
                    Text("Friends")
                }
            }
            Spacer()
            Button(action:{
                //Home action
            }){
                VStack{
                    Image(systemName: "message.badge.filled.fill")
                    Text("Messages")
                }
            }
            Spacer()
            Button(action:{
                SettingsView()
            }){
                VStack{
                    Image(systemName: "gearshape.fill")
                    Text("Settings")
                }
            }
            Spacer()
            
        }
        .padding(.vertical, 10)
        .background(Color.blue)
        .foregroundColor(.white)
        .cornerRadius(15)
        .shadow(radius: 5)
    }
}
#Preview{
    FooterBar()
}

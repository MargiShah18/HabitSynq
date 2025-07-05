//
//  MainTabView.swift
//  HealthSharing
//
//  Created by Margi Shah on 2025-07-04.
//

import Foundation
import SwiftUI

struct MainTabView  : View {
    var body: some View {
        TabView{
            NavigationStack{
                LoggedInHomeView()
            }
            .tabItem{
                Image(systemName: "house")
                Text("Home")
            }
            NavigationStack{
                //FriendsView
            }
            .tabItem {
                Image(systemName:"person.2.fill")
                Text("Friends")
            }
            NavigationStack{
                //MessageView
            }
            .tabItem {
                Image(systemName: "message.fill")
                Text("Messages")
            }
            NavigationStack{
                SettingsView()
            }
            .tabItem{
                Image(systemName: "gearshape.fill")
                Text("Settings")
            }
        }
    }
}

//
//  FriendsView.swift
//  HealthSharing
//
//  Created by Margi Shah on 2025-07-20.
//

import Foundation
import SwiftUI

struct FriendsView: View {
    @State private var showAddFriend = false
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            ZStack {
                Text("Friends")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                HStack {
                    Spacer()
                    Button(action: { showAddFriend = true }) {
                        Image(systemName: "person.badge.plus")
                            .foregroundColor(.white)
                            .imageScale(.large)
                    }
                }
            }
            .padding()
            .background(Color.blue)
            
            Spacer()
            
            Text("Add friends to share activity")
                .font(.subheadline)
                .foregroundColor(.gray)
            
            Spacer()
        }
        .sheet(isPresented: $showAddFriend) {
            AddFriendSheet()
        }
        .background(Color(.systemGroupedBackground))
        .ignoresSafeArea(.container, edges: .bottom)
    }
}


#Preview {
    FriendsView()
}

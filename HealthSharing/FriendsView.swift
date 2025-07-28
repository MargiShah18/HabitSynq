//
//  FriendsView.swift
//  HealthSharing
//
//  Created by Margi Shah on 2025-07-20.
//

import Foundation
import SwiftUI
import Firebase
import FirebaseAuth

struct FriendsView: View {
    @State private var showAddFriend = false
    @Environment(\.dismiss) private var dismiss
    var showBackButton: Bool = false
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            ZStack {
                Text("Friends")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                HStack {
                    if showBackButton {
                        Button(action: { dismiss() }) {
                            Image(systemName: "chevron.left")
                                .foregroundColor(.white)
                                .font(.title2)
                        }
                    } else {
                        // Empty space to maintain layout balance
                        Spacer()
                            .frame(width: 44) // Standard button width
                    }
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
            AddFriendSheet(userId: Auth.auth().currentUser?.uid ?? "UNKNOWN")
        }
        .background(Color(.systemGroupedBackground))
        .ignoresSafeArea(.container, edges: .bottom)
    }
}


#Preview {
    FriendsView()
}

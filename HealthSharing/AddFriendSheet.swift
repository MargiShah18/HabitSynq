//
//  AddFriendSheet.swift
//  HealthSharing
//
//  Created by Margi Shah on 2025-07-20.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth


struct AddFriendSheet: View {
    @Environment(\.dismiss) private var dismiss
    @State private var showQRCodeScanner = false
    @State private var showShareSheet = false
    @State private var inviteLink: String = "https://yourapp.com/invite?user=YOUR_USER_ID"

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                Text("Add a Friend")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.top)
                
                // QR Code
                Button {
                    showQRCodeScanner = true
                } label: {
                    HStack {
                        Image(systemName: "qrcode.viewfinder")
                        Text("Scan Friend's QR Code")
                    }
                }
                .buttonStyle(.bordered)
                .sheet(isPresented: $showQRCodeScanner) {
                    Text("QR Code Scanner Coming Soon")
                        .font(.title3)
                        .padding()
                }
                Divider()
                
                // Invite Link
                Button {
                    showShareSheet = true
                } label: {
                    HStack {
                        Image(systemName: "link")
                        Text("Share Invite Link")
                    }
                }
                .buttonStyle(.bordered)
                .sheet(isPresented: $showShareSheet) {
                    ActivityView(activityItems: [inviteLink])
                }
                
                Spacer()
                Button("Close") {
                    dismiss()
                }
                .padding(.bottom)
            }
            .padding()
        }
    }
}


struct ActivityView: UIViewControllerRepresentable {
    let activityItems: [Any]
    let applicationActivities: [UIActivity]? = nil

    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: activityItems, applicationActivities: applicationActivities)
    }
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

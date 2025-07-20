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
    @State private var inviteLink: String
    @State private var showMyQRCode = false

    init(userId: String) {
        self._inviteLink = State(initialValue: "https://yourapp.com/invite?user=\(userId)")
    }

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 28) {
                // Title & Subtitle
                VStack(alignment: .leading, spacing: 4) {
                    Text("Add a Friend")
                        .font(.largeTitle).bold()
                        .padding(.top, 12)
                    Text("Add a Friend to connect via HabitSync")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.horizontal, 6)

                // Options Card
                VStack(spacing: 0) {
                    // Scan Friend's QR
                    Button(action: { showQRCodeScanner = true }) {
                        HStack(spacing: 16) {
                            ZStack {
                                Circle()
                                    .fill(Color.blue.opacity(0.1))
                                    .frame(width: 36, height: 36)
                                Image(systemName: "qrcode.viewfinder")
                                    .foregroundColor(.blue)
                                    .font(.system(size: 20, weight: .medium))
                            }
                            VStack(alignment: .leading) {
                                Text("Scan Friend's QR Code")
                                    .font(.body).foregroundColor(.primary)
                                Text("Instantly add by scanning their code")
                                    .font(.caption).foregroundColor(.secondary)
                            }
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(.gray)
                        }
                        .padding(.vertical, 12)
                        .padding(.horizontal, 6)
                    }
                    .background(Color(.systemBackground))
                    .sheet(isPresented: $showQRCodeScanner) {
                        QRCodeScannerSheet()
                    }
                    
                    Divider().padding(.leading, 56)

                    // Show My QR Code (Popover)
                    Button(action: { showMyQRCode = true }) {
                        HStack(spacing: 16) {
                            ZStack {
                                Circle()
                                    .fill(Color.green.opacity(0.1))
                                    .frame(width: 36, height: 36)
                                Image(systemName: "qrcode")
                                    .foregroundColor(.green)
                                    .font(.system(size: 20, weight: .medium))
                            }
                            VStack(alignment: .leading) {
                                Text("Show My QR Code")
                                    .font(.body).foregroundColor(.primary)
                                Text("Let friends scan to add you")
                                    .font(.caption).foregroundColor(.secondary)
                            }
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(.gray)
                        }
                        .padding(.vertical, 12)
                        .padding(.horizontal, 6)
                    }
                    .popover(isPresented: $showMyQRCode) {
                        VStack(spacing: 16) {
                            Text("Scan to Add Me!").font(.headline)
                            QRCodeView(dataString: inviteLink)
                                .frame(width: 200, height: 200)
                                .shadow(radius: 8)
                            Text(Auth.auth().currentUser?.email ?? "Unknown Email")
                                .font(.footnote)
                                .foregroundColor(.secondary)
                        }
                        .padding(28)
                        .background(.thinMaterial)
                        .cornerRadius(20)
                        .frame(width: 260)
                        .padding()
                    }
                }
                .background(
                    RoundedRectangle(cornerRadius: 18)
                        .fill(Color(.systemGray6))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 18)
                        .stroke(Color(.systemGray4), lineWidth: 0.5)
                )
                .padding(.horizontal, 2)

                // Share Invite Link Card
                Button(action: { showShareSheet = true }) {
                    HStack(spacing: 16) {
                        ZStack {
                            Circle()
                                .fill(Color.purple.opacity(0.1))
                                .frame(width: 36, height: 36)
                            Image(systemName: "link")
                                .foregroundColor(.purple)
                                .font(.system(size: 20, weight: .medium))
                        }
                        VStack(alignment: .leading) {
                            Text("Share Invite Link")
                                .font(.body).foregroundColor(.primary)
                            Text("Send your invite to friends")
                                .font(.caption).foregroundColor(.secondary)
                        }
                        Spacer()
                    }
                    .padding(.vertical, 12)
                    .padding(.horizontal, 6)
                }
                .background(
                    RoundedRectangle(cornerRadius: 18)
                        .fill(Color(.systemGray6))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 18)
                        .stroke(Color(.systemGray4), lineWidth: 0.5)
                )
                .padding(.horizontal, 2)
                .sheet(isPresented: $showShareSheet) {
                    ActivityView(activityItems: [inviteLink])
                }

                Spacer()
                // Close Button
                Button(action: { dismiss() }) {
                    Text("Close")
                        .font(.body).bold()
                        .frame(maxWidth: .infinity)
                        .padding()
                        .foregroundColor(.blue)
                }
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color(.systemGray5))
                )
                .padding(.vertical, 10)
                .padding(.horizontal, 30)
            }
            .padding(.horizontal, 8)
            .padding(.top, 10)
            .background(Color(.systemBackground).ignoresSafeArea())
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


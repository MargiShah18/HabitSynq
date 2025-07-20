//
//  QRCodeScannerSheet.swift
//  HealthSharing
//
//  Created by Margi Shah on 2025-07-20.
//

import Foundation
import SwiftUI
struct QRCodeScannerSheet: View {
    var body: some View {
        VStack(spacing: 20) {
            Text("QR Code Scanner")
                .font(.title2)
                .fontWeight(.semibold)
            Image(systemName: "qrcode.viewfinder")
                .resizable()
                .scaledToFit()
                .frame(width: 120, height: 120)
                .foregroundColor(.gray)
            Text("Coming soon! Point your camera at your friend's QR code to add them quickly.")
                .font(.body)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
        }
        .padding()
    }
}


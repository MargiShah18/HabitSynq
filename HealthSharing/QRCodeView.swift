//
//  QRCodeView.swift
//  HealthSharing
//
//  Created by Margi Shah on 2025-07-07.
//

import Foundation
import SwiftUI
import CoreImage.CIFilterBuiltins

struct QRCodeView: View {
    var dataString: String
    
    var body: some View {
        if let uiImage = generateQRCode(from: dataString){
            Image(uiImage: uiImage)
                .interpolation(.none)
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200)
        }else{
            Text("Failed to generate QR")
        }
    }
    
    func generateQRCode(from string: String) -> UIImage? {
        let context = CIContext()
        let filter = CIFilter.qrCodeGenerator()
        let data = Data(string.utf8)
        filter.setValue(data, forKey: "inputMessage")
        
        if let outputImage = filter.outputImage,
           let cgimg = context.createCGImage(outputImage.transformed(by: CGAffineTransform(scaleX:10, y:10)), from: outputImage.extent) {
            return UIImage(cgImage: cgimg)
        }
        return nil
    }
}

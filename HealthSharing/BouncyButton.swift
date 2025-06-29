//
//  BouncyButton.swift
//  HealthSharing
//
//  Created by Margi Shah on 2025-06-27.
//

import Foundation
import SwiftUI

struct BouncyButton: View{
    @State private var isPressed = false
    @State private var isHovered = false
    
    var title: String
    var action: () -> Void
    
    var body: some View {
        Button(action: {
            withAnimation(.spring(response: 0.2, dampingFraction: 0.5)){
                isPressed = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                withAnimation(.spring(response: 0.2, dampingFraction: 0.7)){
                    isPressed = false
                }
                action()
     }
        }
               
        ){
            Text(title)
                .padding(.horizontal,20)
                .padding(.vertical,8)
                .background(
                    isHovered ? Color.blue : Color.white.opacity(0.8))
                .foregroundColor(isHovered ? .white : .blue)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.white, lineWidth: 1)
                        )
                        .scaleEffect(isPressed ? 0.9 : (isHovered ? 1.04 : 1.0))
                        .animation(.spring(response: 0.22, dampingFraction: 0.6),value: isHovered)
        }
        .buttonStyle(PlainButtonStyle())
        .onHover{ hovering in
            withAnimation(.easeInOut(duration: 0.17)){
                isHovered = hovering
                
            }
        }
    }
}

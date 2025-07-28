import SwiftUI

struct OverlayMenu: View {
    var onSuccess: () -> Void
    var onFailure: () -> Void
    var onReset: () -> Void

    var body: some View {
        HStack(spacing: 8) {
            // Success Button
            Button(action: onSuccess) {
                VStack(spacing: 4) {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(.white)
                }
                .frame(width: 40, height: 40)
                .background(
                    Circle()
                        .fill(Color.green)
                        .shadow(color: .green.opacity(0.3), radius: 4, x: 0, y: 2)
                )
            }
            .buttonStyle(PlainButtonStyle())
            
            // Failure Button
            Button(action: onFailure) {
                VStack(spacing: 4) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(.white)
                }
                .frame(width: 40, height: 40)
                .background(
                    Circle()
                        .fill(Color.red)
                        .shadow(color: .red.opacity(0.3), radius: 4, x: 0, y: 2)
                )
            }
            .buttonStyle(PlainButtonStyle())
            
            // Reset Button
            Button(action: onReset) {
                VStack(spacing: 4) {
                    Image(systemName: "arrow.counterclockwise.circle.fill")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(.white)
                }
                .frame(width: 40, height: 40)
                .background(
                    Circle()
                        .fill(Color.gray)
                        .shadow(color: .gray.opacity(0.3), radius: 4, x: 0, y: 2)
                )
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.15), radius: 12, x: 0, y: 4)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.gray.opacity(0.1), lineWidth: 1)
                )
        )
        .scaleEffect(1.0)
        .transition(.asymmetric(
            insertion: .scale(scale: 0.8).combined(with: .opacity),
            removal: .scale(scale: 0.9).combined(with: .opacity)
        ))
    }
}

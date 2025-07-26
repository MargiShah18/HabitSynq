import SwiftUI

struct OverlayMenu: View {
    var onSuccess: () -> Void
    var onFailure: () -> Void
    var onReset: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            Button(action: onSuccess) {
                Image(systemName: "checkmark")
                    .foregroundColor(.black)
                    .frame(width: 24, height: 24)
                    .padding()
                    .background(Circle().fill(Color.green))
            }
            Button(action: onFailure) {
                Image(systemName: "xmark")
                    .foregroundColor(.black)
                    .frame(width: 24, height: 24)
                    .padding()
                    .background(Circle().fill(Color.red))
            }
            Button(action: onReset) {
                Image(systemName: "minus")
                    .foregroundColor(.black)
                    .frame(width: 24, height: 24)
                    .padding()
                    .background(Circle().fill(Color.gray))
            }
        }
        .padding(6)
        .background(
            RoundedRectangle(cornerRadius: 16).fill(Color.white).shadow(radius: 6)
        )
        .offset(y: -60)
        .transition(.scale)
    }
}

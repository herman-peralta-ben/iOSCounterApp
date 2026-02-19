import SwiftUI

struct CounterButton: View {
    let icon: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            // 💡 Download Apple SF Symbols App to preview icons
            Image(systemName: icon)
            // 💡 Methods like .font() or .padding() don't modify the existing view; they wrap it in a new one (Decoration Pattern).
                .font(.system(size: 25, weight: .bold))
                .foregroundColor(.white)
            // 💡 Size, like wrapping in  Flutter's SizedBox
                .frame(width: 70, height: 70)
                .background(color)
                .clipShape(Circle())
                .shadow(radius: 5)
        }
    }
}

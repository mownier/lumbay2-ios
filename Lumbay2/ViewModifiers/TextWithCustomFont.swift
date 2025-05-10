import SwiftUI

struct TextWithCustomFont: ViewModifier {
    let fontSize: CGFloat
    func body(content: Content) -> some View {
        content
            .font(Font.custom("Silom", size: fontSize))
            .foregroundStyle(Color("poopy_green").opacity(0.8))
    }
}

import SwiftUI

struct ButtonWithStretchableBkg: ViewModifier {
    let style: String
    let width: CGFloat
    func body(content: Content) -> some View {
        content
            .font(Font.custom("Silom", size: 18))
            .lineLimit(1)
            .minimumScaleFactor(0.1)
            .foregroundStyle(Color.white)
            .padding(EdgeInsets(top: 12, leading: 24, bottom: 16, trailing: 24))
            .background(
                Image("button_\(style)_stretchable_bkg")
                    .resizable(capInsets: EdgeInsets(top: 0, leading: 40, bottom: 0, trailing: 20), resizingMode: .stretch)
                    .frame(width: width)
            )
            .frame(width: width, height: 52)
    }
}

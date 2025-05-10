import SwiftUI

struct TextFieldWithStretchableBkg: ViewModifier {
    let style: String
    let width: CGFloat
    func body(content: Content) -> some View {
        content
            .multilineTextAlignment(.center)
            .font(Font.custom("Silom", size: 18))
            .foregroundStyle(Color.white)
            .padding(EdgeInsets(top: 12, leading: 23, bottom: 16, trailing: 24))
            .background(
                Image("button_1_stretchable_bkg")
                    .resizable(capInsets: EdgeInsets(top: 0, leading: 40, bottom: 0, trailing: 20), resizingMode: .stretch)
                    .frame(width: width)
            )
            .tint(Color.white)
            .frame(width: width)
    }
}

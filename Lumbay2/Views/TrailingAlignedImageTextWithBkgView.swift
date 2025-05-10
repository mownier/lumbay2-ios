import SwiftUI

struct TrailingAlignedImageTextWithBkg: View {
    let text: String
    let imageName: String
    let colorName: String
    
    init(_ text: String, _ imageName: String, _ colorName: String) {
        self.text = text
        self.imageName = imageName
        self.colorName = colorName
    }
    
    var body: some View {
        HStack(spacing: 0) {
            Spacer()
            HStack(spacing: 2) {
                Image(imageName)
                    .padding(.trailing, 8)
                    .padding(.leading, 8)
                Text(text)
                    .foregroundStyle(Color.white)
                    .modifier(TextWithCustomFont(fontSize: 18.0))
                    .padding(.trailing, 8)
            }
            .background {
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(colorName))
                    .frame(height: 32)
            }
        }
    }
}


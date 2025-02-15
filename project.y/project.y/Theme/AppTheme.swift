import SwiftUI

enum AppTheme {
    static let primaryColor = Color.blue
    static let successColor = Color.green
    static let warningColor = Color.orange
    static let backgroundColor = Color(.systemBackground)
    static let secondaryBackground = Color(.secondarySystemBackground)
    
    static let cardShadow = Color.black.opacity(0.1)
    static let spacing: CGFloat = 16
    static let cornerRadius: CGFloat = 12
}

extension View {
    func cardStyle() -> some View {
        self.modifier(CardModifier())
    }
}

struct CardModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(AppTheme.spacing)
            .background(
                RoundedRectangle(cornerRadius: AppTheme.cornerRadius)
                    .fill(AppTheme.backgroundColor)
                    .shadow(color: AppTheme.cardShadow, radius: 8, x: 0, y: 2)
            )
    }
} 
import SwiftUI

struct MilestoneRow: View {
    // Properties
    let milestone: Milestone
    let isLast: Bool
    let onToggle: () -> Void
    
    // Initializer
    init(milestone: Milestone, isLast: Bool, onToggle: @escaping () -> Void) {
        self.milestone = milestone
        self.isLast = isLast
        self.onToggle = onToggle
    }
    
    var body: some View {
        HStack(spacing: 15) {
            // Timeline dot and line
            VStack(spacing: 0) {
                Button(action: onToggle) {
                    Circle()
                        .fill(milestone.isCompleted ? AppTheme.successColor : Color.gray)
                        .frame(width: 12, height: 12)
                }
                .buttonStyle(.plain)
                
                if !isLast {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: 2, height: 30)
                }
            }
            
            // Milestone details
            VStack(alignment: .leading) {
                Text(milestone.title)
                    .font(.subheadline)
                    .strikethrough(milestone.isCompleted)
                Text(milestone.date.formatted(date: .abbreviated, time: .omitted))
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
    }
}

#Preview {
    MilestoneRow(
        milestone: Milestone(
            title: "Complete Task",
            date: Date(),
            isCompleted: false
        ),
        isLast: false,
        onToggle: {}
    )
    .padding()
} 
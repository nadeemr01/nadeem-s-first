import SwiftUI

struct GoalTimelineCard: View {
    let goal: Goal
    let viewModel: GoalsViewModel
    @State private var showingEditSheet = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Title and Progress
            HStack {
                Text(goal.title)
                    .font(.title2)
                    .bold()
                Spacer()
                Text("\(Int(goal.progress * 100))%")
                    .font(.headline)
                    .foregroundColor(goal.category.color)
            }
            
            if !goal.description.isEmpty {
                Text(goal.description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            // Progress Bar
            ProgressView(value: goal.progress)
                .tint(goal.category.color)
            
            // Timeline
            VStack(alignment: .leading, spacing: 8) {
                ForEach(goal.milestones) { milestone in
                    MilestoneRow(
                        milestone: milestone,
                        isLast: milestone.id == goal.milestones.last?.id,
                        onToggle: {
                            viewModel.toggleMilestone(goalId: goal.id, milestoneId: milestone.id)
                        }
                    )
                }
            }
            .padding(.leading, 4)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: AppTheme.cornerRadius)
                .fill(AppTheme.backgroundColor)
                .shadow(color: AppTheme.cardShadow, radius: 2)
        )
        .onTapGesture {
            showingEditSheet = true
        }
        .sheet(isPresented: $showingEditSheet) {
            EditGoalView(viewModel: viewModel, goal: goal)
        }
    }
} 
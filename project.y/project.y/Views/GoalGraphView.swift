import SwiftUI
import Charts

struct GoalGraphView: View {
    let goals: [Goal]
    
    var categoryProgress: [(category: GoalCategory, progress: Double)] {
        Dictionary(grouping: goals, by: \.category)
            .map { (category, goals) in
                let avgProgress = goals.reduce(0.0) { $0 + $1.progress } / Double(goals.count)
                return (category, avgProgress)
            }
            .sorted { $0.progress > $1.progress }
    }
    
    var timelineData: [(date: Date, completed: Int)] {
        let allMilestones = goals.flatMap { goal in
            goal.milestones.filter { $0.isCompleted }
        }
        
        let grouped = Dictionary(grouping: allMilestones) { milestone in
            Calendar.current.startOfDay(for: milestone.date)
        }
        
        return grouped.map { (date, milestones) in
            (date, milestones.count)
        }.sorted { $0.date < $1.date }
    }
    
    var body: some View {
        VStack(spacing: 20) {
            // Category Progress Chart
            GroupBox("Progress by Category") {
                Chart(categoryProgress, id: \.category) { item in
                    BarMark(
                        x: .value("Progress", item.progress * 100),
                        y: .value("Category", item.category.rawValue)
                    )
                    .foregroundStyle(item.category.color)
                }
                .frame(height: 150)
                .padding(.vertical)
            }
            
            // Timeline Progress Chart
            if !timelineData.isEmpty {
                GroupBox("Completion Timeline") {
                    Chart(timelineData, id: \.date) { item in
                        LineMark(
                            x: .value("Date", item.date),
                            y: .value("Completed", item.completed)
                        )
                        .foregroundStyle(AppTheme.primaryColor)
                        
                        AreaMark(
                            x: .value("Date", item.date),
                            y: .value("Completed", item.completed)
                        )
                        .foregroundStyle(AppTheme.primaryColor.opacity(0.1))
                    }
                    .frame(height: 150)
                    .padding(.vertical)
                }
            }
        }
        .padding()
    }
} 
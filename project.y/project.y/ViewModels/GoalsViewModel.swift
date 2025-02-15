import Foundation

class GoalsViewModel: ObservableObject {
    @Published var goals: [Goal] = []
    @Published var selectedCategory: GoalCategory?
    
    init() {
        goals = StorageManager.shared.loadGoals()
        if goals.isEmpty {
            addSampleGoals()
        }
    }
    
    func addGoal(_ goal: Goal) {
        goals.append(goal)
        saveGoals()
    }
    
    func updateGoal(_ goal: Goal) {
        if let index = goals.firstIndex(where: { $0.id == goal.id }) {
            goals[index] = goal
            saveGoals()
        }
    }
    
    func deleteGoal(_ goal: Goal) {
        goals.removeAll { $0.id == goal.id }
        saveGoals()
    }
    
    func toggleMilestone(goalId: UUID, milestoneId: UUID) {
        if let goalIndex = goals.firstIndex(where: { $0.id == goalId }),
           let milestoneIndex = goals[goalIndex].milestones.firstIndex(where: { $0.id == milestoneId }) {
            goals[goalIndex].milestones[milestoneIndex].isCompleted.toggle()
            updateProgress(for: goalIndex)
            saveGoals()
        }
    }
    
    private func updateProgress(for goalIndex: Int) {
        let milestones = goals[goalIndex].milestones
        let completedCount = Double(milestones.filter { $0.isCompleted }.count)
        goals[goalIndex].progress = milestones.isEmpty ? 0 : completedCount / Double(milestones.count)
    }
    
    private func saveGoals() {
        StorageManager.shared.saveGoals(goals)
    }
    
    private func addSampleGoals() {
        // Add sample data
        let currentYear = Calendar.current.component(.year, from: Date())
        let startOfYear = Calendar.current.date(from: DateComponents(year: currentYear, month: 1, day: 1))!
        let endOfYear = Calendar.current.date(from: DateComponents(year: currentYear, month: 12, day: 31))!
        
        goals = [
            Goal(title: "Learn SwiftUI",
                 startDate: startOfYear,
                 targetDate: endOfYear,
                 progress: 0.3,
                 description: "Master SwiftUI framework",
                 milestones: [
                    Milestone(title: "Complete basics", date: Date(), isCompleted: true),
                    Milestone(title: "Build first app", date: Date().addingTimeInterval(60*60*24*30), isCompleted: false)
                 ]),
            Goal(title: "Exercise Routine",
                 startDate: startOfYear,
                 targetDate: endOfYear,
                 progress: 0.5,
                 description: "Work out 3 times per week",
                 milestones: [
                    Milestone(title: "First month completed", date: Date(), isCompleted: true),
                    Milestone(title: "Run 5K", date: Date().addingTimeInterval(60*60*24*60), isCompleted: false)
                 ])
        ]
    }
    
    var filteredGoals: [Goal] {
        guard let category = selectedCategory else { return goals }
        return goals.filter { $0.category == category }
    }
    
    var completedMilestonesCount: Int {
        goals.reduce(0) { count, goal in
            count + goal.milestones.filter { $0.isCompleted }.count
        }
    }
    
    var totalMilestonesCount: Int {
        goals.reduce(0) { count, goal in
            count + goal.milestones.count
        }
    }
    
    var overallProgress: Double {
        guard totalMilestonesCount > 0 else { return 0 }
        return Double(completedMilestonesCount) / Double(totalMilestonesCount)
    }
} 
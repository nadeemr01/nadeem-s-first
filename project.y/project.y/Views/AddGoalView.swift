import SwiftUI

struct AddGoalView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: GoalsViewModel
    
    @State private var title = ""
    @State private var description = ""
    @State private var startDate = Date()
    @State private var targetDate = Date().addingTimeInterval(60*60*24*30)
    @State private var category: GoalCategory = .personal
    @State private var showingMilestoneSheet = false
    @State private var milestones: [Milestone] = []
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Goal Details") {
                    TextField("Title", text: $title)
                    TextField("Description", text: $description, axis: .vertical)
                        .lineLimit(3...6)
                    
                    Picker("Category", selection: $category) {
                        ForEach(GoalCategory.allCases, id: \.self) { category in
                            Label(category.rawValue, systemImage: category.icon)
                                .foregroundColor(category.color)
                                .tag(category)
                        }
                    }
                }
                
                Section("Timeline") {
                    DatePicker("Start Date", selection: $startDate, displayedComponents: .date)
                    DatePicker("Target Date", selection: $targetDate, displayedComponents: .date)
                }
                
                Section("Milestones") {
                    ForEach(milestones) { milestone in
                        HStack {
                            Text(milestone.title)
                            Spacer()
                            Text(milestone.date.formatted(date: .abbreviated, time: .omitted))
                                .foregroundColor(.secondary)
                        }
                    }
                    .onDelete(perform: deleteMilestone)
                    
                    Button(action: { showingMilestoneSheet = true }) {
                        Label("Add Milestone", systemImage: "plus.circle.fill")
                    }
                }
            }
            .navigationTitle("New Goal")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") { saveGoal() }
                        .disabled(title.isEmpty)
                }
            }
            .sheet(isPresented: $showingMilestoneSheet) {
                AddMilestoneView(milestones: $milestones)
            }
        }
    }
    
    private func saveGoal() {
        let goal = Goal(
            title: title,
            startDate: startDate,
            targetDate: targetDate,
            description: description,
            milestones: milestones,
            category: category
        )
        viewModel.addGoal(goal)
        dismiss()
    }
    
    private func deleteMilestone(at offsets: IndexSet) {
        milestones.remove(atOffsets: offsets)
    }
} 
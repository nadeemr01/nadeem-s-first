import SwiftUI

struct EditGoalView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: GoalsViewModel
    let goal: Goal
    
    @State private var title: String
    @State private var description: String
    @State private var startDate: Date
    @State private var targetDate: Date
    @State private var category: GoalCategory
    @State private var milestones: [Milestone]
    @State private var showingMilestoneSheet = false
    @State private var showingDeleteAlert = false
    
    init(viewModel: GoalsViewModel, goal: Goal) {
        self.viewModel = viewModel
        self.goal = goal
        
        // Initialize state with current goal values
        _title = State(initialValue: goal.title)
        _description = State(initialValue: goal.description)
        _startDate = State(initialValue: goal.startDate)
        _targetDate = State(initialValue: goal.targetDate)
        _category = State(initialValue: goal.category)
        _milestones = State(initialValue: goal.milestones)
    }
    
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
                            Button(action: {
                                if let index = milestones.firstIndex(where: { $0.id == milestone.id }) {
                                    milestones[index].isCompleted.toggle()
                                }
                            }) {
                                Image(systemName: milestone.isCompleted ? "checkmark.circle.fill" : "circle")
                                    .foregroundColor(milestone.isCompleted ? .green : .gray)
                            }
                            .buttonStyle(.plain)
                            
                            VStack(alignment: .leading) {
                                Text(milestone.title)
                                    .strikethrough(milestone.isCompleted)
                                Text(milestone.date.formatted(date: .abbreviated, time: .omitted))
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                    .onDelete(perform: deleteMilestone)
                    
                    Button(action: { showingMilestoneSheet = true }) {
                        Label("Add Milestone", systemImage: "plus.circle.fill")
                    }
                }
                
                Section {
                    Button("Delete Goal", role: .destructive) {
                        showingDeleteAlert = true
                    }
                }
            }
            .navigationTitle("Edit Goal")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") { saveChanges() }
                        .disabled(title.isEmpty)
                }
            }
            .sheet(isPresented: $showingMilestoneSheet) {
                AddMilestoneView(milestones: $milestones)
            }
            .alert("Delete Goal", isPresented: $showingDeleteAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Delete", role: .destructive) {
                    viewModel.deleteGoal(goal)
                    dismiss()
                }
            } message: {
                Text("Are you sure you want to delete this goal? This action cannot be undone.")
            }
        }
    }
    
    private func saveChanges() {
        let updatedGoal = Goal(
            id: goal.id,
            title: title,
            startDate: startDate,
            targetDate: targetDate,
            progress: goal.progress,
            description: description,
            milestones: milestones,
            category: category
        )
        viewModel.updateGoal(updatedGoal)
        dismiss()
    }
    
    private func deleteMilestone(at offsets: IndexSet) {
        milestones.remove(atOffsets: offsets)
    }
} 
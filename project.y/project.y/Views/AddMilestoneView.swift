import SwiftUI

struct AddMilestoneView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var milestones: [Milestone]
    
    @State private var title = ""
    @State private var date = Date()
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Milestone Title", text: $title)
                    DatePicker("Target Date", selection: $date, displayedComponents: .date)
                }
            }
            .navigationTitle("Add Milestone")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") { 
                        addMilestone()
                    }
                    .disabled(title.isEmpty)
                }
            }
        }
    }
    
    private func addMilestone() {
        let milestone = Milestone(
            title: title,
            date: date,
            isCompleted: false
        )
        milestones.append(milestone)
        dismiss()
    }
}

#Preview {
    AddMilestoneView(milestones: .constant([]))
} 
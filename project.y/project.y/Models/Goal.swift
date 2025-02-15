import Foundation
import SwiftUI

struct Goal: Identifiable, Codable {
    let id: UUID
    var title: String
    var startDate: Date
    var targetDate: Date
    var progress: Double // 0.0 to 1.0
    var description: String
    var milestones: [Milestone]
    var category: GoalCategory
    
    init(id: UUID = UUID(), title: String, startDate: Date, targetDate: Date, 
         progress: Double = 0.0, description: String, milestones: [Milestone] = [], 
         category: GoalCategory = .personal) {
        self.id = id
        self.title = title
        self.startDate = startDate
        self.targetDate = targetDate
        self.progress = progress
        self.description = description
        self.milestones = milestones
        self.category = category
    }
}

struct Milestone: Identifiable, Codable {
    let id: UUID
    var title: String
    var date: Date
    var isCompleted: Bool
    
    init(id: UUID = UUID(), title: String, date: Date, isCompleted: Bool = false) {
        self.id = id
        self.title = title
        self.date = date
        self.isCompleted = isCompleted
    }
}

enum GoalCategory: String, Codable, CaseIterable {
    case personal = "Personal"
    case work = "Work"
    case health = "Health"
    case education = "Education"
    case financial = "Financial"
    
    var icon: String {
        switch self {
        case .personal: return "person.fill"
        case .work: return "briefcase.fill"
        case .health: return "heart.fill"
        case .education: return "book.fill"
        case .financial: return "dollarsign.circle.fill"
        }
    }
    
    var color: Color {
        switch self {
        case .personal: return .blue
        case .work: return .purple
        case .health: return .green
        case .education: return .orange
        case .financial: return .mint
        }
    }
} 
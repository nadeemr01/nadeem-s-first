import Foundation

class StorageManager {
    static let shared = StorageManager()
    private let goalsKey = "savedGoals"
    
    func saveGoals(_ goals: [Goal]) {
        if let encoded = try? JSONEncoder().encode(goals) {
            UserDefaults.standard.set(encoded, forKey: goalsKey)
        }
    }
    
    func loadGoals() -> [Goal] {
        guard let data = UserDefaults.standard.data(forKey: goalsKey),
              let goals = try? JSONDecoder().decode([Goal].self, from: data) else {
            return []
        }
        return goals
    }
} 
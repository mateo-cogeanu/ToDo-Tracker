import Foundation

struct ToDoItem: Identifiable, Codable {
    var id = UUID()
    var title: String
    var isCompleted: Bool
    var dueDate: Date?
    var notes: String?
    var priority: Priority
    
    enum Priority: String, Codable, CaseIterable {
        case low = "Low"
        case medium = "Medium"
        case high = "High"
    }
} 
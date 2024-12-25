import Foundation
import SwiftUI

struct ToDoItem: Identifiable, Codable {
    var id = UUID()
    var title: String
    var isCompleted: Bool
    var dueDate: Date?
    var notes: String?
    var priority: Priority
    var color: TaskColor
    var notifyMe: Bool?  // Optional because it only applies to todos with due dates
    
    enum Priority: String, Codable, CaseIterable {
        case low = "Low"
        case medium = "Medium"
        case high = "High"
    }
    
    enum TaskColor: String, Codable, CaseIterable {
        case blue = "Blue"
        case green = "Green"
        case red = "Red"
        case purple = "Purple"
        case orange = "Orange"
        case pink = "Pink"
        
        var color: Color {
            switch self {
            case .blue: return .blue
            case .green: return .green
            case .red: return .red
            case .purple: return .purple
            case .orange: return .orange
            case .pink: return .pink
            }
        }
    }
} 
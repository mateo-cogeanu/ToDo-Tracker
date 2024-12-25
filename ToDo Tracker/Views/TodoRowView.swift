import SwiftUI

struct TodoRowView: View {
    let todo: ToDoItem
    let onUpdate: (ToDoItem) -> Void
    
    var body: some View {
        HStack {
            Button(action: {
                var updatedTodo = todo
                updatedTodo.isCompleted.toggle()
                onUpdate(updatedTodo)
            }) {
                Image(systemName: todo.isCompleted ? "checkmark.circle.fill" : "circle")
                    .imageScale(.large)
                    .foregroundStyle(todo.isCompleted ? .green : todo.color.color)
            }
            .buttonStyle(.plain)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(todo.title)
                    .strikethrough(todo.isCompleted)
                    .foregroundStyle(todo.isCompleted ? .gray : todo.color.color)
                
                if let dueDate = todo.dueDate {
                    Text(dueDate.formatted(date: .abbreviated, time: .shortened))
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            
            Spacer()
            
            PriorityBadge(priority: todo.priority)
        }
        .padding(.vertical, 4)
    }
}

struct PriorityBadge: View {
    let priority: ToDoItem.Priority
    
    var body: some View {
        Text(priority.rawValue)
            .font(.caption2)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(priorityColor.opacity(0.2))
            .foregroundStyle(priorityColor)
            .clipShape(Capsule())
    }
    
    private var priorityColor: Color {
        switch priority {
        case .low: return .blue
        case .medium: return .orange
        case .high: return .red
        }
    }
} 
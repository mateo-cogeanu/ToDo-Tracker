import SwiftUI

struct AddTodoView: View {
    @Environment(\.dismiss) private var dismiss
    let onAdd: (ToDoItem) -> Void
    
    @State private var title = ""
    @State private var notes = ""
    @State private var dueDate = Date()
    @State private var hasDueDate = false
    @State private var priority: ToDoItem.Priority = .medium
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Title", text: $title)
                    TextField("Notes", text: $notes, axis: .vertical)
                        .lineLimit(3...6)
                }
                
                Section {
                    Toggle("Has Due Date", isOn: $hasDueDate)
                    
                    if hasDueDate {
                        DatePicker("Due Date", selection: $dueDate, displayedComponents: [.date, .hourAndMinute])
                    }
                }
                
                Section {
                    Picker("Priority", selection: $priority) {
                        ForEach(ToDoItem.Priority.allCases, id: \.self) { priority in
                            Text(priority.rawValue)
                        }
                    }
                }
            }
            .navigationTitle("New Todo")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Add") {
                        let todo = ToDoItem(
                            title: title,
                            isCompleted: false,
                            dueDate: hasDueDate ? dueDate : nil,
                            notes: notes.isEmpty ? nil : notes,
                            priority: priority
                        )
                        onAdd(todo)
                        dismiss()
                    }
                    .disabled(title.isEmpty)
                }
            }
        }
    }
} 
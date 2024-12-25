import SwiftUI
import UserNotifications

struct AddTodoView: View {
    @Environment(\.dismiss) private var dismiss
    let onAdd: (ToDoItem) -> Void
    
    @State private var title = ""
    @State private var notes = ""
    @State private var dueDate = Date()
    @State private var hasDueDate = false
    @State private var priority: ToDoItem.Priority = .medium
    @State private var taskColor: ToDoItem.TaskColor = .blue
    @State private var notifyMe = false
    @State private var showingNotificationAlert = false
    
    private let columns = Array(repeating: GridItem(.flexible()), count: 6)
    
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
                        Toggle("Notify Me", isOn: $notifyMe)
                            .onChange(of: notifyMe) { newValue in
                                if newValue {
                                    requestNotificationPermission()
                                }
                            }
                    }
                }
                
                Section {
                    Picker("Priority", selection: $priority) {
                        ForEach(ToDoItem.Priority.allCases, id: \.self) { priority in
                            Text(priority.rawValue)
                        }
                    }
                }
                
                Section {
                    Picker("Color", selection: $taskColor) {
                        ForEach(ToDoItem.TaskColor.allCases, id: \.self) { color in
                            HStack {
                                Circle()
                                    .fill(color.color)
                                    .frame(width: 20, height: 20)
                                Text(color.rawValue)
                            }
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
                            priority: priority,
                            color: taskColor,
                            notifyMe: hasDueDate ? notifyMe : nil
                        )
                        
                        if todo.notifyMe == true {
                            scheduleNotification(for: todo)
                        }
                        
                        onAdd(todo)
                        dismiss()
                    }
                    .disabled(title.isEmpty)
                }
            }
            .alert("Notification Permission Required", isPresented: $showingNotificationAlert) {
                Button("Settings", role: .none) {
                    if let url = URL(string: UIApplication.openSettingsURLString) {
                        UIApplication.shared.open(url)
                    }
                }
                Button("Cancel", role: .cancel) {
                    notifyMe = false
                }
            } message: {
                Text("Please enable notifications in Settings to receive reminders for your todos.")
            }
        }
    }
    
    private func requestNotificationPermission() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                if settings.authorizationStatus == .denied {
                    showingNotificationAlert = true
                    notifyMe = false
                } else if settings.authorizationStatus == .notDetermined {
                    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { success, _ in
                        DispatchQueue.main.async {
                            if !success {
                                notifyMe = false
                            }
                        }
                    }
                }
            }
        }
    }
    
    private func scheduleNotification(for todo: ToDoItem) {
        guard let dueDate = todo.dueDate else { return }
        
        let content = UNMutableNotificationContent()
        content.title = "Todo Due: \(todo.title)"
        if let notes = todo.notes {
            content.body = notes
        }
        content.sound = .default
        
        let components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: dueDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        
        let request = UNNotificationRequest(
            identifier: todo.id.uuidString,
            content: content,
            trigger: trigger
        )
        
        UNUserNotificationCenter.current().add(request)
    }
} 


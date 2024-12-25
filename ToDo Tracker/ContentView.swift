//
//  ContentView.swift
//  ToDo Tracker
//
//  Created by Mateo Cogeanu on 25.12.2024.
//

import SwiftUI

struct ContentView: View {
    @State private var todos: [ToDoItem] = []
    @State private var showingAddTodo = false
    
    private var sortedTodos: [ToDoItem] {
        todos.sorted { todo1, todo2 in
            if todo1.isCompleted == todo2.isCompleted {
                return todos.firstIndex(where: { $0.id == todo1.id })! < 
                       todos.firstIndex(where: { $0.id == todo2.id })!
            }
            return !todo1.isCompleted && todo2.isCompleted
        }
    }
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(sortedTodos) { todo in
                    TodoRowView(todo: todo) { updatedTodo in
                        if let index = todos.firstIndex(where: { $0.id == updatedTodo.id }) {
                            withAnimation(.spring(duration: 0.3)) {
                                todos[index] = updatedTodo
                            }
                        }
                    }
                }
                .onDelete(perform: deleteTodos)
                .onMove(perform: moveTodos)
            }
            .navigationTitle("ToDo Tracker")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: { showingAddTodo = true }) {
                        Image(systemName: "plus.circle.fill")
                            .imageScale(.large)
                    }
                }
                ToolbarItem(placement: .topBarLeading) {
                    EditButton()
                }
            }
            .sheet(isPresented: $showingAddTodo) {
                AddTodoView { newTodo in
                    withAnimation(.spring(duration: 0.3)) {
                        todos.append(newTodo)
                    }
                }
            }
        }
    }
    
    private func deleteTodos(at offsets: IndexSet) {
        withAnimation(.spring(duration: 0.3)) {
            let idsToDelete = offsets.map { sortedTodos[$0].id }
            todos.removeAll(where: { idsToDelete.contains($0.id) })
        }
    }
    
    private func moveTodos(from source: IndexSet, to destination: Int) {
        var movedTodos = todos
        
        // Convert source indices from sortedTodos to original todos array
        let sourceIndices = source.map { sortedTodos[$0] }
            .compactMap { todo in
                todos.firstIndex(where: { $0.id == todo.id })
            }
        
        // Convert destination index from sortedTodos to original todos array
        let destinationTodo = destination < sortedTodos.count ? sortedTodos[destination] : nil
        let destinationIndex = destinationTodo.flatMap { todo in
            todos.firstIndex(where: { $0.id == todo.id })
        } ?? todos.count
        
        // Perform the move
        movedTodos.move(fromOffsets: IndexSet(sourceIndices), toOffset: destinationIndex)
        
        withAnimation(.spring(duration: 0.3)) {
            todos = movedTodos
        }
    }
}

#Preview {
    ContentView()
}

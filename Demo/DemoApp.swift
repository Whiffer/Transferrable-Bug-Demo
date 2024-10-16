//
//  DemoApp.swift
//  DemoApp
//
//  Created by Chuck Hartman on 10/15/24.
//

import SwiftUI
import SwiftData
import UniformTypeIdentifiers

extension UTType {
    public static var persistentModelID: UTType { UTType(exportedAs: "com.Demo.persistentModelID") }
}

extension PersistentIdentifier: @retroactive Transferable {
    public static var transferRepresentation: some TransferRepresentation {
        CodableRepresentation(for: PersistentIdentifier.self, contentType: .persistentModelID)
    }
}

@Model final class Item {
    var timestamp: Date
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}

@main struct DemoApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    var body: some View {
        VStack {
            Button("Add Item", systemImage: "plus", action: {
                withAnimation {
                    let newItem = Item(timestamp: Date())
                    modelContext.insert(newItem)
                    try? modelContext.save()
                }
            } )
            ItemsListView()
            Spacer()
            TargetView()
        }
    }
}

struct ItemsListView: View {
    @Query private var items: [Item]
    @State private var selection = Set<Item>()
    @Environment(\.modelContext) private var modelContext
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Tap the '+ Add Item' button above to create Items and select one or more to drag.")
                Text("1) Dragging onto the Target below works on Sonoma and fails on Sequoia.")
                Text("2) Dragging onto a List Row works on Sonoma and fails on Sequoia.")
            }
            Spacer()
        }
        .padding(.horizontal)
        List(selection: $selection) {
            ForEach(items, id: \.self) { item in
                HStack {
                    Text(item.timestamp.description)
                    Spacer()
                }
                .contentShape(Rectangle())
                .draggable(item.persistentModelID)
                .dropDestination(for: PersistentIdentifier.self) { persistentModelIDs, _ in
                    for persistentModelID in persistentModelIDs {
                        let droppedItem = modelContext.model(for: persistentModelID) as? Item
                        print("\(String(describing: droppedItem?.timestamp)) dropped on List Row \(item.timestamp)")
                    }
                    return true
                }
            }
        }
    }
}

struct TargetView: View {
    @Environment(\.modelContext) private var modelContext
    var body: some View {
        HStack {
            Text("Drop one or more Items here.")
            Spacer()
        }
        .contentShape(Rectangle())
        .padding()
        .border(.gray, width: 1)
        .dropDestination(for: PersistentIdentifier.self) { persistentModelIDs, _ in
            for persistentModelID in persistentModelIDs {
                let droppedItem = modelContext.model(for: persistentModelID) as? Item
                print("\(String(describing: droppedItem?.timestamp)) dropped on Target")
            }
            return true
        }
    }
}

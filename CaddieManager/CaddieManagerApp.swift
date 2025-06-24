import SwiftUI

@main
struct CaddieManagerApp: App {
    @StateObject private var store = GroupDataStore()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(store)
        }
    }
}

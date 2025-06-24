import SwiftUI

struct ContentView: View {
    @EnvironmentObject var store: GroupDataStore
    @State private var selection: DateRange = .upcoming
    @State private var showNeedingCaddiesOnly = false

    var filteredGroups: [Group] {
        var result = store.groups(for: selection)
        if showNeedingCaddiesOnly {
            result = result.filter { !$0.isFullyAssigned }
        }
        return result.sorted { $0.date < $1.date }
    }

    var body: some View {
        NavigationView {
            VStack {
                Picker("Date Range", selection: $selection) {
                    Text("Today").tag(DateRange.today)
                    Text("Tomorrow").tag(DateRange.tomorrow)
                    Text("Next Week").tag(DateRange.nextWeek)
                    Text("Upcoming").tag(DateRange.upcoming)
                }
                .pickerStyle(SegmentedPickerStyle())

                Toggle("Groups Needing Caddies", isOn: $showNeedingCaddiesOnly)
                    .padding(.horizontal)

                List(filteredGroups) { group in
                    VStack(alignment: .leading) {
                        Text(dateFormatter.string(from: group.date))
                            .font(.headline)
                        Text("Caddies: \(group.caddies.count)/\(group.requiredCaddies)")
                            .font(.subheadline)
                    }
                }
            }
            .navigationTitle("Groups")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: exportPDF) {
                        Image(systemName: "square.and.arrow.up")
                    }
                }
            }
        }
    }

    func exportPDF() {
        PDFExporter.export(view: AnyView(self.body))
    }
}

private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    return formatter
}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(GroupDataStore())
    }
}

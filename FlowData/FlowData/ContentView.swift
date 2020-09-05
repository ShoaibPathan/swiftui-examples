//
//  ContentView.swift
//  FlowData
//
//  Created by Hao Luo on 9/5/20.
//

import Combine
import SwiftUI

// MARK: - DateIntervalView

final class DateIntervalViewStore: ObservableObject {
    @Published private(set) var dateInterval: DateInterval
    
    init(initialDateInterval: DateInterval) {
        self._dateInterval = .init(initialValue: initialDateInterval)
    }
    
    func updateStartDate(_ newStartDate: Date) {
        dateInterval = .init(
            start: newStartDate,
            end: dateInterval.end
        )
    }
    
    func updateEndDate(_ newEndDate: Date) {
        dateInterval = .init(
            start: dateInterval.start,
            end: newEndDate
        )
    }
}

struct DateIntervalView: View {
    @ObservedObject private var viewStore: DateIntervalViewStore
    @ObservedObject private var startDateEditViewStore: DateEditViewStore
    @ObservedObject private var endDateEditViewStore: DateEditViewStore
    @Binding private var presentDateEditView: Bool
    private var cancellable: Set<AnyCancellable> = .init()
    
    init(viewStore: DateIntervalViewStore, presentDateEditView: Binding<Bool>) {
        self.viewStore = viewStore
        self.startDateEditViewStore = .init(
            initialDate: viewStore.dateInterval.start,
            presentDateEditView: presentDateEditView
        )
        self.endDateEditViewStore = .init(
            initialDate: viewStore.dateInterval.end,
            presentDateEditView: presentDateEditView
        )
        self._presentDateEditView = presentDateEditView
        
        self.startDateEditViewStore.$date.sink { newStartDate in
            viewStore.updateStartDate(newStartDate)
        }.store(in: &cancellable)
        self.endDateEditViewStore.$date.sink { newEndDate in
            viewStore.updateEndDate(newEndDate)
        }.store(in: &cancellable)
    }
    
    var body: some View {
        VStack {
            Text("\(viewStore.dateInterval.duration.format())")
            HStack {
                Button("\(viewStore.dateInterval.start.timeFormat())") {
                    presentDateEditView = true
                }
                .sheet(isPresented: $presentDateEditView) {
                    DateEditView(viewStore: startDateEditViewStore)
                }
                
                Text("-")
                
                Button("\(viewStore.dateInterval.end.timeFormat())") {
                    presentDateEditView = true
                }
                .sheet(isPresented: $presentDateEditView) {
                    DateEditView(viewStore: endDateEditViewStore)
                }
            }
        }
    }
}

// MARK: - DateEditView

final class DateEditViewStore: ObservableObject {
    @Published private(set) var date: Date
    @Binding private var presentDateEditView: Bool
    
    init(initialDate: Date, presentDateEditView: Binding<Bool>) {
        self._date = .init(initialValue: initialDate)
        self._presentDateEditView = presentDateEditView
    }
    
    func cancelEdit() {
        presentDateEditView = false
    }
    
    func saveEdit(_ newDate: Date) {
        presentDateEditView = false
        date = newDate
    }
}

struct DateEditView: View {
    @ObservedObject private var viewStore: DateEditViewStore
    @State private var date: Date
    
    init(viewStore: DateEditViewStore) {
        self.viewStore = viewStore
        self._date = .init(initialValue: viewStore.date)
    }
    
    var body: some View {
        NavigationView {
            DatePicker("", selection: $date)
                .datePickerStyle(WheelDatePickerStyle())
                .navigationBarTitle("Edit Time")
                .navigationBarItems(
                    leading: Button(action: {
                        viewStore.cancelEdit()
                    }, label: {
                        Text("Cancel")
                    }),
                    trailing: Button(action: {
                        viewStore.saveEdit(date)
                    }, label: {
                        Text("Done")
                    })
                )
        }
    }
}

// MARK: - Helper Extensions

private extension Date {
    func timeFormat() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: self)
    }
}

private extension TimeInterval {
    func format() -> String {
        let hours = Int(self) / 3600
        let minutes = Int(self) / 60 % 60
        return String(format:"%02i:%02i", hours, minutes)
    }
}
    
// MARK: - Root Content View

struct ContentView: View {
    @State private var presentDateEditView: Bool = false
    var body: some View {
        DateIntervalView(
            viewStore: .init(initialDateInterval: .init()),
            presentDateEditView: $presentDateEditView
        )
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

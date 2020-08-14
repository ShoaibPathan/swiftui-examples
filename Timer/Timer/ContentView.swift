//
//  ContentView.swift
//  Timer
//
//  Created by Hao Luo on 8/13/20.
//

import Combine
import SwiftUI

struct TimerState {
    let isActive: Bool
    let elapsedTime: DateInterval?
}

enum TimerAction {
  case timerTicked
  case toggleTimerButtonTapped
}

final class TimerViewStore: ObservableObject {
    @Published private(set) var state: TimerState = .init(isActive: false, elapsedTime: nil)
    
    private let timerInterval: TimeInterval
    private var cancellable: AnyCancellable!
    
    init(timerInterval: TimeInterval = 1) {
        self.timerInterval = timerInterval
    }
    
    func send(_ action: TimerAction) {
        switch action {
        case .timerTicked:
            state = .init(
                isActive: true,
                elapsedTime: state.elapsedTime.map {
                    DateInterval(
                        start: $0.start,
                        end: $0.end.advanced(by: timerInterval)
                    )
                } ?? .init()
            )
            
        case .toggleTimerButtonTapped:
            if state.isActive {
                cancellable!.cancel()
            } else {
                cancellable = Timer
                    .publish(every: timerInterval, on: .main, in: .common)
                    .autoconnect()
                    .sink { _ in
                        self.send(.timerTicked)
                    }
            }
            state = .init(
                isActive: state.isActive ? false : true,
                elapsedTime: state.elapsedTime ?? .init()
            )
        }
    }
}

struct TimerView: View {
    @ObservedObject private(set) var viewStore: TimerViewStore = .init()
    
    private var timerState: TimerState {
        return viewStore.state
    }

    var body: some View {
      VStack {
          Text(timerState.elapsedTime.map {$0.duration.format()} ?? "0m")
          Text(
            timerState.isActive ?
                "Start at \(timerState.elapsedTime!.start.timeFormat())" :
                timerState.elapsedTime.map {"From \($0.start.timeFormat()) to \($0.end.timeFormat())"} ?? ""
          )
          Button(action: { viewStore.send(.toggleTimerButtonTapped) }) {
            Text(timerState.isActive ? "Stop" : "Start")
            .foregroundColor(.white)
            .padding()
            .background(timerState.isActive ? Color.red : .blue)
            .cornerRadius(16)
          }
      }
    }
}

private extension TimeInterval {
    func format() -> String {
        let hours = Int(self) / 3600
        let minutes = Int(self) / 60 % 60
        let seconds = Int(self) % 60
        return String(format:"%02i:%02i:%02i", hours, minutes, seconds)
    }
}

private extension Date {
    func timeFormat() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        return dateFormatter.string(from: self)
    }
}

struct ContentView: View {
    var body: some View {
        TimerView()
    }
}

import SwiftUI

struct HabitCardView: View {
    @ObservedObject var viewModel: HabitsViewModel
    var habit: Habit
    @State private var overlayDay: String? = nil

    var weekDates: [(symbol: String, date: Date)] {
            // Always start week on Sunday, matching calendar view!
            let week = Date.currentWeekDates() // [Su, Mo, Tu, We, Th, Fr, Sa]
            return zip(weekdaySymbols, week).map { ($0, $1) }
        }

    var body: some View {
        
        
        VStack(alignment: .leading, spacing: 12) {
            Text(habit.title)
                .font(.title3).bold()
                .foregroundColor(.blue)
            Text(habit.description)
                .font(.subheadline)
                .foregroundColor(.gray)
            HStack(spacing: 12) {
                ForEach(weekDates, id: \.symbol) { tuple in
                    HabitDayCircle(
                        habit: habit,
                        viewModel: viewModel,
                        daySymbol: tuple.symbol,
                        date: tuple.date,
                        overlayDay: $overlayDay
                    )
                }
                
            }
            .onAppear {
                print("Current week dates:")
                for date in Date.currentWeekDates() {
                    print(date.toDateKey(), date.weekdayShort())
                }
            }

        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 22)
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [Color(.systemGray6), .white]),
                        startPoint: .topLeading, endPoint: .bottomTrailing
                    )
                )
                .shadow(color: .black.opacity(0.11), radius: 20, x: 0, y: 8)
        )
        .padding(.horizontal, 16)
        .padding(.vertical, 4)
        
    }
    
}


struct HabitDayCircle: View {
    var habit: Habit
    @ObservedObject var viewModel: HabitsViewModel
    var daySymbol: String
    var date: Date
    @Binding var overlayDay: String?

    var dateKey: String { date.toDateKey() }
    var isActive: Bool { habit.isActive(on: date) }
    var status: CompletionStatus {
        viewModel.completions[habit.id]?[dateKey] ?? .none
    }
    var circleColor: Color {
        switch status {
            case .success: return .green
            case .failure: return .red
            case .none: return isActive ? .blue : Color.gray.opacity(0.15)
        }
    }

    var body: some View {
        ZStack {
            Circle()
                .fill(circleColor)
                .frame(width: 38, height: 38)
                .overlay(
                    Text(daySymbol)
                        .font(.subheadline)
                        .foregroundColor(
                            status == .none ? (isActive ? .white : .gray) : .white
                        )
                )
                .onTapGesture {
                    if isActive {
                        withAnimation { overlayDay = daySymbol }
                    }
                }
                .overlay(
                    Group {
                        if overlayDay == daySymbol {
                            OverlayMenu(
                                onSuccess: {
                                    withAnimation(.easeInOut(duration: 0.2)) {
                                        viewModel.setCompletion(habit: habit, date: date, status: .success)
                                        overlayDay = nil
                                    }
                                },
                                onFailure: {
                                    withAnimation(.easeInOut(duration: 0.2)) {
                                        viewModel.setCompletion(habit: habit, date: date, status: .failure)
                                        overlayDay = nil
                                    }
                                },
                                onReset: {
                                    withAnimation(.easeInOut(duration: 0.2)) {
                                        viewModel.setCompletion(habit: habit, date: date, status: .none)
                                        overlayDay = nil
                                    }
                                }
                            )
                            .offset(y: -65)
                        }
                    }
                )
        }
        .animation(.spring(), value: status)
        .zIndex(overlayDay == daySymbol ? 1 : 0)
    }
}



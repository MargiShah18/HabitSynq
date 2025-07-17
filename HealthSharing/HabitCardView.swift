import SwiftUI

struct HabitCardView: View {
    var habit: Habit

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(habit.title)
                .font(.title3).bold()
                .foregroundColor(.blue)
            Text(habit.description)
                .font(.subheadline)
                .foregroundColor(.gray)
            HStack(spacing: 12) {
                ForEach(["Mo", "Tu", "We", "Th", "Fr", "Sa", "Su"], id: \.self) { day in
                    let isSelected = habit.frequencyType == "Daily" || habit.frequencyDays.contains(day)
                    Circle()
                        .fill(isSelected ? Color.blue : Color.gray.opacity(0.15))
                        .frame(width: 38, height: 38)
                        .overlay(
                            Text(day)
                                .font(.subheadline)
                                .foregroundColor(isSelected ? .white : .gray)
                        )
                        .animation(.spring(), value: habit.frequencyDays) // animated highlight
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 22)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.04), radius: 8, x: 0, y: 3)
        )
        .padding(.horizontal, 16)
        .padding(.vertical, 4)
        .transition(.move(edge: .bottom).combined(with: .opacity))
    }
}

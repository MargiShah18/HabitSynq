import SwiftUI

struct FrequencySectionView: View {
    @Binding var frequency: String
    @Binding var selectedDays: Set<String>
    @Binding var daysPerWeek: String
    @Binding var daysPerMonth: String

    let allDays: [String]
    let frequencyOptions: [String]

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Frequency")
                .font(.headline)
                .padding(.bottom, 2)
            
            // Picker
            Picker("Frequency", selection: $frequency) {
                ForEach(frequencyOptions, id: \.self) { option in
                    Text(option)
                }
            }
            .pickerStyle(MenuPickerStyle())
            
            // Daily: show all days (non-interactive)
            if frequency == "Daily" {
                HStack(spacing: 8) {
                    ForEach(allDays, id: \.self) { day in
                        Text(day)
                            .font(.caption2)
                            .padding(.vertical, 7)
                            .padding(.horizontal, 12)
                            .background(Color.blue.opacity(0.16))
                            .cornerRadius(13)
                    }
                }
            }

            // Specific Days: selectable chips
            if frequency == "Specific Days" {
                HStack(spacing: 8) {
                    ForEach(allDays, id: \.self) { day in
                        Button(action: {
                            if selectedDays.contains(day) {
                                selectedDays.remove(day)
                            } else {
                                selectedDays.insert(day)
                            }
                        }) {
                            Text(day)
                                .font(.caption)
                                .padding(.vertical, 7)
                                .padding(.horizontal, 12)
                                .background(selectedDays.contains(day) ? Color.blue : Color.gray.opacity(0.15))
                                .foregroundColor(selectedDays.contains(day) ? .white : .primary)
                                .cornerRadius(13)
                                .shadow(color: selectedDays.contains(day) ? Color.blue.opacity(0.11) : .clear, radius: 4, y: 2)
                        }
                        .buttonStyle(.plain)
                        .animation(.easeInOut(duration: 0.13), value: selectedDays)
                    }
                }
            }

            // Number of Days per Week
            if frequency == "Number of Days per Week" {
                TextField("How many days per week?", text: $daysPerWeek)
                    .keyboardType(.numberPad)
                    .padding(8)
                    .background(Color.gray.opacity(0.11))
                    .cornerRadius(10)
            }

            // Number of Days per Month
            if frequency == "Number of days per Month" {
                TextField("How many days per month?", text: $daysPerMonth)
                    .keyboardType(.numberPad)
                    .padding(8)
                    .background(Color.gray.opacity(0.11))
                    .cornerRadius(10)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(18)
        .shadow(color: .gray.opacity(0.09), radius: 8, y: 3)
    }
}

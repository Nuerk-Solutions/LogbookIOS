//
//  ChartAnnotation.swift
//  Logbook
//
//  Created by Thomas Nürk on 03.01.24.
//

import SwiftUI
import Charts

struct ChartAnnotation: View {
    
    var date: Date
    var consumption: Double
    
    let dayAndMonth: DateFormatter = {
        var dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM"
        return dateFormatter
    }()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Verbrauch")
                .fontWeight(.semibold)
                .foregroundStyle(.gray)
            
            HStack(spacing: 4) {
                Text(String(format: "%.2fL", consumption))
                    .font(.title3)
                    .fontWeight(.semibold)
                
                Text(dayAndMonth.string(from: date))
                    .font(.title3)
                    .textScale(.secondary)
            }
        }
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 8)
                .foregroundStyle(Color.gray.opacity(0.12))
        }
    }
}

#Preview {
    //    ChartAnnotation(barSelection: .constant(Date()), refuelsReceive: .constant(LogbookRefuelReceive.previewData[0].refuels))
    ChartAnnotation(date: Date(), consumption: 4)
}

//
//  StartDateView.swift
//  Demo
//
//  Created by iMac on 07/11/25.
//
import SwiftUI

struct StartDateView: View {
    @Binding var selectedDate: Date
    @Environment(\.dismiss) var dismiss
    
    
    var body: some View {
        VStack(spacing: 20) {
            ZStack{
                
                Text("Start Date")
                    .font(.medium(size: ._18))
                    .foregroundStyle(Color.appBlack)
                
                HStack{
                    Spacer()
                    Button{
                        dismiss()
                    }label: {
                        Text("Done")
                            .font(.medium(size: ._18))
                            .foregroundStyle(Color.appDarkBlue)
                    }
                }
            }.padding(.top)
            DatePicker(
                "",
                selection: $selectedDate,
                in: Date()...,
                displayedComponents: [.date]
            )
            .datePickerStyle(.wheel)
            .labelsHidden()
            
        }
        .padding(.horizontal, 16)
        
    }
}

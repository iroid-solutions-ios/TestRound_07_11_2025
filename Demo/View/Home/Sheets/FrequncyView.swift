//
//  FrequncyView.swift
//  Demo
//
//  Created by iMac on 07/11/25.
//
import SwiftUI

struct FrequncyView: View {
    @Binding var selectedFrequncy: Frequency
    @State var selectedCat: Frequency?
    @Environment(\.dismiss) var dismiss
    
    
    var body: some View {
        VStack(spacing: 20) {
            //            Text("Services")
            //                .font(.title2)
            //                .fontWeight(.bold)
            //                .padding(.top)
            
            
            // Services List
            ZStack{
                
                Text("Frequency")
                    .font(.medium(size: ._18))
                    .foregroundStyle(Color.appBlack)
                
                HStack{
                    Spacer()
                    Button{
                        if let selectedCat = selectedCat{
                            selectedFrequncy = selectedCat
                        }
                        dismiss()
                    }label: {
                        Text("Done")
                            .font(.medium(size: ._18))
                            .foregroundStyle(Color.appDarkBlue)
                    }
                }
            }.padding(.top)
            
            VStack(spacing: 0){
                ForEach(Frequency.demo) { service in
                    VStack {
                        HStack(spacing: 12) {
                            Text(service.name)
                                .font(.regular(size: ._16))
                                .foregroundStyle(Color.appLightBlack)
                            Spacer()
                            
                            if selectedCat?.id == service.id {
                                Image("check")
                                
                            }
                        }
                        .padding(.vertical, 5)
                        
                        if service.id != Frequency.demo.last?.id{
                            Rectangle()
                                                                    .fill(Color("Neutral200"))
                                                                    .frame(height: 1)
                        }
                    }
                    .padding(.vertical,8)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        self.selectedCat = service
                    }
                }
            }
            
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }
}

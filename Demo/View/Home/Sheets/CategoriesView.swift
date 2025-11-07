//
//  CategoriesView.swift
//  Demo
//
//  Created by iMac on 07/11/25.
//
import SwiftUI

struct CategoriesView: View {
    @State var selectedCat: Category?
    @Binding var selectedCategory: Category
    @Environment(\.dismiss) var dismiss
    @State var searchText: String = ""
    
    // Computed property to filter services based on search text
    
    
    var body: some View {
        VStack(spacing: 20) {
            ZStack{
                
                Text("Category")
                    .font(.medium(size: ._18))
                    .foregroundStyle(Color.appBlack)
                
                HStack{
                    Spacer()
                    Button{
                        if let selectedCat = selectedCat{
                            self.selectedCategory = selectedCat
                        }
                        
                        dismiss()
                    }label: {
                        Text("Done")
                            .font(.medium(size: ._18))
                            .foregroundStyle(Color.appDarkBlue)
                    }
                }
            }.padding(.top)
            
            ScrollView {
                ForEach(Category.demo) { service in
                    VStack {
                        HStack(spacing: 12) {
                            Image(service.img)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 30, height: 30)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                            
                            Text(service.name)
                                .font(.regular(size: ._16))
                                .foregroundStyle(Color.appLightBlack)
                            Spacer()
                            
                            if selectedCat?.id == service.id {
                                Image("check")
                            }
                        }
                        .padding(.vertical, 4)
                        
                        if service.id != Category.demo.last?.id{
                            Rectangle()
                                                                    .fill(Color("Neutral200"))
                                                                    .frame(height: 1)
                        }
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        self.selectedCat = service
                    }
                }
            }
            .scrollIndicators(.hidden)
            .listStyle(.plain)
        }
        
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }
}

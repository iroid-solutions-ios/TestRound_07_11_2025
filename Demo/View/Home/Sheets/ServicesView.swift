//
//  ServicesView.swift
//  Demo
//
//  Created by iMac on 07/11/25.
//

import SwiftUI

struct ServicesView: View {
    @Binding var selectedCategory: Service?
    @State var selectedCat: Service?
    @Environment(\.dismiss) var dismiss
    @State var searchText: String = ""
    
    // Computed property to filter services based on search text
    var filteredServices: [Service] {
        if searchText.isEmpty {
            return Service.demo
        } else {
            return Service.demo.filter { service in
                service.name.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var body: some View {
        VStack(spacing: 20) {
            ZStack{
                
                Text("Services")
                    .font(.medium(size: ._18))
                    .foregroundStyle(Color.appBlack)
                
                HStack{
                    Spacer()
                    Button{
                        self.selectedCategory = selectedCat
                        dismiss()
                    }label: {
                        Text("Done")
                            .font(.medium(size: ._18))
                            .foregroundStyle(Color.appDarkBlue)
                    }
                }
            }.padding(.top)
            
            // Search Bar
            HStack(spacing: 10) {
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 16))
                    .foregroundColor(Color("Neutral400"))
                    .padding(.leading, 16)
                
                TextField("Search", text: $searchText)
                    .font(.regular(size: ._16))
                    .foregroundColor(.black)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
            }
            .frame(height: 44)
            .background(Color.white)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(searchText.isEmpty ? Color("Neutral200") : Color("Primary500"), lineWidth: 1)
            )
            .padding(.top, 8)
            
            // Services List
            if filteredServices.isEmpty {
                VStack(spacing: 12) {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 48))
                        .foregroundColor(.gray.opacity(0.5))
                    Text("No services found")
                        .font(.headline)
                        .foregroundColor(.gray)
                    Text("Try searching for something else")
                        .font(.subheadline)
                        .foregroundColor(.gray.opacity(0.8))
                }
                .frame(maxWidth: .infinity)
                .padding(.top, 60)
                Spacer()
            } else {
                ScrollView {
                    ForEach(filteredServices) { service in
                        VStack {
                            HStack(spacing: 14) {
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
                            .padding(.vertical, 5)
                            
                            if service.id != Service.demo.last?.id{
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
                .listStyle(.plain)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }
}

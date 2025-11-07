//
//  CreateSubscriptionView.swift
//  Demo
//
//  Created by iMac on 07/11/25.
//

/*
 CreateSubscriptionView is a modal form screen for creating new subscriptions.
 
 Features:
 - Three-card layout with animated entrance effects
 - Service selection with icon display
 - Amount input with formatted currency display
 - Category selection with visual icons
 - Start date picker and frequency selection
 - Active/inactive toggle for subscription status
 - Form validation with enabled/disabled save button
 - Custom header with back button and save action
 - Modal sheet presentations for detailed inputs
*/

import SwiftUI

struct CreateSubscriptionView: View {
    // MARK: - Properties
    
    /// Binding to control the presentation of this modal view
    @Binding var isShowCreate: Bool
    
    /// View model that handles all the subscription creation logic and validation
    @StateObject private var viewModel = CreateSubscriptionViewModel()
    
    /// Environment dismiss action for programmatic dismissal
    @Environment(\.dismiss) var dismiss
    
    /// Animation state array to control the sequential appearance of the three cards
    @State private var appearedCards: [Bool] = [false, false, false]
    
    // MARK: - Body
    var body: some View {
        ZStack {
            // Background color that extends beyond safe area
            Color("BackgroundPage")
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Custom header with back button, title, and save action
                headerView
                
                // MARK: - Main Content ScrollView
                ScrollView {
                    VStack(spacing: 20) {
                        // MARK: - Service Selection Card (First Card)
                        // Card for choosing subscription service with animated entrance
                        serviceSelectionCard
                            .opacity(appearedCards[0] ? 1 : 0)
                            .offset(y: appearedCards[0] ? 0 : 20)
                            .animation(.easeInOut(duration: 0.4).delay(0.0), value: appearedCards[0])
                        
                        // MARK: - Details Card (Second Card)
                        // Card containing name, amount, and category selection
                        detailsCard
                            .opacity(appearedCards[1] ? 1 : 0)
                            .offset(y: appearedCards[1] ? 0 : 20)
                            .animation(.easeInOut(duration: 0.4).delay(0.2), value: appearedCards[1])
                        
                        // MARK: - Schedule Card (Third Card)
                        // Card for start date, frequency, and active toggle
                        scheduleCard
                            .opacity(appearedCards[2] ? 1 : 0)
                            .offset(y: appearedCards[2] ? 0 : 20)
                            .animation(.easeInOut(duration: 0.4).delay(0.4), value: appearedCards[2])
                    }
                    .padding(.horizontal, 16)
                }
            }
            .navigationBarBackButtonHidden(true)
            .navigationBarTitleDisplayMode(.inline)
            // Attach custom sheet modifier for modal presentations
            .attachSheets(viewModel: viewModel)
            // Animate cards entrance when view appears
            .onAppear {
                // Delay initial animation, then animate each card sequentially
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
                    for i in 0..<appearedCards.count {
                        DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * 0.2) {
                            appearedCards[i] = true
                        }
                    }
                })
            }
        }
    }
    
    // MARK: - Header View
    /// Custom header with back button, title, and save action
    private var headerView: some View {
        HStack {
            // Back button to dismiss the create view with animation
            Button(action: {
                withAnimation(.spring(response: 0.5, dampingFraction: 0.75)) {
                isShowCreate = false
            }}) {
                Image("ic_back")
                    .resizable()
                    .frame(width: 40, height: 40)
            }
            
            Spacer()
            
            // Screen title
            Text("Create Subscription")
                .font(.medium(size: ._18))
                .foregroundColor(.black)
            
            Spacer()
            
            // Save button with conditional styling based on form validation
            Button(action: saveAction) {
                Text("Save")
                    .font(.medium(size: ._18))
                    // Dynamic color: primary when can save, neutral when disabled
                    .foregroundColor(viewModel.canSave ? Color("Primary500") : Color("Neutral500"))
            }
            .frame(width: 44, height: 44)
            .disabled(!viewModel.canSave)  // Disabled until all required fields are filled
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 14)
    }
    
    // MARK: - Service Selection Card
    /// Main service selection card that displays chosen service and amount
    private var serviceSelectionCard: some View {
        // Tappable card that opens service selection sheet
        Button(action: { viewModel.isShowServices = true }) {
            HStack(spacing: 14) {
                // Service icon (plus icon if none selected, service image if selected)
                serviceIcon
                
                // Service name and amount display
                VStack(alignment: .leading, spacing: 2) {
                    // Service name with conditional styling
                    Text(viewModel.selectedService?.name ?? "Choose a service")
                        .font(viewModel.selectedService == nil ? .regular(size: ._18) : .medium(size: ._18))
                        .foregroundColor(viewModel.selectedService == nil ? Color("Neutral400") : .black)
                    
                    // Formatted amount display
                    Text(viewModel.formattedAmount)
                        .font(.system(size: 16, weight: .regular))
                        .foregroundColor(Color("Neutral80"))
                }
                
                Spacer()
            }
            .padding(20)
            .background(Color.white)
            .cornerRadius(16)
            .shadow(color: Color.black.opacity(0.02), radius: 16, x: 0, y: 0)
        }
        .buttonStyle(PlainButtonStyle())  // Remove button highlighting
    }
    
    /// Service icon that shows either the selected service image or a plus icon placeholder
    private var serviceIcon: some View {
        Group {
            if let service = viewModel.selectedService {
                // Display the actual service icon when service is selected
                Image(service.img)
                    .resizable()
                    .frame(width: 50, height: 50)
            } else {
                // Show plus icon placeholder when no service is selected
                ZStack {
                    Circle()
                        .fill(Color("Primary25"))  // Light primary background
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: "plus")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(Color("Primary500"))  // Primary color plus icon
                }
            }
        }
    }
    
    // MARK: - Details Card
    /// Second card containing detailed subscription information (name, amount, category)
    private var detailsCard: some View {
        VStack(spacing: 12) {
            // Service name selection row
            nameRow
            Divider().background(Color("Neutral200"))
            
            // Amount input row
            amountRow
            Divider().background(Color("Neutral200"))
            
            // Category selection row
            categoryRow
        }
        .padding(20)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.02), radius: 16, x: 0, y: 0)
    }
    
    /// Row for selecting subscription service name via dropdown menu
    private var nameRow: some View {
        HStack {
            // Label for the name field
            Text("Name")
                .font(.regular(size: ._16))
                .foregroundColor(Color("Neutral500"))
            Spacer()
            
            // Dropdown menu for service selection
            Menu {
                ForEach(Service.demo) { service in
                    Button(service.name) {
                        viewModel.selectedService = service
                    }
                    .font(.regular(size: ._16))
                }
            } label: {
                HStack(spacing: 4) {
                    // Selected service name or placeholder text
                    Text(viewModel.selectedService?.name ?? "Choose a Service")
                        .font(.regular(size: ._16))
                        .foregroundColor(viewModel.selectedService == nil ? Color("Neutral400") : .black)
                    
                    // Dropdown indicator chevron
                    Image(systemName: "chevron.up.chevron.down")
                        .font(.system(size: 12, weight: .regular))
                        .foregroundColor(Color("Neutral400"))
                }
                .padding(.vertical, 6)
            }
        }
        .padding(.vertical, 8)
    }
    
    /// Row for amount input with formatted currency display
    private var amountRow: some View {
        HStack {
            // Label for the amount field
            Text("Amount")
                .font(.regular(size: ._16))
                .foregroundColor(Color("Neutral500"))
            Spacer()
            
            // Button to open amount input sheet
            Button {
                viewModel.showAmountInput = true
            } label: {
                // Underlined formatted amount display
                Text(viewModel.formattedAmount)
                    .font(.regular(size: ._16))
                    .foregroundColor(.black)
                    .underline()  // Indicates it's tappable
                    .padding(.vertical, 6)
            }
        }
        .padding(.vertical, 8)
    }
    
    /// Row for category selection with icon and dropdown indicator
    private var categoryRow: some View {
        HStack {
            // Label for the category field
            Text("Category")
                .font(.regular(size: ._16))
                .foregroundColor(Color("Neutral500"))
            Spacer()
            
            // Button to open category selection sheet
            Button {
                viewModel.isShowCategory = true
            } label: {
                HStack(spacing: 4) {
                    // Category icon
                    Image(viewModel.selectedCategory.img)
                        .resizable()
                        .frame(width: 25, height: 25)
                    
                    // Category name
                    Text(viewModel.selectedCategory.name)
                        .font(.regular(size: ._16))
                        .foregroundColor(.black)
                    
                    // Dropdown indicator
                    Image(systemName: "chevron.up.chevron.down")
                        .font(.system(size: 12, weight: .regular))
                        .foregroundColor(Color("Neutral400"))
                }
            }
        }
        .padding(.vertical, 8)
    }
    
    // MARK: - Schedule Card
    /// Third card containing scheduling information (start date, frequency, active status)
    private var scheduleCard: some View {
        VStack(spacing: 20) {
            // Start date selection row
            startDateRow
            Divider().background(Color("Neutral200"))
            
            // Frequency selection row (weekly/monthly/annually)
            frequencyRow
            Divider().background(Color("Neutral200"))
            
            // Active/inactive toggle row
            activeRow
        }
        .padding(20)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.02), radius: 16, x: 0, y: 0)
    }
    
    /// Row for start date selection with styled date display
    private var startDateRow: some View {
        HStack(spacing: 14) {
            // Label for start date field
            Text("Start Date")
                .font(.regular(size: ._16))
                .foregroundColor(Color("Neutral500"))
                .frame(maxWidth: .infinity, alignment: .leading)
            
            // Button to open date picker sheet
            Button(action: { viewModel.isShowDate = true }) {
                // Formatted date display with background styling
                Text(viewModel.formattedDate)
                    .font(.system(size: 16, weight: .regular))
                    .foregroundColor(.black)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 6)
                    .background(Color("Neutral100"))  // Light background for date display
                    .cornerRadius(8)
            }
        }
    }
    
    /// Row for frequency selection (Weekly, Monthly, Annually)
    private var frequencyRow: some View {
        HStack {
            // Label for frequency field
            Text("Frequency")
                .font(.regular(size: ._16))
                .foregroundColor(Color("Neutral500"))
            Spacer()
            
            // Button to open frequency selection sheet
            Button {
                viewModel.isShowFrequency = true
            } label: {
                HStack(spacing: 4) {
                    // Selected frequency name
                    Text(viewModel.selectedFrequency.name)
                        .font(.regular(size: ._16))
                        .foregroundColor(.black)
                    
                    // Dropdown indicator chevron
                    Image(systemName: "chevron.up.chevron.down")
                        .font(.system(size: 12, weight: .regular))
                        .foregroundColor(Color("Neutral400"))
                }
                .padding(.vertical, 6)
            }
        }
    }
    
    /// Row for active/inactive toggle switch
    private var activeRow: some View {
        HStack(spacing: 14) {
            // Label for active status field
            Text("Active")
                .font(.system(size: 16, weight: .regular))
                .foregroundColor(Color("Neutral500"))
                .frame(maxWidth: .infinity, alignment: .leading)
            
            // Toggle switch for subscription active status
            Toggle("", isOn: $viewModel.isActive)
                .labelsHidden()  // Hide default toggle label
                .tint(Color.appBlue)  // Custom toggle color
                .padding(.vertical, 3)
        }
    }
    
    // MARK: - Actions
    
    /// Saves the subscription and dismisses the view with animation
    /// Called when the save button is tapped (only enabled when form is valid)
    private func saveAction() {
        // Save the subscription to the shared view model
        viewModel.saveSubscription()
        
        // Dismiss the create view with spring animation
        withAnimation(.spring(response: 0.5, dampingFraction: 0.75)) {
            isShowCreate = false
        }
    }
}

// MARK: - Preview
#Preview {
    CreateSubscriptionView(isShowCreate: .constant(true))
}

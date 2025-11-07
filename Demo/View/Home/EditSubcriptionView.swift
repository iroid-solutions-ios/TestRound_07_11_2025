//
//  EditSubcriptionView.swift
//  Demo
//
//  Created by iMac on 07/11/25.
//

/*
 EditSubcriptionView is a form screen for editing existing subscriptions.
 
 Features:
 - Pre-populated form fields with existing subscription data
 - Same three-card layout as create view with animated entrance effects
 - Real-time form validation with enabled/disabled save button
 - Multiple modal sheet presentations for detailed inputs
 - Custom amount input sheet with cancel/done actions
 - Index-based subscription loading and updating
 - Navigation-based presentation (not modal overlay)
 - Dynamic view model initialization with subscription index
*/

import SwiftUI

struct EditSubcriptionView: View {
    // MARK: - Properties
    
    /// Binding to control the navigation back to home view
    @Binding var isShowEdit: Bool
    
    /// Binding to the index of the subscription being edited
    @Binding var index: Int
    
    /// View model that handles editing logic for the specific subscription
    @StateObject private var viewModel: EditSubscriptionViewModel
    
    /// Animation state array to control the sequential appearance of the three cards
    @State private var appearedCards: [Bool] = [false, false, false]

    // MARK: - Custom Initializer
    /// Custom initializer to create view model with the specific subscription index
    /// This ensures the view model loads the correct subscription data when the view appears
    init(isShowEdit: Binding<Bool>, index: Binding<Int>) {
        _isShowEdit = isShowEdit
        _index = index
        // Initialize the view model with the subscription index to edit
        _viewModel = StateObject(wrappedValue: EditSubscriptionViewModel(index: index.wrappedValue))
    }

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
            // MARK: - View Lifecycle
            .onAppear {
                // Update view model with current index to load subscription data
                viewModel.updateIndex(index)
                
                // Animate cards entrance when view appears with sequential timing
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
                    for i in 0..<appearedCards.count {
                        DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * 0.2) {
                            appearedCards[i] = true
                        }
                    }
                })
                
            }
            // Listen for index changes and update view model accordingly
            .onChange(of: index) { oldValue, newValue in
                viewModel.updateIndex(newValue)
            }
            
            .navigationBarBackButtonHidden(true)
            .navigationBarTitleDisplayMode(.inline)
            // MARK: - Sheet Presentations
            
            // Service selection sheet - Large modal for choosing subscription service
            .sheet(isPresented: $viewModel.isShowServices) {
                ServicesView(selectedCategory: $viewModel.selectedService, selectedCat: viewModel.selectedService)
                    .presentationDetents([.large])  // Full height presentation
                    .presentationDragIndicator(.visible)
            }
            
            // Category selection sheet - Medium modal for choosing category
            .sheet(isPresented: $viewModel.isShowCategory) {
                CategoriesView(selectedCat: viewModel.selectedCategory, selectedCategory: $viewModel.selectedCategory)
                    .presentationDetents([.medium])  // Half height presentation
                    .presentationDragIndicator(.visible)
            }
            
            // Date picker sheet - Fixed height for start date selection
            .sheet(isPresented: $viewModel.isShowDate) {
                StartDateView(selectedDate: $viewModel.startDate)
                    .presentationDetents([.height(300)])  // Fixed 300pt height
                    .presentationDragIndicator(.visible)
            }
            
            // Frequency selection sheet - Fixed height for frequency options
            .sheet(isPresented: $viewModel.isShowFrequency) {
                FrequncyView(selectedFrequncy: $viewModel.selectedFrequency, selectedCat: viewModel.selectedFrequency)
                    .presentationDetents([.height(240)])  // Fixed 240pt height
                    .presentationDragIndicator(.visible)
            }
            
            // Amount input sheet - Custom NavigationView for amount entry
            .sheet(isPresented: $viewModel.showAmountInput) {
                NavigationView {
                    VStack(spacing: 20) {
                        // Sheet title
                        Text("Enter Amount")
                            .font(.headline)
                            .padding(.top)

                        // Decimal input field with rounded border styling
                        TextField("0.00", text: $viewModel.amountText)
                            .keyboardType(.decimalPad)  // Numeric keyboard for amount input
                            .textFieldStyle(.roundedBorder)
                            .padding(.horizontal)

                        // Cancel and Done action buttons
                        HStack(spacing: 20) {
                            // Cancel button - resets input and dismisses sheet
                            Button("Cancel") {
                                viewModel.resetAmountInput()
                                viewModel.showAmountInput = false
                            }
                            .foregroundColor(.gray)

                            // Done button - saves amount and dismisses sheet
                            Button("Done") {
                                viewModel.updateAmount(from: viewModel.amountText)
                                viewModel.showAmountInput = false
                            }
                            .foregroundColor(Color("Primary500"))
                        }
                        .padding()

                        Spacer()
                    }
                    .navigationBarTitleDisplayMode(.inline)
                }
                .presentationDetents([.height(200)])  // Fixed small height for amount input
            }
        }
    }

    // MARK: - Header View
    /// Custom header with back button, title, and save action
    private var headerView: some View {
        HStack {
            // Back button to navigate back to home view
            Button(action: {
                isShowEdit = false
            }) {
                Image("ic_back")
                    .resizable()
                    .frame(width: 40, height: 40)
            }

            Spacer()

            // Screen title
            Text("Update Subscription")
                .font(.medium(size: ._18))
                .foregroundColor(.black)

            Spacer()

            // Save button with conditional styling and form validation
            Button(action: {
                // Save changes to the subscription
                viewModel.saveChanges()
                
                // Navigate back to home view
                isShowEdit = false
            }) {
                Text("Save")
                    .font(.medium(size: ._18))
                    // Dynamic color: primary when can save, neutral when disabled
                    .foregroundColor(viewModel.canSave ?
                                     Color("Primary500") : Color("Neutral500"))
            }
            .frame(width: 44, height: 44)
            .disabled(!viewModel.canSave)  // Disabled until form is valid
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 14)
    }

    // MARK: - Service Selection Card
    /// Main service selection card that displays chosen service and amount
    private var serviceSelectionCard: some View {
        // Tappable card that opens service selection sheet
        Button(action: {
            viewModel.isShowServices = true
        }) {
            HStack(spacing: 14) {
                // Service icon - shows selected service image or plus icon placeholder
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

                // Service name and amount display
                VStack(alignment: .leading, spacing: 2) {
                    // Service name with conditional styling
                    if let selectedService = viewModel.selectedService {
                        Text(selectedService.name)
                            .font(.medium(size: ._18))
                            .foregroundColor(.black)
                    } else {
                        Text("Choose a service")
                            .font(.regular(size: ._18))
                            .foregroundColor(Color("Neutral400"))
                    }

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

    // MARK: - Details Card
    /// Second card containing detailed subscription information (name, amount, category)
    private var detailsCard: some View {
        VStack(spacing: 12) {
            // MARK: - Name Row
            // Service name selection row with dropdown menu
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

            Divider()
                .background(Color("Neutral200"))

            // MARK: - Amount Row
            // Amount input row with formatted currency display
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

            Divider()
                .background(Color("Neutral200"))

            // MARK: - Category Row
            // Category selection row with icon and dropdown indicator
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
        .padding(20)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.02), radius: 16, x: 0, y: 0)
    }

    // MARK: - Schedule Card
    /// Third card containing scheduling information (start date, frequency, active status)
    private var scheduleCard: some View {
        VStack(spacing: 20) {
            // MARK: - Start Date Row
            // Row for start date selection with styled date display
            HStack(spacing: 14) {
                // Label for start date field
                Text("Start Date")
                    .font(.system(size: 16, weight: .regular))
                    .foregroundColor(Color("Neutral500"))
                    .frame(maxWidth: .infinity, alignment: .leading)

                // Button to open date picker sheet
                Button(action: {
                    viewModel.isShowDate = true
                }) {
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

            Divider()
                .background(Color("Neutral200"))

            // MARK: - Frequency Row
            // Row for frequency selection (Weekly, Monthly, Annually)
            HStack {
                // Label for frequency field
                Text("Frequency")
                    .font(.system(size: 16, weight: .regular))
                    .foregroundColor(Color("Neutral500"))
                Spacer()
                
                // Button to open frequency selection sheet
                Button {
                    viewModel.isShowFrequency = true
                } label: {
                    HStack(spacing: 4) {
                        // Selected frequency name
                        Text(viewModel.selectedFrequency.name)
                            .font(.system(size: 16, weight: .regular))
                            .foregroundColor(.black)

                        // Dropdown indicator chevron
                        Image(systemName: "chevron.up.chevron.down")
                            .font(.system(size: 12, weight: .regular))
                            .foregroundColor(Color("Neutral400"))
                    }
                    .padding(.vertical, 6)
                }
            }

            Divider()
                .background(Color("Neutral200"))

            // MARK: - Active Row
            // Row for active/inactive toggle switch
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
        .padding(20)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.02), radius: 16, x: 0, y: 0)
    }
}

// MARK: - Preview
#Preview {
    EditSubcriptionView(isShowEdit: .constant(true), index: .constant(0))
}

//
//  Home.swift
//  Demo
//
//  Created by iMac on 07/11/25.
//

/*
 HomeView is the main screen of the subscription management app.
 
 Features:
 - Displays a list of all subscriptions using SubscriptionRow components
 - Shows empty state when no subscriptions exist
 - Provides swipe actions for delete and edit operations
 - Has a '+' button in navigation bar to create new subscriptions
 - Uses custom animation transitions for the create subscription overlay
 - Handles navigation to edit subscription screen
 */

import SwiftUI

struct HomeView: View {
    // MARK: - Properties
    
    /// Shared view model that manages all subscription data across the app
    @StateObject var subscriptionViewModel = SubcriptionViewModel.shared
    
    /// Animation namespace for matched geometry effects between views
    @Namespace private var animation
    
    /// Controls the presentation of the create subscription overlay
    @State var isShowCreate : Bool = false
    
    /// Controls navigation to the edit subscription screen
    @State var isShowEdit : Bool = false
    
    /// Index of the selected subscription for editing
    @State var selectedSub : Int = 0
    
    /// Set to track which subscription rows have appeared for entrance animations
    /// Uses UUID to uniquely identify each subscription for animation state management
    @State private var appearedRows: Set<UUID> = []

    // MARK: - Body
    var body: some View {
        ZStack{
            // MARK: - Main Navigation Stack
            NavigationStack {
                VStack{
                    if subscriptionViewModel.subscriptions.isEmpty{
                        VStack(spacing: 12) {
                            Spacer()
                            Text("No Subscription found")
                                .font(.headline)
                                .foregroundColor(.gray)
                            Spacer()
                        }
                        .frame(maxWidth: .infinity)
                        Spacer()
                    }else{
                        List {
                            ForEach(Array(subscriptionViewModel.subscriptions.enumerated()), id: \.element.id) { index, subscription in
                                SubscriptionRow(subscription: subscription)
                                    // MARK: - Row Entrance Animation
                                    // Fade and slide animation for each subscription row
                                    .opacity(appearedRows.contains(subscription.id) ? 1 : 0)
                                    .offset(x: appearedRows.contains(subscription.id) ? 0 : -30)  // Slide in from left
                                    .animation(
                                        .easeOut(duration: 0.5)  // Smooth ease-out animation
                                        .delay(Double(index) * 0.08),  // Staggered delay for each row
                                        value: appearedRows.contains(subscription.id)
                                    )
                                    .onAppear {
                                        // Trigger animation after a delay based on row index
                                        DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 0.08) {
                                            appearedRows.insert(subscription.id)
                                        }
                                    }
                                    .onTapGesture{
                                        selectedSub = subscriptionViewModel.subscriptions.firstIndex(where: {$0.id == subscription.id}) ?? 0
                                        isShowEdit = true
                                    }
                                    .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                        // MARK: - Delete Action with Animation
                                        // Delete button with destructive role and smooth removal animation
                                        Button(role: .destructive) {
                                            if let subscriptionIndex = subscriptionViewModel.subscriptions.firstIndex(where: {$0.id == subscription.id}){
                                                // First animate the row out by removing it from appeared set
                                                _ = withAnimation(.easeIn(duration: 0.3)) {
                                                    appearedRows.remove(subscription.id)
                                                }
                                                // Then remove from data source after animation completes
                                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                                    subscriptionViewModel.subscriptions.remove(at: subscriptionIndex)
                                                }
                                            }
                                        } label: {
                                            Text("Delete")
                                        }
                                        
                                        Button {
                                            selectedSub = subscriptionViewModel.subscriptions.firstIndex(where: {$0.id == subscription.id}) ?? 0
                                            isShowEdit = true
                                        } label: {
                                            Text("Update")
                                        }
                                        .tint(.blue)
                                    }
                            }
                        }
                        
                    }
                }
                .navigationTitle("Subscription")
                // MARK: - Navigation Toolbar
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        // Plus button to create new subscription
                        Button(action: {
                            withAnimation(.spring(response: 0.5, dampingFraction: 0.75)) {
                                isShowCreate = true
                            }
                        }) {
                            Image(systemName: "plus")
                        }
                    }
                }
                // Navigation destination for editing subscriptions
                .navigationDestination(isPresented: $isShowEdit, destination: {
                    EditSubcriptionView(isShowEdit: $isShowEdit, index: $selectedSub)
                })
            }
            // MARK: - Create Subscription Overlay
            if isShowCreate{
                // Modal overlay for creating new subscriptions
                CreateSubscriptionView(isShowCreate: $isShowCreate)
                    // Custom transition animation from top-trailing corner
                    .transition(.asymmetric(
                        insertion: .scale(scale: 0.01, anchor: .topTrailing)
                            .combined(with: .opacity),
                        removal: .scale(scale: 0.01, anchor: .topTrailing)
                        
                    ))
                    // Matched geometry effect for smooth transitions
                    .matchedGeometryEffect(id: isShowCreate, in: animation)
                    // Ensure overlay appears above other content
                    .zIndex(1)
            }
        }
    }
}

// MARK: - Preview
#Preview{
    HomeView()
}

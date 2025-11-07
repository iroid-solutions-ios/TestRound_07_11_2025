//
//  SubscriptionRow.swift
//  Demo
//
//  Created by iMac on 07/11/25.
//
import SwiftUI

struct SubscriptionRow: View {
    let subscription: Subcription
    
    var body: some View {
        HStack(spacing: 12) {
            // Service Image
            Image(subscription.service.img)
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 50)
                .clipShape(Circle())
            
            // Subscription Details
            VStack(alignment: .leading, spacing: 4) {
                Text(subscription.service.name)
                    .font(.medium(size: ._18))
                
                HStack {
                    Text(subscription.category.name)
                        .font(.regular(size: ._12))
                        .foregroundColor(.secondary)
                    
                    Text("•")
                        .font(.regular(size: ._12))
                        .foregroundColor(.secondary)
                    
                    Text(subscription.frequency.name)
                        .font(.regular(size: ._12))
                        .foregroundColor(.secondary)
                }
                
                Text(subscription.startDate, style: .date)
                    .font(.regular(size: ._12))
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            // Amount and Status
            VStack(alignment: .trailing, spacing: 4) {
        
                Text("$\(subscription.amount, specifier: "%.2f")")
                    .font(.medium(size: ._16))
                    .foregroundColor(.primary)
                
                Circle()
                    .fill(subscription.isActice ? Color.green : Color.red)
                    .frame(width: 8, height: 8)
                
                
            }
        }
        .padding(.vertical, 8)
    }
}

//
//  Subcription.swift
//  Demo
//
//  Created by iMac on 07/11/25.
//
import Foundation

struct Subcription : Identifiable{
    var id : UUID = UUID()
    var service : Service
    var category : Category
    var frequency : Frequency
    var amount : Double
    var startDate : Date
    var isActice : Bool
    
}

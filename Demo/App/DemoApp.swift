//
//  DemoApp.swift
//  Demo
//
//  Created by iMac on 07/11/25.
//

/*
 DemoApp is the main entry point for the subscription management application.
 
 Features:
 - SwiftUI App protocol implementation with @main attribute
 - Uses UIApplicationDelegateAdaptor to integrate UIKit AppDelegate
 - Sets HomeView as the root view of the application
 - Manages the app's window group and scene lifecycle
*/

import SwiftUI

/// Main application entry point for the subscription management app
@main
struct DemoApp: App {
    // MARK: - Properties
    
    /// Adaptor to integrate UIKit AppDelegate with SwiftUI App lifecycle
    /// This allows the app to use traditional UIKit delegate methods alongside SwiftUI
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    // MARK: - Scene Configuration
    var body: some Scene {
        /// Primary window group that contains the app's main interface
        WindowGroup {
            // Set HomeView as the root view for the entire application
            HomeView()
        }
    }
}

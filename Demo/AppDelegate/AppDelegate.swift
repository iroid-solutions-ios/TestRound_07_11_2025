//
//  AppDelegate.swift
//  Demo
//
//  Created by iMac on 05/09/25.
//

/*
 AppDelegate provides UIKit integration for the SwiftUI-based subscription management app.
 
 Features:
 - Configures IQKeyboardManager for enhanced keyboard handling
 - Provides traditional UIKit app lifecycle methods
 - Integrates with SwiftUI through UIApplicationDelegateAdaptor
 - Handles keyboard behavior for text input fields throughout the app
*/

import Foundation
import SwiftUI
import IQKeyboardManagerSwift
import IQKeyboardToolbarManager

/// UIKit AppDelegate that provides keyboard management and app lifecycle handling
/// Integrated with SwiftUI app through UIApplicationDelegateAdaptor
class AppDelegate: NSObject, UIApplicationDelegate{
    // MARK: - Properties
    
    /// Main window reference (legacy UIKit requirement)
    var window: UIWindow?
    
    // MARK: - App Lifecycle Methods
    
    /// Called when the application finishes launching
    /// Configures global keyboard management settings for text input fields
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        // MARK: - IQKeyboardManager Configuration
        
        // Enable automatic keyboard management throughout the app
        IQKeyboardManager.shared.isEnabled = true
        
        // Enable toolbar with Done/Previous/Next buttons above keyboard
        IQKeyboardToolbarManager.shared.isEnabled = true
        
        // Allow keyboard dismissal by tapping outside text fields
        IQKeyboardManager.shared.resignOnTouchOutside = true
        
        return true
    }
    
    /// Called when the app moves to the background
    /// Currently unused but available for future background task handling
    func applicationDidEnterBackground(_ application: UIApplication) {
        // TODO: Handle background tasks if needed (data saving, etc.)
    }
    
    /// Called when the app is about to terminate
    /// Currently unused but available for cleanup operations
    func applicationWillTerminate(_ application: UIApplication) {
        // TODO: Handle app termination cleanup if needed
    }
}

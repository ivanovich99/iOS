//
//  CineByteApp.swift
//  CineByte
//
//  Created by CETYS Universidad  on 19/02/25.
//

import SwiftUI

@main
struct CineByteApp: App {
    @StateObject var userManager: UserManager
    @StateObject var authManager: AuthManager
    @StateObject var movieManager: MovieManager

    init() {
        let tempUserManager = UserManager()
        _userManager = StateObject(wrappedValue: tempUserManager)
        _authManager = StateObject(wrappedValue: AuthManager(userManager: tempUserManager))
        _movieManager = StateObject(wrappedValue: MovieManager(userManager: tempUserManager))
    }

    var body: some Scene {
        WindowGroup {
            ListView()
                .environmentObject(userManager)
                .environmentObject(authManager)
                .environmentObject(movieManager)
        }
    }
}

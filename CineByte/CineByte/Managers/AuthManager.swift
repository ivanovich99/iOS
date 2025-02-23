//
//  AuthManager.swift
//  CineByte
//
//  Created by Daniel Nuno on 2/22/25.
//

import Foundation

class AuthManager: ObservableObject {
    @Published var currentUser: User?

    init(userManager: UserManager) {
        self.currentUser = userManager.users.randomElement()
    }
}

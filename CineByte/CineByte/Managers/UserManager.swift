//
//  UserManager.swift
//  CineByte
//
//  Created by Daniel Nuno on 2/21/25.
//

import Foundation

class UserManager: ObservableObject {
    @Published var users: [User] = []

    init() {
        populateUsers()
    }

    private func populateUsers() {
        let names = ["Juan", "María", "Carlos", "Ana", "Luis", "Elena", "Pablo", "Diana", "Oscar", "Fernanda",
                     "Gabriel", "Sofía", "Ricardo", "Patricia", "Diego", "Valeria", "José", "Andrea", "Raúl", "Laura"]
        
        for i in 0..<20 {
            let user = User(
                name: names[i],
                lastName: "Apellido \(i)",
                email: "\(names[i].lowercased())\(i)@cinebyte.com",
                phone: "555-1234\(i)",
                username: "user\(i)",
                topGenre: ["Acción", "Drama", "Comedia", "Terror", "Ciencia Ficción"].randomElement()!,
                movies: []
            )
            users.append(user)
        }
    }

    func getUser(byId id: UUID) -> User? {
        return users.first(where: { $0.id == id })
    }
}

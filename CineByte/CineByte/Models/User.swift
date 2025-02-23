//
//  User.swift
//  CineByte
//
//  Created by Daniel Nuno on 2/21/25.
//

import Foundation

class User: ObservableObject, Identifiable {
    var id = UUID()
    @Published var name: String
    @Published var lastName: String
    @Published var email: String
    @Published var phone: String
    @Published var username: String
    @Published var topGenre: String
    @Published var movies: [Movie]

    init(name: String, lastName: String, email: String, phone: String, username: String, topGenre: String, movies: [Movie] = []) {
        self.name = name
        self.lastName = lastName
        self.email = email
        self.phone = phone
        self.username = username
        self.topGenre = topGenre
        self.movies = movies
    }
}

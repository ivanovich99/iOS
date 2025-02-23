//
//  Movie.swift
//  CineByte
//
//  Created by Daniel Nuno on 2/21/25.
//

import Foundation

class Movie: ObservableObject, Identifiable {
    var id = UUID()
    @Published var userId: UUID
    @Published var name: String
    @Published var poster: String
    @Published var rating: Double
    @Published var review: [String]
    @Published var location: String

    init(userId: UUID, name: String, poster: String, rating: Double, review: [String], location: String) {
        self.userId = userId
        self.name = name
        self.poster = poster
        self.rating = rating
        self.review = review
        self.location = location
    }
}

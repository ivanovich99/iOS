//
//  MovieManager.swift
//  CineByte
//
//  Created by Daniel Nuno on 2/21/25.
//

import Foundation
import UIKit

class MovieManager: ObservableObject {
    @Published var movies: [Movie] = []
    @Published var customPosters: [String: UIImage] = [:]


    init(userManager: UserManager) {
        populateMovies(userManager: userManager)
    }

    private func populateMovies(userManager: UserManager) {
        let movieTitles = ["Inception", "Interstellar", "Titanic", "Avatar", "The Matrix",
                           "Gladiator", "The Dark Knight", "Pulp Fiction", "Forrest Gump", "The Godfather",
                           "The Shawshank Redemption", "Fight Club", "The Avengers", "Jurassic Park", "Star Wars",
                           "Deadpool", "The Lion King", "Toy Story", "Finding Nemo", "Coco"]
        
        let reviewSamples = [
            "Increíble película, la volvería a ver!",
            "La cinematografía es espectacular.",
            "No me gustó mucho el final...",
            "Los efectos visuales son de otro nivel.",
            "La historia es un poco lenta, pero vale la pena.",
            "¡Definitivamente una de mis favoritas!",
            "No la recomiendo, me aburrí mucho.",
            "Los actores hicieron un excelente trabajo.",
            "Buena, pero esperaba más.",
            "La música es increíble, me puso la piel de gallina.",
            "Un clásico que nunca pasa de moda.",
            "No entiendo por qué la gente la ama tanto...",
            "Tiene momentos épicos que te dejan sin aliento.",
            "Podría haber sido mejor, pero me entretuvo.",
            "Una obra maestra del cine moderno.",
            "No pude despegar los ojos de la pantalla.",
            "Los diálogos están muy bien escritos.",
            "No es lo que esperaba, pero tiene su encanto.",
            "Me hizo llorar, súper emotiva.",
            "El giro de la trama me dejó impactado.",
            "Es entretenida, pero le faltó algo.",
            "Me reí mucho, gran comedia.",
            "Siento que le dieron demasiado hype.",
            "Muy buena, pero el final me decepcionó un poco.",
            "Es un poco predecible, pero disfrutable.",
            "Me encantó la actuación del protagonista.",
            "No la volvería a ver, pero no está mal.",
            "Perfecta para ver con amigos.",
            "El ritmo es un poco lento, pero vale la pena.",
            "Una de las mejores películas que he visto en años."
        ]
                
        for i in 0..<20 {
                    if let randomUser = userManager.users.randomElement() {
                        let numberOfReviews = Int.random(in: 3...7)
                        
                        let movieReviews = Array(reviewSamples.shuffled().prefix(numberOfReviews))
                        
                        let movie = Movie(
                            userId: randomUser.id,
                            name: movieTitles[i],
                            poster: "\(formatMovieTitle(movieTitles[i]))",
                            rating: Double.random(in: 1...5),
                            review: movieReviews,
                            location: ["Cinemex", "Cinepolis", "Casa", "Streaming"].randomElement()!
                        )
                        movies.append(movie)
                    }
                }
    }

    func addMovie(_ movie: Movie, customImage: UIImage? = nil) {
            if let customImage = customImage, movie.poster.starts(with: "custom_") {
                customPosters[movie.poster] = customImage
            }
            movies.append(movie)
        }
    func deleteMovie(_ movie: Movie) {
            if let index = movies.firstIndex(where: { $0.id == movie.id }) {
                movies.remove(at: index)
            }
            customPosters[movie.poster] = nil
        }
    private func formatMovieTitle(_ title: String) -> String {
        return title.lowercased()
            .replacingOccurrences(of: " ", with: "-")
    }
}

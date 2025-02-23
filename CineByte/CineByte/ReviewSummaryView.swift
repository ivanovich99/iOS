//
//  ReviewSummaryView.swift
//  CineByte
//
//  Created by Daniel Nuno on 2/21/25.
//

import SwiftUI

struct ReviewSummaryView: View {
    var movie: Movie
    @EnvironmentObject var movieManager: MovieManager
    @EnvironmentObject var authManager: AuthManager
    @EnvironmentObject var userManager: UserManager

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                PosterView(movie: movie)
                
                InfoAndReviewsView(
                    movieName: movie.name,
                    rating: movie.rating,
                    review: movie.review
                )
                
                if movie.userId == authManager.currentUser?.id {
                    HStack(spacing: 20) {
                        NavigationLink(destination: EditMovieView(movie: movie)
                                        .environmentObject(movieManager)
                                        .environmentObject(authManager)
                                        .environmentObject(userManager)) {
                            Label("Editar", systemImage: "pencil")
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(.blue)
                        
                        Button(action: {
                            movieManager.deleteMovie(movie)
                        }) {
                            Label("Eliminar", systemImage: "trash")
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.bordered)
                        .tint(.red)
                    }
                    .padding(.horizontal, 20)
                }
            }
            .padding(.top, 20)
        }
        .navigationTitle("📖 Reseña")
        .navigationBarTitleDisplayMode(.inline)
        .background(Color(.systemGroupedBackground))
    }
}

struct PosterView: View {
    var movie: Movie
    @EnvironmentObject var movieManager: MovieManager
    
    var body: some View {
        Group {
            if movie.poster.starts(with: "custom_"),
               let customImage = movieManager.customPosters[movie.poster] {
                Image(uiImage: customImage)
                    .resizable()
                    .scaledToFill()
            } else {
                Image(movie.poster)
                    .resizable()
                    .scaledToFill()
            }
        }
        .frame(width: 120, height: 180)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .shadow(radius: 5)
    }
}

struct InfoAndReviewsView: View {
    let movieName: String
    let rating: Double
    let review: [String]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(movieName)
                .font(.title.bold())
            
            Text("⭐ \(rating, specifier: "%.1f")")
                .font(.title2)
                .foregroundColor(.yellow)
            
            Divider().padding(.vertical, 5)
            
            Text("Reseñas de usuarios")
                .font(.headline)
                .foregroundColor(.gray)
            
            ReviewListView(review: review)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.white)
                .shadow(radius: 4)
        )
        .padding(.horizontal, 20)
    }
}

struct ReviewListView: View {
    let review: [String]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ForEach(review, id: \.self) { review in
                Text("• \(review)")
                    .font(.body)
                    .padding(.vertical, 2)
            }
        }
    }
}

struct ReviewSummaryView_Previews: PreviewProvider {
    static var previews: some View {
        let exampleMovie = Movie(
            userId: UUID(uuidString: "11111111-1111-1111-1111-111111111111")!,
            name: "Ejemplo de Película",
            poster: "placeholderPoster",
            rating: 4.5,
            review: [
                "¡Me encantó esta película!",
                "Podría ser mejor, pero es entretenida."
            ],
            location: "Cinepolis"
        )
        
        let auth = AuthManager(userManager: UserManager())
        auth.currentUser = User(
            name: "Daniel",
            lastName: "Nuno",
            email: "[email protected]",
            phone: "1234567890",
            username: "daniel.nuno",
            topGenre: "Acción"
        )
        
        return NavigationView {
            ReviewSummaryView(movie: exampleMovie)
                .environmentObject(auth)
                .environmentObject(MovieManager(userManager: UserManager()))
                .environmentObject(UserManager())
        }
    }
}

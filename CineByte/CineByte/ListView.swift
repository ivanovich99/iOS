//
//  ListView.swift
//  CineByte
//
//  Created by Daniel Nuno on 2/21/25.
//

import SwiftUI

import SwiftUI

struct ListView: View {
    @EnvironmentObject var movieManager: MovieManager
    @EnvironmentObject var authManager: AuthManager
    
    var sortedMovies: [Movie] {
        if let currentUserId = authManager.currentUser?.id {
            return movieManager.movies.sorted { movie1, movie2 in
                if movie1.userId == currentUserId && movie2.userId != currentUserId {
                    return true
                } else if movie1.userId != currentUserId && movie2.userId == currentUserId {
                    return false
                } else {
                    return movie1.name < movie2.name
                }
            }
        } else {
            return movieManager.movies
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottomTrailing) {
                ScrollView {
                    HeaderView()
                    
                    VStack(spacing: 20) {
                        ForEach(sortedMovies) { movie in
                            NavigationLink(destination: ReviewSummaryView(movie: movie)
                                            .environmentObject(authManager)
                                            .environmentObject(movieManager)) {
                                MovieCardView(movie: movie)
                                    .environmentObject(authManager)
                                    .environmentObject(movieManager)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding()
                }
                
                NavigationLink(destination: AddReviewView()
                                .environmentObject(authManager)
                                .environmentObject(movieManager)) {
                    Image(systemName: "plus")
                        .font(.system(size: 24, weight: .bold))
                        .padding(20)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .clipShape(Circle())
                        .shadow(radius: 5)
                }
                .padding(.trailing, 20)
                .padding(.bottom, 20)
            }
            .navigationTitle("🎬 Feed de Películas")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: ProfileView()
                                    .environmentObject(authManager)
                                    .environmentObject(movieManager)) {
                        Image(systemName: "gearshape.fill")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.black)
                    }
                }
            }
        }
    }
}


struct HeaderView: View {
    @EnvironmentObject var authManager: AuthManager

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("¡Hola, \(authManager.currentUser?.name ?? "Usuario")! 👋")
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(.blue)

            Text("Explora y comparte reseñas de películas")
                .font(.system(size: 16))
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.top, 10)
        .padding(.leading, 25)
    }
}


#Preview {
    let userManager = UserManager()
    let authManager = AuthManager(userManager: userManager)
    let movieManager = MovieManager(userManager: userManager)
    
    return ListView()
        .environmentObject(authManager)
        .environmentObject(movieManager)
        .environmentObject(userManager)
}

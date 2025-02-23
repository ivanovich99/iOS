//
//  MovieCardView.swift
//  CineByte
//
//  Created by Daniel Nuno on 2/22/25.
//

import SwiftUI

struct MovieCardView: View {
    var movie: Movie
    @EnvironmentObject var movieManager: MovieManager
    @EnvironmentObject var userManager: UserManager
    @EnvironmentObject var authManager: AuthManager

    var body: some View {
        HStack(alignment: .top, spacing: 15) {
            
            if movie.poster.starts(with: "custom_"),
               let customImage = movieManager.customPosters[movie.poster] {
                Image(uiImage: customImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 120, height: 180)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .shadow(radius: 5)
            } else {
                Image(movie.poster)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 120, height: 180)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .shadow(radius: 5)
            }
            
            VStack(alignment: .leading, spacing: 6) {
                Text(movie.name)
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(.primary)
                
                Text("⭐ \(movie.rating, specifier: "%.1f")")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.yellow)
                
                Text("Visualiza las reseñas que ha escrito \(userName)")
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
                    .lineLimit(2)
            }
            .padding(.vertical, 10)
            
            Spacer()
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(movie.userId == authManager.currentUser?.id ? Color.blue.opacity(0.1) : Color.white)
                .shadow(color: Color.gray.opacity(0.3), radius: 5, x: 0, y: 3)
        )
    }
    
    private var userName: String {
        if let user = userManager.users.first(where: { $0.id == movie.userId }) {
            return user.name
        }
        return "Desconocido"
    }
}

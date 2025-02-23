//
//  EditMovieView.swift
//  CineByte
//
//  Created by Daniel Nuno on 2/22/25.
//

import SwiftUI

struct EditMovieView: View {
    var movie: Movie
    @EnvironmentObject var authManager: AuthManager
    @EnvironmentObject var movieManager: MovieManager
    @Environment(\.dismiss) var dismiss

    @State private var movieName: String
    @State private var rating: Double
    @State private var location: String
    @State private var currentReview: String = ""
    @State private var reviews: [String]
    
    let locationOptions = ["Cinemex", "Cinepolis", "Casa", "Streaming"]
    
    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @State private var showImagePicker: Bool = false
    @State private var selectedImage: UIImage? = nil
    
    @State private var showAlert: Bool = false

    init(movie: Movie) {
        self.movie = movie
        _movieName = State(initialValue: movie.name)
        _rating = State(initialValue: movie.rating)
        _location = State(initialValue: movie.location)
        _reviews = State(initialValue: movie.review)
    }
    
    var body: some View {
        ZStack {
            Color(.systemGroupedBackground)
                .ignoresSafeArea()
            
            VStack {
                Form {
                    Section(header: Text("Información de la Película")
                                .font(.headline)) {
                        TextField("Nombre", text: $movieName)
                        
                        HStack {
                            Text("Calificación: \(rating, specifier: "%.1f")")
                            Slider(value: $rating, in: 0...5, step: 0.5)
                        }
                        
                        Picker("Ubicación", selection: $location) {
                            ForEach(locationOptions, id: \.self) { option in
                                Text(option)
                            }
                        }
                        
                        // Sección para agregar múltiples reseñas
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Reseñas:")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            HStack {
                                TextField("Agregar reseña", text: $currentReview)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                Button {
                                    if !currentReview.isEmpty {
                                        reviews.append(currentReview)
                                        currentReview = ""
                                    }
                                } label: {
                                    Image(systemName: "plus.circle")
                                }
                            }
                            if !reviews.isEmpty {
                                ForEach(reviews, id: \.self) { review in
                                    Text("• \(review)")
                                }
                                .padding(.top, 2)
                            }
                        }
                        .padding(.vertical, 8)
                    }
                    
                    Section(header: Text("Póster")) {
                        if let image = selectedImage {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 180)
                                .cornerRadius(8)
                        } else {
                            if movie.poster.starts(with: "custom_"),
                               let customImage = movieManager.customPosters[movie.poster] {
                                Image(uiImage: customImage)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 180)
                                    .cornerRadius(8)
                            } else {
                                Image(movie.poster)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 180)
                                    .cornerRadius(8)
                                    .opacity(0.7)
                            }
                        }
                    }
                    
                    Button {
                        sourceType = .photoLibrary
                        showImagePicker = true
                    } label: {
                        Label("Galería", systemImage: "photo")
                    }
                    
                    Button {
                        sourceType = .camera
                        showImagePicker = true
                    } label: {
                        Label("Cámara", systemImage: "camera")
                    }
                }
                .scrollContentBackground(.hidden)
                .background(Color.clear)
                .listStyle(InsetGroupedListStyle())
                
                Button {
                    guardarCambios()
                } label: {
                    Text("Guardar Cambios")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(10)
                        .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)
                }
                .padding(.horizontal)
                .padding(.vertical, 10)
            }
        }
        .navigationTitle("Editar Película")
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(sourceType: sourceType, selectedImage: $selectedImage)
        }
        .alert("Película Actualizada", isPresented: $showAlert) {
            Button("OK", role: .cancel) {
                // Llamamos a dismiss dos veces para retroceder dos niveles
                dismiss()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    dismiss()
                }
            }
        } message: {
            Text("Los cambios se han guardado correctamente.")
        }
    }
    
    private func guardarCambios() {
        guard let _ = authManager.currentUser else { return }
        
        let poster: String = (selectedImage != nil)
            ? "custom_\(formatMovieTitle(movieName))"
            : movie.poster
        
        let updatedMovie = Movie(
            userId: movie.userId,
            name: movieName,
            poster: poster,
            rating: rating,
            review: reviews,
            location: location
        )
        
        if let index = movieManager.movies.firstIndex(where: { $0.id == movie.id }) {
            movieManager.movies[index] = updatedMovie
        }
        
        if let newImage = selectedImage, poster.starts(with: "custom_") {
            movieManager.customPosters[poster] = newImage
        }
        
        showAlert = true
    }
    
    private func formatMovieTitle(_ title: String) -> String {
        title.lowercased().replacingOccurrences(of: " ", with: "-")
    }
}

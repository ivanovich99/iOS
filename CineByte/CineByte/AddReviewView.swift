//
//  AddReviewView.swift
//  CineByte
//
//  Created by Daniel Nuno on 2/21/25.
//

import SwiftUI

struct AddReviewView: View {
    @EnvironmentObject var authManager: AuthManager
    @EnvironmentObject var movieManager: MovieManager
    @Environment(\.dismiss) var dismiss

    @State private var movieName = ""
    @State private var rating = 3.0
    @State private var location = "Cinemex"
    @State private var currentReview = ""
    @State private var reviews: [String] = []
    
    let locationOptions = ["Cinemex", "Cinepolis", "Casa", "Streaming"]

    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @State private var showImagePicker = false
    @State private var selectedImage: UIImage? = nil

    @State private var showAlert = false

    var body: some View {
        ZStack {
            // Fondo uniforme
            Color(.systemGroupedBackground)
                .ignoresSafeArea()
            
            VStack {
                Form {
                    // Sección de información de la película
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
                            Image("default_poster")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 180)
                                .cornerRadius(8)
                                .opacity(0.7)
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
                    guardarReseña()
                } label: {
                    Text("Guardar Reseña")
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
        .navigationTitle("Agregar Reseña")
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(sourceType: sourceType, selectedImage: $selectedImage)
        }
        .alert("Película Agregada", isPresented: $showAlert) {
            Button("OK", role: .cancel) {
                dismiss()
            }
        } message: {
            Text("La película se agregó correctamente.")
        }
    }
    
    private func guardarReseña() {
            guard let user = authManager.currentUser else { return }
            
            let poster: String = (selectedImage != nil)
                ? "custom_\(formatMovieTitle(movieName))"
                : formatMovieTitle(movieName)
            
            let newMovie = Movie(
                userId: user.id,
                name: movieName,
                poster: poster,
                rating: rating,
                review: reviews,
                location: location
            )
            movieManager.addMovie(newMovie, customImage: selectedImage)
            
            movieName = ""
            rating = 3.0
            location = locationOptions.first ?? "Cinemex"
            reviews = []
            currentReview = ""
            selectedImage = nil
            
            showAlert = true
        }
    
    private func formatMovieTitle(_ title: String) -> String {
        return title.lowercased().replacingOccurrences(of: " ", with: "-")
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @Binding var selectedImage: UIImage?
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIViewController(context: Context) -> some UIViewController {
        let picker = UIImagePickerController()
        picker.sourceType = sourceType
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) { }
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker
        init(_ parent: ImagePicker) { self.parent = parent }
        
        func imagePickerController(_ picker: UIImagePickerController,
                                   didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.selectedImage = image
            }
            picker.dismiss(animated: true)
        }
    }
}

struct AddReviewView_Previews: PreviewProvider {
    static var previews: some View {
        let userManager = UserManager()
        let authManager = AuthManager(userManager: userManager)
        let movieManager = MovieManager(userManager: userManager)
        
        authManager.currentUser = User(
            name: "Daniel",
            lastName: "Nuno",
            email: "[email protected]",
            phone: "1234567890",
            username: "daniel.nuno",
            topGenre: "Acción"
        )
        
        return NavigationView {
            AddReviewView()
                .environmentObject(authManager)
                .environmentObject(movieManager)
        }
    }
}


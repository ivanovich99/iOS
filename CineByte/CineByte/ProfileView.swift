//
//  ProfileView.swift
//  CineByte
//
//  Created by Daniel Nuno on 2/21/25.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var authManager: AuthManager
    @State private var showUpdateAlert = false
    @Environment(\.dismiss) var dismiss
    var body: some View {
        if let user = authManager.currentUser {
            ZStack {
                Color(.systemGroupedBackground)
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    Form {
                        Section(header: Text("Información Personal")
                            .font(.headline)
                            .foregroundColor(.primary)
                        ) {
                            HStack {
                                Image(systemName: "person.fill")
                                    .foregroundColor(.gray)
                                TextField("Nombre", text: Binding(
                                    get: { user.name },
                                    set: { authManager.currentUser?.name = $0 }
                                ))
                                .autocapitalization(.words)
                            }
                            HStack {
                                Image(systemName: "person.fill")
                                    .foregroundColor(.gray)
                                TextField("Apellido", text: Binding(
                                    get: { user.lastName },
                                    set: { authManager.currentUser?.lastName = $0 }
                                ))
                                .autocapitalization(.words)
                            }
                            HStack {
                                Image(systemName: "envelope.fill")
                                    .foregroundColor(.gray)
                                TextField("Correo", text: Binding(
                                    get: { user.email },
                                    set: { authManager.currentUser?.email = $0 }
                                ))
                                .keyboardType(.emailAddress)
                                .autocapitalization(.none)
                            }
                            HStack {
                                Image(systemName: "phone.fill")
                                    .foregroundColor(.gray)
                                TextField("Teléfono", text: Binding(
                                    get: { user.phone },
                                    set: { authManager.currentUser?.phone = $0 }
                                ))
                                .keyboardType(.phonePad)
                            }
                            HStack {
                                Image(systemName: "person.crop.circle")
                                    .foregroundColor(.gray)
                                TextField("Usuario", text: Binding(
                                    get: { user.username },
                                    set: { authManager.currentUser?.username = $0 }
                                ))
                                .autocapitalization(.none)
                            }
                            HStack {
                                Image(systemName: "star.fill")
                                    .foregroundColor(.gray)
                                TextField("Género Favorito", text: Binding(
                                    get: { user.topGenre },
                                    set: { authManager.currentUser?.topGenre = $0 }
                                ))
                                .autocapitalization(.words)
                            }
                        }
                    }
                    .scrollContentBackground(.hidden)
                    .background(Color.clear)
                    .listStyle(.insetGrouped)
                    
                    Button(action: {
                        print("Perfil actualizado en el modelo")

                        showUpdateAlert = true
                    }) {
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
                    .padding(.vertical, 30)
                    .alert("Perfil Actualizado", isPresented: $showUpdateAlert) {
                        Button("OK", role: .cancel) {
                            dismiss()
                        }
                    } message: {
                        Text("Los cambios se han guardado correctamente.")
                    }
                }
            }
            .navigationTitle("Perfil")
        } else {
            Text("Por favor, inicia sesión.")
                .font(.title2)
                .foregroundColor(.gray)
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        let userManager = UserManager()
        let authManager = AuthManager(userManager: userManager)
        
        let sampleUser = User(
            name: "Daniel",
            lastName: "Nuno",
            email: "[email protected]",
            phone: "1234567890",
            username: "daniel.nuno",
            topGenre: "Ciencia Ficción"
        )
        
        authManager.currentUser = sampleUser
        
        return NavigationView {
            ProfileView()
                .environmentObject(authManager)
        }
    }
}

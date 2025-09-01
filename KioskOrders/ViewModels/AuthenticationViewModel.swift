import Foundation
import FirebaseAuth

class AuthenticationViewModel: ObservableObject {
    @Published var isAuthenticated = false
    @Published var currentUser: User?
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    init() {
        setupAuthListener()
    }
    
    private func setupAuthListener() {
        Auth.auth().addStateDidChangeListener { [weak self] _, user in
            DispatchQueue.main.async {
                self?.isAuthenticated = user != nil
                self?.currentUser = user
                print("🔐 Auth status: \(user != nil ? "Inloggad" : "Utloggad")")
            }
        }
    }
    
    func signIn(email: String, password: String) {
        isLoading = true
        errorMessage = nil
        
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                if let error = error {
                    self?.errorMessage = error.localizedDescription
                    print("❌ Inloggningsfel: \(error.localizedDescription)")
                    return
                }
                
                self?.isAuthenticated = true
                self?.currentUser = result?.user
                print("✅ Inloggad som: \(result?.user.email ?? "Okänd")")
            }
        }
    }
    
    func signUp(email: String, password: String, name: String) {
        isLoading = true
        errorMessage = nil
        
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                if let error = error {
                    self?.errorMessage = error.localizedDescription
                    print("❌ Registreringsfel: \(error.localizedDescription)")
                    return
                }
                
                guard let user = result?.user else { return }
                
                // Uppdatera användarnamn
                let changeRequest = user.createProfileChangeRequest()
                changeRequest.displayName = name
                changeRequest.commitChanges { error in
                    if let error = error {
                        self?.errorMessage = error.localizedDescription
                        print("❌ Namnfel: \(error.localizedDescription)")
                    } else {
                        self?.isAuthenticated = true
                        self?.currentUser = user
                        print("✅ Registrerad som: \(name) (\(user.email ?? "Okänd"))")
                    }
                }
            }
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            isAuthenticated = false
            currentUser = nil
            print("✅ Utloggad")
        } catch {
            errorMessage = error.localizedDescription
            print("❌ Utloggningsfel: \(error.localizedDescription)")
        }
    }
}
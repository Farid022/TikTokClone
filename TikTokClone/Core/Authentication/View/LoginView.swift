import SwiftUI

struct LoginView: View {
    private let service: AuthService
    @StateObject private var viewModel: LoginViewModel
    @Environment(\.dismiss) var dismiss
    
    init(service: AuthService) {
        self.service = service
        self._viewModel = StateObject(wrappedValue: LoginViewModel(service: service))
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                
                // Set the background color to white
                // You can also use Color(UIColor.white) instead of .white if needed
                .background(Color.white)
                
                Text("Hello again!")
                    .fontWeight(.heavy)
                    .font(Font(CTFont(.alertHeader, size: 35)))
                    .padding(.top, 50)
                
                Text("Welcome back you've\n been missed")
                    .fontWeight(.medium)
                    .font(Font(CTFont(.alertHeader, size: 25)))
                    .padding(.top, 15)
                    .padding(.bottom, 20)
                    .multilineTextAlignment(.center)
                
                VStack {
                    TextField("Enter your email", text: $viewModel.email)
                        .autocapitalization(.none)
                        .modifier(StandardTextFieldModifier())
                    
                    SecureField("Enter your password", text: $viewModel.password)
                        .modifier(StandardTextFieldModifier())
                }
                
                NavigationLink(destination: ForgotPasswordView()) {
                    Text("Forgot Password?")
                        .font(.footnote)
                        .fontWeight(.semibold)
                        .padding(.top)
                        .padding(.trailing, 28)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }
                
                GeometryReader { geometry in
                    Button {
                        Task {
                            await viewModel.login()
                            dismiss()
                        }
                    } label: {
                        Text(viewModel.isAuthenticating ? "" : "Login")
                            .foregroundColor(.white)
                            .modifier(StandardButtonModifier())
                            .overlay {
                                if viewModel.isAuthenticating {
                                    ProgressView()
                                        .tint(.white)
                                }
                            }
                    }
                    .frame(width: geometry.size.width, height: 60) // Set the button height to 60
                    .disabled(viewModel.isAuthenticating || !formIsValid)
                    .opacity(formIsValid ? 1 : 0.7)
                    .padding(.vertical)
                }
               
                Spacer()
                Divider()

                NavigationLink {
                    RegistrationView(service: service)
                        .navigationBarBackButtonHidden()
                } label: {
                    HStack(spacing: 3) {
                        Text("Don't have an account?")
                        
                        Text("Sign Up")
                            .fontWeight(.semibold)
                    }
                    .font(.footnote)
                }
                .padding(.vertical, 16)
            }
            Image("Flow-app-icon")
                .renderingMode(.template)
                .resizable()
                .scaledToFit()
                .frame(width: 30, height: 30)
                .padding(.vertical, 5)
        }
        .background(Color.white) // Set the background color to white for the entire VStack
        .edgesIgnoringSafeArea(.all) // Ignore safe area edges to ensure a completely white background
        .preferredColorScheme(.light) // Ignore dark mode
        .alert(isPresented: $viewModel.showAlert) {
            Alert(title: Text("Error"),
                  message: Text(viewModel.authError?.description ?? "Please try again.."))
        }
    }
}

extension LoginView: AuthenticationFormProtocol {
    var formIsValid: Bool {
        return !viewModel.email.isEmpty
            && viewModel.email.contains("@")
            && !viewModel.password.isEmpty
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(service: AuthService())
    }
}

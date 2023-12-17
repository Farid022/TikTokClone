import SwiftUI
import WebKit

// Create a custom WebView component conforming to UIViewControllerRepresentable
struct WebView: UIViewControllerRepresentable {
    let url: URL

    func makeUIViewController(context: Context) -> WebViewController {
        let webViewController = WebViewController()
        webViewController.url = url
        return webViewController
    }

    func updateUIViewController(_ uiViewController: WebViewController, context: Context) {
        uiViewController.url = url
    }
}

class WebViewController: UIViewController, WKNavigationDelegate {
    var webView: WKWebView!
    var url: URL!

    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let request = URLRequest(url: url)
        webView.load(request)
    }

    // You can implement WKNavigationDelegate methods if needed
    // For example, you can handle loading events or errors here
}

struct RegistrationView: View {
    @StateObject var viewModel: RegistrationViewModel
    @Environment(\.dismiss) var dismiss

    @State private var isPresentWebView = false

    init(service: AuthService) {
        self._viewModel = StateObject(wrappedValue: RegistrationViewModel(service: service))
    }

    var body: some View {
        VStack {
//            Spacer()

            // Logo image
//            Image("1024")
//                .resizable()
//                .scaledToFit()
//                .frame(width: 120, height: 120)
//                .padding()
            
            Text("Welcome to Flow")
                .fontWeight(.heavy)
                .font(Font(CTFont(.alertHeader, size: 35)))
                .padding(.top, 50)
            
            Text("Create a new account!")
                .fontWeight(.medium)
                .font(Font(CTFont(.alertHeader, size: 25)))
                .padding(.top, 15)
                .padding(.bottom, 20)
                .multilineTextAlignment(.center)
            
            // Text fields
            VStack {
                TextField("Enter your email", text: $viewModel.email)
                    .autocapitalization(.none)
                    .modifier(StandardTextFieldModifier())

                SecureField("Enter your password", text: $viewModel.password)
                    .modifier(StandardTextFieldModifier())

                TextField("Enter your full name", text: $viewModel.fullname)
                    .autocapitalization(.none)
                    .modifier(StandardTextFieldModifier())

                TextField("Enter your username", text: $viewModel.username)
                    .autocapitalization(.none)
                    .modifier(StandardTextFieldModifier())
            }

            Spacer()

            Text("By continuing you accept our")
                .foregroundColor(.gray)

            Button("Terms and Privacy Policy") {
                isPresentWebView = true
            }
            .font(.footnote)
            .foregroundColor(.gray)
            .padding(.vertical, 8)
            .sheet(isPresented: $isPresentWebView) {
                NavigationView {
                    WebView(url: URL(string: "https://greyhound-grouper-2wn9.squarespace.com/terms")!)
                        .navigationBarTitle("Terms and Privacy Policy", displayMode: .inline)
                        .navigationBarItems(trailing: Button("Close") {
                            isPresentWebView = false
                        })
                }
            }

            Button {
                Task { try await viewModel.createUser() }
            } label: {
                ZStack {
                    Text(viewModel.isAuthenticating ? "" : "Sign up")
                        .modifier(StandardButtonModifier())

                    if viewModel.isAuthenticating {
                        ProgressView()
                            .tint(.white)
                    }
                }
            }
            .disabled(viewModel.isAuthenticating || !formIsValid)
            .opacity(formIsValid ? 1 : 0.7)
            .padding(.vertical)

            Spacer()

            Divider()

            Button {
                dismiss()
            } label: {
                HStack(spacing: 3) {
                    Text("Already have an account?")
                    Text("Sign in")
                        .fontWeight(.semibold)
                }
                .font(.footnote)
            }
            .padding(.vertical, 16)
        }
        .alert(isPresented: $viewModel.showAlert) {
            Alert(
                title: Text("Error"),
                message: Text(viewModel.authError?.description ?? "")
            )
        }
    }
}

// MARK: - Form Validation

extension RegistrationView: AuthenticationFormProtocol {
    var formIsValid: Bool {
        return !viewModel.email.isEmpty
            && viewModel.email.contains("@")
            && !viewModel.password.isEmpty
            && !viewModel.fullname.isEmpty
            && viewModel.password.count > 5
    }
}

struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationView(service: AuthService())
    }
}

//
//  ForgotPasswordView.swift
//  TikTokClone
//
//  Created by Herbert Perryman on 12/13/23.
//

import Foundation
import SwiftUI

struct ForgotPasswordView: View {
    @StateObject var viewModel = ForgotPasswordViewModel()
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
//            Spacer()
            
//            Image("1024")
//                .renderingMode(.template)
//                .resizable()
            //                .colorMultiply(Color.theme.primaryText)
//                .scaledToFit()
//                .frame(width: 120, height: 120)
//                .padding()
            
            Text("Forgot password?")
                .fontWeight(.heavy)
                .font(Font(CTFont(.alertHeader, size: 35)))
                .padding(.top, 50)
            
            Text("Reset below")
                .fontWeight(.medium)
                .font(Font(CTFont(.alertHeader, size: 25)))
                .padding(.top, 15)
                .padding(.bottom, 20)
                .multilineTextAlignment(.center)
            
            VStack {
                TextField("Enter your email", text: $viewModel.email)
                    .autocapitalization(.none)
                    .padding(.horizontal)
                    .frame(height: 50)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray, lineWidth: 1)
                    )
                    .padding(.horizontal)
                
                Button {
                    
                    Task { try await viewModel.sendPasswordResetEmail() }
                } label: {
                    
                    Text("Reset Password")
                    //                    .foregroundColor(Color.theme.primaryBackground)
                    //                    .modifier(ThreadsButtonModifier())
                    
                }
                .padding(.vertical)
                
                Spacer()
                
                Divider()
                
                Button {
                    dismiss()
                } label: {
                    
                    Text("Return to login")
                    //                    .foregroundColor(Color.theme.primaryText)
                        .font(.footnote)
                }
                .padding(.vertical, 16)
            }
            .alert(isPresented: $viewModel.didSendEmail) {
                Alert(
                    title: Text("Email sent"),
                    message: Text("An email has been sent to \(viewModel.email) to reset your password."),
                    dismissButton: .default(Text("Ok"), action: {
                        dismiss()
                    })
                )
            }
        }
    }
    
    struct ForgotPasswordView_Previews: PreviewProvider {
        static var previews: some View {
            ForgotPasswordView()
        }
    }
}

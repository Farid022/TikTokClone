import SwiftUI
import AVFoundation

struct UploadPostView: View {
    let movie: Movie
    @ObservedObject var viewModel: UploadPostViewModel
    @Environment(\.dismiss) var dismiss
    @Binding var tabIndex: Int
    @State private var isCaptionEmptyAlertPresented = false // State variable to control the caption error alert
    @State private var isInvalidDurationAlertPresented = false // State variable to control the duration error alert
    @State private var isInvalidFileSizeAlertPresented = false // State variable to control the file size error alert

    var body: some View {
        VStack {
            HStack(alignment: .top) {
                TextField("Enter your caption..", text: $viewModel.caption, axis: .vertical)
                    .font(.subheadline)

                Spacer()

                if let uiImage = MediaHelpers.generateThumbnail(path: movie.url.absoluteString) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 88, height: 100)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
            }

            Divider()

            Spacer()

            Button {
                Task {
                    if !viewModel.caption.isEmpty && isValidDuration(movie.url) && isValidFileSize(movie.url) {
                        await viewModel.uploadPost()
                        tabIndex = 0
                        viewModel.reset()
                        dismiss()
                    } else {
                        if viewModel.caption.isEmpty {
                            isCaptionEmptyAlertPresented = true
                        }
                        if !isValidDuration(movie.url) {
                            isInvalidDurationAlertPresented = true
                        }
                        if !isValidFileSize(movie.url) {
                            isInvalidFileSizeAlertPresented = true
                        }
                    }
                }
            } label: {
                Text(viewModel.isLoading ? "" : "Post")
                    .modifier(StandardButtonModifier())
                    .overlay {
                        if viewModel.isLoading {
                            ProgressView()
                                .tint(.white)
                        }
                    }
            }
            .disabled(viewModel.isLoading)
        }
        .padding()
        .navigationTitle("Post")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                }
            }
        }
        .alert(isPresented: $isCaptionEmptyAlertPresented) {
            Alert(title: Text("Caption is required"), message: Text("Please enter a caption before posting."), dismissButton: .default(Text("OK")))
        }
        .alert(isPresented: $isInvalidDurationAlertPresented) {
            Alert(title: Text("Invalid Video Duration"), message: Text("Uploaded videos must be between 2 - 3.01 minutes in duration."), dismissButton: .default(Text("OK")))
        }
        .alert(isPresented: $isInvalidFileSizeAlertPresented) {
            Alert(title: Text("File Size Exceeded"), message: Text("Uploaded video file size cannot exceed 1GB."), dismissButton: .default(Text("OK")))
        }
    }
    
    // Function to validate video duration (3.01 minutes)
    func isValidDuration(_ videoURL: URL) -> Bool {
        let asset = AVAsset(url: videoURL)
        let durationInSeconds = CMTimeGetSeconds(asset.duration)
        return durationInSeconds >= 120 && durationInSeconds <= 181.5 // 3.01 minutes
    }
    
    // Function to validate file size (1GB limit)
    func isValidFileSize(_ fileURL: URL) -> Bool {
        if let fileSize = try? FileManager.default.attributesOfItem(atPath: fileURL.path)[.size] as? Int64 {
            let fileSizeInBytes = fileSize
            let fileSizeInGB = Double(fileSizeInBytes) / 1024 / 1024 / 1024
            return fileSizeInGB <= 1.0 // Check if file size is less than or equal to 1GB
        }
        return false
    }
}

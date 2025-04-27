//
//  ContentView.swift
//  Task Fortress
//
//  Created by Gregory Lucas-Smith on 27/4/2025.
//

import SwiftUI

struct ContentView: View {
    @State private var jsonData: String = "{\n  \"key\": \"value\"\n}"
    @State private var errorMessage: String? = nil

    var body: some View {
        VStack(alignment: .leading) {
            Text("JSON Editor")
                .font(.headline)

            TextEditor(text: $jsonData)
                .border(Color.gray, width: 1)
                .padding()
                .onChange(of: jsonData) { newValue in
                    validateJSON(newValue)
                }

            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding(.horizontal)
            }

            Spacer()
        }
        .padding()
    }

    private func validateJSON(_ text: String) {
        let data = text.data(using: .utf8)
        do {
            if let data = data {
                _ = try JSONSerialization.jsonObject(with: data, options: [])
                errorMessage = nil
            } else {
                errorMessage = "Invalid JSON format."
            }
        } catch {
            errorMessage = "Error: \(error.localizedDescription)"
        }
    }
}

#Preview {
    ContentView()
}

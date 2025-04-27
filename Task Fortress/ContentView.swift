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

    private let fileName = "jsonData.json"

    var body: some View {
        VStack(alignment: .leading) {
            Text("JSON Editor")
                .font(.headline)

            TextEditor(text: $jsonData)
                .border(Color.gray, width: 1)
                .padding()
                .onChange(of: jsonData) { newValue in
                    validateJSON(newValue)
                    saveJSONToFile(newValue)
                }

            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding(.horizontal)
            }

            Spacer()
        }
        .padding()
        .onAppear {
            loadJSONFromFile()
        }
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

    private func getDocumentsDirectory() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }

    private func saveJSONToFile(_ json: String) {
        let fileURL = getDocumentsDirectory().appendingPathComponent(fileName)
        do {
            try json.write(to: fileURL, atomically: true, encoding: .utf8)
        } catch {
            errorMessage = "Failed to save JSON: \(error.localizedDescription)"
        }
    }

    private func loadJSONFromFile() {
        let fileURL = getDocumentsDirectory().appendingPathComponent(fileName)
        do {
            let savedData = try String(contentsOf: fileURL, encoding: .utf8)
            jsonData = savedData
        } catch {
            errorMessage = "Failed to load JSON: \(error.localizedDescription)"
        }
    }
}

#Preview {
    ContentView()
}

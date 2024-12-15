import Foundation

struct InputFetcher {
    static let inputDirectory = "Inputs"  // directory where input files are stored
    static let baseURL = "https://adventofcode.com/2024/day"  // Adjust year as needed

    // Your AoC session cookie.
    // You can store it in environment variables (e.g., AOC_SESSION) and read it in at runtime.
    static let sessionToken: String = {
        guard let token = ProcessInfo.processInfo.environment["AOC_SESSION"] else {
            fatalError("AOC_SESSION environment variable not set.")
        }
        return token
    }()
    
    static func fetchInput(for day: Int) -> String {
        let dayString = String(format: "%02d", day)
        let inputFilePath = "\(inputDirectory)/day\(dayString).txt"

        // Check if input file exists locally
        if FileManager.default.fileExists(atPath: inputFilePath),
           let contents = try? String(contentsOfFile: inputFilePath, encoding: .utf8) {
            return contents
        }

        // If not, we need to download it
        let inputURL = URL(string: "\(baseURL)/\(day)/input")!
        var request = URLRequest(url: inputURL)
        request.addValue("session=\(sessionToken)", forHTTPHeaderField: "Cookie")

        let semaphore = DispatchSemaphore(value: 0)
        var result: String?
        var downloadError: Error?

        URLSession.shared.dataTask(with: request) { data, _, error in
            // Capture results in local constants first
            let localResult: String?
            let localError: Error?

            if let error = error {
                // Network or request error
                localError = error
                localResult = nil
            } else if let data = data,
                      let inputString = String(data: data, encoding: .utf8) {
                // Successfully downloaded input
                localResult = inputString
                do {
                    try FileManager.default.createDirectory(atPath: inputDirectory, withIntermediateDirectories: true)
                    try inputString.write(toFile: inputFilePath, atomically: true, encoding: .utf8)
                    localError = nil
                } catch {
                    // File write error
                    localError = error
                }
            } else {
                // Data was nil or decoding failed
                localError = NSError(domain: "InputFetch", code: 1,
                                     userInfo: [NSLocalizedDescriptionKey: "Failed to decode input"])
                localResult = nil
            }

            // Synchronize mutations back on the main queue
            DispatchQueue.main.sync {
                result = localResult
                downloadError = localError
            }
            semaphore.signal()
        }.resume()

        semaphore.wait()

        if let error = downloadError {
            fatalError("Failed to download input: \(error.localizedDescription)")
        }

        return result ?? ""
    }
}

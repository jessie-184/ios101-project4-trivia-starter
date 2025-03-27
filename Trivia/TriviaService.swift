
import Foundation

struct TriviaResponse: Decodable {
    let results: [TriviaQuestion]
}

class TriviaService {
    static func fetchTrivia(category: String, difficulty: String, type: String, encoding: String, completion: @escaping ([TriviaQuestion]?, Error?) -> Void) {
        var urlString = "https://opentdb.com/api.php?amount=10"
        
        if !category.isEmpty {
            urlString += "&category=\(category)"
        }
        if !difficulty.isEmpty {
            urlString += "&difficulty=\(difficulty)"
        }
        if !type.isEmpty {
            urlString += "&type=\(type)"
        }
        if !encoding.isEmpty {
            urlString += "&encode=\(encoding)"
        }
        print("Fetching trivia questions from URL: \(urlString)")
        guard let url = URL(string: urlString) else {
            let error = NSError(domain: "Invalid URL", code: -1, userInfo: nil)
            completion(nil, error)
            print("error1")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                if let error = error {
                    completion(nil, error)
                } else {
                    let error = NSError(domain: "No data received", code: -1, userInfo: nil)
                    completion(nil, error)
                }
                return
            }
            do {
                let decoder = JSONDecoder()
                let triviaResponse = try decoder.decode(TriviaResponse.self, from: data)
                completion(triviaResponse.results, nil)
                print("result:", triviaResponse)
            } catch {
                print("error:", error)
                completion(nil, error)
            }
        }
        task.resume()
    }
}

import Foundation

protocol NetworkManagerDescription {
    func fetchNews(page: Int, language: String, completion: @escaping (Result<Item, Error>) -> Void)
}

class NetworkManager: NetworkManagerDescription {
    static let shared = NetworkManager()
    
    private init() {}
        
    func fetchNews(page: Int, language: String, completion: @escaping (Result<Item, Error>) -> Void) {
        let url = URL(string: "https://newsapi.org/v2/top-headlines?language=\(language)&page=\(page)&apiKey=\(Keys.key)")
        guard let saveUrl = url else {
            return
        }
        let decoder = JSONDecoder()
        let task = URLSession.shared.dataTask(with: saveUrl) { (data, response, error) in
            guard let data = data else { return }
            do {
                let news = try decoder.decode(Item.self, from: data)
                completion(.success(news))
            } catch (let error) {
                print(error)
            }
        }
        task.resume()
    }
}

import Foundation

protocol MainPresenterProtocol {
    func loadData(page: Int)
    
    var newsCount: Int { get }
    func getNews() -> [Article]
    func getNews(by index: Int) -> Article?
}

class MainPresenter: MainPresenterProtocol {
    
    // MARK: - Properties
    
    private weak var mainView: MainViewProtocol?
    
    private var networkManager: NetworkManagerDescription = NetworkManager.shared
    
    var news = [Article]()
    
    var newsCount: Int {
        news.count
    }
        
    // MARK: - Init
    
    init(mainView: MainViewProtocol) {
        self.mainView = mainView
    }
    
    // MARK: - Handlers
    
    func loadData(page: Int) {
        networkManager.fetchNews(page: page, language: "en") { [weak self] (res) in
            switch res {
            case .success(let items):
                self?.news.append(contentsOf: items.articles ?? [])
                self?.mainView?.reloadView()
            case .failure(let err):
                print(err)
            }
        }
    }
    
    func getNews() -> [Article] {
        return news
    }
    
    func getNews(by index: Int) -> Article? {
        return index < news.count ? news[index] : nil
    }
}

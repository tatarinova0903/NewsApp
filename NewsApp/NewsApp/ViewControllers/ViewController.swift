import UIKit
import PinLayout

protocol MainViewProtocol: AnyObject {
    func reloadView()
}

class ViewController: UIViewController {
    
    // MARK: - Properties
    
    private var presenter: MainPresenterProtocol?
    
    private let tableView = UITableView()
    
    private var page: Int = 1
    
    // MARK: - Init
    
    init() {
        super.init(nibName: nil, bundle: nil)
        presenter = MainPresenter(mainView: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Override functions

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Marvel's comics"
        view.addSubview(tableView)
        configureTableView()
        presenter?.loadData(page: page)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.pin
            .all()
    }
    
    // MARK: - Configures
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    // MARK: - Handlers

}

// MARK: - Extenstons

extension ViewController: MainViewProtocol {
    func reloadView() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter?.newsCount ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = presenter?.getNews(by: indexPath.row)?.title
        return cell
    }
    
    
}

extension ViewController: UITableViewDelegate {
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView.contentOffset.y > scrollView.contentSize.height - scrollView.frame.size.height {
            page += 1
            presenter?.loadData(page: page)
        }
    }
}




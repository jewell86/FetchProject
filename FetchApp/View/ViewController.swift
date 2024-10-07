import UIKit

internal class ViewController: UIViewController {
    private struct Identifiers {
        static let tableView = "TableView"
        static let tableViewCell = "TableViewCell"
        static let emptyTableViewCell = "EmptyTableViewCell"
        static let errorBanner = "ErrorBanner"
    }
    
    // MARK: UI elements
    
    internal lazy var tableView: UITableView = {
        let tableView = UITableView()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.accessibilityLabel = Identifiers.tableView
        
        tableView.register(
            TableViewCell.self,
            forCellReuseIdentifier: Identifiers.tableViewCell
        )
        
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(didRefresh), for: .valueChanged)
        if let refreshControl {
            tableView.addSubview(refreshControl)
        }
        
        return tableView
    }()
    
    // MARK: Internal properties
    
    // MARK: Private properties
    
    private var viewModel: ViewModel?
    private var photoCache: PhotoCache?
    private var refreshControl: UIRefreshControl?

    private(set) var recipes: [Recipe]? {
        didSet {
            tableView.reloadData()
            refreshControl?.endRefreshing()
        }
    }
    
    // MARK: Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white

        loadTableView()
        viewModel?.receive(event: .getRecipes)
    }
    
    // MARK: Internal methods
    
    init(viewModel: ViewModel, photoCache: PhotoCache) {
        super.init(nibName: nil, bundle: nil)
        
        self.photoCache = photoCache
        self.viewModel = viewModel
        viewModel.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    internal func showError() {
        if view.subviews.first(where: { $0.accessibilityIdentifier == Identifiers.errorBanner }) == nil {
            let errorBanner = ErrorBanner(errorMessage: "Recipes not available")
            errorBanner.frame = CGRect(x: 16, y: 100, width: view.bounds.width - 32, height: 50)
            errorBanner.accessibilityIdentifier = Identifiers.errorBanner
            errorBanner.accessibilityLabel = Identifiers.errorBanner
            view.addSubview(errorBanner)
        }
        
        refreshControl?.endRefreshing()
    }
    
    // MARK: Private methods
    
    private func loadTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    @objc private func didRefresh() {
        self.viewModel?.receive(event: .getRecipes)
    }
}

// MARK: ViewModelDelegate conformance

extension ViewController: ViewModelDelegate {
    internal func loadRecipes(recipes: [Recipe]) {
        self.recipes = recipes
    }
}

// MARK: TableView conformance

extension ViewController: UITableViewDelegate { }

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let recipeCount = recipes?.count, recipeCount > 0 {
            return recipeCount
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let recipes, recipes.indices.contains(indexPath.row) else {
            if recipes?.isEmpty == true {
                /** Empty directory cell */
                let cell = UITableViewCell(text: "No recipes in this directory")
                cell.accessibilityLabel = Identifiers.emptyTableViewCell
                cell.textLabel?.adjustsFontForContentSizeCategory = true
                return cell
            } else {
                /** Possible index out of bounds */
                return UITableViewCell()
            }
        }
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Identifiers.tableViewCell, for: indexPath) as? TableViewCell else {
            return UITableViewCell()
        }
        
        let recipe = recipes[indexPath.row]

        /** Image loagind - currentTask ensures that the cell gets the correct image,, and that images are reloaded correctly upon reuse  */
        let currentTask = Task {
            if let photoURL = recipe.smallPhoto, let photo = try await photoCache?.getPhoto(from: photoURL) {
                if tableView.indexPath(for: cell) == indexPath {
                    cell.photoView.image = photo
                }
            }
        }
        
        cell.accessibilityLabel = Identifiers.tableViewCell
        cell.configure(title: recipe.name, cuisine: recipe.cuisine)
        
        cell.currentTask?.cancel()
        cell.currentTask = currentTask
        
        return cell
    }
}

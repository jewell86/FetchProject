import Foundation

internal protocol ViewModelDelegate: AnyObject {
    func loadRecipes(recipes: [Recipe])
    func showError()
}

internal enum ViewEvent {
    case getRecipes
}

internal class ViewModel {
    private var service: ServiceProtocol
    internal weak var delegate: ViewModelDelegate?
    
    init(service: ServiceProtocol) {
        self.service = service
    }
    
    internal func receive(event: ViewEvent) {
        switch event {
        case .getRecipes:
            Task {
                do {
                    let recipes = try await service.getRecipes()
                    DispatchQueue.main.async {
                        self.delegate?.loadRecipes(recipes: recipes)
                    }
                } catch {
                    print("Failed to get recipes. Error: \(error)")
                    DispatchQueue.main.async {
                        self.delegate?.showError()
                    }
                }
            }
        }
    }
}

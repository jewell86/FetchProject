import Foundation
import UIKit

@testable import FetchApp

class MockURLSession: URLSessionProtocol {
    var data: Data?
    
    func data(from url: URL) async throws -> (Data, URLResponse) {
        guard let data = data else {
            throw URLError(.badServerResponse)
        }
        return (data, URLResponse())
    }
}

class MockViewModel: ViewModel {
    var didReceiveEvent: ((ViewEvent) -> Void)?
    
    override func receive(event: ViewEvent) {
        didReceiveEvent?(event)
    }
}

class MockService: ServiceProtocol {
    var shouldThrowError = false
    var photo: UIImage?
    var mockRecipes: [Recipe] = []
    
    func getRecipes() async throws -> [Recipe] {
        if shouldThrowError {
            throw URLError(.badServerResponse)
        }
        return mockRecipes
    }
    
    func getPhoto(from photoString: String) async throws -> UIImage? {
        if shouldThrowError {
            throw NSError()
        }
        return photo ?? nil
    }
}

class MockDelegate: ViewModelDelegate {
    var loadedRecipes: [Recipe]?
    var receivedError = false
    
    func loadRecipes(recipes: [Recipe]) {
        loadedRecipes = recipes
    }
    
    func showError() {
        receivedError = true
    }
}

// MARK: PhotoCache

final class MockPhotoCache: PhotoCache {
    var mockPhotos: [String: UIImage] = [:]
    var didReceiveGetPhoto = false
    
    override func getPhoto(from photoString: String) async -> UIImage? {
        didReceiveGetPhoto = true
        return mockPhotos[photoString]
    }
}

func mockRecipe() -> Recipe {
    return Recipe(
        cuisine: "dinner",
        name: "Chicken",
        smallPhoto: "www.large.com",
        largePhoto: "www.small.com",
        sourceURL: nil,
        uuid: "123",
        youtubeURl: nil
    )
}

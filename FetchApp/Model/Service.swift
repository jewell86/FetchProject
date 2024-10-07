import Foundation
import UIKit


protocol URLSessionProtocol {
    func data(from url: URL) async throws -> (Data, URLResponse)
}

extension URLSession: URLSessionProtocol {}

protocol ServiceProtocol {
    func getRecipes() async throws -> [Recipe]
    func getPhoto(from photoString: String) async throws -> UIImage?
}

internal class Service: ServiceProtocol {
    private struct Endpoints {
        static let recipesEndpoint = "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json"
        static let emptyResonseEndpoint = "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-empty.json"
        static let malformedResponseEndpoing = "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-malformed.json"
    }
    
    private var isAppLaunch: Bool = true
    private let session: URLSessionProtocol
    
    init(session: URLSessionProtocol) {
        self.session = session
    }
    
    internal func getRecipes() async throws -> [Recipe] {
        let randomEndpoint = try getRandomEndpointURL()
        
        do {
            let (serviceResponse, _) = try await session.data(from: randomEndpoint)
            let recipeResponseModel = try JSONDecoder().decode(RecipeResponse.self, from: serviceResponse)
            return recipeResponseModel.recipes
        }
        catch {
            throw error
        }
    }
    
    internal func getPhoto(from photoString: String) async throws -> UIImage? {
        guard let photoURL = URL(string: photoString) else {
            throw URLError(.badURL)
        }
        
        do {
            let (serviceResponse, _) = try await session.data(from: photoURL)
            return UIImage(data: serviceResponse)
        }
        catch {
            throw error
        }
    }
    
    /** Randomize endpoints to simulate different scenarios */
    private func getRandomEndpointURL() throws -> URL {
        var endpoints = [Endpoints.recipesEndpoint, Endpoints.emptyResonseEndpoint, Endpoints.malformedResponseEndpoing]
        
        /** On first app launch, call the happy path endpoint */
        if isAppLaunch { endpoints = [Endpoints.recipesEndpoint] }
        isAppLaunch = false
        
        /** On refresh, randomize endpoints to simulate different responses */
        guard let randomEndpoint = endpoints.randomElement(), let randomEndpointURL = URL(string: randomEndpoint) else {
            throw URLError(.badURL)
        }
        /** Print which endpoint was called */
        print("Endpoint: " + randomEndpoint)
        
        return randomEndpointURL
    }
}

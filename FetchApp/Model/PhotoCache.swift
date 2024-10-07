import Foundation
import UIKit

internal class PhotoCache {
    internal let cache = NSCache<NSString, UIImage>()
    private let service: ServiceProtocol
    
    init(service: ServiceProtocol) {
        self.service = service
    }
    
    internal func getPhoto(from photoString: String) async throws -> UIImage? {
        /** Cached photo is available */
        if let cachedPhoto = cache.object(forKey: photoString as NSString) {
            return cachedPhoto
        }
        
        /** Cached photo NOT available, try service */
        do {
            if let photo = try await service.getPhoto(from: photoString) {
                self.cache.setObject(photo, forKey: photoString as NSString)
                return photo
            }
        } catch {
            print("Error loading image. Error: \(error)")
        }
        
        return nil
    }
}

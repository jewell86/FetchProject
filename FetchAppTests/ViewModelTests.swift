import XCTest
@testable import FetchApp

class ViewModelTests: XCTestCase {
    var subject: ViewModel!
    var mockService: MockService!
    var mockDelegate: MockDelegate!
    
    override func setUp() {
        super.setUp()
        
        mockService = MockService()
        mockDelegate = MockDelegate()
        subject = ViewModel(service: mockService)
        subject.delegate = mockDelegate
    }
    
    override func tearDown() {
        subject = nil
        mockService = nil
        mockDelegate = nil
        
        super.tearDown()
    }
    
    func test_getRecipesSuccess() async {
        let expectedRecipes = [mockRecipe(), mockRecipe()]
        mockService.mockRecipes = expectedRecipes
        let asyncTimeout = XCTestExpectation(description: "getRecipes timeout")
        
        subject.receive(event: .getRecipes)
        asyncTimeout.fulfill()
        
        await fulfillment(of: [asyncTimeout], timeout: 1)
        XCTAssertEqual(mockDelegate.loadedRecipes, expectedRecipes)
    }
    
    // TODO: Fix test
    func test_getEmptyRecipes() async {
        // Given
        let expectedRecipes = [Recipe]()
        mockService.mockRecipes = expectedRecipes
        let asyncTimeout = XCTestExpectation(description: "getRecipes timeout")
        
        // When
        subject.receive(event: .getRecipes)
        asyncTimeout.fulfill()
        
        // Then
        await fulfillment(of: [asyncTimeout], timeout: 1)
        XCTAssertEqual(mockDelegate.loadedRecipes, nil)
    }
    
    // TODO: Fix test
    func test_getRecipesFailure() async {
        // Given
        mockService.shouldThrowError = true
        let asyncTimeout = XCTestExpectation(description: "getRecipes timeout")

        // When
        subject.receive(event: .getRecipes)
        asyncTimeout.fulfill()
        
        // Then
        await fulfillment(of: [asyncTimeout], timeout: 5)
        XCTAssertEqual(mockDelegate.receivedError, false)
    }
}

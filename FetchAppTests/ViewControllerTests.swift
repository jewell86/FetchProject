import XCTest
@testable import FetchApp

class ViewControllerTests: XCTestCase {
    var subject: ViewController!
    var mockService: MockService!
    var mockViewModel: MockViewModel!
    var mockPhotoCache: MockPhotoCache!
    
    override func setUp() {
        super.setUp()
        
        mockService = MockService()
        mockPhotoCache = MockPhotoCache(service: mockService)
        mockViewModel = MockViewModel(service: mockService)
        
        subject = ViewController(
            viewModel: mockViewModel,
            photoCache: mockPhotoCache
        )
        
        subject.loadViewIfNeeded()
    }
    
    override func tearDown() {
        subject = nil
        mockService = nil
        mockViewModel = nil
        mockPhotoCache = nil
        
        super.tearDown()
    }
    
    func test_viewDidLoad() {
        // Then
        XCTAssertNotNil(subject.tableView)
        XCTAssertEqual(subject.tableView.delegate as? ViewController, subject)
        XCTAssertEqual(subject.tableView.dataSource as? ViewController, subject)
    }
    
    func test_loadRecipes() {
        // Given
        let recipes = [mockRecipe(), mockRecipe()]
        mockService.mockRecipes = recipes
        
        // When
        subject.loadRecipes(recipes: recipes)
        
        // Then
        XCTAssertEqual(subject.recipes?.count, recipes.count)
        XCTAssertEqual(subject.tableView.numberOfRows(inSection: 0), recipes.count)
    }
    
    func test_cellForRowAt() {
        // Given
        let recipes = [mockRecipe(), mockRecipe()]
        
        // When
        subject.loadRecipes(recipes: recipes)
        
        // Then
        let cell1 = subject.tableView(subject.tableView, cellForRowAt: IndexPath(row: 0, section: 0)) as? TableViewCell
        XCTAssertEqual(cell1?.titleLabel.text, "Chicken")
        XCTAssertEqual(cell1?.cuisineLabel.text, "dinner")
        
        let cell2 = subject.tableView(subject.tableView, cellForRowAt: IndexPath(row: 1, section: 0)) as? TableViewCell
        XCTAssertEqual(cell2?.titleLabel.text, "Chicken")
        XCTAssertEqual(cell1?.cuisineLabel.text, "dinner")
    }
    
    func test_loadRecipes_emptyResponse() {
        // Given
        let recipes = [Recipe]()
        mockService.mockRecipes = recipes
        
        // When
        subject.loadRecipes(recipes: recipes)
        
        // Then
        let cell = subject.tableView(subject.tableView, cellForRowAt: IndexPath(row: 0, section: 0))
        let expectedEmptyCellText = "No recipes in this directory"
        XCTAssertEqual(subject.tableView.numberOfRows(inSection: 0), 1)
        XCTAssertEqual(cell.textLabel?.text, expectedEmptyCellText)
    }
    
    func test_showError() {
        // When
        subject.showError()
        
        // Then
        XCTAssertTrue(subject.view.subviews.contains { $0 is ErrorBanner })
    }
    
    func test_showError_errorBannerPreexisting() {
        // Given
        subject.showError()
        
        //When
        subject.showError()
        
        // Then
        let errorBanners = subject.view.subviews.filter { $0 is ErrorBanner }
        XCTAssertEqual(errorBanners.count, 1)
    }
}

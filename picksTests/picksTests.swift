//
//  picksTests.swift
//  picksTests
//
//  Created by Elaine Herrera on 25/3/22.
//

import XCTest
import Combine
@testable import picks

class picksTests: XCTestCase {

    var sut: DataModel!
    var sutDataSource: MockDataSource!
    var sutPersistance: MockPersistance!
    private var cancellables = Set<AnyCancellable>()
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        sutDataSource = MockDataSource()
        sutDataSource.loadResult = Result.success(.failed(NSError())).publisher.eraseToAnyPublisher()
        sutPersistance = MockPersistance()
        sutPersistance.loadResult = Result.success(.loaded([])).publisher.eraseToAnyPublisher()
        sut = DataModel(dataSource: sutDataSource, persistence: sutPersistance)
    }

    override func tearDownWithError() throws {
        sut = nil
        sutDataSource = nil
        sutPersistance = nil
        try super.tearDownWithError()
    }
    
    func testNetworkFailure() throws {
        let expectation = XCTestExpectation(description: "If network error then list of videos is empty")
        
        sut.$state.dropFirst().sink { state in
            switch state {
            case .idle:
                break
            case .loading:
                break;
            default:
                XCTAssertEqual(self.sut.videos.count, 0)
                expectation.fulfill()
                break;
            }
        }
        .store(in: &cancellables)
        
        sut.loadData()
        
        wait(for: [expectation], timeout: 1)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}

internal struct MockDataSource: DataSource {
    var loadResult: AnyPublisher<ObservableState, Never>!
    
    func load(page: Int) -> AnyPublisher<ObservableState, Never> {
        return loadResult
    }
    
    func search(query: String, page: Int) -> AnyPublisher<ObservableState, Never> {
        return loadResult
    }
}

internal struct MockPersistance: Persistence {
    var loadResult: AnyPublisher<ObservableState, Never>!
    
    func load() -> AnyPublisher<ObservableState, Never> {
        return loadResult
    }
    
    func save(video: Video) -> AnyPublisher<ObservableState, Never> {
        return loadResult
    }
    
    func remove(video: Video) -> AnyPublisher<ObservableState, Never> {
        return loadResult
    }
    
    func clear() {
        
    }
    
    
}

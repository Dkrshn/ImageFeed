//
//  ImageFeedTests.swift
//  ImageFeedTests
//
//  Created by Даниил Крашенинников on 19.03.2023.
//

import XCTest
@testable import ImageFeed

final class ImageFeedTests: XCTestCase {


    func testExample() {
        let service = ImagesListService()
        
        let expectation = self.expectation(description: "Wait for Notification")
        NotificationCenter.default.addObserver(forName: ImagesListService.DidChangeNotification, object: nil, queue: .main) { _ in
            expectation.fulfill()
            service.fetchPhotosNextPage()
            print("--------________________~--------\(service.photos.count)")
        }
        //service.fetchPhotosNextPage()
        wait(for: [expectation], timeout: 40)
        
        XCTAssertEqual(service.photos.count, 10)
    }
}

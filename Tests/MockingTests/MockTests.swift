//
//  MockTests.swift
//  
//
//  Created by Joel Saltzman on 6/1/21.
//

import Foundation
import Mocking
import XCTest

class MockTests: XCTestCase {
    
    func testResetLoader_mock() {
        // Given a mock that has been reset
        let fileManager = MockFileManager()
        fileManager.fileExistsMock = { _ in return true }
        fileManager.$fileExistsMock.resetLoader()
        
        // When calling the mock
        let result = fileManager.fileExists(atPath: "/invalid")
        
        // Then the defaultValueLoader should be used
        XCTAssertFalse(result, "False should have been returned for the \"invalid\" path.")
        XCTAssertTrue(fileManager.$fileExistsMock.wasCalled, "The mock's default value loader should have been called.")
    }
    func testResetLoader_throwingMock() throws {
        enum TestError: Error {
            case unexpected
        }
        // Given a mock that has been reset
        let fileManager = MockFileManager()
        fileManager.contentsOfDirectoryAtPathMock = { _ in ["should not be returned"] }
        fileManager.$contentsOfDirectoryAtPathMock.resetLoader()
        
        do {
            // When calling the mock
            _ = try fileManager.contentsOfDirectory(atPath: "/invalid")
            
        } catch {
            // Then the defaultValueLoader should be used
            XCTAssertTrue(fileManager.$contentsOfDirectoryAtPathMock.wasCalled, "The mock's default value loader should have been called.")
            // and an error should be thrown
            XCTAssertTrue("\(error)".contains("doesn’t exist."))
        }
    }
    func testDefaultValueLoader() {
        // Given a mock that has not been customized
        let fileManager = MockFileManager()
        
        // When calling the mock
        let result = fileManager.fileExists(atPath: "/tmp")
        
        // Then the default value loader should be called
        XCTAssertTrue(result, "True should have been returned")
    }

    
    public var allTests = [
        ("testResetLoader_mock", testResetLoader_mock),
        ("testResetLoader_throwingMock", testResetLoader_throwingMock),
        ("testDefaultValueLoader", testDefaultValueLoader),
    ]
}

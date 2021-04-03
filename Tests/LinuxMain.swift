import XCTest

import YoutubeKitTests

var tests = [XCTestCaseEntry]()
tests += EndpointTests.allTests()
tests += ResourcesTests.allTests()
XCTMain(tests)

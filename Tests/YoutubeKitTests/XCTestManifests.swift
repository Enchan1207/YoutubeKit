import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(EndpointTests.allTests),
        testCase(ResourcesTests.allTests),
    ]
}
#endif

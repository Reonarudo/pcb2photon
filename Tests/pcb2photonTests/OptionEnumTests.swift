import XCTest
@testable import pcb2photonlib

final class OptionEnumTests: XCTestCase {
    func testOptionTypeInit() {
        XCTAssertEqual(OptionType(value: "t"), .threshold)
        XCTAssertEqual(OptionType(value: "a"), .alignment)
        XCTAssertEqual(OptionType(value: "s"), .scaling)
        XCTAssertEqual(OptionType(value: "p"), .pcbThickness)
        XCTAssertEqual(OptionType(value: "o"), .output)
        XCTAssertEqual(OptionType(value: "e"), .exposure)
        XCTAssertEqual(OptionType(value: "z"), .unknown)
    }

    func testImageAlignmentInit() {
        XCTAssertEqual(ImageAlignment(value: "c"), .center)
        XCTAssertEqual(ImageAlignment(value: "ul"), .upperLeft)
        XCTAssertEqual(ImageAlignment(value: "ll"), .lowerLeft)
        XCTAssertEqual(ImageAlignment(value: "ur"), .upperRight)
        XCTAssertEqual(ImageAlignment(value: "lr"), .lowerRight)
        XCTAssertEqual(ImageAlignment(value: "cl"), .centerLeft)
        XCTAssertEqual(ImageAlignment(value: "cr"), .centerRight)
        XCTAssertEqual(ImageAlignment(value: "cu"), .centerUp)
        XCTAssertEqual(ImageAlignment(value: "cd"), .centerDown)
        XCTAssertEqual(ImageAlignment(value: "x"), .unknown)
    }

    func testImageScalingInit() {
        XCTAssertEqual(ImageScaling(value: "o"), .original)
        XCTAssertEqual(ImageScaling(value: "v"), .verticalFit)
        XCTAssertEqual(ImageScaling(value: "h"), .horizontalFit)
        XCTAssertEqual(ImageScaling(value: "f"), .stretchFit)
        XCTAssertEqual(ImageScaling(value: "n"), .scaleBy)
        XCTAssertEqual(ImageScaling(value: "x"), .unknown)
    }

    static var allTests = [
        ("testOptionTypeInit", testOptionTypeInit),
        ("testImageAlignmentInit", testImageAlignmentInit),
        ("testImageScalingInit", testImageScalingInit)
    ]
}

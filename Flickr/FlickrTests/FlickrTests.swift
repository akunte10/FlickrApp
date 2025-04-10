import XCTest
@testable import Flickr

final class PexelsModelTests: XCTestCase {

    func testPexelsPhotoModelDecoding() throws {
        let json = """
        {
            "photos": [
                {
                    "id": 101,
                    "src": {
                        "medium": "https://images.pexels.com/photos/101/medium.jpg"
                    }
                }
            ]
        }
        """.data(using: .utf8)!

        do {
            let decodedResponse = try JSONDecoder().decode(PexelsResponse.self, from: json)
            let photo = decodedResponse.photos.first

            XCTAssertNotNil(photo)
            XCTAssertEqual(photo?.id, 101)
            XCTAssertEqual(photo?.src.medium, "https://images.pexels.com/photos/101/medium.jpg")
            XCTAssertEqual(photo?.imageURL, "https://images.pexels.com/photos/101/medium.jpg")
        } catch {
            XCTFail("Model decoding failed with error: \(error)")
        }
    }
}

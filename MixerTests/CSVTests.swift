import XCTest
import Nimble

@testable import Mixer

class CSVTests: XCTestCase {
    
    override func setUp() {
        continueAfterFailure = false
    }

    func testParseRows() {
        let parsed = CSV(contentsOfFile: csvPath("CSV"))
        expect(parsed?.rows.count).to(equal(2))
        
        let firstRow = parsed!.rows[0]
        expect(firstRow["x"]).to(equal("1"))
        expect(firstRow["y"]).to(equal("23"))
        expect(firstRow["z"]).to(equal("4"))
        
        let secondRow = parsed!.rows[1]
        expect(secondRow["x"]).to(equal("5"))
        expect(secondRow["y"]).to(equal("67"))
        expect(secondRow["z"]).to(equal("8"))
    }
    
    func testParseCorrupt() {
        let parsed = CSV(contentsOfFile: csvPath("CorruptFile"))
        expect(parsed).to(beNil())
    }
    
    fileprivate func csvPath(_ fileName: String) -> String {
        return Bundle(for: type(of: self)).path(forResource: fileName, ofType: "csv") ?? ""
    }
}

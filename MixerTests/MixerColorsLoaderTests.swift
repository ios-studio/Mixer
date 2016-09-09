import XCTest
import Nimble

@testable import Mixer

class MixerColorsLoaderTests: XCTestCase {
    
    var fileManager: FileManager!
    
    override func setUp() {
        fileManager = FileManager.default
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testCache() {
        let testPath = copyCSVFixtureToTestPath(csvPath("Colors"))
        _ = MixerColorsLoader(path: testPath).load()
        removeCSVFixtureAtPath(testPath)
        
        let cacheLoader = MixerColorsLoader(path: testPath)
        
        let cachedResult = cacheLoader.load()
        expect(cachedResult?.keys.count).to(equal(3))
        expect(cachedResult?["Blue"]).notTo(beNil())
        
        cacheLoader.clear()
        
        let deletedResult = cacheLoader.load()
        expect(deletedResult).to(beNil())
    }
    
    fileprivate func copyCSVFixtureToTestPath(_ path: String) -> String {
        let newPath = path.replacingOccurrences(of: "Colors", with: "CorrectFontSizes-CacheTest")
        do {
            try fileManager.copyItem(atPath: path, toPath: newPath)
        } catch _ {
            fail("Could not copy file for cache test")
        }
        
        return newPath
    }
    
    fileprivate func removeCSVFixtureAtPath(_ path: String) {
        do {
            try fileManager.removeItem(atPath: path)
        } catch _ {
            fail("Could not remove file for cache test")
        }
    }
    
    func testWithIncorrectPath() {
        let incorrectPath = "Something/Something"
        let colors = MixerColorsLoader(path: incorrectPath).load()
        expect(colors).to(beNil())
    }
    
    func testWithCorrectCSV() {
        let loader = MixerColorsLoader(path: csvPath("Colors"))
        let colors = loader.load()
        expect(colors?.keys.count).to(equal(3))
        expect(colors?["Red"]).notTo(beNil())
        loader.clear()
    }

    func testWithCSVWithMissingHeader() {
        let colors = MixerColorsLoader(path: csvPath("MissingHeader")).load()
        expect(colors).to(beNil())
    }
    
    func testWithMissingRGBChannelValuesCSV() {
        let colors = MixerColorsLoader(path: csvPath("MissingRGBChannelValues")).load()
        expect(colors).to(beNil())
    }
    
    
    func testWithMissingAlphaChannelValuesCSV() {
        let colors = MixerColorsLoader(path: csvPath("MissingAlphaChannelValues")).load()
        expect(colors).to(beNil())
    }
    
    func testWithNonIntegerRGBChannelValuesCSV() {
        let colors = MixerColorsLoader(path: csvPath("NonIntegerRGBChannelValues")).load()
        expect(colors).to(beNil())
    }
    
    func testWithNonFloatAlphaChannelValuesCSV() {
        let colors = MixerColorsLoader(path: csvPath("NonFloatAlphaChannelValues")).load()
        expect(colors).to(beNil())
    }
    
    func testWithInvalidRGBChannelValuesCSV() {
        let colors = MixerColorsLoader(path: csvPath("InvalidRGBChannelValues")).load()
        expect(colors).to(beNil())
    }
    
    func testWithInvalidAlphaChannelValuesCSV() {
        let colors = MixerColorsLoader(path: csvPath("InvalidAlphaChannelValues")).load()
        expect(colors).to(beNil())
    }
    
    func testWithIncorrectValuesCSV() {
        let colors = MixerColorsLoader(path: csvPath("IncorrectValues")).load()
        expect(colors).to(beNil())
    }
    
    func testWithCorruptFile() {
        let colors = MixerColorsLoader(path: csvPath("CorruptFile")).load()
        expect(colors).to(beNil())
    }
    
    fileprivate func csvPath(_ fileName: String) -> String {
        return Bundle(for: self.classForCoder).path(forResource: fileName, ofType: "csv") ?? ""
    }
}

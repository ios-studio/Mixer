import XCTest
import Nimble

@testable import Mixer

class MixerColorsLoaderTests: XCTestCase {
    
    var fileManager: NSFileManager!
    
    override func setUp() {
        fileManager = NSFileManager.defaultManager()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testCache() {
        let testPath = copyCSVFixtureToTestPath(csvPath("Colors"))
        MixerColorsLoader(path: testPath).load()
        removeCSVFixtureAtPath(testPath)
        
        let cacheLoader = MixerColorsLoader(path: testPath)
        
        let cachedResult = cacheLoader.load()
        expect(cachedResult?.keys.count).to(equal(3))
        expect(cachedResult?["Blue"]).notTo(beNil())
        
        cacheLoader.clear()
        
        let deletedResult = cacheLoader.load()
        expect(deletedResult).to(beNil())
    }
    
    private func copyCSVFixtureToTestPath(path: String) -> String {
        let newPath = path.stringByReplacingOccurrencesOfString("Colors", withString: "CorrectFontSizes-CacheTest")
        do {
            try fileManager.copyItemAtPath(path, toPath: newPath)
        } catch _ {
            fail("Could not copy file for cache test")
        }
        
        return newPath
    }
    
    private func removeCSVFixtureAtPath(path: String) {
        do {
            try fileManager.removeItemAtPath(path)
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
    
    func testWithCorruptCSV() {
        let colors = MixerColorsLoader(path: csvPath("CorruptColors")).load()
        expect(colors).to(beNil())
    }
    
    func testWithCorruptFile() {
        let colors = MixerColorsLoader(path: csvPath("CorruptFile")).load()
        expect(colors).to(beNil())
    }
    
    private func csvPath(fileName: String) -> String {
        return NSBundle(forClass: self.dynamicType).pathForResource(fileName, ofType: "csv") ?? ""
    }
}

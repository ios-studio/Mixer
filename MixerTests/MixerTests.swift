import XCTest
import Nimble

import Mixer

enum Color: String, MixerColor {
    case Blue
    
    var name: String { return rawValue }
}

class MixerTests: XCTestCase {
    
    var mixer: Mixer!
    
    override func setUp() {
        super.setUp()
        
        continueAfterFailure = false
        
        guard let csvPath = Bundle(for: type(of: self)).path(forResource: "Colors", ofType: "csv") else {
            fail("Color fixture file Colors.csv is missing")
            return
        }
        
        mixer = Mixer(
            configuration: MixerConfiguration(colorDefinitionsPath: csvPath)
        )
    }
    
    override func tearDown() {
        mixer = nil
        super.tearDown()
    }
    
    func testConvenienceInit() {
        let convenienceMixer = Mixer(bundle: Bundle(for: type(of: self)))
        expect(convenienceMixer.hasColors).to(beTrue())
    }
    
    func testConvenienceInitWithMissingFile() {
        let convenienceMixer = Mixer(bundle: Bundle())
        expect(convenienceMixer.hasColors).to(beFalse())
    }
    
    func testConvenienceInitPerformance() {
        self.measure {
            for _ in 1..<10000 {
                let _ = Mixer(bundle: Bundle(for: type(of: self)))
            }
        }
    }
    
    func testColorFor() {
        let color = mixer.colorFor(Color.Blue)
        let (red, green, blue, alpha) = extractColorValues(color)
        
        expect(red).to(equal(0.0))
        expect(green).to(equal(0.0))
        expect(blue).to(equal(0.8))
        expect(alpha).to(equal(1.0))
    }
    
    func testColorForString() {
        let color = mixer.colorFor("Red")
        let (red, green, blue, alpha) = extractColorValues(color)
        
        expect(red).to(equal(0.8))
        expect(green).to(equal(0.0))
        expect(blue).to(equal(0.0))
        expect(alpha).to(beCloseTo(0.9, within: 0.001))
    }
    
    fileprivate func extractColorValues(_ color: UIColor?) -> (CGFloat, CGFloat, CGFloat, CGFloat) {
        var red: CGFloat = -1.0
        var green: CGFloat = -1.0
        var blue: CGFloat = -1.0
        var alpha: CGFloat = -1.0
        
        color?.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        return (red, green, blue, alpha)
    }

    
}

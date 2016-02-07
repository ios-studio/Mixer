import XCTest
import Nimble

import Mixer

class MixerConfigurationTests: XCTestCase {

    func testSizeDefinitionsPath() {
        let configuration = MixerConfiguration(colorDefinitionsPath: "PATH")
        expect(configuration.colorDefinitionsPath).to(equal("PATH"))
    }

}

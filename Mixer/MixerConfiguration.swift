import UIKit

/**
 A detailed configuration for an instance of `Mixer`. Allows color definitions file.
 */
public struct MixerConfiguration {
    /**
     The path to the color definitions. By default, `Mixer` will try and load `Colors.csv` from the bundle given to it at initialisation.
     */
    public let colorDefinitionsPath: String
    
    /**
     Initialize a new `MixerConfiguration` with a custom path to a definition file.
     
     - Parameter colorDefinitionsPath: The path to the file to load the color definitions from.
     */
    public init(colorDefinitionsPath: String) {
        self.colorDefinitionsPath = colorDefinitionsPath
    }
}
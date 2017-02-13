import UIKit
/** `Mixer` allows you to load color definitions from a CSV file which contains RGBA color definitions. The CSV file has to have the following form:
 
 ```csv
 Name,Red,Green,Blue,Alpha
 Blue,0,0,204,1.0
 Red,204,0,0,0.9
 Green,0,204,0,1.0
 ```
 
 Where the columns headers are RGBA channel values and the row headers are the names of the colors.
 */
open class Mixer {
    internal struct Color {
        let red: Int
        let green: Int
        let blue: Int
        let alpha: Float
        
        var uiColor: UIColor {
            return UIColor(
                red: cgFloatValueOf(red),
                green: cgFloatValueOf(green),
                blue: cgFloatValueOf(blue),
                alpha: CGFloat(alpha)
            )
        }
        
        fileprivate func cgFloatValueOf(_ value: Int) -> CGFloat {
            return CGFloat(value) / CGFloat(255.0)
        }
    }
    
    internal typealias Colors = [String: Color]
    
    fileprivate let colors: Colors
    
    /**
     Check if this instance of `Mixer` has colors loaded. Returns `true` if this instance has successfully loaded colors from a file, `false` if not.
     */
    open var hasColors: Bool {
        return self.colors.count > 0
    }
    
    fileprivate static var resourcePaths: [Bundle: String] = [:]
    fileprivate static func defaultResourcePathForBundle(_ bundle: Bundle) -> String? {
        if let path = resourcePaths[bundle] {
            return path
        } else if let path = bundle.path(forResource: "Colors", ofType: "csv") {
            resourcePaths[bundle] = path
            return path
        }
        
        return nil
    }
    
    fileprivate let configuration: MixerConfiguration
    
    /**
     Initialize an instance of `Mixer` with a given custom `MixerConfiguration`. Files loaded are cached for the run time of the application so there is no performance penalty in initializing multiple `Mixer` instances.
     */
    public init(configuration: MixerConfiguration) {
        self.configuration = configuration
        
        if let colors = MixerColorsLoader(path: configuration.colorDefinitionsPath).load() {
            self.colors = colors
        } else {
            self.colors = Colors()
        }
    }
    
    /**
     Initialize an instance of `Mixer` by implicitly searching for a file named `Colors.csv` in the given bundle. Files loaded are cached for the run time of the application so there is no performance penalty in initializing multiple `Mixer` instances.
     
     - Parameter bundle: The bundle in which to look for the file named `Colors.csv`
     */
    public convenience init(bundle: Bundle) {
        guard let path = Mixer.defaultResourcePathForBundle(bundle) else {
            self.init(configuration: MixerConfiguration(colorDefinitionsPath: "NoPath"))
            return
        }
        
        self.init(configuration: MixerConfiguration(colorDefinitionsPath: path))
    }
    
    /**
     Return an `UIColor` from a color definition in the colors file. Takes a string for the color name to ease use with `@IBInspectable`.
     
     - Parameter name: The color to return
     */
    open func colorFor(_ name: String) -> UIColor? {
        return colors[name]?.uiColor
    }
    
    /**
     Return an `UIColor` from a color definition in the colors file.
     
     - Parameter name: The color to return
     */
    open func colorFor(_ color: MixerColor) -> UIColor? {
        return colors[color.name]?.uiColor
    }
    
}

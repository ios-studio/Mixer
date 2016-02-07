import UIKit

/**
 The mixer color protocol. Implement this to use `Mixer`s `colorFor` with compile-time checks.
 
 An example implementation would be:
 
 ```Swift
 enum MyColor: String, MixerColor {
    case Blue = "Blue"
 
    var name: String { return rawValue }
 }
 ```
 
 */
public protocol MixerColor {
    /**
     The name of the color as stated in the color definitions file.
     */
    var name: String { get }
}
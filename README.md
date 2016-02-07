# Mixer [![Build Status](https://travis-ci.org/ios-studio/Mixer.svg?branch=master)](https://travis-ci.org/ios-studio/Mixer) [![codecov.io](https://codecov.io/github/ios-studio/Mixer/coverage.svg?branch=master)](https://codecov.io/github/ios-studio/Mixer?branch=master) [![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
Centralize your color definitions in a CSV file & easily share them for people to edit.

## Installation

#### Via [Carthage](https://github.com/Carthage/Carthage):
Add the following your Cartfile:

```Swift
github "ios-studio/Mixer" ~> 0.1.0
```

#### Via [Cocoapods](https://cocoapods.org/):
Add the following your Podfile:

```ruby
pod "Mixer", "~> 0.1.0"
```

## Default Setup
Mixer will look for a file named `Colors.csv` in the specified bundle or at the specified path. [The contents of the file should look like this](https://github.com/ios-studio/Mixer/blob/master/MixerTests/Support/Colors.csv). It is important to keep the headers as shown, otherwise Mixer will not be able to read the file.

For the colors you'd like to use in your project, define a class which conforms to the protocol `MixerColor`. The only requirement of that protocol is that the object responds to the property `name`, so for example it could look like:

```Swift
enum Color: String, MixerColor {
    case Blue = "Blue"
    case Red = "Red"

    var name: String { return rawValue }
}

```

Where `"Blue"` corresponds to the name of a color in the csv file.

## Configuring
Mixer can be passed a `MixerConfiguration` object where you can specify another path to your colors file.

## Using Mixer

Pass the bundle to initialize. Mixer will look up the `Colors` file in the bundle and cache it for subsequent initializations in the same process:

```Swift
let bundle = NSBundle(forClass: self.dynamicType)
let mixer = Mixer(bundle: bundle)
```

Typically, all you will then use is the `colorFor` method, which you can use in two ways:

#### Using your color definition

Remember the definition of `Color` from above? This is how to get a color according to your definitions:

```Swift
let color = mixer.colorFor(Color.Blue)
```

#### Using a string

This is a convenience method to be able to use Mixer with `@IBDesignable` / `@IBInspectable`. Since `@IBInspectable` does not yet work with enum types, you can use the version of `colorFor` without a type check like so:

```Swift
let color = mixer.colorFor("Blue")
```

For an example involving `@IBDesignable`, [go to the wiki](https://github.com/ios-studio/Mixer/wiki/Setting-up-an-@IBDesignable-Label)

## Contributions

Yes please!

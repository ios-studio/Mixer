import UIKit

internal class MixerColorsLoader {
    fileprivate static var cachedPaths: [String: Mixer.Colors] = [:]
    
    let path: String
    
    init(path: String) {
        self.path = path
    }
    
    func clear() {
        MixerColorsLoader.cachedPaths.removeValue(forKey: path)
    }
    
    
    func load() -> Mixer.Colors? {
        if let cached = MixerColorsLoader.cachedPaths[path] { return cached }
        
        guard let csv = CSV(contentsOfFile: path), !csv.rows.isEmpty else {
            logReadFailure("Could not find or read colors csv")
            return nil
        }
        
        if let colors = loadColors(csv) {
            MixerColorsLoader.cachedPaths[path] = colors
            return colors
        }
        
        return nil
    }
    
    fileprivate func loadColors(_ csv: CSV) -> Mixer.Colors? {
        var colors = Mixer.Colors()
        for row in csv.rows {
            guard let name = row["Name"],
                let red = extractColorValue(row, channel: "Red"),
                let green = extractColorValue(row, channel: "Green"),
                let blue = extractColorValue(row, channel: "Blue"),
                let alpha = extractAlphaValue(row) else {
                    return nil
            }
            
            colors[name] = Mixer.Color(red: red, green: green, blue: blue, alpha: alpha)
        }
        
        return colors
    }
    
    fileprivate func extractColorValue(_ row: [String: String], channel: String) -> Int? {
        guard let string = row[channel] else {
            logReadFailureForRow(row, message: "Value for \(channel) channel not found")
            return nil
        }
        guard let value = Int(string) else {
            logReadFailureForRow(row, message: "Value for \(channel) channel is no integer")
            return nil
        }
        guard isValidColorValue(value) else {
            logReadFailureForRow(row, message: "Value for \(channel) channel is invalid, must be between 0 and 255")
            return nil
        }
        return value
    }
    
    fileprivate func extractAlphaValue(_ row: [String: String]) -> Float? {
        guard let string = row["Alpha"] else {
            logReadFailureForRow(row, message: "Value for alpha channel not found")
            return nil
        }
        guard let value = Float(string) else {
            logReadFailureForRow(row, message: "Value for alpha channel is not a float")
            return nil
        }
        guard isValidAlphaValue(value) else {
            logReadFailureForRow(row, message: "Value for alpha channel not valid - must be between 0.0 and 1.0")
            return nil
        }
        return value
    }
    
    fileprivate func isValidColorValue(_ value: Int) -> Bool {
        return (0..<256).contains(value)
    }
    
    fileprivate func isValidAlphaValue(_ value: Float) -> Bool {
        return (0.0..<1.0).contains(value) || value == 1.0
    }

    fileprivate func logReadFailureForRow(_ row: [String: String], message: String) {
        NSLog("Mixer: Failure parsing color \"\(row["Name"] ?? "")\" - \(message) - colors will not be loaded")
    }
    
    fileprivate func logReadFailure(_ message: String) {
        NSLog("Mixer: \(message) - colors will not be loaded")
    }
}

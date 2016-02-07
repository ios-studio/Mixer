import UIKit

internal class MixerColorsLoader {
    private static var cachedPaths: [String: Mixer.Colors] = [:]
    
    let path: String
    
    init(path: String) {
        self.path = path
    }
    
    func clear() {
        MixerColorsLoader.cachedPaths.removeValueForKey(path)
    }
    
    
    func load() -> Mixer.Colors? {
        if let cached = MixerColorsLoader.cachedPaths[path] { return cached }
        
        guard let csv = CSV(contentsOfFile: path) where !csv.rows.isEmpty else {
            logReadFailure("Could not find or read colors csv")
            return nil
        }
        
        if let colors = loadColors(csv) {
            MixerColorsLoader.cachedPaths[path] = colors
            return colors
        }
        
        return nil
    }
    
    private func loadColors(csv: CSV) -> Mixer.Colors? {
        var colors = Mixer.Colors()
        for row in csv.rows {
            guard let name = row["Name"],
                red = extractColorValue(row, channel: "Red"),
                green = extractColorValue(row, channel: "Green"),
                blue = extractColorValue(row, channel: "Blue"),
                alpha = extractAlphaValue(row) else {
                    return nil
            }
            
            colors[name] = Mixer.Color(red: red, green: green, blue: blue, alpha: alpha)
        }
        
        return colors
    }
    
    private func extractColorValue(row: [String: String], channel: String) -> Int? {
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
    
    private func extractAlphaValue(row: [String: String]) -> Float? {
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
    
    private func isValidColorValue(value: Int) -> Bool {
        return (0..<256).contains(value)
    }
    
    private func isValidAlphaValue(value: Float) -> Bool {
        return (0.0..<1.0).contains(value) || value == 1.0
    }

    private func logReadFailureForRow(row: [String: String], message: String) {
        NSLog("Mixer: Failure parsing color \"\(row["Name"] ?? "")\" - \(message) - colors will not be loaded")
    }
    
    private func logReadFailure(message: String) {
        NSLog("Mixer: \(message) - colors will not be loaded")
    }
}
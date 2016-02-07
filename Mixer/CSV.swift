import Foundation

internal class CSV {
    let rows: [[String: String]]
    
    private let headers: [String]
    private static let delimiter = NSCharacterSet(charactersInString: ",")
    
    init?(contentsOfFile file: String) {
        let contents: String
        do {
            contents = try String(contentsOfFile: file)
        } catch {
            self.headers = []
            self.rows = []
            return nil
        }
        
        let newline = NSCharacterSet.newlineCharacterSet()
        var lines: [String] = []
        contents.stringByTrimmingCharactersInSet(newline).enumerateLines { line, stop in lines.append(line)
        }
        
        guard lines.count > 1 else {
            self.headers = []
            self.rows = []
            return nil
        }
        
        let headers = lines[0].componentsSeparatedByCharactersInSet(CSV.delimiter)
        self.headers = headers
        self.rows = Array(lines)[1..<lines.count].reduce([[String: String]]()) { (var allRows, line) in
            
            var row = [String: String]()
            for (key, value) in zip(headers, line.componentsSeparatedByCharactersInSet(CSV.delimiter)) {
                row[key] = value
            }
            
            allRows.append(row)
            return allRows
        }
    }
}
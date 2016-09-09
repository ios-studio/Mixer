import Foundation

internal class CSV {
    let rows: [[String: String]]
    
    fileprivate let headers: [String]
    fileprivate static let delimiter = CharacterSet(charactersIn: ",")
    
    init?(contentsOfFile file: String) {
        let contents: String
        do {
            contents = try String(contentsOfFile: file)
        } catch {
            self.headers = []
            self.rows = []
            return nil
        }
        
        let newline = CharacterSet.newlines
        var lines: [String] = []
        contents.trimmingCharacters(in: newline).enumerateLines { line, stop in lines.append(line)
        }
        
        guard lines.count > 1 else {
            self.headers = []
            self.rows = []
            return nil
        }
        
        let headers = lines[0].components(separatedBy: CSV.delimiter)
        self.headers = headers
        self.rows = Array(lines)[1..<lines.count].reduce([[String: String]]()) { allRows, line in
            var newRows = allRows
            var row = [String: String]()
            for (key, value) in zip(headers, line.components(separatedBy: CSV.delimiter)) {
                row[key] = value
            }
            
            newRows.append(row)
            return newRows
        }
    }
}

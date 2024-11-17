import Foundation

struct StartDate: Codable {
    let localTime: String
    private let localDate: String
    
    var eventFullDate: String? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        guard let date = formatter.date(from: localDate) else { return nil }
        
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter.string(from: date)
    }
}

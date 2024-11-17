import Foundation

struct StartDate: Codable {
    private let localTime: String
    private let localDate: String
    
    var time: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        
        guard let date = formatter.date(from: localTime) else { return "no time" }
        
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }
    
    var eventFullDate: String? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        guard let date = formatter.date(from: localDate) else { return nil }
        
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter.string(from: date)
    }
}

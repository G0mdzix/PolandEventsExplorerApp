struct Address: Codable {
    let line: String
}

extension Address {
    enum CodingKeys: String, CodingKey {
        case line = "line1"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        line = try container.decode(String.self, forKey: .line)
    }
}

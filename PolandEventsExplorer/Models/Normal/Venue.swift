struct Venue: Codable {
    let name: String
    let timezone: String
    let city: City
    let state: State
    let address: Address
}

extension Venue {
    enum CodingKeys: String, CodingKey {
        case name, timezone, city, state, address
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        timezone = try container.decode(String.self, forKey: .timezone)
        city = try container.decode(City.self, forKey: .city)
        state = try container.decode(State.self, forKey: .state)
        address = try container.decode(Address.self, forKey: .address)
    }
}

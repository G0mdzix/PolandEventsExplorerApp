struct Venue: Codable {
    let name: String
    let timezone: String
    let city: City
    let state: EventState
    let address: Address
    let country: Country?
}

extension Venue {
    enum CodingKeys: String, CodingKey {
        case name, timezone, city, state, address, country
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        timezone = try container.decode(String.self, forKey: .timezone)
        city = try container.decode(City.self, forKey: .city)
        state = try container.decode(EventState.self, forKey: .state)
        address = try container.decode(Address.self, forKey: .address)
        country = try? container.decode(Country.self, forKey: .country)
    }
}

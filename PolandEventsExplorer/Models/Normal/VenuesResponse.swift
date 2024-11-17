struct VenuesResponse: Codable {
    let venues: [Venue]
    let attractions: [EventsAttraction]
}

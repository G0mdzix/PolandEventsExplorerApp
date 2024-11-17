protocol EventsServiceProtocol {
    func searchEvents(fetchSettings: EventFetchSettings) async throws -> EventResponse
    func searchEventDetails(id: String) async throws -> Event
}

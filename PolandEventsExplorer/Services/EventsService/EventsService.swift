import Foundation

final class EventsService: EventsServiceProtocol {
    func searchEvents(fetchSettings: EventFetchSettings) async throws -> EventResponse {
        try await APIClient.performRequest(router: EventsRouter.getEventSearch(settings: fetchSettings))
    }
    
    func searchEventDetails(id: String) async throws -> Event {
        try await APIClient.performRequest(router: EventsRouter.getEventDetails(id: id))
    }
}

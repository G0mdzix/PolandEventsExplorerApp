import SwiftUI

final class DashboardViewModel: ObservableObject {
    
    @Injected(\.eventsServiceProvider) private var eventsService: EventsServiceProtocol
    
    @Published var isLoading = false
    @Published var pageSize: PageSize = .ten
    @Published var searchText = ""
    @Published var error: APIError?
    @Published var mappedDashboardEvents: Set<EventsDashboardModel> = []
    @Published var selectedEventId: String = ""
    
    private var page: Page?
    
    var searchResults: [EventsDashboardModel] {
        mappedDashboardEvents.filter { $0.name.lowercased().contains(searchText.lowercased()) }
    }
    
    var isMorePagesAvailable: Bool {
        guard let page else { return false }
        return page.number < page.totalPages
    }
    
    private var nextPageNumber: Int {
        guard let page else { return 1 }
        return page.number + 1
    }
    
    init() {
        fetchEvents()
    }
    
    func refreshEvents() {
        guard mappedDashboardEvents.isEmpty else { return }
        mappedDashboardEvents.removeAll()
        page = nil
        fetchEvents()
    }
    
    func fetchEvents() {
        guard !isLoading else { return }
        isLoading = true
        
        Task { @MainActor in
            do {
                let eventsResponse = try await eventsService.searchEvents(
                    fetchSettings: EventFetchSettings(pageSize: pageSize, page: nextPageNumber)
                )
                page = eventsResponse.page
                mapEvents(eventsResponse, to: &mappedDashboardEvents)
            } catch {
                self.error = error as? APIError
            }
        }
        
        isLoading = false
    }
    
    private func mapEvents(_ eventsResponse: EventResponse, to mappedEvents: inout Set<EventsDashboardModel>) {
        let newMappedEvents = eventsResponse.embedded.events.map {
            EventsDashboardModel(
                id: $0.id,
                name: $0.name,
                date: $0.dates?.start.eventFullDate ?? StringHandler.NoData.noDate,
                city: $0.venuesResponse?.venues.first?.city.name ?? StringHandler.NoData.noCity,
                objectName: $0.venuesResponse?.venues.first?.name ?? StringHandler.NoData.noObject,
                image: $0.images.first
            )
        }

        if !newMappedEvents.isEmpty {
            mappedEvents.formUnion(newMappedEvents) 
        }
    }
}

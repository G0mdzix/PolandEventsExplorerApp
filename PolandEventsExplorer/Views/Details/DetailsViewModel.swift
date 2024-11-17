import SwiftUI

final class DetailsViewModel: ObservableObject {
    
    @Injected(\.eventsServiceProvider) private var eventsService: EventsServiceProtocol
    
    @Published var error: APIError?
    @Published var mappedEventDetails: EventDetailsModel?
    @Published var isLoading = true
    
    @Published private var eventDetails: Event?
    
    var shouldShowBuildingRow: Bool {
        !(mappedEventDetails?.objectName.isEmpty ?? true && (mappedEventDetails?.address.isEmpty ?? true))
    }
    
    var shouldShowLocationRow: Bool {
        !(mappedEventDetails?.country.isEmpty ?? true && (mappedEventDetails?.city.isEmpty ?? true))
    }
    
    var shouldShowCalendarRow: Bool {
        !(mappedEventDetails?.fullDate.isEmpty ?? true
          && (mappedEventDetails?.time.isEmpty ?? true)
          && (mappedEventDetails?.timezone.isEmpty ?? true))
    }
    
    var shouldShowPriceRangerRow: Bool {
        mappedEventDetails?.priceRange.isEmpty == false
    }
    
    var priceRangeString: String {
        "\(priceRangeOverallMin) - \(priceRangeOverallMax) \(mappedEventDetails?.priceRange.first?.currency ?? "")"
    }
    
    var shouldShowSeatMap: Bool {
        mappedEventDetails?.layoutImage.isEmpty == false
    }
    
    private var priceRangeOverallMin: Double {
        mappedEventDetails?.priceRange
            .compactMap { $0.min }
            .filter { $0 > 0.0 }
            .min() ?? 0.0
    }
    
    private var priceRangeOverallMax: Double {
        mappedEventDetails?.priceRange.compactMap { $0.max }.max() ?? 0.0
    }
    
    init(eventId: String) {
        fetchEventDetails(eventId)
    }
    
    private func fetchEventDetails(_ eventId: String) {
        guard isLoading else { return }
        
        Task { @MainActor in
            do {
                eventDetails = try await eventsService.searchEventDetails(id: eventId)
                mapEventDetails(eventDetails, to: &mappedEventDetails)
                eventDetails = nil
                isLoading = false
            } catch {
                self.error = error as? APIError
            }
        }
    }
    
    private func mapEventDetails(_ eventsDetails: Event?, to mappedEvents: inout EventDetailsModel?) {
        guard let eventsDetails else { return }
        
        mappedEvents = EventDetailsModel(
            name: eventsDetails.name,
            bandName: eventsDetails.venuesResponse?.attractions.first?.name ?? "",
            fullDate: eventsDetails.dates?.start.eventFullDate ?? "",
            time: eventsDetails.dates?.start.time ?? "",
            timezone: eventsDetails.dates?.timezone ?? "",
            country: eventsDetails.venuesResponse?.venues.first?.country?.name ?? "",
            city: eventsDetails.venuesResponse?.venues.first?.city.name ?? "",
            objectName: eventsDetails.venuesResponse?.venues.first?.name ?? "",
            address: eventsDetails.venuesResponse?.venues.first?.address.line ?? "",
            genre: eventsDetails.classifications?.first?.genre.name ?? "",
            priceRange: eventsDetails.priceRanges ?? [],
            gallery: eventsDetails.originalImages,
            layoutImage: eventsDetails.seatmap?.staticUrl ?? ""
        )
    }
}

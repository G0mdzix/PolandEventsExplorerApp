import SwiftUI

final class DetailsViewModel: ObservableObject {
    
    @Injected(\.eventsServiceProvider) private var eventsService: EventsServiceProtocol
    
    @Published var error: APIError?
    @Published var isLoading = true
    
    @Published private var eventDetails: Event?
    
    private var mappedEventDetails: EventDetailsModel?
    
    var eventDetailsInfo: EventDetailsModel {
        guard let mappedEventDetails else { return EventDetailsModel.emptyMock }
        return mappedEventDetails
    }
    
    var shouldShowBuildingRow: Bool {
        !(eventDetailsInfo.objectName.isEmpty && eventDetailsInfo.address.isEmpty)
    }
    
    var shouldShowLocationRow: Bool {
        !(eventDetailsInfo.country.isEmpty && eventDetailsInfo.city.isEmpty)
    }
    
    var shouldShowCalendarRow: Bool {
        !(eventDetailsInfo.fullDate.isEmpty && eventDetailsInfo.time.isEmpty && eventDetailsInfo.timezone.isEmpty)
    }
    
    var shouldShowPriceRangerRow: Bool {
        eventDetailsInfo.priceRange.isEmpty == false
    }
    
    var priceRangeString: String {
        "\(priceRangeOverallMin) - \(priceRangeOverallMax) \(eventDetailsInfo.priceRange.first?.currency ?? "PLN")"
    }
    
    var shouldShowArtistLabels: Bool {
        eventDetailsInfo.bandName.isEmpty == false
    }
    
    var shouldShowGenreLabel: Bool {
        eventDetailsInfo.genre.isEmpty == false
    }
    
    var shouldShowSeatMap: Bool {
        eventDetailsInfo.layoutImage.isEmpty == false
    }
    
    private var priceRangeOverallMin: Double {
        eventDetailsInfo.priceRange
            .compactMap { $0.min }
            .filter { $0 > 0.0 }
            .min() ?? 0.0
    }
    
    private var priceRangeOverallMax: Double {
        eventDetailsInfo.priceRange.compactMap { $0.max }.max() ?? 0.0
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
            bandName: eventsDetails.venuesResponse?.attractions.first?.name ?? EventDetailsModel.emptyMock.bandName,
            fullDate: eventsDetails.dates?.start.eventFullDate ?? EventDetailsModel.emptyMock.fullDate,
            time: eventsDetails.dates?.start.time ?? EventDetailsModel.emptyMock.time,
            timezone: eventsDetails.dates?.timezone ?? EventDetailsModel.emptyMock.timezone,
            country: eventsDetails.venuesResponse?.venues.first?.country?.name ?? EventDetailsModel.emptyMock.country,
            city: eventsDetails.venuesResponse?.venues.first?.city.name ?? EventDetailsModel.emptyMock.city,
            objectName: eventsDetails.venuesResponse?.venues.first?.name ?? EventDetailsModel.emptyMock.objectName,
            address: eventsDetails.venuesResponse?.venues.first?.address.line ?? EventDetailsModel.emptyMock.address,
            genre: eventsDetails.classifications?.first?.genre.name ?? EventDetailsModel.emptyMock.genre,
            priceRange: eventsDetails.priceRanges ?? EventDetailsModel.emptyMock.priceRange,
            gallery: eventsDetails.originalImages,
            layoutImage: eventsDetails.seatmap?.staticUrl ?? EventDetailsModel.emptyMock.layoutImage
        )
    }
}

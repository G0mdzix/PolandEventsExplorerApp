enum StringHandler {
    enum DashboardView {
        static let navigationTitle = "Poland Explorer"
        static let navigationBarTitle = "Searchable Example"
        static let pageSizePickerTitle = "Pick page size"
        static let noSearchResultsTitle = "No events found"
        static let noSearchResultsDescription = "Search only works for events that are already loaded!"
    }
    
    enum DetailsView {
        static let artistLabel = "Artists: "
        static let genreLabel = "Genre: "
        static let detailsInfoTitle = "About the event: "
        static let priceRangeTitle = "Price range for tickets: "
        static let seatMapTitle = "Seat map"
    }
    
    enum ErrorAlert {
        static let title = "⚠️ Error ⚠️"
        static let dismissButton = "OK"
        static let unknownError = "Unknown error"
    }
    
    enum APIErrorDescription {
        static let invalidResponse = "Invalid response from the server."
        static let serverError = "Server returned an error with status code \n"
        static let noData = "No data was received from the server."
        static let decodingError = "Failed to decode the data."
        static let networkError = "Network error occurred: \n"
    }
    
    enum NoData {
        static let noDate = "No date available"
        static let noCity = "No city information available"
        static let noObject = "No object name available"
    }
}

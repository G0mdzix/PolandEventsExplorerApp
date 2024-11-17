extension InjectedValues {
    var eventsServiceProvider: EventsServiceProtocol {
        get { Self[ServicesKeys.EventsServiceProvider.self] }
        set { Self[ServicesKeys.EventsServiceProvider.self] = newValue }
    }
}

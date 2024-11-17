struct ServicesKeys {
    struct EventsServiceProvider: InjectionKey {
        static var currentValue: EventsServiceProtocol = EventsService()
    }
}

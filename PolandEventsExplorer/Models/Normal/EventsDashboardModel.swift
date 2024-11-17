struct EventsDashboardModel: Hashable {
    let id: String
    let name: String
    let date: String
    let city: String
    let objectName: String
    let image: EventImage?
    
    static func == (lhs: EventsDashboardModel, rhs: EventsDashboardModel) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

enum SortOption {
    case single(field: Field, order: Order)
    case none

    func stringValue() -> String {
        switch self {
        case let .single(field, order):
            guard field != .none else { return "" }
            return "\(field.rawValue),\(order.rawValue)"
        case .none:
            return ""
        }
    }
}

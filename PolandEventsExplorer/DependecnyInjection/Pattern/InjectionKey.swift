protocol InjectionKey {
    associatedtype Value
    
    static var currentValue: Self.Value { get set }
}

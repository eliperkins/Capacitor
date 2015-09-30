public protocol Action {
    typealias ActionType
    var source: String { get }
    var action: ActionType { get }
}

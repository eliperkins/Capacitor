public class Store<State, Payload: Action> {
    
    public func addChangeListener(callback: (Store -> Void)) -> Token {
        let token = NSUUID().UUIDString
        changeListeners[token] = callback
        return token
    }
    
    public func removeChangeListener(token: Token) {
        changeListeners.removeValueForKey(token)
    }
    
    private(set) var token: Token = ""
    
    private var changeListeners: [Token:(Store -> Void)]

    private(set) public var changed: Bool
    
    public let dispatcher: Dispatcher<Payload>
    
    public init(dispatcher: Dispatcher<Payload>) {
        self.changeListeners = [:]
        self.dispatcher = dispatcher
        self.changed = false
        self.token = dispatcher.register {
            [weak self] payload in
            self?.invokeOnDispatch(payload)
        }
    }
    
    
    public func invokeOnDispatch(payload: Payload) {
        changed = false
        onDispatch(payload)
        if changed {
            emit()
        }
    }
    
    /// The callback that will be registered with the dispatcher during
    /// instantiation. Subclasses must override this method. This callback is the
    /// only way the store receives new data.
    ///
    /// - parameters:
    ///   - payload: The data dispatched by the dispatcher, describing
    ///     something that has happened in the real world: the user clicked, the
    ///     server responded, time passed, etc.
    public func onDispatch(payload: Payload) {
        fatalError("Subclasses must implement this functionality.")
    }
    
    private func emitChanged() {
        if !dispatcher.isDispatching() {
            fatalError("This must only be called while dispatching.")
        }
        changed = true
    }
    
    public func emit() {
        self.changeListeners.forEach {
            $0.1(self)
        }
    }
}

public class ReduceStore<State: Equatable, Payload: Action> : Store<State, Payload> {
    
    public private(set) var state: State
    
    public init(dispatcher: Dispatcher<Payload>, initialState: State) {
        state = initialState
        super.init(dispatcher: dispatcher)
    }
    
    public func reduce(state: State, action: Payload) -> State {
        fatalError("Subclasses must implement this functionality.")
    }
    
    override public func invokeOnDispatch(payload: Payload) {
        changed = false
        let startingState = state
        let endingState = reduce(startingState, action: payload)
        if startingState != endingState {
            state = endingState
            emitChanged()
        }
        
        if changed {
            emit()
        }
    }
}

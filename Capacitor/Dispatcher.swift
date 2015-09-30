public typealias Token = String

public class Dispatcher<Payload where Payload: Action> {

    private var dispatching: Bool = false
    
    private var callbacks: [Token : DispatchCallback<Payload>] = [:]
    private var handled: [Token : Bool] = [:]
    private var pending: [Token : Bool] = [:]
    private var pendingPayload: Payload?
    
    public init() {

    }

    /// Registers a callback to be invoked with every dispatched payload. Returns a token that can be used with waitFor().
    public func register(callback: (Payload -> Void)) -> Token {
        let dispatchCallback = DispatchCallback(callback: callback, token: NSUUID().UUIDString)
        callbacks[dispatchCallback.token] = dispatchCallback
        return dispatchCallback.token
    }
    
    /// Removes a callback based on its token.
    public func unregister(token: Token) {
        guard let _ = callbacks[token] else {
            fatalError("Callback index could not be found to unregister token \(token).")
        }
        callbacks.removeValueForKey(token)
    }
    
    /// Waits for the callbacks specified to be invoked before continuing execution of the current callback. This method should only be used by a callback in response to a dispatched payload.
    public func waitFor(tokens: [Token]) {
        if !isDispatching() {
            fatalError("Illegal call to waitFor() with tokens \(tokens). Only call waitFor() while dispatching.")
        }
        tokens.forEach {
            token in
            guard self.pending[token] == nil else {
                fatalError("Circular reference to token callback: \(token).")
            }
            guard let callback = callbacks[token] else {
                fatalError("Token \(token) does not map to registered callback.")
            }
            invokeCallback(callback)
        }
    }
    
    /// Dispatches a payload to all registered callbacks.
    public func dispatch(payload: Payload) {
        startDispatching(payload)
        // TODO: Promise chain if needed? or async?
        callbacks.forEach {
            $0.1.callback(payload)
        }
        stopDispatching()
    }
    
    /// Is this Dispatcher currently dispatching.
    public func isDispatching() -> Bool {
        return dispatching
    }
    
    private func invokeCallback(callback: DispatchCallback<Payload>) {
        pending[callback.token] = true
        guard let pendingPayload = pendingPayload else {
            fatalError("Callback \(callback.token) invoked without payload to send.")
        }
        callback.callback(pendingPayload)
        handled[callback.token] = true
    }
    
    private func startDispatching(payload: Payload) {
        callbacks.forEach {
            handled[$0.0] = false
            pending[$0.0] = false
        }
        pendingPayload = payload
        dispatching = true
    }
    
    private func stopDispatching() {
        pendingPayload = nil
        dispatching = false
    }
}

struct DispatchCallback<Payload> {
    let callback: (Payload -> Void)
    let token: Token
}


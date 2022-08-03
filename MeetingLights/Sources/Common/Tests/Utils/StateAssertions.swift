import Asynchrone
import CustomDump
import RedUx
import XCTest

/// Assert that a store's state changes match expectation after sending
/// a collection of events.
/// - Parameters:
///   - store: The store to test state changes against.
///   - event: The event to send to the store.
///   - statesToMatch: An array of state changes expected. These will be asserted
///     equal against the store's state changes.
///   - timeout: Time to wait for store state changes. Defaults to `5`
///   - file: The file where this assertion is being called. Defaults to `#filePath`.
///   - line: The line in the file where this assertion is being called. Defaults to `#line`.
func XCTAssertStateChange<State: Equatable, Event, Environment>(
    store: Store<State, Event, Environment>,
    event: Event,
    matches statesToMatch: [State],
    timeout: TimeInterval = 5.0,
    file: StaticString = #filePath,
    line: UInt = #line
) async {
    let expectationTask = Task<Void, Error> {
        var states: [State] = []
        let sequence = Just(await store.state)
            .eraseToAnyAsyncSequenceable()
            .chain(with: await store.stateSequence)
            .removeDuplicates()
        
        do {
            for try await state in sequence {
                states.append(state)
                if states.count == 1 {
                    Task.detached {
                        await store.send(event)
                    }
                }
                
                if states == statesToMatch {
                    break
                }
            }
            
            // Task cancelled...
            guard Task.isCancelled else { return }
            let error = XCTAssertStatesEventuallyEqualError(
                stateChanges: states,
                stateChangesExpected: statesToMatch
            )
            throw error
        } catch {
            throw error
        }
    }
    
    Task<Void, Error>.detached {
        try? await Task.sleep(seconds: timeout)
        guard !Task.isCancelled,
              !expectationTask.isCancelled else { return }
        expectationTask.cancel()
        throw TimeoutError()
    }
    
    switch await expectationTask.result {
    case .failure(let error):
        XCTFail(
            error.localizedDescription,
            file: file,
            line: line
        )
    case .success:()
    }
}

struct TimeoutError: Error {}

/// Assert two async expressions are eventually equal.
/// - Parameters:
///   - expressionA: Expression A
///   - expressionB: Expression B
///   - timeout: Time to wait for store state changes. Defaults to `2`
///   - file: The file where this assertion is being called. Defaults to `#filePath`.
///   - line: The line in the file where this assertion is being called. Defaults to `#line`.
func XCTAssertEventuallyEqual<T: Equatable>(
    _ expressionA: @escaping @autoclosure () -> T?,
    _ expressionB: @escaping @autoclosure () -> T?,
    timeout: TimeInterval = 5.0,
    file: StaticString = #filePath,
    line: UInt = #line
) async {
    let timeoutDate = Date(timeIntervalSinceNow: timeout)
            
    while true {
        let resultA = expressionA()
        let resultB = expressionB()
        
        switch resultA == resultB {
        // All good!
        case true:
            return
        // False and timed out.
        case false where Date.now.compare(timeoutDate) == .orderedDescending:
            let error = XCTAssertEventuallyEqualError(
                resultA: resultA,
                resultB: resultB
            )

            XCTFail(
                error.message,
                file: file,
                line: line
            )
            return
        // False but still within timeout limit.
        case false:
            try? await Task.sleep(nanoseconds: 1000000)
        }
    }
}

// MARK: XCTAssertStatesEventuallyEqualError

struct XCTAssertStatesEventuallyEqualError: LocalizedError {
    let message: String

    var errorDescription: String? {
        self.message
    }
    
    var localizedDescription: String {
        self.message
    }

    // MARK: Initialization

    init(_ message: String) {
        self.message = message
    }

    init<State: Equatable>(stateChanges: [State], stateChangesExpected: [State]) {
        self.init(
            """

---------------------------
Failed To Assert Equality
---------------------------
\(diff(stateChangesExpected, stateChanges) ?? "")
"""
        )
    }
}

import RedUx

typealias AppStore = Store<AppState, AppEvent, AppEnvironment>

extension AppStore {
    static func make(
        state: State = .init()
    ) -> Self {
        .init(
            state: state,
            reducer: AppReducer.main,
            environment: .main()
        )
    }

    #if DEBUG
    static func test(
        state: State = .init(),
        environment: Environment = .mock()
    ) -> Self {
        .init(
            state: state,
            reducer: AppReducer.main,
            environment: environment
        )
    }
    #endif
}

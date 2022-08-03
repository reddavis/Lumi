import RedUx

typealias SettingsStore = Store<SettingsState, SettingsEvent, SettingsEnvironment>

extension SettingsStore {
    static func make(
        state: State = .init(),
        environment: Environment = .main()
    ) -> Self {
        .init(
            state: .init(),
            reducer: reducer,
            environment: .main()
        )
    }

    #if DEBUG || ADHOC
    static func mock(
        state: State = .init(),
        environment: Environment = .mock()
    ) -> Self {
        .init(
            state: state,
            reducer: .empty,
            environment: environment
        )
    }
    #endif
}

private let reducer: Reducer<SettingsState, SettingsEvent, SettingsEnvironment> = SettingsReducer.main

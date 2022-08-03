import RedUx

typealias OnboardingStore = Store<OnboardingState, OnboardingEvent, OnboardingEnvironment>

extension OnboardingStore {
    static func make(
        state: State = .init()
    ) -> Self {
        .init(
            state: state,
            reducer: OnboardingReducer.main,
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
            reducer: OnboardingReducer.main,
            environment: environment
        )
    }
    #endif
}

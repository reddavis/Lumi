import Foundation

public enum ApplicationError: LocalizedError {
    case standard(Error)
    case collection([Error])
    case unknown

    // MARK: Builders

    public static func build(_ error: Error) -> ApplicationError {
        .standard(error)
    }

    // MARK: Description

    public var errorDescription: String? {
        switch self {
        case let .standard(error):
            return error.localizedDescription
        case let .collection(errors):
            return errors
                .map { $0.localizedDescription }
                .joined(separator: "\n")
        case .unknown:
            return "Unknown error"
        }
    }
}

// MARK: Equatable

extension ApplicationError: Equatable {
    public static func == (lhs: ApplicationError, rhs: ApplicationError) -> Bool {
        lhs.localizedDescription == rhs.localizedDescription
    }
}

// MARK: Sequence

extension Sequence where Element == ApplicationError {
    public var message: String {
        map { $0.localizedDescription }
            .joined(separator: "\n")
    }
}

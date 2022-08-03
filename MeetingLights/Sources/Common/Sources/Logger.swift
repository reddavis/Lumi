import Foundation
import os.log

public final class Logger {
    // Public
    var logLevel: LogLevel = .info

    // Private
    private let log: OSLog

    // MARK: Initialziation

    public init(subsystem: String, category: String) {
        log = OSLog(subsystem: subsystem, category: category)
    }

    // MARK: API

    public func info(_ message: String) {
        log("ℹ️ \(message)", level: .info)
    }

    func debug(_ message: String) {
        log("🔎 \(message)", level: .debug)
    }

    func error(_ message: String) {
        log("⚠️ \(message)", level: .error)
    }

    func fault(_ message: String) {
        log("🔥 \(message)", level: .fault)
    }

    // MARK: Log

    private func log(_ message: String, level: LogLevel) {
        guard level >= logLevel,
              let type = level.logType else { return }
        os_log("%@", log: log, type: type, message)
    }
}

// MARK: Log level

extension Logger {
    enum LogLevel: Int {
        case info
        case debug
        case error
        case fault
        case off

        var logType: OSLogType? {
            switch self {
            case .info:
                return .info
            case .debug:
                return .debug
            case .error:
                return .error
            case .fault:
                return .fault
            case .off:
                return nil
            }
        }
    }
}

// MARK: Comparable

extension Logger.LogLevel: Comparable {
    static func < (lhs: Logger.LogLevel, rhs: Logger.LogLevel) -> Bool { lhs.rawValue < rhs.rawValue }
}

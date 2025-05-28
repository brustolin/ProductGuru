/**
 * This is a Log entry point to register error
 * The current implementation only prints the error to console.
 * We could change implementation to use any monitoring SaaS.
 */
public final class Log: Sendable {
    // We will handle isolation safety by only changing the shared logger in the main thread
    private static nonisolated(unsafe) var shared: Logger = DefaultLogger()
    
    @MainActor
    public static func configure(using logger: Logger) {
        shared = logger
    }
    
    public static func error(_ error: any Error, file: StaticString = #file, line: UInt = #line) {
        shared.error(error, file: file, line: line)
    }
}

/**
 Its possible to use this protocol to override
 Log default behaviour.
 */
public protocol Logger {
    func error(_ error: any Error, file: StaticString, line: UInt)
}

private final class DefaultLogger: Logger, Sendable {
    public func error(_ error: any Error, file: StaticString, line: UInt) {
        print("[\(file):\(line)] \(error)")
    }
}

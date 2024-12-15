import Foundation

enum RunMode {
    case all
    case day(Int)
    case last
    case none
}

// Example day registry
let days: [Int: Day] = [
    1: Day01(),
]

print("Arguments: \(CommandLine.arguments)")
let args = CommandLine.arguments.dropFirst() // Drop the executable name
print("Parsed arguments: \(args)")

var mode: RunMode = .none

if let dayIndex = args.firstIndex(of: "--day") {
    let dayArg = args[dayIndex + 1]
    if let dayNumber = Int(dayArg) {
        print("Mode: Run day \(dayNumber)")
        mode = .day(dayNumber)
    } else {
        print("Error: Invalid day number '\(dayArg)' after --day.")
    }
} else if args.contains("--all") {
    print("Mode: Run all days")
    mode = .all
} else if args.contains("--last") {
    if let lastDayNumber = days.keys.max() {
        print("Mode: Run last day (\(lastDayNumber))")
        mode = .day(lastDayNumber)
    } else {
        print("Error: No days available to run.")
    }
} else {
    print("No valid command found in arguments.")
}

switch mode {
case .all:
    for dayNumber in days.keys.sorted() {
        runDay(dayNumber)
    }
case .day(let number):
    runDay(number)
case .last:
    // This is handled by converting last to .day internally above
    break
case .none:
    print("No command provided. Use --all, --day X, or --last.")
}

@MainActor func runDay(_ dayNumber: Int) {
    guard let day = days[dayNumber] else {
        print("Day \(dayNumber) not found.")
        return
    }
    
    //https://old.reddit.com/r/adventofcode/comments/a1qovy/please_dont_spam_requests_to_aoc/
    //let input = InputFetcher.fetchInput(for: dayNumber)
    let start = DispatchTime.now()
    day.run(input)
    let end = DispatchTime.now()

    let nanoTime = end.uptimeNanoseconds - start.uptimeNanoseconds
    let timeInterval = Double(nanoTime) / 1_000_000_000
    
    print("Time: \(timeInterval)s")
}

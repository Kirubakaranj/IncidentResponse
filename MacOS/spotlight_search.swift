import Foundation

// Search Spotlight metadata for suspicious content
let query = NSMetadataQuery()
query.predicate = NSPredicate(format: "kMDItemTextContent == '*malicious*' OR kMDItemDisplayName == '*suspicious*'")
query.sortDescriptors = [NSSortDescriptor(key: NSMetadataItemFSContentChangeDateKey, ascending: false)]

NotificationCenter.default.addObserver(forName: .NSMetadataQueryDidFinishGathering, object: query, queue: nil) { _ in
    for result in query.results {
        if let item = result as? NSMetadataItem,
           let path = item.value(forAttribute: NSMetadataItemPathKey) as? String {
            print("Found match: \(path)")
        }
    }
    exit(0)
}

query.start()
RunLoop.current.run()

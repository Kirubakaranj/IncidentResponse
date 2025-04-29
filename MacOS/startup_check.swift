#!/usr/bin/env swift
// macOS Startup Item Auditor v1.0.0
// Checks launchd/launchctl entries and recent login items

import Foundation
import AppKit

struct StartupItem: Codable {
    let name: String
    let path: String
    let type: String
    let signatureValid: Bool
    let lastModified: Date
}

func getLaunchdItems() -> [StartupItem] {
    var items = [StartupItem]()
    
    // Get launchd items
    let launchdPaths = [
        "/Library/LaunchAgents",
        "/Library/LaunchDaemons",
        "~/Library/LaunchAgents"
    ]
    
    for path in launchdPaths {
        let expandedPath = (path as NSString).expandingTildeInPath
        if let contents = try? FileManager.default.contentsOfDirectory(atPath: expandedPath) {
            for item in contents {
                let fullPath = "\(expandedPath)/\(item)"
                if let attributes = try? FileManager.default.attributesOfItem(atPath: fullPath),
                   let modDate = attributes[.modificationDate] as? Date {
                    
                    let signatureValid = verifySignature(path: fullPath)
                    items.append(StartupItem(
                        name: item,
                        path: fullPath,
                        type: "launchd",
                        signatureValid: signatureValid,
                        lastModified: modDate
                    ))
                }
            }
        }
    }
    
    return items
}

func getLoginItems() -> [StartupItem] {
    var items = [StartupItem]()
    
    // Get login items
    if let sharedWorkspace = NSWorkspace.shared as? NSWorkspace {
        for app in sharedWorkspace.runningApplications {
            if let bundleURL = app.bundleURL,
               let attributes = try? FileManager.default.attributesOfItem(atPath: bundleURL.path),
               let modDate = attributes[.modificationDate] as? Date {
                
                let signatureValid = verifySignature(path: bundleURL.path)
                items.append(StartupItem(
                    name: bundleURL.lastPathComponent,
                    path: bundleURL.path,
                    type: "login",
                    signatureValid: signatureValid,
                    lastModified: modDate
                ))
            }
        }
    }
    
    return items
}

func verifySignature(path: String) -> Bool {
    let task = Process()
    task.launchPath = "/usr/bin/codesign"
    task.arguments = ["-v", path]
    
    let pipe = Pipe()
    task.standardError = pipe
    task.launch()
    task.waitUntilExit()
    
    return task.terminationStatus == 0
}

func main() {
    var allItems = [StartupItem]()
    allItems.append(contentsOf: getLaunchdItems())
    allItems.append(contentsOf: getLoginItems())
    
    let encoder = JSONEncoder()
    encoder.outputFormatting = .prettyPrinted
    encoder.dateEncodingStrategy = .iso8601
    
    if let jsonData = try? encoder.encode(allItems),
       let jsonString = String(data: jsonData, encoding: .utf8) {
        print(jsonString)
    } else {
        print("{\"error\": \"Failed to encode results\"}")
        exit(1)
    }
}

main()

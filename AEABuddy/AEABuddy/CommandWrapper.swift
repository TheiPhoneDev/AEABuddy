//
//  CommandWrapper.swift
//  AEABuddy
//
//  Created by Pietro Gambatesa on 7/20/25.
//

import Foundation

@discardableResult
func shellCommand(_ command: String) -> String {
    let process = Process()
    let pipe = Pipe()
    
    process.standardOutput = pipe
    process.standardError = pipe
    process.launchPath = "/bin/zsh"
    process.arguments = ["-c", command]
    process.standardInput = nil
    process.launch()
    
    let data = pipe.fileHandleForReading.readDataToEndOfFile()
    let output = String(data: data, encoding: .utf8) ?? ""
    print(output)
    
    return output
}

//
//  MyTimer.swift
//  uClock
//
//  Created by Eric Walter on 03.02.21.
//

import SwiftUI
import Intents

/// Class to represent a single work timer which can be coded and decoded to a JSON data object
class MyTimer: Codable, Identifiable {
    
    var id: UUID
    var projectName: String
    var clientName: String?
    var taskName: String
    var storedElapsed: Int
    var startTimeStamp: Date
    var stopTimeStamp: Date
    var isRunning: Bool
    var timerColor: UIColor
    
    /// Initialize all variables
    init(projectName: String, clientName: String?, taskName: String, storedElapsed: Int, startTimeStamp: Date, stopTimeStamp: Date, isRunning: Bool, timerColor: UIColor) {
        
        self.id = UUID()
        self.projectName = projectName
        self.clientName = clientName
        self.taskName = taskName
        self.storedElapsed = storedElapsed
        self.startTimeStamp = startTimeStamp
        self.stopTimeStamp = stopTimeStamp
        self.isRunning = isRunning
        self.timerColor = timerColor
    }
    
    /// Initialize from decoder with coding keys
    required init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = UUID()
        projectName = try container.decode(String.self, forKey: .projectName)
        taskName = try container.decode(String.self, forKey: .taskName)
        clientName = try container.decode(String?.self, forKey: .clientName)
        projectName = try container.decode(String.self, forKey: .projectName)
        storedElapsed = try container.decode(Int.self, forKey: .storedElapsed)
        startTimeStamp = try container.decode(Date.self, forKey: .startTimeStamp)
        stopTimeStamp = try container.decode(Date.self, forKey: .stopTimeStamp)
        isRunning = try container.decode(Bool.self, forKey: .isRunning)
        timerColor = try container.decode(CodableColor.self, forKey: .timerColor).color
    }
    
    /// Function to encode timer object into container with coding keys
    func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(projectName, forKey: .projectName)
        try container.encode(taskName, forKey: .taskName)
        try container.encode(clientName, forKey: .clientName)
        try container.encode(storedElapsed, forKey: .storedElapsed)
        try container.encode(startTimeStamp, forKey: .startTimeStamp)
        try container.encode(stopTimeStamp, forKey: .stopTimeStamp)
        try container.encode(isRunning, forKey: .isRunning)
        try container.encode(timerColor.codable(), forKey: .timerColor)
    }
}

// MARK: - Coding Keys
/// Define coding key enums
enum CodingKeys: String, CodingKey {
    
    case id
    case projectName
    case clientName
    case taskName
    case storedElapsed
    case startTimeStamp
    case stopTimeStamp
    case isRunning
    case timerColor
}

//MARK: - CodableColor
/*
 This is an extension to use UIColor with Codable protocol by Ben Leggiero
 https://gist.github.com/BenLeggiero/120fe68857703107881e7f33a88111f2
 */
/// Allows you to use Swift encoders and decoders to process UIColor
public struct CodableColor {
    
    /// The color to be (en/de)coded
    let color: UIColor
}

/// Make CodableColor encodable
extension CodableColor: Encodable {
    
    /// Function to encode the data
    public func encode(to encoder: Encoder) throws {
        
        let nsCoder = NSKeyedArchiver(requiringSecureCoding: true)
        color.encode(with: nsCoder)
        var container = encoder.unkeyedContainer()
        try container.encode(nsCoder.encodedData)
    }
}

/// Make CodableColor decodable
extension CodableColor: Decodable {
    
    /// Initialize from decoder
    public init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        let decodedData = try container.decode(Data.self)
        let nsCoder = try NSKeyedUnarchiver(forReadingFrom: decodedData)
        
        guard let color = UIColor(coder: nsCoder) else {
            struct UnexpectedlyFoundNilError: Error {}
            throw UnexpectedlyFoundNilError()
        }
        self.color = color
    }
}

/// Add codable function to UIColor
public extension UIColor {
    
    /// Function to return a CodableColor object
    func codable() -> CodableColor {
        return CodableColor(color: self)
    }
}

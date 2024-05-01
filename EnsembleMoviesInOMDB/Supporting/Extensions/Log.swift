//
//  Log.swift
//  ConceptLibrary
//
//  Created by Lucas C Barros on 2024-04-08.
//
// Reference: https://www.youtube.com/watch?v=Ao6jkaV_9Kc

import Foundation

enum Log {
    enum LogLevel {
        case info
        case warning
        case error
        
        fileprivate var prefix: String {
            switch self {
            case .info: return "INFO ℹ️"
            case .warning: return "WARN ⚠️"
            case .error: return "ALERT ❌"
            }
        }
    }
    
    struct Context {
        let file: String
        let function: String
        let line: Int
        // The state the app was in before the error
        var description: String {
            return "\((file as NSString).lastPathComponent):\(line) \(function)"
        }
    }
    
    // #file is Literal Expression: Swift will substitute in runtime
    static func info(_ str: String, shouldLogContext: Bool = true, file: String = #file, function: String = #function, line: Int = #line) {
        let context = Context(file: file, function: function, line: line)
        Log.handleLog(level: .info, str: str.description, shouldLogContext: shouldLogContext, context: context)
        
    }
    
    static func warning(_ str: String, shouldLogContext: Bool = true, file: String = #file, function: String = #function, line: Int = #line) {
        let context = Context(file: file, function: function, line: line)
        Log.handleLog(level: .warning, str: str.description, shouldLogContext: shouldLogContext, context: context)
        
    }
    
    static func error(_ str: String, shouldLogContext: Bool = true, file: String = #file, function: String = #function, line: Int = #line) {
        let context = Context(file: file, function: function, line: line)
        Log.handleLog(level: .error, str: str.description, shouldLogContext: shouldLogContext, context: context)
        
    }
    
    fileprivate static func handleLog(level: LogLevel, str: String, shouldLogContext: Bool, context: Context) {
        let logComponents = ["[\(level.prefix)] >>", str]
        
        var fullString = logComponents.joined(separator: " ")
        if shouldLogContext {
            fullString += " ➢ \(context.description)"
        }
        
        #if DEBUG
        print(fullString)
        #endif
    }
}

import UIKit
extension UIView {
    
    func debugMode(subLevels: Int = 5,
                   contrast: Int = 1,
                   debugColor: DebugColor = .redScale) {
        
        debugSubView(subLevels: subLevels,
                     currentLevel: subLevels,
                     contrast: contrast,
                     debugColor: debugColor,
                     in: self)
    }
    
    private func debugSubView(subLevels: Int,
                              currentLevel: Int,
                              contrast: Int,
                              debugColor: DebugColor,
                              in subview: UIView) {
        
        for subView in self.subviews {
            let maxLevel = CGFloat(subLevels)
            let current = CGFloat(currentLevel)
            let contrastFraction = CGFloat(contrast)/maxLevel
            
            subView.backgroundColor = debugColor.color((current/maxLevel) + contrastFraction)
            
            if subLevels < 0 {
                debugSubView(subLevels: subLevels,
                             currentLevel: subLevels-1,
                             contrast: contrast,
                             debugColor: debugColor,
                             in: subView)
            }
        }
    }
}

enum DebugColor {
    case redScale, blueScale, greenScale, grayScale, pinkScale, yellowScale, cyanScale
    
    func color(_ levelFraction: CGFloat) -> UIColor {
        let step = (levelFraction) * 255.0
        
        switch self {
        case .redScale:
            return UIColor(red: step/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 1.0)
        case .blueScale:
            return UIColor(red: 0.0/255.0, green: 0.0/255.0, blue: step/255.0, alpha: 1.0)
        case .greenScale:
            return UIColor(red: 0.0/255.0, green: step/255.0, blue: 0.0/255.0, alpha: 1.0)
            
        case .pinkScale:
            return UIColor(red: 255.0/255.0, green: step/255.0, blue: 255.0/255.0, alpha: 1.0)
        case .yellowScale:
            return UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: step/255.0, alpha: 1.0)
        case .cyanScale:
            return UIColor(red: step/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0)
            
        case .grayScale:
            return UIColor(red: step/255.0, green: step/255.0, blue: step/255.0, alpha: 1.0)
        }
    }
}

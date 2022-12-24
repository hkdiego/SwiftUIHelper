//
//  String.swift
//  
//
//  Created by Aleksandr Nesterov on 17.11.2020.
//

import Foundation
import UIKit

extension String {
    var isNotEmpty: Bool {
        return !isEmpty
    }
}

extension String {
    
    ///
    func substring(to index: Int) -> String {
        guard let end_Index = validEndIndex(original: index) else {
            return self
        }
        return String(self[startIndex..<end_Index])
    }
    ///
    func substring(from index: Int) -> String {
        guard let start_index = validStartIndex(original: index)  else {
            return self
        }
        return String(self[start_index..<endIndex])
    }
    
    ///
    func sliceString(_ range: CountableRange<Int>) -> String {
        guard
            let startIndex = validStartIndex(original: range.lowerBound),
            let endIndex   = validEndIndex(original: range.upperBound),
            startIndex <= endIndex
            else {
                return ""
        }
        return String(self[startIndex..<endIndex])
    }
    ///
    func sliceString(_ range: CountableClosedRange<Int>) -> String {
        guard
            let start_Index = validStartIndex(original: range.lowerBound),
            let end_Index   = validEndIndex(original: range.upperBound),
            startIndex <= endIndex
            else {
                return ""
        }
        if endIndex.utf16Offset(in: self) <= end_Index.utf16Offset(in: self) {
            return String(self[start_Index..<endIndex])
        }
        return String(self[start_Index...end_Index])
    }
    
    private func validIndex(original: Int) -> String.Index {
        switch original {
        case ...startIndex.utf16Offset(in: self) : return startIndex
        case endIndex.utf16Offset(in: self)...   : return endIndex
        default                          : return index(startIndex, offsetBy: original)
        }
    }
    
    private func validStartIndex(original: Int) -> String.Index? {
        guard original <= endIndex.utf16Offset(in: self) else { return nil }
        return validIndex(original: original)
    }
    
    private func validEndIndex(original: Int) -> String.Index? {
        guard original >= startIndex.utf16Offset(in: self) else { return nil }
        return validIndex(original: original)
    }
    
    
    /// removing all non-numeric characters from a string and keep '+' if occurrences
    func phoneNumeric() -> String {
        return self.replacingOccurrences(of: "[^0-9+]", with: "", options: .regularExpression)
    }
    
    /// removing all non-numeric characters from a string
    func numeric() -> String {
        return self.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
    }

    /// Converts self to an unsigned byte array.
    public var bytes: [UInt8] {
        return utf8.map { $0 }
    }

    /// Converts self to an NSMutableAttributedString.
    public var attributed: NSMutableAttributedString {
        return NSMutableAttributedString(string: self)
    }

    /// Converts self to an NSString.
    public var ns: NSString {
        return self as NSString
    }

    /**
     The base64 encoded version of self.
     Credit: http://stackoverflow.com/a/29365954
     */
    public var base64Encoded: String? {
        let utf8str = data(using: .utf8)
        return utf8str?.base64EncodedString()
    }

    /**
     The decoded value of a base64 encoded string
     Credit: http://stackoverflow.com/a/29365954
     */
    public var base64Decoded: String? {
        guard let data = Data(base64Encoded: self, options: []) else { return nil }
        return String(data: data, encoding: .utf8)
    }

    /**
     Returns true if every character within the string is a numeric character. Empty strings are
     considered non-numeric.
     */
    public var isNumeric: Bool {
        guard !isEmpty else { return false }
        return trimmingCharacters(in: .decimalDigits).isEmpty
    }

    /**
     Replaces all occurences of the pattern on self in-place.

     Examples:

     ```
     "hello".regexInPlace("[aeiou]", "*")      // "h*ll*"
     "hello".regexInPlace("([aeiou])", "<$1>") // "h<e>ll<o>"
     ```
     */
    public mutating func formRegex(_ pattern: String, _ replacement: String) {
        do {
            let expression = try NSRegularExpression(pattern: pattern, options: [])
            let range = NSRange(location: 0, length: count)
            self = expression.stringByReplacingMatches(in: self, options: [], range: range, withTemplate: replacement)
        } catch { return }
    }

    /**
     Returns a string containing replacements for all pattern matches.

     Examples:

     ```
     "hello".regex("[aeiou]", "*")      // "h*ll*"
     "hello".regex("([aeiou])", "<$1>") // "h<e>ll<o>"
     ```
     */
    public func regex(_ pattern: String, _ replacement: String) -> String {
        var replacementString = self
        replacementString.formRegex(pattern, replacement)
        return replacementString
    }

    /**
     Replaces pattern-matched strings, operated upon by a closure, on self in-place.

     - parameter pattern: The pattern to match against.
     - parameter matches: The closure in which to handle matched strings.

     Example:

     ```
     "hello".regexInPlace(".") {
     let s = $0.unicodeScalars
     let v = s[s.startIndex].value
     return "\(v) "
     }   // "104 101 108 108 111 "
     */
    public mutating func formRegex(_ pattern: String, _ matches: (String) -> String) {

        let expression: NSRegularExpression
        do {
            expression = try NSRegularExpression(pattern: "(\(pattern))", options: [])
        } catch {
            print("regex error: \(error)")
            return
        }

        let range = NSMakeRange(0, count)

        var startOffset = 0

        let results = expression.matches(in: self, options: [], range: range)

        for result in results {

            var endOffset = startOffset

            for i in 1 ..< result.numberOfRanges {
                var resultRange = result.range
                resultRange.location += startOffset

                let startIndex = index(self.startIndex, offsetBy: resultRange.location)
                let endIndex = index(self.startIndex, offsetBy: resultRange.location + resultRange.length)
                let replacementRange = startIndex ..< endIndex

                let match = expression.replacementString(for: result, in: self, offset: startOffset, template: "$\(i)")
                let replacement = matches(match)

                replaceSubrange(replacementRange, with: replacement)

                endOffset += replacement.count - resultRange.length
            }

            startOffset = endOffset
        }
    }

    /**
     Returns a string with pattern-matched strings, operated upon by a closure.

     - parameter pattern: The pattern to match against.
     - parameter matches: The closure in which to handle matched strings.

     - returns: String containing replacements for the matched pattern.

     Example:

     ```
     "hello".regex(".") {
     let s = $0.unicodeScalars
     let v = s[s.startIndex].value
     return "\(v) "
     }   // "104 101 108 108 111 "
     */
    public func regex(_ pattern: String, _ matches: (String) -> String) -> String {
        var replacementString = self
        replacementString.formRegex(pattern, matches)
        return replacementString
    }

    /**
     A bridge for invoking `String.localizedStandardContainsString()`, which is available in iOS 9 and later. If you need to
     support iOS versions prior to iOS 9, use `compatibleStandardContainsString()` as a means to bridge functionality.
     If you can support iOS 9 or greater only, use `localizedStandardContainsString()` directly.

     From Apple's Swift 2.1 documentation:

     `localizedStandardContainsString()` is the most appropriate method for doing user-level string searches, similar to how searches are done generally in the system. The search is locale-aware, case and diacritic insensitive. The exact list of search options applied may change over time.

     - parameter string: The string to determine if is contained by self.

     - returns: Returns true if self contains string, taking the current locale into account.
     */
    public func compatibleStandardContains(_ string: String) -> Bool {
        if #available(iOS 9.0, *) {
            return localizedStandardContains(string)
        }
        return range(of: string, options: [.caseInsensitive, .diacriticInsensitive], locale: .current) != nil
    }

    /**
     Convert an NSRange to a Range. There is still a mismatch between the regular expression libraries
     and NSString/String. This makes it easier to convert between the two. Using this allows complex
     strings (including emoji, regonial indicattors, etc.) to be manipulated without having to resort
     to NSString instances.

     Note that it may not always be possible to convert from an NSRange as they are not exactly the same.

     Taken from:
     http://stackoverflow.com/questions/25138339/nsrange-to-rangestring-index

     - parameter nsRange: The NSRange instance to covert to a Range.

     - returns: The Range, if it was possible to convert. Otherwise nil.
     */
    public func range(from nsRange: NSRange) -> Range<String.Index>? {
        return Range(nsRange, in: self)
    }

    /**
     Convert a Range to an NSRange. There is still a mismatch between the regular expression libraries
     and NSString/String. This makes it easier to convert between the two. Using this allows complex
     strings (including emoji, regonial indicators, etc.) to be manipulated without having to resort
     to NSString instances.

     Taken from:
     http://stackoverflow.com/questions/25138339/nsrange-to-rangestring-index

     - parameter range: The Range instance to conver to an NSRange.

     - returns: The NSRange converted from the input. This will always succeed.
     */
    public func nsRange(from range: Range<String.Index>) -> NSRange {
        return NSRange(range, in: self)
    }
}

extension Optional where Wrapped == String {
    var isNilOrEmpty: Bool {
        switch self {
        case let string?:
            return string.isEmpty
        case nil:
            return true
        }
    }
    
    var isNotNilOrEmpty: Bool { return !isNilOrEmpty }
}

extension String {

    public func size(withFont font: UIFont, constrainedToWidth width: CGFloat? = nil) -> CGSize {
        // TODO: update this method after Swift 4.2 migration

        let size: CGSize
        if let width = width {
            size = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        } else {
            size = CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
        }

        let attributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: font]
        let result = (self as NSString).boundingRect(with: size, options: [.usesLineFragmentOrigin], attributes: attributes, context: nil).size

        return result
    }
}


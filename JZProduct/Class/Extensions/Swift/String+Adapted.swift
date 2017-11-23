//
//  String+Inflections.swift
//  JeffZhao
//
//  Created by Jeff Zhao on 15/9/17.
//  Copyright © 2015 JZ Studio. All rights reserved.
//

import JZSwiftWarpper

extension String: JZStudioCompatible { }

extension JZStudio where Base == String {
    
    var underscore: String {
        return (self.base as NSString).underscore() 
    }
    
    var camelize: String {
        return (self.base as NSString).camelcase()
    }
    
    var classify: String {
        return (self.base as NSString).classify()
    }
    
    var capitalize: String {
        return (self.base as NSString).capitalize()
    }
    
    var decapitalize: String {
        return (self.base as NSString).decapitalize()
    }
    
    func trimmed() -> String {
        return self.base.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    
    func split(_ separator: String) -> [String] {
        return self.base.components(separatedBy: separator)
    }
    
    func contains(_ find: String) -> Bool {
        return base.range(of: find) != nil
    }
    
    subscript(index:Int) -> Character{
        let startIndex = base.startIndex
        let endIndex = base.endIndex
        let range = base.index(startIndex, offsetBy: index, limitedBy: endIndex)
        return base[range!]
    }
    
    subscript(range:Range<Int>) -> String {
        let startIndex = base.startIndex
        let endIndex = base.endIndex
        let start = base.index(startIndex, offsetBy: range.lowerBound, limitedBy: endIndex)
        let end = base.index(startIndex, offsetBy: range.upperBound, limitedBy: endIndex)
        return String(base[start!..<end!])
    }
    
    func remove(_ subString: String) -> String {
        return base.replacingOccurrences(of: subString, with: "")
    }
    
    func replace(_ subString: String, with: String = "") -> String {
        return base.replacingOccurrences(of: subString, with: with)
    }
    
    var md5: String {
        return (base as NSString).md5()
    }
}

extension JZStudio where Base == String {
    
    var lastPathComponent: String {
        return (base as NSString).lastPathComponent
    }
    
    var pathExtension: String {
        return (base as NSString).pathExtension
    }
    
    var stringByDeletingLastPathComponent: String {
        return (base as NSString).deletingLastPathComponent
    }
    
    var stringByDeletingPathExtension: String {
        return (base as NSString).deletingPathExtension
    }
    
    var pathComponents: [String] {
        return (base as NSString).pathComponents
    }
    
    func stringByAppendingPathComponent(_ path: String) -> String {
        return (base as NSString).appendingPathComponent(path)
    }
    
    func stringByAppendingPathExtension(_ ext: String) -> String? {
        return (base as NSString).appendingPathExtension(ext)
    }
}

extension JZStudio where Base == String {
    
    func boundingSize(limitSize: CGSize, font: UIFont, lineBreakMode: NSLineBreakMode = .byWordWrapping) -> CGSize {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = lineBreakMode;
        let attributes = [NSAttributedStringKey.font: font, NSAttributedStringKey.paragraphStyle: paragraphStyle ]
        let size = (base as NSString).boundingRect(with: limitSize, options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: attributes, context: nil).size
        return CGSize(width: ceil(size.width), height: ceil(size.height))
    }
    
    func draw(at point : CGPoint, font: UIFont) {
        (base as NSString).draw(at: point, withAttributes: [NSAttributedStringKey.font : font])
    }
}



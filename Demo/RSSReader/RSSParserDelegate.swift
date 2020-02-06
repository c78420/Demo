//
//  RSSParserDelegate.swift
//  Demo
//
//  Created by 黃崇漢 on 2018/7/31.
//  Copyright © 2018年 Tony Huang (黃崇漢). All rights reserved.
//

import Foundation

class RSSParserDelegate: NSObject, XMLParserDelegate {
    var currentItem: NewsItem?
    var currentElementValue: String?
    var resultsArray = [NewsItem]()
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        if elementName == "item" {
            self.currentItem = NewsItem()
        }
        else if elementName == "title" {
            self.currentElementValue = nil
        }
        else if elementName == "link" {
            self.currentElementValue = nil
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "item" {
            if let item = currentItem {
                self.resultsArray.append(item)
                self.currentItem = nil
            }
        }
        else if elementName == "title" {
            self.currentItem?.title = self.currentElementValue
        }
        else if elementName == "link" {
            self.currentItem?.link = self.currentElementValue
        }
        
        self.currentElementValue = nil
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        if self.currentElementValue == nil {
            self.currentElementValue = string
        }
        else {
            self.currentElementValue = self.currentElementValue! + string
        }
    }
    
    func getResult() -> [NewsItem] {
        return resultsArray
    }
}

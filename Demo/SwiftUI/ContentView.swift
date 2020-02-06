//
//  ContentView.swift
//  test
//
//  Created by 黃崇漢 on 2019/12/5.
//  Copyright © 2019 Tony. All rights reserved.
//

import SwiftUI

struct ContentData: Identifiable {
    var id = UUID()
    
    var title: String
}

let contentDatas = [
    ContentData(title: "List"),
    ContentData(title: "Form")
]

struct ContentView: View {
    var contentDatas: [ContentData] = []
    
    var body: some View {
        List(contentDatas) { contentData in
            if contentData.title == "List" {
                ContentCellTutors(content: contentData)
            }
            else if contentData.title == "Form" {
                ContentCellForm(content: contentData)
            }
        }
    }
}

struct ContentCellTutors: View {
    let content: ContentData
    
    var body: some View {
        NavigationLink(destination: Tutors(tutors: testData)) {
            Text(content.title)
        }
    }
}

struct ContentCellForm: View {
    let content: ContentData
    
    var body: some View {
        NavigationLink(destination: Form()) {
            Text(content.title)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(contentDatas: contentDatas)
    }
}

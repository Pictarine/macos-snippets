//
//  HierarchyList.swift
//  Snip
//
//  Created by Anthony Fernandez on 7/31/20.
//  Copyright © 2020 pictarine. All rights reserved.
//

import SwiftUI


public struct HierarchyList<Data, RowContent>: View where Data: RandomAccessCollection, Data.Element: Identifiable, RowContent: View {
  private let recursiveView: RecursiveView<Data, RowContent>
  
  public init(data: Data, children: KeyPath<Data.Element, Data?>, rowContent: @escaping (Data.Element) -> RowContent) {
    self.recursiveView = RecursiveView(data: data, children: children, rowContent: rowContent)
  }
  
  public var body: some View {
    recursiveView
  }
}

private struct RecursiveView<Data, RowContent>: View where Data: RandomAccessCollection, Data.Element: Identifiable, RowContent: View {
  let data: Data
  let children: KeyPath<Data.Element, Data?>
  let rowContent: (Data.Element) -> RowContent
  
  var body: some View {
    ForEach(data) { child in
      if self.containsSub(child)  {
        FSDisclosureGroup(content: {
          RecursiveView(data: child[keyPath: self.children]!, children: self.children, rowContent: self.rowContent)
            .padding(.leading)
        }, label: {
          self.rowContent(child)
        })
      } else {
        self.rowContent(child)
      }
    }
  }
  
  func containsSub(_ element: Data.Element) -> Bool {
    element[keyPath: children] != nil
  }
}

struct FSDisclosureGroup<Label, Content>: View where Label: View, Content: View {
  @State var isExpanded: Bool = false
  var content: () -> Content
  var label: () -> Label
  
  @ViewBuilder
  var body: some View {
    Button(action: {
      self.isExpanded.toggle()
      
    },
           label: {
            label()
              .frame(maxWidth: .infinity, alignment: .leading)
              .padding(EdgeInsets(top: 4, leading: 0, bottom: 4, trailing: 0))
            
    })
      .frame(maxWidth: .infinity, alignment: .leading)
      .padding(0)
      .buttonStyle(PlainButtonStyle())
    
    if isExpanded {
      content()
    }
  }
}


struct HierarchyList_Previews: PreviewProvider {
  
  static var previews: some View {
    
    
    let items = [
      SnipItem(name: "Hello",
               kind: .folder,
               content: [],
               tags: [],
               creationDate: Date(),
               lastUpdateDate: Date()),
      SnipItem(name: "IM",
               kind: .folder,
               content: [
                SnipItem(name: "Folder #1",
                         kind: .folder,
                         content: [
                          SnipItem(name: "File #1",
                                   kind: .file,
                                   content: [],
                                   tags: [],
                                   creationDate: Date(),
                                   lastUpdateDate: Date())
                  ],
                         tags: [],
                         creationDate: Date(),
                         lastUpdateDate: Date())
        ],
               tags: [],
               creationDate: Date(),
               lastUpdateDate: Date()),
      SnipItem(name: "BATMAN",
               kind: .folder,
               content: [],
               tags: [],
               creationDate: Date(),
               lastUpdateDate: Date())
    ]
    
    return HierarchyList(data: items, children: \.content, rowContent: { Text($0.name) })
  }
}

//
//  Entry.swift
//  Test
//
//  Created by Eugene on 15.04.2022.
//

import Foundation

struct Entry: Identifiable {
    var id: Int
    var title: String
    var description: String
    var imageId: String?
    var authorName: String
    var date: Date
    var group: String
    var commentsCount: Int
    var rating: Int
    
    var imageLink: String? {
        if let imageId = imageId {
            return "https://leonardo.osnova.io/\(imageId)"
        } else {
            return nil
        }
    }

}

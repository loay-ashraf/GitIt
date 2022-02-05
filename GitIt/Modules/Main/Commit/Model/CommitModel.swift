//
//  CommitModel.swift
//  GitIt
//
//  Created by Loay Ashraf on 17/01/2022.
//

import Foundation

struct CommitModel: Model {
    
    typealias T = UserCollectionCellViewModel
    typealias U = CommitCellViewModel
    
    let id: Int
    let message: String
    let htmlURL: URL
    let author: OwnerModel?
    var isComplete: Bool
    
    enum CodingKeys: String, CodingKey {
        
        case commit
        case htmlURL = "html_url"
        case author

    }
    
    enum CommitCodingKeys: String, CodingKey {
        
        case message
    
    }
    
    init() {
        id = 0
        message = ""
        htmlURL = URL(string: "www.github.com")!
        author = OwnerModel()
        isComplete = false
    }
    
    init(message: String, htmlURL: URL, author: OwnerModel?) {
        id = 0
        self.message = message
        self.htmlURL = htmlURL
        self.author = author
        isComplete = true
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let nestedContainer = try container.nestedContainer(keyedBy: CommitCodingKeys.self, forKey: .commit)
        id = 0
        message = try nestedContainer.decode(String.self, forKey: .message)
        htmlURL = try container.decode(URL.self, forKey: .htmlURL)
        author = try? container.decode(OwnerModel.self, forKey: .author)
        isComplete = true
    }
    
    init(from collectionCellViewModel: T) {
        id = 0
        message = ""
        htmlURL = URL(string: "www.github.com")!
        author = OwnerModel()
        isComplete = false
    }
    
    init(from tableCellViewModel: U) {
        id = 0
        message = tableCellViewModel.message
        htmlURL = tableCellViewModel.htmlURL
        author = tableCellViewModel.author
        isComplete = false
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        var nestedContainer = container.nestedContainer(keyedBy: CommitCodingKeys.self, forKey: .commit)
        try nestedContainer.encode(message, forKey: .message)
        try container.encode(htmlURL, forKey: .htmlURL)
        try container.encode(author, forKey: .author)
    }
    
}

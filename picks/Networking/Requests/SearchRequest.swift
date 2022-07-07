//
//  SearchRequest.swift
//  picks
//
//  Created by Elaine Herrera on 6/7/22.
//

import Foundation

struct SearchRequest: VimeoRequest{
    let pagination: Int = 20
    
    var path: String {
        return "/videos"
    }
    var parameters: Parameters
    
    init(page: Int, query: String) {
        self.parameters = ["filter": "content_rating",
                           "filter_content_rating": "safe",
                           "per_page": "\(pagination)",
                           "page": "\(page)",
                           "query": "\(query)"]
    }
}

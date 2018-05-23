//
//  CommentService.swift
//  YourJourney
//
//  Created by Apple on 16.05.2018.
//  Copyright © 2018 md. All rights reserved.
//

import Foundation
import SwiftyJSON

class CommentService {
    
    typealias LoadCommentsResult = (comments: [Comment]?, error: Error?)
    
    static func loadComments(placeId: Int, offset: Int, limit: Int, completionHandler: @escaping (LoadCommentsResult) -> Void) {
        let _ = APIService.shared().comments(placeId: placeId,
                                             offset: offset,
                                             limit: limit,
                                             completionHandler:
            {(responce: (code: Int?, body: JSON?)?, error) in
                
                if error != nil {
                    completionHandler(LoadCommentsResult(comments: nil, error: error))
                    return
                }
                
                var comments = [Comment]()
                
                if responce!.code == 0 {
                    let commentsJson = responce!.body!["comments"].arrayValue
                    
                    for commentJson in commentsJson {
                        let comment = Comment()
                        
                        comment.id = commentJson["id"].int
                        comment.date = Date(timeIntervalSince1970: commentJson["date"].double!)
                        comment.ownerId = commentJson["owner_id"].int
                        comment.ownerName = commentJson["owner_name"].string
                        comment.avatar = commentJson["avatar"].string
                        comment.text = commentJson["text"].string
                        
                        comments.append(comment)
                    }
                } else if responce!.code == 3 {
                    completionHandler(LoadCommentsResult(comments: nil, APIErrors.noInfo))
                    return
                } else if responce!.code == 4 {
                    completionHandler(LoadCommentsResult(comments: nil, APIErrors.badRequest))
                    return
                } else {
                    completionHandler(LoadCommentsResult(comments: nil, APIErrors.unknounError))
                    return
                }
                
                completionHandler(LoadCommentsResult(comments: comments, error: nil))
        })
    }
}

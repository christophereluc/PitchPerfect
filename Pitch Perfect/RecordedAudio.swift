//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by Christopher Luc on 7/26/15.
//  Copyright (c) 2015 Christopher Luc. All rights reserved.
//

import Foundation

class RecordedAudio: NSObject{
    var filePathUrl: NSURL!
    var title: String!
    
    init(filePathUrl: NSURL!, title: String!){
        self.filePathUrl = filePathUrl
        self.title = title
    }
}
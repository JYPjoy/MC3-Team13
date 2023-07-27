//
//  BasicModel.swift
//  MalBal
//
//  Created by kibum on 2023/07/20.
//

import Foundation

struct Record{
    
    var fileURL: URL
    var createdAt : Date
    var wpm: Int
    var detailWpms: [Int]
    
    init(fileURL: URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("MalBal.m4a"),
         createdAt: Date,
         cpm: Int = -1,
         detailCpms: [Int] = []) {
        
        self.fileURL = fileURL
        self.createdAt = createdAt
        self.wpm = cpm
        self.detailWpms = detailCpms
        
    }
    
}

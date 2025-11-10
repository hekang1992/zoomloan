//
//  baseModel.swift
//  zoomloan
//
//  Created by hekang on 2025/11/10.
//

class BaseModel: Codable {
    var sentences: String?
    var regarding: String?
    var credulity: credulityModel?
}

class credulityModel: Codable {
    var efforts: effortsModel?
}

class effortsModel: Codable {
    var prevail: String?
    var entreaties: String?
    var withdraw: String?
    var entreated: String?
}

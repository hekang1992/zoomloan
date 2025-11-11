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
    var considerate: String?
    var really: [reallyModel]?
}

class effortsModel: Codable {
    var prevail: String?
    var entreaties: String?
    var withdraw: String?
    var entreated: String?
}

class reallyModel: Codable {
    var odd: String?
    var chairs: [chairsModel]?
}

class chairsModel: Codable {
    var borne: Int?
    var profound: String?
    var breaking: String?
    var illusion: String?
    var going: String?
    var goes: String?
    var extraordinary: String?
    var relate: String?
    var hereafter: String?
    var explain: String?
}

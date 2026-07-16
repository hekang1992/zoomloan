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
    var trick: String?
    var userInfo: userInfoModel?
    var head: headModel?
    var lowered: loweredModel?
    var produce: [produceModel]?
    var expected: expectedModel?
    var anger: angerModel?
    var belong: angerModel?
    var suggestion: [String]?
    var insensibility: [String]?
    var scrupulous: [scrupulousModel]?
    var superiority: [superiorityModel]?
    var eye: [eyeModel]?
    var ease: String?
    var visibly: Int?
    var customerService: [customerServiceModel]?
}

class customerServiceModel: Codable {
    var trick: String?
}

class effortsModel: Codable {
    var prevail: String?
    var entreaties: String?
    var withdraw: String?
    var entreated: String?
}

class reallyModel: Codable {
    var odd: String?
    var affray: String?
    var trick: String?
    var searched: String?
    var chairs: [chairsModel]?
    var choler: String?
    var really: [reallyModel]?
    var stopped: [stoppedModel]?
    var earnest: String?
    var profound: String?
    var breaking: String?
    var illusion: String?
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

class userInfoModel: Codable {
    var userphone: String?
}

class headModel: Codable {
    var bertolini: String?
    var st: String?
    var borne: String?
    var signora: String?
    var profound: String?
    var breaking: String?
    var illusion: String?
    var drink: String?
    var cried: String?
    var exploit: String?
    var remembrance: Int?

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        if let intValue = try? container.decode(String.self, forKey: .bertolini) {
            bertolini = intValue
        } else if let stringValue = try? container.decode(String.self, forKey: .bertolini) {
            bertolini = String(stringValue)
        } else {
            bertolini = nil
        }
        
        st = try? container.decode(String.self, forKey: .st)
        borne = try? container.decode(String.self, forKey: .borne)
        signora = try? container.decode(String.self, forKey: .signora)
        profound = try? container.decode(String.self, forKey: .profound)
        breaking = try? container.decode(String.self, forKey: .breaking)
        illusion = try? container.decode(String.self, forKey: .illusion)
        drink = try? container.decode(String.self, forKey: .drink)
        cried = try? container.decode(String.self, forKey: .cried)
        exploit = try? container.decode(String.self, forKey: .exploit)
        remembrance = try? container.decode(Int.self, forKey: .remembrance)
    }

    enum CodingKeys: String, CodingKey {
        case bertolini, st, borne, signora, profound, breaking, illusion, drink, cried, exploit, remembrance
    }
}

class loweredModel: Codable {
    var affray: String?
    var repeated: String?
}

class produceModel: Codable {
    var affray: String?
    var sternly: String?
    var weak: String?
    var forbade: String?
    var indignation: String?
    var possessed: Int?
    var trick: String?
}

class expectedModel: Codable {
    var weak: String?
    var affray: String?
    var trick: String?
}

class angerModel: Codable {
    var possessed: Int?
    var trick: String?
}

class scrupulousModel: Codable {
    var jealously: String?
    var importance: String?
    var sentences: String?
}

class eyeModel: Codable {
    var affray: String?
    var cavigni: String?
    var gaiety: String?
    var merriment: String?
    var loose: String?
    var choler: String?
    var contrary: String?
    var irascible: [irascibleModel]?
    var clouded: String?
}

class stoppedModel: Codable {
    var affray: String?
    var rested: String?
}

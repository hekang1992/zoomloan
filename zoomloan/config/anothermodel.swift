//
//  anothermodel.swift
//  zoomloan
//
//  Created by hekang on 2025/11/12.
//

class superiorityModel: Codable {
    var affray: String?
    var sternly: String?
    var sentences: String?
    var conscious: String?
    var displayed: Int?
    var impunity: String?
    var odd: String?
    var irascible: [irascibleModel]?

    enum CodingKeys: String, CodingKey {
        case affray, sternly, sentences, conscious, displayed, impunity, odd, irascible
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        affray = try? container.decode(String.self, forKey: .affray)
        sternly = try? container.decode(String.self, forKey: .sternly)
        sentences = try? container.decode(String.self, forKey: .sentences)
        conscious = try? container.decode(String.self, forKey: .conscious)
        displayed = try? container.decode(Int.self, forKey: .displayed)
        impunity = try? container.decode(String.self, forKey: .impunity)
        irascible = try? container.decode([irascibleModel].self, forKey: .irascible)

        if let str = try? container.decode(String.self, forKey: .odd) {
            odd = str
        } else if let intValue = try? container.decode(Int.self, forKey: .odd) {
            odd = String(intValue)
        } else {
            odd = nil
        }
    }
}

class irascibleModel: Codable {
    var choler: String?
    var odd: String?
    var isselect: Bool?

    enum CodingKeys: String, CodingKey {
        case choler, odd, isselect
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        choler = try? container.decode(String.self, forKey: .choler)
        isselect = try? container.decode(Bool.self, forKey: .isselect)

        if let str = try? container.decode(String.self, forKey: .odd) {
            odd = str
        } else if let intValue = try? container.decode(Int.self, forKey: .odd) {
            odd = String(intValue)
        } else {
            odd = nil
        }
    }

}

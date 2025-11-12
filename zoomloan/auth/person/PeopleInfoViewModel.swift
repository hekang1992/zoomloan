//
//  PeopleInfoViewModel.swift
//  zoomloan
//
//  Created by hekang on 2025/11/12.
//

class PeopleInfoViewModel {
    
    func getListInfo(with json: [String: Any]) async throws -> BaseModel {
        
        Loading.show()
        
        defer {
            Loading.hide()
        }
        
        do {
            let model: BaseModel = try await RequsetHttpManager.shared.post("/dhlpt/prevail", body: json)
            return model
        } catch  {
            throw error
        }
    }
    
    func saveInfo(with json: [String: Any]) async throws -> BaseModel {
        
        Loading.show()
        
        defer {
            Loading.hide()
        }
        
        do {
            let model: BaseModel = try await RequsetHttpManager.shared.post("/dhlpt/entreaties", body: json)
            return model
        } catch  {
            throw error
        }
    }
    
}

//
//  LiftHardViewModel.swift
//  zoomloan
//
//  Created by hekang on 2025/11/12.
//

class LiftHardViewModel {
    
    func getListInfo(with json: [String: Any]) async throws -> BaseModel {
        
        Loading.show()
        
        defer {
            Loading.hide()
        }
        
        do {
            let model: BaseModel = try await RequsetHttpManager.shared.post("/dhlpt/aye", body: json)
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
            let model: BaseModel = try await RequsetHttpManager.shared.post("/dhlpt/destroyed", body: json)
            return model
        } catch  {
            throw error
        }
    }
    
}

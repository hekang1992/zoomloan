//
//  LaunchViewModel.swift
//  zoomloan
//
//  Created by hekang on 2025/11/10.
//


class LaunchViewModel {
    
    func initOneInfo(with json: [String: Any]) async throws -> BaseModel {
        
        Loading.show()
        
        defer {
            Loading.hide()
        }
        
        do {
            let model: BaseModel = try await RequsetHttpManager.shared.post("/dhlpt/respective", body: json)
            return model
        } catch  {
            throw error
        }
    }
    
    func initTwoInfo(with json: [String: Any]) async throws -> BaseModel {
        
        do {
            let model: BaseModel = try await RequsetHttpManager.shared.post("/dhlpt/author", body: json)
            return model
        } catch  {
            throw error
        }
    }
    
}

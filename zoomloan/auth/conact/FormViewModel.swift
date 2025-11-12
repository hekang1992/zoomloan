//
//  FormViewModel.swift
//  zoomloan
//
//  Created by hekang on 2025/11/12.
//

class FormViewModel {
    
    func getListInfo(with json: [String: Any]) async throws -> BaseModel {
        
        Loading.show()
        
        defer {
            Loading.hide()
        }
        
        do {
            let model: BaseModel = try await RequsetHttpManager.shared.post("/dhlpt/withdraw", body: json)
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
            let model: BaseModel = try await RequsetHttpManager.shared.post("/dhlpt/entreated", body: json)
            return model
        } catch  {
            throw error
        }
    }
    
    func saveAllInfo(with json: [String: Any]) async throws -> BaseModel {
        
        do {
            let model: BaseModel = try await RequsetHttpManager.shared.post("/dhlpt/dejected", body: json)
            return model
        } catch  {
            throw error
        }
    }
    
}

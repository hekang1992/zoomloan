//
//  LoginViewModel.swift
//  zoomloan
//
//  Created by hekang on 2025/11/10.
//

class LoginViewModel {
    
    func sendCodeInfo(with json: [String: Any]) async throws -> BaseModel {
        
        Loading.show()
        
        defer {
            Loading.hide()
        }
        
        do {
            let model: BaseModel = try await RequsetHttpManager.shared.post("/dhlpt/separating", body: json)
            return model
        } catch  {
            throw error
        }
    }
    
    func sendVoiceCodeInfo(with json: [String: Any]) async throws -> BaseModel {
        
        Loading.show()
        
        defer {
            Loading.hide()
        }
        
        do {
            let model: BaseModel = try await RequsetHttpManager.shared.post("/dhlpt/frequently", body: json)
            return model
        } catch  {
            throw error
        }
    }
    
    func toLoginInfo(with json: [String: Any]) async throws -> BaseModel {
        
        Loading.show()
        
        defer {
            Loading.hide()
        }
        
        do {
            let model: BaseModel = try await RequsetHttpManager.shared.post("/dhlpt/sentences", body: json)
            return model
        } catch  {
            throw error
        }
    }
    
}

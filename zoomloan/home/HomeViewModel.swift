//
//  HomeViewModel.swift
//  zoomloan
//
//  Created by hekang on 2025/11/11.
//


class HomeViewModel {

    func getHomeInfo(with json: [String: Any]) async throws -> BaseModel {
        
        Loading.show()
        
        defer {
            Loading.hide()
        }
        
        do {
            let model: BaseModel = try await RequsetHttpManager.shared.get("/dhlpt/jeeringly", params: json)
            return model
        } catch  {
            throw error
        }
    }
    
    func applyProductInfo(with json: [String: Any]) async throws -> BaseModel {
        
        Loading.show()
        
        defer {
            Loading.hide()
        }
        
        do {
            let model: BaseModel = try await RequsetHttpManager.shared.post("/dhlpt/superstitious", body: json)
            return model
        } catch  {
            throw error
        }
    }
    
    func getAssInfo(with json: [String: Any]) async throws -> BaseModel {
        
        Loading.show()
        
        defer {
            Loading.hide()
        }
        
        do {
            let model: BaseModel = try await RequsetHttpManager.shared.get("/dhlpt/affecting", params: json)
            return model
        } catch  {
            throw error
        }
    }
    
}

class CityConfig {
    static let shared = CityConfig()
    private init() {}
    var addressModel: BaseModel?
}

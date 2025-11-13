//
//  ProductDetailViewModel.swift
//  zoomloan
//
//  Created by hekang on 2025/11/11.
//

class ProductDetailViewModel {
    
    func detailPageInfo(with json: [String: Any]) async throws -> BaseModel {
        
        Loading.show()
        
        defer {
            Loading.hide()
        }
        
        do {
            let model: BaseModel = try await RequsetHttpManager.shared.post("/dhlpt/disordered", body: json)
            return model
        } catch  {
            throw error
        }
    }
    
    func facePageInfo(with json: [String: Any]) async throws -> BaseModel {
        
        Loading.show()
        
        defer {
            Loading.hide()
        }
        
        do {
            let model: BaseModel = try await RequsetHttpManager.shared.post("/dhlpt/visibly", body: json)
            return model
        } catch  {
            throw error
        }
    }
    
    func orderPageInfo(with json: [String: Any]) async throws -> BaseModel {
        
        Loading.show()
        
        defer {
            Loading.hide()
        }
        
        do {
            let model: BaseModel = try await RequsetHttpManager.shared.post("/dhlpt/solemn", body: json)
            return model
        } catch  {
            throw error
        }
    }
    
}

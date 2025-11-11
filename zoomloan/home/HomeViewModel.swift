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
    
}

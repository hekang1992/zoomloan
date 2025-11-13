//
//  OrderListViewModel.swift
//  zoomloan
//
//  Created by hekang on 2025/11/13.
//

class OrderListViewModel {
    
    func listOrderInfo(with json: [String: Any]) async throws -> BaseModel {
        
        Loading.show()
        
        defer {
            Loading.hide()
        }
        
        do {
            let model: BaseModel = try await RequsetHttpManager.shared.post("/dhlpt/discomposed", body: json)
            return model
        } catch  {
            throw error
        }
    }
    
}

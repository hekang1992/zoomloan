//
//  Untitled.swift
//  zoomloan
//
//  Created by hekang on 2025/11/12.
//

import UIKit

class UploadAuthViewModel {
    
    func uploadImageInfo(with json: [String: Any], imageData: Data) async throws -> BaseModel {
        
        Loading.show()
        
        defer {
            Loading.hide()
        }
        
        do {
            let model: BaseModel = try await RequsetHttpManager.shared.uploadImage("/dhlpt/ease", imageData: imageData, params: json)
            return model
        } catch  {
            throw error
        }
    }
    
}

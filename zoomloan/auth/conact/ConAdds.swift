//
//  ConAdds.swift
//  zoomloan
//
//  Created by hekang on 2025/11/12.
//

import ContactsUI
import Contacts
import UIKit

struct ContactModel: Codable {
    var choler: String
    var roused: String
}

class ContactsUtil: NSObject {
    
    static func selectOneContact(completion: @escaping (ContactModel?) -> Void) {
        checkPermission { allowed in
            guard allowed else {
                completion(nil)
                return
            }
            presentContactPicker(completion: completion)
        }
    }
    
    
    static func getAllContacts(completion: @escaping ([ContactModel]) -> Void) {
        checkPermission { allowed in
            guard allowed else {
                completion([])
                return
            }
            
            DispatchQueue.global().async {
                let contacts = fetchAllContacts()
                DispatchQueue.main.async {
                    completion(contacts)
                }
            }
        }
    }
    
    private static func checkPermission(completion: @escaping (Bool) -> Void) {
        let status = CNContactStore.authorizationStatus(for: .contacts)
        
        switch status {
        case .authorized:
            completion(true)
            
        case .notDetermined:
            CNContactStore().requestAccess(for: .contacts) { granted, _ in
                DispatchQueue.main.async {
                    if granted {
                        completion(true)
                    } else {
                        showPermissionAlert()
                        completion(false)
                    }
                }
            }
            
        case .denied, .restricted:
            showPermissionAlert()
            completion(false)
            
        case .limited:
            completion(true)
            
        @unknown default:
            showPermissionAlert()
            completion(false)
        }
    }
    
    private static func fetchAllContacts() -> [ContactModel] {
        var result: [ContactModel] = []
        let store = CNContactStore()
        
        let keys = [
            CNContactGivenNameKey,
            CNContactFamilyNameKey,
            CNContactPhoneNumbersKey
        ] as [CNKeyDescriptor]
        
        let request = CNContactFetchRequest(keysToFetch: keys)
        
        do {
            try store.enumerateContacts(with: request) { contact, _ in
                let name = contact.givenName + " " + contact.familyName
                
                let phone = contact.phoneNumbers.map { $0.value.stringValue }
                    .joined(separator: ",")
                
                result.append(ContactModel(choler: name, roused: phone))
            }
        } catch {
            print("error=====：\(error)")
        }
        
        return result
    }
    
    
    private static func presentContactPicker(completion: @escaping (ContactModel?) -> Void) {
        let picker = CNContactPickerViewController()
        picker.delegate = ContactPickerDelegate.shared
        ContactPickerDelegate.shared.completion = completion
        
        DispatchQueue.main.async {
            guard let vc = UIApplication.shared.windows.first(where: { $0.isKeyWindow })?.rootViewController else {
                completion(nil)
                return
            }
            vc.present(picker, animated: true)
        }
    }
    
    
    private static func showPermissionAlert() {
        DispatchQueue.main.async {
            
            guard let vc = UIApplication.shared.windows.first(where: { $0.isKeyWindow })?.rootViewController else { return }
            
            let alert = UIAlertController(
                title: "无法访问通讯录",
                message: "请前往设置开启通讯录权限以使用此功能。",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "取消", style: .cancel))
            alert.addAction(UIAlertAction(title: "去设置", style: .default, handler: { _ in
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(url)
                }
            }))
            vc.present(alert, animated: true)
        }
    }
}


class ContactPickerDelegate: NSObject, CNContactPickerDelegate {
    
    static let shared = ContactPickerDelegate()
    var completion: ((ContactModel?) -> Void)?
    
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
        let name = contact.givenName + " " + contact.familyName
        let phone = contact.phoneNumbers.map { $0.value.stringValue }
            .joined(separator: ",")
        
        completion?(ContactModel(choler: name, roused: phone))
    }
    
    func contactPickerDidCancel(_ picker: CNContactPickerViewController) {
        completion?(nil)
    }
}

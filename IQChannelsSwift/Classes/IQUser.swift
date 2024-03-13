import Foundation
import UIKit

class IQUser {
    
    var id: Int = 0
    var name: String?
    var displayName: String?
    var email: String?
    var online: Bool = false
    var deleted: Bool = false
    var avatarId: String?

    var createdAt: Int = 0
    var loggedInAt: Int?
    var lastSeenAt: Int?

    // JSQ
    var senderId: String?
    var senderDisplayName: String?

    // Local
    var avatarURL: URL?
    var avatarImage: UIImage?
}

extension IQUser {
    
    static func fromJSONObject(_ object: Any?) -> IQUser? {
        guard let jsonObject = object as? [String: Any] else {
            return nil
        }

        var user = IQUser()
        user.id = IQJSON.int(from: jsonObject, key: "id")
        user.name = IQJSON.string(from: jsonObject, key: "name")
        user.displayName = IQJSON.string(from: jsonObject, key: "displayName")
        user.email = IQJSON.string(from: jsonObject, key: "email")
        user.online = IQJSON.bool(from: jsonObject, key: "online")
        user.deleted = IQJSON.bool(from: jsonObject, key: "deleted")
        user.avatarId = IQJSON.string(from: jsonObject, key: "avatarId")

        user.createdAt = IQJSON.int(from: jsonObject, key: "createdAt")
        user.loggedInAt = IQJSON.int(from: jsonObject, key: "loggedInAt")
        user.lastSeenAt = IQJSON.int(from: jsonObject, key: "lastSeenAt")

        return user
    }
    
    static func fromJSONArray(_ array: Any?) -> [IQUser] {
        guard let jsonArray = array as? [[String: Any]] else {
            return []
        }

        var users = [IQUser]()
        for jsonObject in jsonArray {
            if let user = IQUser.fromJSONObject(jsonObject) {
                users.append(user)
            }
        }
        return users
    }
}

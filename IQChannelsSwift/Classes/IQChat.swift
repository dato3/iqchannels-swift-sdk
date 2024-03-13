import Foundation

class IQChat {
    
    var id: Int = 0
    var channelId: Int = 0
    var clientId: Int = 0
    var isOpen: Bool = false
    var eventId: Int?
    var messageId: Int?
    var sessionId: Int?
    var assigneeId: Int?
    var clientUnread: Int = 0
    var userUnread: Int = 0
    var totalMembers: Int = 0
    var createdAt: Int = 0
    var openedAt: Int?
    var closedAt: Int?
    
    // Relations
    var client: IQClient?
    var message: IQChatMessage?
    var channel: IQChannel?
}

extension IQChat {
    
     static func fromJSONObject(_ object: Any?) -> IQChat? {
        guard let jsonObject = object as? [String: Any] else { return nil }

        var chat = IQChat()
        chat.id = IQJSON.int(from: jsonObject, key: "id")
        chat.channelId = IQJSON.int(from: jsonObject, key: "channelId")
        chat.clientId = IQJSON.int(from: jsonObject, key: "clientId")
        chat.isOpen = IQJSON.bool(from: jsonObject, key: "isOpen")

        chat.eventId = IQJSON.int(from: jsonObject, key: "eventId")
        chat.messageId = IQJSON.int(from: jsonObject, key: "messageId")
        chat.sessionId = IQJSON.int(from: jsonObject, key: "sessionId")
        chat.assigneeId = IQJSON.int(from: jsonObject, key: "assigneeId")

        chat.clientUnread = IQJSON.int(from: jsonObject, key: "clientUnread")
        chat.userUnread = IQJSON.int(from: jsonObject, key: "userUnread")
        chat.totalMembers = IQJSON.int(from: jsonObject, key: "totalMembers")

        chat.createdAt = IQJSON.int(from: jsonObject, key: "createdAt")
        chat.openedAt = IQJSON.int(from: jsonObject, key: "openedAt")
        chat.closedAt = IQJSON.int(from: jsonObject, key: "closedAt")

        return chat
    }

    static func fromJSONArray(_ array: Any?) -> [IQChat] {
        guard let jsonArray = array as? [[String: Any]] else { return [] }

        var chats = [IQChat]()
        for item in jsonArray {
            if let chat = IQChat.fromJSONObject(item) {
                chats.append(chat)
            }
        }
        return chats
    }
}

import Foundation

class IQChannel {
    
    var id: Int = 0
    var orgId: Int = 0
    var name: String?
    var title: String?
    var description: String?
    var deleted: Bool = false
    var eventId: Int?
    var chatEventId: Int?
    var createdAt: Int = 0
}

extension IQChannel {
    
    static func fromJSONObject(_ object: Any?) -> IQChannel? {
        guard let jsonObject = object as? [String: Any] else {
            return nil
        }

        var channel = IQChannel()
        channel.id = IQJSON.int(from: jsonObject, key: "id")
        channel.orgId = IQJSON.int(from: jsonObject, key: "orhId")
        channel.name = IQJSON.string(from: jsonObject, key: "name")
        channel.title = IQJSON.string(from: jsonObject, key: "title")
        channel.description = IQJSON.string(from: jsonObject, key: "description")
        channel.deleted = IQJSON.bool(from: jsonObject, key: "deleted")
        channel.eventId = IQJSON.int(from: jsonObject, key: "eventId")
        channel.chatEventId = IQJSON.int(from: jsonObject, key: "chatEventId")
        channel.createdAt = IQJSON.int(from: jsonObject, key: "createdAt")
        return channel
    }
    
    static func fromJSONArray(_ array: Any?) -> [IQChannel] {
        guard let jsonArray = array as? [Any] else {
            return []
        }

        var channels = [IQChannel]()
        for item in jsonArray {
            if let jsonObject = item as? [String: Any], let channel = IQChannel.fromJSONObject(jsonObject) {
                channels.append(channel)
            }
        }
        return channels
    }
}

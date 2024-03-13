import Foundation

class IQSingleChoice {
    
    var id: Int = 0
    var chatMessageId: Int = 0
    var clientId: Int = 0
    var deleted: Bool = false

    var title: String?
    var value: String?
    var tag: String?

    var createdAt: Int = 0
    var updatedAt: Int = 0
}

extension IQSingleChoice {
    
    static func fromJSONObject(_ object: Any?) -> IQSingleChoice? {
        guard let jsonObject = object as? [String: Any] else {
            return nil
        }

        var singleChoice = IQSingleChoice()
        singleChoice.id = IQJSON.int(from: jsonObject, key: "id")
        singleChoice.chatMessageId = IQJSON.int(from: jsonObject, key: "chatMessageId")
        singleChoice.clientId = IQJSON.int(from: jsonObject, key: "clientId")
        singleChoice.deleted = IQJSON.bool(from: jsonObject, key: "deleted")

        singleChoice.title = IQJSON.string(from: jsonObject, key: "title")
        singleChoice.value = IQJSON.string(from: jsonObject, key: "value")
        singleChoice.tag = IQJSON.string(from: jsonObject, key: "tag")

        singleChoice.createdAt = IQJSON.int(from: jsonObject, key: "createdAt")
        singleChoice.updatedAt = IQJSON.int(from: jsonObject, key: "updatedAt")

        return singleChoice
    }
    
    static func fromJSONArray(_ array: Any?) -> [IQSingleChoice] {
        guard let jsonArray = array as? [[String: Any]] else {
            return []
        }

        var singleChoices = [IQSingleChoice]()
        for jsonObject in jsonArray {
            if let singleChoice = IQSingleChoice.fromJSONObject(jsonObject) {
                singleChoices.append(singleChoice)
            }
        }
        return singleChoices
    }
}

import Foundation

class IQClient {
    
    var id: Int = 0
    var name: String?
    var integrationId: String?
    var createdAt: Int = 0
    var updatedAt: Int = 0
    
    // JSQ
    var senderId: String?
    var senderDisplayName: String?
}

extension IQClient {
    
    static func fromJSONObject(_ object: Any?) -> IQClient? {
        guard let jsonObject = object as? [String: Any] else {
            return nil
        }

        var client = IQClient()
        client.id = IQJSON.int(from: jsonObject, key: "id")
        client.name = IQJSON.string(from: jsonObject, key: "name")
        client.integrationId = IQJSON.string(from: jsonObject, key: "integrationId")
        client.createdAt = IQJSON.int(from: jsonObject, key: "createdAt")
        client.updatedAt = IQJSON.int(from: jsonObject, key: "updatedAt")
        return client
    }

    static func fromJSONArray(_ array: Any?) -> [IQClient] {
        guard let array = array as? [[String: Any]] else {
            return []
        }

        var clients: [IQClient] = []
        for item in array {
            if let client = IQClient.fromJSONObject(item) {
                clients.append(client)
            }
        }
        return clients
    }
}

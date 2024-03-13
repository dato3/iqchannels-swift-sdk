import Foundation

class IQClientSession {
    
    var id: Int?
    var clientId: Int?
    var token: String?
    var integration: Bool?
    var integrationHash: String?
    var integrationCredentials: String?
    var createdAt: Int?
}

extension IQClientSession {
    
    static func fromJSONObject(_ object: Any?) -> IQClientSession? {
        guard let jsonObject = object as? [String: Any] else {
            return nil
        }

        let session = IQClientSession()
        session.id = IQJSON.int(from: jsonObject, key: "id")
        session.clientId = IQJSON.int(from: jsonObject, key: "clientId")
        session.token = IQJSON.string(from: jsonObject, key: "token")
        session.integration = IQJSON.bool(from: jsonObject, key: "integration")
        session.integrationHash = IQJSON.string(from: jsonObject, key: "integrationHash")
        session.integrationCredentials = IQJSON.string(from: jsonObject, key: "integrationCredentials")
        session.createdAt = IQJSON.int(from: jsonObject, key: "createdAt")
        
        return session
    }
}

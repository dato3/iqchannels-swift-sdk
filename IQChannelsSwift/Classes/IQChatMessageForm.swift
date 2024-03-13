import Foundation

class IQChatMessageForm: IQJSONEncodable {
    
    var localId: Int = 0
    var payload: IQChatPayloadType?
    var text: String?
    var fileId: String?
    var botpressPayload: String?
    
    init(message: IQChatMessage?) {
        localId = message?.localId ?? 0
        payload = message?.payload
        text = message?.text ?? ""
        fileId = message?.fileId
        botpressPayload = message?.botpressPayload
    }
    
    func toJSONObject() -> [String: Any] {
        var dict = [String: Any]()
        dict["localId"] = localId
        if payload != nil {
            if let payload {
                dict["payload"] = payload
            }
        }
        if let text {
            dict["text"] = text
        }
        if let fileId {
            dict["fileId"] = fileId
        }
        if let botpressPayload {
            dict["botpressPayload"] = botpressPayload
        }
        return dict
    }
}

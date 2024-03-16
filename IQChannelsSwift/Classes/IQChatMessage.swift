import Foundation
import UIKit
import MessageKit

class IQChatMessage: MessageType {
    
    var id: Int = 0
    var uID: String = UUID().uuidString
    var chatId: Int = 0
    var sessionId: Int = 0
    var localId: Int = 0
    var eventId: Int?
    var isPublic: Bool = false
    
    // Author
    var author: IQActorType?
    var clientId: Int?
    var userId: Int?
    
    // Payload
    var payload: IQChatPayloadType?
    var _text: String?
    var fileId: String?
    var ratingId: Int?
    var noticeId: Int?
    var botpressPayload: String?
    
    // Flags
    var received: Bool = false
    var read: Bool = false
    var disableFreeText: Bool = false
    var isDropDown: Bool = false
    
    // Timestamps
    var createdAt: Int = 0
    var receivedAt: Int?
    var readAt: Int?
    
    // Transitive
    var isMy: Bool = false
    
    // Relations
    var client: IQClient?
    var user: IQUser?
    var file: IQFile?
    var rating: IQRating?
    
    var createdDate: Date?
    var createdComponents: DateComponents?
    
    // Message Kit
    var sender: SenderType = MessageSender(senderId: "",
                                           displayName: "")
    var messageId: String = UUID().uuidString
    var sentDate: Date = Date()
    var kind: MessageKind = .text("")
    
    var text: String {
        if let uploadError {
            return "Ошибка: \(uploadError.localizedDescription)"
        }
        if isFileMessage() {
            return "\(file!.name ?? ""), \(IQFileSize.unit(with: file!.size))"
        }
        if let rating {
            if rating.state == .ignored {
                return "Без оценки"
            }
            if rating.state == .rated {
                return "Оценка оператора: \(rating.value ?? 0) из 5"
            }
        }
        return _text ?? ""
    }
    
    var isMediaMessage: Bool {
        if uploadError != nil {
            return false // Display an error message.
        }
        if uploadImage != nil {
            return true
        }
        return isImageMessage() || isPendingRatingMessage()
    }
    
    var media: JSQMessageMediaData? {
        if isPendingRatingMessage() {
            return IQRatingMediaItem(rating: rating!)
        }
        
        if !isMediaMessage {
            return nil
        }
        
        return JSQPhotoMediaItem(image: nil)
    }
    
    // Local
    var uploadImage: UIImage?
    var uploadData: Data?
    var uploadFilename: String?
    var uploaded: Bool = false
    var uploading: Bool = false
    var uploadError: Error?
    
    var singleChoices: [IQSingleChoice]?
    var actions: [IQAction]?
    
    // MARK: - INIT
    init() {
        
    }
    
    init(client: IQClient?, localId: Int) {
        self.localId = localId
        self.isPublic = true
        
        // Author
        self.author = .client
        self.clientId = client?.id
        
        // Timestamps
        self.createdAt = Int(Date().timeIntervalSince1970 * 1000)
        
        // Relations
        self.isMy = true
    }

    convenience init(client: IQClient?, localId: Int, text: String?) {
        self.init(client: client, localId: localId)
        self.payload = .text
        self._text = text
    }

    convenience init(client: IQClient?, localId: Int, image: UIImage, fileName: String) {
        self.init(client: client, localId: localId)
        self.payload = .file
        self.uploadImage = image
        self.uploadFilename = fileName
    }

    convenience init(client: IQClient?, localId: Int, data: Data, fileName: String) {
        self.init(client: client, localId: localId)
        self.payload = .file
        self.uploadData = data
        self.uploadFilename = fileName
    }
}

extension IQChatMessage {
    
    static func fromJSONObject(_ object: Any?) -> IQChatMessage? {
        guard let jsonObject = object as? [String: Any] else {
            return nil
        }
        
        let message = IQChatMessage()
        message.id = IQJSON.int(from: jsonObject, key: "id")
        message.uID = IQJSON.string(from: jsonObject, key: "uID") ?? UUID().uuidString
        message.chatId = IQJSON.int(from: jsonObject, key: "chatId")
        message.sessionId = IQJSON.int(from: jsonObject, key: "sessionId")
        message.localId = IQJSON.int(from: jsonObject, key: "localId")
        message.eventId = IQJSON.int(from: jsonObject, key: "eventId")
        message.isPublic = IQJSON.bool(from: jsonObject, key: "isPublic")
        
        message.author = IQActorType(rawValue: IQJSON.string(from: jsonObject, key: "author") ?? "")
        message.clientId = IQJSON.int(from: jsonObject, key: "clientId")
        message.userId = IQJSON.int(from: jsonObject, key: "userId")
        
        message.payload = IQChatPayloadType(rawValue: IQJSON.string(from: jsonObject, key: "payload") ?? "")
        message._text = IQJSON.string(from: jsonObject, key: "text")
        message.fileId = IQJSON.string(from: jsonObject, key: "fileId")
        message.ratingId = IQJSON.int(from: jsonObject, key: "ratingId")
        message.noticeId = IQJSON.int(from: jsonObject, key: "noticeId")
        message.botpressPayload = IQJSON.string(from: jsonObject, key: "botpressPayload")
        
        message.received = IQJSON.bool(from: jsonObject, key: "received")
        message.read = IQJSON.bool(from: jsonObject, key: "read")
        message.disableFreeText = IQJSON.bool(from: jsonObject, key: "disableFreeText")
        message.isDropDown = IQJSON.bool(from: jsonObject, key: "isDropDown")
        
        message.createdAt = IQJSON.int(from: jsonObject, key: "createdAt")
        message.receivedAt = IQJSON.int(from: jsonObject, key: "receivedAt")
        message.readAt = IQJSON.int(from: jsonObject, key: "readAt")
        
        message.isMy = IQJSON.bool(from: jsonObject, key: "isMy")
        
        message.singleChoices = IQSingleChoice.fromJSONArray(IQJSON.array(from: jsonObject, key: "singleChoices"))
        message.actions = IQAction.fromJSONArray(IQJSON.array(from: jsonObject, key: "actions"))
        
        return message
    }
    
    static func fromJSONArray(_ array: Any?) -> [IQChatMessage] {
        guard let jsonArray = array as? [[String: Any]] else {
            return []
        }
        
        var messages = [IQChatMessage]()
        for jsonObject in jsonArray {
            if let message = IQChatMessage.fromJSONObject(jsonObject) {
                messages.append(message)
            }
        }
        return messages
    }
}

extension IQChatMessage {

    func isFileMessage() -> Bool {
        return file != nil && file!.type == .file
    }

    func isImageMessage() -> Bool {
        return file != nil && file!.type == .image
    }

    func isPendingRatingMessage() -> Bool {
        return rating != nil && rating!.state == .pending
    }
    
    func merge(with message: IQChatMessage) {
        // Ids
        id = message.id
        eventId = message.eventId

        // Payload
        payload = message.payload
        _text = message.text
        fileId = message.fileId
        noticeId = message.noticeId
        botpressPayload = message.botpressPayload

        // Relations
        client = message.client
        user = message.user
        file = message.file

        // Message Kit
        sender = message.sender
        messageId = message.messageId
        sentDate = message.sentDate
        kind = message.kind
    }
}

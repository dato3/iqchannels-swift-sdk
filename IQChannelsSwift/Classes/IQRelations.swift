import Foundation

class IQRelations {
    
    var channels: [IQChannel] = []
    var chats: [IQChat] = []
    var chatMessages: [IQChatMessage] = []
    var clients: [IQClient] = []
    var files: [IQFile] = []
    var ratings: [IQRating] = []
    var users: [IQUser] = []
}

extension IQRelations {
    
    static func fromJSONObject(_ object: Any?) -> IQRelations? {
        guard let jsonObject = object as? [String: Any] else { return nil }
        
        var rels = IQRelations()
        rels.channels = IQChannel.fromJSONArray(jsonObject["channels"])
        rels.chats = IQChat.fromJSONArray(jsonObject["chats"])
        rels.chatMessages = IQChatMessage.fromJSONArray(jsonObject["chatMessages"])
        rels.clients = IQClient.fromJSONArray(jsonObject["clients"])
        rels.files = IQFile.fromJSONArray(jsonObject["files"])
        rels.ratings = IQRating.fromJSONArray(jsonObject["ratings"])
        rels.users = IQUser.fromJSONArray(jsonObject["users"])
        
        return rels
    }
}

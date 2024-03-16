import MessageKit

struct MessageSender: MessageKit.SenderType {
    var senderId: String
    var displayName: String
}

import AVFoundation
import CoreLocation
import Foundation
import UIKit
@testable import MessageKit

// MARK: - MockLocationItem
struct MockLocationItem: LocationItem {
    var location: CLLocation
    var size: CGSize
    
    init(location: CLLocation) {
        self.location = location
        size = CGSize(width: 240, height: 240)
    }
}

// MARK: - MockMediaItem
struct MockMediaItem: MediaItem {
    var url: URL?
    var image: UIImage?
    var placeholderImage: UIImage
    var size: CGSize
    
    init(image: UIImage) {
        self.image = image
        size = CGSize(width: 240, height: 240)
        placeholderImage = UIImage()
    }
}

// MARK: - MockAudiotem
private struct MockAudiotem: AudioItem {
    var url: URL
    var size: CGSize
    var duration: Float
    
    init(url: URL, duration: Float) {
        self.url = url
        size = CGSize(width: 160, height: 35)
        self.duration = duration
    }
}

// MARK: - MockMessage
struct MockMessage: MessageType {
    
    private init(kind: MessageKind, user: MockUser, messageId: String) {
        self.kind = kind
        self.user = user
        self.messageId = messageId
        sentDate = Date()
    }
    
    init(text: String, user: MockUser, messageId: String) {
        self.init(kind: .text(text), user: user, messageId: messageId)
    }
    
    init(attributedText: NSAttributedString, user: MockUser, messageId: String) {
        self.init(kind: .attributedText(attributedText), user: user, messageId: messageId)
    }
    
    init(image: UIImage, user: MockUser, messageId: String) {
        let mediaItem = MockMediaItem(image: image)
        self.init(kind: .photo(mediaItem), user: user, messageId: messageId)
    }
    
    init(thumbnail: UIImage, user: MockUser, messageId: String) {
        let mediaItem = MockMediaItem(image: thumbnail)
        self.init(kind: .video(mediaItem), user: user, messageId: messageId)
    }
    
    init(location: CLLocation, user: MockUser, messageId: String) {
        let locationItem = MockLocationItem(location: location)
        self.init(kind: .location(locationItem), user: user, messageId: messageId)
    }
    
    init(emoji: String, user: MockUser, messageId: String) {
        self.init(kind: .emoji(emoji), user: user, messageId: messageId)
    }
    
    init(audioURL: URL, duration: Float, user: MockUser, messageId: String) {
        let audioItem = MockAudiotem(url: audioURL, duration: duration)
        self.init(kind: .audio(audioItem), user: user, messageId: messageId)
    }
    
    var messageId: String
    var sentDate: Date
    var kind: MessageKind
    var user: MockUser
    
    var sender: SenderType {
        user
    }
}

// MARK: - MockUser
struct MockUser: SenderType {
    var senderId: String
    var displayName: String
}

// MARK: - MockMessagesDataSource
class MockMessagesDataSource: MessagesDataSource {
    
    var messages: [MessageType] = []
    let senders: [MockUser] = [
        MockUser(senderId: "sender_1", displayName: "Sender 1"),
        MockUser(senderId: "sender_2", displayName: "Sender 2"),
    ]
    
    var currentUser: MockUser {
        senders[0]
    }
    
    func currentSender() -> MessageKit.SenderType {
        currentUser
    }
    
    func numberOfSections(in _: MessagesCollectionView) -> Int {
        messages.count
    }
    
    func messageForItem(at indexPath: IndexPath, in _: MessagesCollectionView) -> MessageType {
        messages[indexPath.section]
    }
}

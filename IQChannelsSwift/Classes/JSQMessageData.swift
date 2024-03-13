import Foundation

/// The `JSQMessageData` protocol defines the common interface through which
/// a `JSQMessagesViewController` and `JSQMessagesCollectionView` interact with message model objects.
///
/// It declares the required and optional methods that a class must implement so that instances of that class
/// can be displayed properly within a `JSQMessagesCollectionViewCell`.
///
/// The class that conforms to this protocol is provided in the library. See `JSQMessage`.
///
/// - SeeAlso: `JSQMessage`.
protocol JSQMessageData {
    /// A string identifier that uniquely identifies the user who sent the message.
    ///
    /// If you need to generate a unique identifier, consider using
    /// `UUID().uuidString`.
    ///
    /// - Warning: You must not return `nil` from this method. This value must be unique.
    var senderId: String? { get }
    
    /// The display name for the user who sent the message.
    ///
    /// - Warning: You must not return `nil` from this method.
    var senderDisplayName: String? { get }
    
    /// The date that the message was sent.
    ///
    /// - Warning: You must not return `nil` from this method.
    var date: Date? { get }
    
    /// This method is used to determine if the message data item contains text or media.
    /// If this method returns `true`, an instance of `JSQMessagesViewController` will ignore
    /// the `text()` method of this protocol when dequeuing a `JSQMessagesCollectionViewCell`
    /// and only call the `media()` method.
    ///
    /// Similarly, if this method returns `false` then the `media()` method will be ignored and
    /// only the `text()` method will be called.
    ///
    /// - Returns: A boolean value specifying whether or not this is a media message or a text message.
    ///   Return `true` if this item is a media message, and `false` if it is a text message.
    var isMediaMessage: Bool { get }
    
    /// An integer that can be used as a table address in a hash table structure.
    ///
    /// This value must be unique for each message with distinct contents.
    /// This value is used to cache layout information in the collection view.
    ///
    /// - Returns: An integer representing the hash value.
    var messageHash: UInt { get }
    
    /// The body text of the message.
    ///
    /// - Warning: You must not return `nil` from this method.
    var text: String { get }
    
    /// The media item of the message.
    ///
    /// - Warning: You must not return `nil` from this method.
    var media: JSQMessageMediaData? { get }
}

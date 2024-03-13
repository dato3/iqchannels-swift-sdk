import UIKit

/// The `JSQMessageMediaData` protocol defines the common interface through which
/// a `JSQMessagesViewController` and `JSQMessagesCollectionView` interact with media message model objects.
///
/// It declares the required and optional methods that a class must implement so that instances of that class
/// can be displayed properly within a `JSQMessagesCollectionViewCell`.
///
/// This library provides a few concrete classes that conform to this protocol. You may use them as-is,
/// but they will likely require some modifications or extensions to conform to your particular data models.
/// These concrete media items are: `JSQPhotoMediaItem`, `JSQLocationMediaItem`, `JSQVideoMediaItem`.
///
/// - SeeAlso: `JSQPhotoMediaItem`.
/// - SeeAlso: `JSQLocationMediaItem`.
/// - SeeAlso: `JSQVideoMediaItem`.
protocol JSQMessageMediaData {
    /// - Returns: An initialized `UIView` object that represents the data for this media object.
    ///
    /// - Discussion: You may return `nil` from this method while the media data is being downloaded.
    func mediaView() -> UIView?

    /// - Returns: The frame size for the mediaView when displayed in a `JSQMessagesCollectionViewCell`.
    ///
    /// - Discussion: You should return an appropriate size value to be set for the mediaView's frame
    /// based on the contents of the view, and the frame and layout of the `JSQMessagesCollectionViewCell`
    /// in which mediaView will be displayed.
    ///
    /// - Warning: You must return a size with non-zero, positive width and height values.
    func mediaViewDisplaySize() -> CGSize

    /// - Returns: A placeholder media view to be displayed if mediaView is not yet available, or `nil`.
    /// For example, if mediaView will be constructed based on media data that must be downloaded,
    /// this placeholder view will be used until mediaView is not `nil`.
    ///
    /// - Discussion: If you do not need support for a placeholder view, then you may simply return the
    /// same value here as mediaView. Otherwise, consider using `JSQMessagesMediaPlaceholderView`.
    ///
    /// - Warning: You must not return `nil` from this method.
    ///
    /// - SeeAlso: `JSQMessagesMediaPlaceholderView`.
    func mediaPlaceholderView() -> UIView?

    /// - Returns: An integer that can be used as a table address in a hash table structure.
    ///
    /// - Discussion: This value must be unique for each media item with distinct contents.
    /// This value is used to cache layout information in the collection view.
    func mediaHash() -> UInt
}

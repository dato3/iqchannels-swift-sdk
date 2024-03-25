import UIKit
import MessageKit
import SDWebImage

open class IQChannelMessagesViewController: MessagesViewController {
    
    // MARK: - PROPERTIES
    private var client: IQClient?
    private var messages: [IQChatMessage] = []
    private var stateSub: IQSubscription?
    private var state: IQChannelsState = .loggedOut
    private var visible: Bool = false
    private var readMessages: Set<Int> = []
    private var messagesSub: IQSubscription?
    private var messagesLoaded: Bool = false
    
    // MARK: - LIFECYCLE
    public override func viewDidLoad() {
        messagesCollectionView = MessagesCollectionView(frame: .zero,
                                                        collectionViewLayout: CustomMessagesFlowLayout())
        
        super.viewDidLoad()
        
        setupNavBar()
        setupCollectionView()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        stateSub = IQChannels.state(self)
    }

    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        visible = true

        if readMessages.count > 0 {
            for messageId in readMessages {
                IQChannels.markAsRead(messageId)
            }
            readMessages.removeAll()
        }
    }

    public override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        visible = false
    }
    
    // MARK: - PRIVATE METHODS
    private func setupNavBar() {
        navigationItem.title = "Сообщения"
    }
    
    private func setupCollectionView() {
        let layout = messagesCollectionView.collectionViewLayout as? MessagesCollectionViewFlowLayout
        
        layout?.setMessageOutgoingAvatarSize(.zero)
        layout?.setMessageIncomingAvatarPosition(AvatarPosition(vertical: .messageBottom))
        layout?.setMessageIncomingCellBottomLabelAlignment(.init(textAlignment: .left,
                                                                 textInsets: .zero))
        layout?.setMessageOutgoingCellBottomLabelAlignment(.init(textAlignment: .right,
                                                                 textInsets: .zero))
        messagesCollectionView.register(IQCardCell.self, forCellWithReuseIdentifier: IQCardCell.cellIdentifier)
        messagesCollectionView.register(IQSingleChoicesCell.self, forCellWithReuseIdentifier: IQSingleChoicesCell.cellIdentifier)
        messagesCollectionView.register(IQStackedSingleChoicesCell.self, forCellWithReuseIdentifier: IQStackedSingleChoicesCell.cellIdentifier)
        messagesCollectionView.register(IQFilePreviewCell.self, forCellWithReuseIdentifier: IQFilePreviewCell.cellIdentifier)
        messagesCollectionView.register(MyCustomCell.self, forCellWithReuseIdentifier: MyCustomCell.cellIdentifier)
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
    }
    
    private func getMessageIndexById(messageId: Int) -> Int {
        guard messageId != 0 else {
            return -1
        }

        for (index, message) in messages.enumerated() {
            if message.id == messageId {
                return index
            }
        }
        return -1
    }

    private func getMyMessageByLocalId(localId: Int) -> Int {
        guard localId != 0 else {
            return -1
        }

        for (index, message) in messages.enumerated() {
            if message.isMy && message.localId == localId {
                return index
            }
        }
        return -1
    }
    
    private func getMessageIndex(_ message: IQChatMessage) -> Int? {
        let index = getMessageIndexById(messageId: message.id)
        if index >= 0 {
            return index
        }
        if message.isMy {
            return getMyMessageByLocalId(localId: message.localId)
        }
        return nil
    }
    
    private func isGroupStart(_ indexPath: IndexPath) -> Bool {
        let index = indexPath.row
        let message = messages[index]
        if index == 0 {
            return true
        }

        let prev = messages[index - 1]
        return prev.isMy != message.isMy
                || (prev.userId != nil && prev.userId != message.userId)
                || (message.createdAt - prev.createdAt) > 60000
    }

    private func isGroupEnd(_ indexPath: IndexPath) -> Bool {
        let index = indexPath.row
        let message = messages[index]
        if index + 1 == messages.count {
            return true
        }

        let next = messages[index + 1]
        return next.isMy != message.isMy
                || (next.userId != nil && next.userId != message.userId)
                || (next.createdAt - message.createdAt) > 60000
    }
    
    private func shouldDisplayMessageDate(_ indexPath: IndexPath) -> Bool {
        let index = indexPath.row
        guard index > 0 else { return true }
        let message = messages[index]
        let prev = messages[index - 1]
        
        let calendar = Calendar.current
        let messageDateComponents = calendar.dateComponents([.year, .month, .day], from: message.sentDate)
        let prevDateComponents = calendar.dateComponents([.year, .month, .day], from: prev.sentDate)
        
        return messageDateComponents.year != prevDateComponents.year ||
        messageDateComponents.month != prevDateComponents.month ||
        messageDateComponents.day != prevDateComponents.day
    }
    
    override open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let messagesDataSource = messagesCollectionView.messagesDataSource else {
            fatalError("Ouch. nil data source for messages")
        }
        
        if isSectionReservedForTypingIndicator(indexPath.section){
            return super.collectionView(collectionView, cellForItemAt: indexPath)
        }
        
        let message = messages[indexPath.row]
        
        if message.isMediaMessage {
            IQChannels.loadMessageMedia(message.id)
        }
        
        if case .custom = message.kind {
            if message.payload == .singleChoice {
                let cell = messagesCollectionView.dequeueReusableCell(IQStackedSingleChoicesCell.self, for: indexPath)
                cell.setSingleChoices(message.singleChoices ?? [])
                cell.configure(with: message, at: indexPath, and: messagesCollectionView)
                return cell
            } else if message.payload == .card || message.payload == .carousel {
                let cell = messagesCollectionView.dequeueReusableCell(IQCardCell.self, for: indexPath)
                cell.configure(with: message, at: indexPath, and: messagesCollectionView)
                return cell
            }
            
            if message.file?.type == .file {
                let cell = messagesCollectionView.dequeueReusableCell(IQFilePreviewCell.self, for: indexPath)
                cell.configure(with: message, at: indexPath, and: messagesCollectionView)
                return cell
            }
            
            let cell = messagesCollectionView.dequeueReusableCell(MyCustomCell.self, for: indexPath)
            cell.configure(with: message, at: indexPath, and: messagesCollectionView)
            return cell
        } else if case .text = message.kind {
            if message.payload == .singleChoice,
               message.isDropDown,
               messages.count - 1 == indexPath.row,
               !(message.singleChoices?.isEmpty ?? true){
                let cell = messagesCollectionView.dequeueReusableCell(IQSingleChoicesCell.self, for: indexPath)
                cell.configure(with: message, at: indexPath, and: messagesCollectionView)
                return cell
            }
        }
        
        return super.collectionView(collectionView, cellForItemAt: indexPath)
    }
}

// MARK: - MESSAGES DATA SOURCE
extension IQChannelMessagesViewController: MessagesDataSource {
    public func currentSender() -> MessageKit.SenderType {
        return MessageSender(senderId: client?.senderId ?? "",
                             displayName: client?.senderDisplayName ?? "")
    }
    
    public func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessageKit.MessagesCollectionView) -> MessageKit.MessageType {
        return messages[indexPath.row]
    }
    
    public func numberOfSections(in messagesCollectionView: MessageKit.MessagesCollectionView) -> Int {
        return 1
    }
    
    public func numberOfItems(inSection section: Int, in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }
}

// MARK: - MESSAGES LAYOUT DELEGATE
extension IQChannelMessagesViewController: MessagesLayoutDelegate {
    public func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
        guard let dataSource = messagesCollectionView.messagesDataSource else { return .bubble }
        let isSender = dataSource.isFromCurrentSender(message: message)
        return .bubbleTail(isSender ? .bottomRight : .bottomLeft, .curved)
    }
    
    public func messageTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        guard isGroupStart(indexPath) else {
            return 0
        }
        
        let message = messages[indexPath.row]
        guard message.user != nil else {
            return 0
        }
        
        return 20
    }
    
    public func cellTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        if !shouldDisplayMessageDate(indexPath) {
            return 0
        }
        
        return 20
    }
    
    public func cellBottomLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        if !isGroupEnd(indexPath) {
            return 0
        }
        return 20
    }
}

// MARK: - MESSAGES DISPLAY DELEGATE
extension IQChannelMessagesViewController: MessagesDisplayDelegate {
    public func messageTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        guard isGroupStart(indexPath) else {
            return nil
        }
        
        guard let message = message as? IQChatMessage,
              let user = message.user,
              let displayName = user.displayName else {
            return nil
        }
        
        return NSAttributedString(string: displayName, attributes: [NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 11),
                                                                    NSAttributedStringKey.foregroundColor : UIColor.lightGray])
    }
    
    public func cellTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        guard shouldDisplayMessageDate(indexPath) else {
            return nil
        }
        
        let index = indexPath.row
        let message = messages[index]
        
        let dateFormatter = DateFormatter()
        dateFormatter.doesRelativeDateFormatting = true
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        let date = dateFormatter.string(from: message.sentDate)
        return NSAttributedString(string: date, attributes: [NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 12),
                                                             NSAttributedStringKey.foregroundColor : UIColor.lightGray])
    }
    
    public func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        let message = messages[indexPath.row]
        avatarView.isHidden = false

        guard !message.isMy,
              isGroupStart(indexPath),
              let user = message.user else {
            avatarView.isHidden = true
            return
        }

        if let avatarImage = user.avatarImage {
            let avatar: Avatar = .init(image: avatarImage)
            avatarView.set(avatar: avatar)
        }

        if let avatarURL = user.avatarURL {
            let m = SDWebImageManager.shared
            m.loadImage(with: avatarURL, options: [], progress: nil) { [weak self] (image, data, error, cacheType, finished, imageURL) in
                DispatchQueue.main.async {
                    guard let self = self, let image = image else { return }
                    user.avatarImage = image
                    let index: Int
                    if message.isMy {
                        index = self.getMyMessageByLocalId(localId: message.localId)
                    } else {
                        index = self.getMessageIndexById(messageId: message.id)
                    }
                    let path = IndexPath(item: index, section: 0)
                    messagesCollectionView.reloadItems(at: [path])
                }
            }
        }

        let initials = String((message.user?.name ?? "").prefix(1))
        let backgroundColor = UIColor.paletteColorFromString(string: user.name)
        let avatar: Avatar = .init(initials: initials)
        avatarView.backgroundColor = backgroundColor
        avatarView.set(avatar: avatar)
    }
    
    public func cellBottomLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        if !isGroupEnd(indexPath) {
            return nil
        }
        
        let message = messages[indexPath.row]
        let style = NSParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
        if message.isMy {
            style.alignment = .right
        } else {
            style.alignment = .left
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .short
        let time = dateFormatter.string(from: message.sentDate)
        let str = "\(time)"
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 11.0),
            .foregroundColor: UIColor.lightGray,
            .paragraphStyle: style
        ]
        let attrStr = NSMutableAttributedString(string: str, attributes: attributes)
        
        if message.isMy {
            if message.received {
                let receivedCheckmark = NSAttributedString(string: "✓", attributes: [.foregroundColor: UIColor(hex: 0x00c853)])
                attrStr.append(receivedCheckmark)
            }
            if message.read {
                attrStr.addAttribute(.kern, value: -7, range: NSRange(location: attrStr.length - 1, length: 1))
                let readCheckmark = NSAttributedString(string: "✓", attributes: [.foregroundColor: UIColor(hex: 0x00c853)])
                attrStr.append(readCheckmark)
            }
            attrStr.addAttribute(.kern, value: 7, range: NSRange(location: attrStr.length - 1, length: 1))
            
        } else {
            let space = NSAttributedString(string: " ", attributes: [.kern: 33])
            attrStr.insert(space, at: 0)
        }
        
        return attrStr
    }
}

// MARK: - STATE LISTENER
extension IQChannelMessagesViewController: IQChannelsStateListener {
    var id: String { UUID().uuidString }
    
    private func clearState() {
        stateSub?.unsubscribe()

        client = nil
        state = .loggedOut
        stateSub = nil
    }

    func iqLoggedOut(_ state: IQChannelsState) {
        self.state = state
    }

    func iqAwaitingNetwork(_ state: IQChannelsState) {
        self.state = state
    }

    func iqAuthenticating(_ state: IQChannelsState) {
        self.state = state
    }

    func iqAuthenticated(_ state: IQChannelsState, client: IQClient) {
        self.state = state
        self.client = client
        
        loadMessages()
    }
}

// MARK: - MESSAGES LISTENER
extension IQChannelMessagesViewController: IQChannelsMessagesListener {
    private func clearMessages() {
        messagesSub?.unsubscribe()

        messages = []
        readMessages = []
        messagesSub = nil
        messagesLoaded = false
    }

    private func loadMessages() {
        guard let client, messagesSub == nil, !messagesLoaded else { return }

        messagesSub = IQChannels.messages(self)
    }

    func iq(messagesError error: Error) {
        guard messagesSub != nil else { return }

        messagesSub = nil
    }

    func iq(messages: [IQChatMessage]) {
        guard messagesSub != nil else { return }
        
        self.messages = messages
        readMessages = []
        messagesLoaded = true
        
        messagesCollectionView.reloadData()
    }

    func iqMessagesCleared() {
        clearMessages()

        messagesCollectionView.reloadData()
    }

    func iq(messageAdded message: IQChatMessage) {
        messages.append(message)
        messagesCollectionView.reloadData()
    }

    func iq(messageSent message: IQChatMessage) {
        messages.append(message)
        messagesCollectionView.reloadData()
    }

    func iq(messageUpdated message: IQChatMessage) {
        guard let index = getMessageIndex(message) else {
            return
        }

        messages[index] = message
        var paths = [IndexPath]()
        paths.append(IndexPath(item: index, section: 0))
        if index > 0 {
            paths.append(IndexPath(item: index - 1, section: 0))
        }
        messagesCollectionView.reloadItems(at: paths)
    }
    
    func iq(messagesRemoved messages: [IQChatMessage]) {
        
    }
    
    func iq(messageTyping user: IQUser?) {
        
    }
}

open class MyCustomCell: UICollectionViewCell {
    open func configure(with message: MessageType, at indexPath: IndexPath, and messagesCollectionView: MessagesCollectionView) {
        self.contentView.backgroundColor = UIColor.red
    }
}

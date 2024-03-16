import Foundation
import MessageKit
import InputBarAccessoryView

open class IQChannelMessagesViewController: MessagesViewController {
    
    private var refreshControl: UIRefreshControl!
//    var loginIndicator: IQActivityIndicator!
//    var messagesIndicator: IQActivityIndicator!
//    var incomingBubble: JSQMessagesBubbleImage!
//    var outgoingBubble: JSQMessagesBubbleImage!
    
    private var client: IQClient?
    private var typingUser: IQUser?
    private var typingTimer: Timer?
    private var visible: Bool = false
    private var state: IQChannelsState = .loggedOut
    private var stateSub: IQSubscription?
    private var messagesLoaded: Bool = false
    private var messages: [IQChatMessage] = []
    private var readMessages: Set<Int> = []
    private var messagesSub: IQSubscription?
    private var moreMessagesLoading: IQSubscription?
    private var pickerActionSheet: UIAlertController?
    private var fileActionSheet: UIAlertController?
    private var fileActionSheetMessageId: Int = 0
    private var uploadActionSheet: UIAlertController?
    private var uploadActionSheetLocalId: Int = 0
    
    // MARK: - LIFECYCLE
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavbar()
        setupTabbarSupport()
        setupCollectionView()
        setupLoginIndicator()
        setupMessagesIndicator()
        setupBubbles()
        setupAvatars()
        setupRefreshControl()
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
    private func setupNavbar() {
        navigationItem.title = "Сообщения"
    }
    
    private func setupTabbarSupport() {
        if tabBarController == nil && (parent?.parent as? UITabBarController) == nil {
            edgesForExtendedLayout = .top
        }
    }
    
    private func setupCollectionView() {
//        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard(_:)))
//        tap.delegate = self
//        collectionView.addGestureRecognizer(tap)
//        collectionView.register(MessagesTypingIndicatorFooterView.nib(), forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: MessagesTypingIndicatorFooterView.footerReuseIdentifier)
//        collectionView.register(IQStackedSingleChoicesCell.nib(), forCellWithReuseIdentifier: IQStackedSingleChoicesCell.cellReuseIdentifier)
//        collectionView.register(IQSingleChoicesCell.nib(), forCellWithReuseIdentifier: IQSingleChoicesCell.cellReuseIdentifier)
//        collectionView.register(IQCardCell.self, forCellWithReuseIdentifier: IQCardCell.cellReuseIdentifier)
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        
        messageInputBar.delegate = self
        messageInputBar.inputTextView.tintColor = .red
        messageInputBar.sendButton.setTitleColor(.red, for: .normal)
        messageInputBar.sendButton.setTitleColor(UIColor.red.withAlphaComponent(0.3), for: .highlighted)
    }
    
    private func setupLoginIndicator() {
//        loginIndicator = IQActivityIndicator.activityIndicator()
//        loginIndicator.translatesAutoresizingMaskIntoConstraints = false
//        
//        view.addSubview(loginIndicator)
//        NSLayoutConstraint.activate([
//            loginIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            loginIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
//        ])
    }
    
    private func setupMessagesIndicator() {
//        messagesIndicator = IQActivityIndicator.activityIndicator()
//        messagesIndicator.translatesAutoresizingMaskIntoConstraints = false
//        
//        view.addSubview(messagesIndicator)
//        NSLayoutConstraint.activate([
//            messagesIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            messagesIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
//        ])
    }
    
    private func setupBubbles() {
//        let factory = JSQMessagesBubbleImageFactory()
//        incomingBubble = factory?.incomingMessagesBubbleImage(with: UIColor(hex: 0xe6e6eb))
//        outgoingBubble = factory?.outgoingMessagesBubbleImage(with: UIColor(hex: 0x0f87ff))
    }
    
    private func setupAvatars() {
//        collectionView.collectionViewLayout.outgoingAvatarViewSize = .zero
    }
    
    private func setupRefreshControl() {
//        if refreshControl != nil {
//            return
//        }
//        
//        refreshControl = UIRefreshControl()
//        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
//        collectionView.addSubview(refreshControl)
    }
    
    private func setupTypingTimer() {
        typingTimer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(onTick), userInfo: nil, repeats: false)
        if typingTimer == nil {
            typingTimer?.invalidate()
        }
    }

//    private func singleChoicesView(_ view: IQSingleChoicesView, didSelectOption singleChoice: IQSingleChoice) {
//        IQChannels.sendSingleChoice(singleChoice)
//    }

    private func extendByTime(_ seconds: TimeInterval) {
        let newFireDate = (typingTimer?.fireDate ?? Date()).addingTimeInterval(seconds)
        typingTimer?.fireDate = newFireDate
    }
    
    private func clear() {
        clearState()
//        clearMessages()
//        clearMoreMessages()
    }
    
    private func inputToolbarEnableInteraction() {
//        inputToolbar.contentView.textView.isEditable = true
//        inputToolbar.contentView.leftBarButtonItem.isEnabled = true
    }

    private func inputToolbarDisableInteraction() {
//        inputToolbar.contentView.textView.isEditable = false
//        inputToolbar.contentView.leftBarButtonItem.isEnabled = false
    }

    
    // MARK: - ACTIONS
    @objc
    private func onTick() {
//        showTypingIndicator = false
        typingUser = nil
        typingTimer?.invalidate()
    }
    
    @objc
    private func dismissKeyboard(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    @objc 
    private func refresh(_ sender: Any) {
        if messagesLoaded {
//            loadMoreMessages()
        } else {
//            loadMessages()
        }
    }

}

// MARK: - MESSAGES DATA SOURCE
extension IQChannelMessagesViewController: MessagesDataSource {
    public func currentSender() -> MessageKit.SenderType {
        return MessageSender(senderId: client?.senderId ?? "",
                             displayName: client?.senderDisplayName ?? "")
    }
    
    public func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessageKit.MessagesCollectionView) -> MessageKit.MessageType {
        return messages[indexPath.section]
    }
    
    public func numberOfSections(in messagesCollectionView: MessageKit.MessagesCollectionView) -> Int {
        return messages.count
    }
}

// MARK: - INPUT BAR DELEGATE
extension IQChannelMessagesViewController: InputBarAccessoryViewDelegate {
    
}

// MARK: - MESSAGES LAYOUT DELEGATE
extension IQChannelMessagesViewController: MessagesLayoutDelegate {
    public func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        IQChannels.sendText(text)
    }
}

// MARK: - MESSAGES DISPLAY DELEGATE
extension IQChannelMessagesViewController: MessagesDisplayDelegate {
//    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//        if !isTypingIndicatorHidden && kind == UICollectionView.elementKindSectionFooter {
//            return dequeueTypingIndicatorFooterView(for: indexPath)
//        } else if showLoadEarlierMessagesHeader && kind == UICollectionView.elementKindSectionHeader {
//            return collectionView.dequeueLoadEarlierMessagesViewHeader(for: indexPath)
//        }
//        
//        return nil
//    }
}

// MARK: - IQCHANNELS STATE LISTENER
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
//        clear()
//        _loginIndicator.stopAnimating()
//        inputToolbarDisableInteraction()
    }

    func iqAwaitingNetwork(_ state: IQChannelsState) {
        self.state = state
//        _loginIndicator.label.text = NSLocalizedString("iqchannels.login_waiting_for_net", comment: "Ожидание сети...")
//        _loginIndicator.startAnimating()
//
//        inputToolbarDisableInteraction()
    }

    func iqAuthenticating(_ state: IQChannelsState) {
        self.state = state
//        _loginIndicator.label.text = NSLocalizedString("iqchannels.login_in_progress", comment: "Авторизация...")
//        _loginIndicator.startAnimating()
//
//        inputToolbarDisableInteraction()
    }

    func iqAuthenticated(_ state: IQChannelsState, client: IQClient) {
        self.state = state
        self.client = client
//        _loginIndicator.label.text = ""
//        _loginIndicator.stopAnimating()
//
        loadMessages()
    }
}

// MARK: - IQCHANNELS MESSAGES LISTENER
extension IQChannelMessagesViewController: IQChannelsMessagesListener {
    private func clearMessages() {
//        messagesIndicator.stopAnimating()
        messagesSub?.unsubscribe()

        messages = []
        readMessages = []
        messagesSub = nil
        messagesLoaded = false
    }

    private func loadMessages() {
        guard let client = client, messagesSub == nil, !messagesLoaded else { return }

        messagesSub = IQChannels.messages(self)
//        messagesIndicator.label.text = NSLocalizedString("iqchannels.loading", comment: "Loading...")
//        messagesIndicator.startAnimating()
    }

    func iq(messagesError error: Error) {
        guard messagesSub != nil else { return }

        messagesSub = nil
//        messagesIndicator.stopAnimating()
        refreshControl.endRefreshing()

//        let alert = UIAlertController.iq_alert(withError: error)
//        present(alert, animated: true, completion: nil)
    }

    func iq(messages: [IQChatMessage]) {
        guard let messagesSub = messagesSub else { return }

        let initial = !messagesLoaded
//        let prevOffsetReversed = collectionView.contentSize.height - collectionView.contentOffset.y

        self.messages = messages
        readMessages = []
        messagesLoaded = true

//        messagesIndicator.stopAnimating()
        messagesCollectionView.reloadData()
        view.layoutIfNeeded()
//
//        if initial {
//            finishReceivingMessage(animated: false)
//        } else {
//            let offset = collectionView.contentSize.height - prevOffsetReversed
//            collectionView.contentOffset = CGPoint(x: collectionView.contentOffset.x, y: offset)
//        }

//        refreshControl.endRefreshing()
    }

    func iqMessagesCleared() {
        clearMessages()

        messagesCollectionView.reloadData()
        inputToolbarDisableInteraction()
//        messagesIndicator.stopAnimating()
        refreshControl.endRefreshing()
    }

    func iq(messageAdded message: IQChatMessage) {
        messages.append(message)
//        finishReceivingMessage(animated: true)
    }

    func iq(messageSent message: IQChatMessage) {
        messages.append(message)
//        finishSendingMessage(animated: true)
    }

    func iq(messageUpdated message: IQChatMessage) {
//        guard let index = getMessageIndex(message), index != -1 else { return }
//
//        messages[index] = message
//
//        var paths = [IndexPath]()
//        paths.append(IndexPath(item: index, section: 0))
//        if index > 0 {
//            paths.append(IndexPath(item: index - 1, section: 0))
//        }
//        messagesCollectionView.reloadItems(at: paths)
    }
    
    func iq(messagesRemoved messages: [IQChatMessage]) {
//        guard let messagesSub = messagesSub else { return }
//
//        var remoteMessages = messages
//
//        var index = 0
//        var paths = [IndexPath]()
//        var indexSet = IndexSet()
//        for localMessage in messages {
//            for remoteMessage in remoteMessages {
//                if localMessage.id == remoteMessage.id {
//                    paths.append(IndexPath(item: index, section: 0))
//                    indexSet.insert(index)
//                }
//            }
//
//            index += 1
//        }
//
//        messages.remove(at: indexSet)
//        messagesCollectionView.deleteItems(at: paths)
    }
    
    func iq(messageTyping user: IQUser?) {
//        if !showTypingIndicator {
//            setupTypingTimer()
//        } else {
//            extendByTime(2)
//        }
//
//        typingUser = user
//        showTypingIndicator = true
//        scrollToBottomAnimated(true)
    }
}

// MARK: - GESTURE RECOGNIZER DELEGATE
extension IQChannelMessagesViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, 
                           shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

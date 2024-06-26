import UIKit
import MessageKit

final class IQFilePreviewCell: MessageContentCell {
    
    override weak var delegate: MessageCellDelegate? {
        didSet {
            messageLabel.delegate = delegate
        }
    }
    
    private let timestampView = IQTimestampView()
    
    private var replyView = IQCellReplyView()
    
    weak var replyViewDelegate: IQCellReplyViewDelegate?

    var contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.distribution = .fillProportionally
        stackView.alignment = .top
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()
    var messageLabel = MessageLabel()
    var fileImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()

    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        if let attributes = layoutAttributes as? MessagesCollectionViewLayoutAttributes {
            contentStackView.layoutMargins = attributes.messageLabelInsets
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        messageLabel.attributedText = nil
        messageLabel.text = nil
    }

    override func setupSubviews() {
        super.setupSubviews()
        messageContainerView.addSubview(contentStackView)
        messageContainerView.addSubview(timestampView)
        messageContainerView.addSubview(replyView)
        
        contentStackView.addArrangedSubview(fileImageView)
        contentStackView.addArrangedSubview(messageLabel)
        
        contentStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        replyView.snp.makeConstraints { make in
            make.horizontalEdges.top.equalToSuperview()
        }

        timestampView.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(12)
            make.bottom.equalToSuperview().inset(8)
        }
        
        fileImageView.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 32, height: 36))
        }
    }
    
    override func handleTapGesture(_ gesture: UIGestureRecognizer) {
        let touchLocation = convert(gesture.location(in: self), to: messageContainerView)
        if !replyView.isHidden, replyView.frame.contains(touchLocation) {
            replyViewDelegate?.cell(self, didTapReplyView: replyView)
        } else {
            super.handleTapGesture(gesture)
        }
    }
        
    override func configure(with message: MessageType, at indexPath: IndexPath, and messagesCollectionView: MessagesCollectionView) {
        super.configure(with: message, at: indexPath, and: messagesCollectionView)

        timestampView.configure(with: message)
        guard let displayDelegate = messagesCollectionView.messagesDisplayDelegate else {
            fatalError("MessagesDisplayDelegate has not been set.")
        }
        
        guard let chatMessage = message as? IQChatMessage else { return }
        
        fileImageView.tintColor = chatMessage.isMy ? .white : .black
        
        replyView.configure(with: chatMessage)
        replyView.isHidden = chatMessage.replyToMessage == nil
        
        if chatMessage.file?.url == nil {
            fileImageView.startRotating()
            fileImageView.contentMode = .center
            fileImageView.image = UIImage(named: "loaderBig",
                                      in: .channelsAssetBundle(),
                                      compatibleWith: nil)
        } else {
            fileImageView.stopRotating()
            fileImageView.contentMode = .bottom
            fileImageView.image = UIImage(named: "doc",
                                      in: .channelsAssetBundle(),
                                      compatibleWith: nil)
        }

        let enabledDetectors = displayDelegate.enabledDetectors(for: message, at: indexPath, in: messagesCollectionView)

        messageLabel.configure {
            messageLabel.enabledDetectors = enabledDetectors
            for detector in enabledDetectors {
                let attributes = displayDelegate.detectorAttributes(for: detector, and: message, at: indexPath)
                messageLabel.setAttributes(attributes, detector: detector)
            }
            
            let textColor = displayDelegate.textColor(for: message, at: indexPath, in: messagesCollectionView)
            let attributedText = NSMutableAttributedString()
            attributedText.append(.init(string: chatMessage.text + "\n", attributes: [
                .foregroundColor: textColor,
                .font: UIFont.preferredFont(forTextStyle: .body)
            ]))
            attributedText.append(.init(string: IQFileSize.unit(with: chatMessage.file?.size ?? 0), attributes: [
                .foregroundColor: textColor.withAlphaComponent(0.64),
                .font: UIFont.systemFont(ofSize: 15)
            ]))
            messageLabel.attributedText = attributedText
        }
    }
}

import UIKit
//import JSQMessagesViewController

class JSQMediaItem: NSObject, NSCoding, NSCopying, JSQMessageMediaData {
    
    // MARK: - PROPERTIES
    var appliesMediaViewMaskAsOutgoing: Bool
    
    private var cachedPlaceholderView: UIView?

    // MARK: - INIT
    override init() {
        self.appliesMediaViewMaskAsOutgoing = true
        self.cachedPlaceholderView = nil
        super.init()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(didReceiveMemoryWarningNotification(_:)),
                                               name: UIApplication.didReceiveMemoryWarningNotification,
                                               object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    init(maskAsOutgoing: Bool) {
        self.appliesMediaViewMaskAsOutgoing = maskAsOutgoing
        self.cachedPlaceholderView = nil
        super.init()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(didReceiveMemoryWarningNotification(_:)),
                                               name: UIApplication.didReceiveMemoryWarningNotification,
                                               object: nil)
    }

    // MARK: - METHODS
    func setAppliesMediaViewMaskAsOutgoing(_ appliesMediaViewMaskAsOutgoing: Bool) {
        self.appliesMediaViewMaskAsOutgoing = appliesMediaViewMaskAsOutgoing
        self.cachedPlaceholderView = nil
    }

    func clearCachedMediaViews() {
        self.cachedPlaceholderView = nil
    }

    // MARK: - ACTIONS
    @objc private func didReceiveMemoryWarningNotification(_ notification: Notification) {
        clearCachedMediaViews()
    }

    // MARK: - NSObject
    override func isEqual(_ object: Any?) -> Bool {
        guard let item = object as? JSQMediaItem else { return false }
        return self.appliesMediaViewMaskAsOutgoing == item.appliesMediaViewMaskAsOutgoing
    }

    override var hash: Int {
        return NSNumber(value: appliesMediaViewMaskAsOutgoing).hash
    }

    override var description: String {
        return "<\(type(of: self)): appliesMediaViewMaskAsOutgoing=\(appliesMediaViewMaskAsOutgoing)>"
    }

    override var debugDescription: String {
        return description
    }

    // MARK: - NSCoding
    required init?(coder aDecoder: NSCoder) {
        self.appliesMediaViewMaskAsOutgoing = aDecoder.decodeBool(forKey: "appliesMediaViewMaskAsOutgoing")
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(appliesMediaViewMaskAsOutgoing, forKey: "appliesMediaViewMaskAsOutgoing")
    }
    
    // MARK: - NSCopying
    func copy(with zone: NSZone? = nil) -> Any {
        return JSQMediaItem(maskAsOutgoing: appliesMediaViewMaskAsOutgoing)
    }
    
    // MARK: - JSQMessageMediaData
    func mediaView() -> UIView? {
        fatalError("Error! required method not implemented in subclass. Need to implement \(#function)")
    }

    func mediaViewDisplaySize() -> CGSize {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return CGSize(width: 315.0, height: 225.0)
        } else {
            return CGSize(width: 210.0, height: 150.0)
        }
    }

    func mediaPlaceholderView() -> UIView? {
//        if self.cachedPlaceholderView == nil {
//            let size = mediaViewDisplaySize()
//            let view = JSQMessagesMediaPlaceholderView.view(with: .gray)
//            view?.frame = CGRect(x: 0.0, y: 0.0, width: size.width, height: size.height)
//            JSQMessagesMediaViewBubbleImageMasker.applyBubbleImageMask(toMediaView: view, isOutgoing: appliesMediaViewMaskAsOutgoing)
//            self.cachedPlaceholderView = view
//        }
        return self.cachedPlaceholderView
    }

    func mediaHash() -> UInt {
        return UInt(hash)
    }
}

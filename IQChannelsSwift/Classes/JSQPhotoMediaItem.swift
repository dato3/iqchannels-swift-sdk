import UIKit
//import JSQMessagesViewController

class JSQPhotoMediaItem: JSQMediaItem {
    
    // MARK: - PROPERTIES
    var image: UIImage?
    var cachedImageView: UIImageView?
    
    // MARK: - INIT
    init(image: UIImage?) {
        self.image = image
        self.cachedImageView = nil
        super.init()
    }
    
    // MARK: - OVERRIDE
    override func clearCachedMediaViews() {
        cachedImageView = nil
    }
    
    override func setAppliesMediaViewMaskAsOutgoing(_ appliesMediaViewMaskAsOutgoing: Bool) {
        cachedImageView = nil
    }
    
    override func mediaView() -> UIView? {
        guard let image = image else { return nil }
        
//        if cachedImageView == nil {
//            let size = mediaViewDisplaySize()
//            let imageView = UIImageView(image: image)
//            imageView.frame = CGRect(x: 0.0, y: 0.0, width: size.width, height: size.height)
//            imageView.contentMode = .scaleAspectFill
//            imageView.clipsToBounds = true
//            JSQMessagesMediaViewBubbleImageMasker.applyBubbleImageMask(toMediaView: imageView, isOutgoing: appliesMediaViewMaskAsOutgoing)
//            cachedImageView = imageView
//        }
        
        return cachedImageView
    }
    
    override var hash: Int {
        var hasher = Hasher()
        hasher.combine(super.hash)
        hasher.combine(self.image?.hash)
        return hasher.finalize()
    }
    
    override var description: String {
        return "<\(type(of: self)): image=\(String(describing: self.image)), appliesMediaViewMaskAsOutgoing=\(self.appliesMediaViewMaskAsOutgoing)>"

    }
    
    // NSCoding
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.image = aDecoder.decodeObject(forKey: "image") as? UIImage
    }

    override func encode(with aCoder: NSCoder) {
        super.encode(with: aCoder)
        aCoder.encode(self.image, forKey: "image")
    }

    // NSCopying
    override func copy(with zone: NSZone? = nil) -> Any {
        let copy = JSQPhotoMediaItem(image: self.image)
        copy.appliesMediaViewMaskAsOutgoing = self.appliesMediaViewMaskAsOutgoing
        return copy
    }

    
    // MARK: - METHODS
    func setImage(_ image: UIImage?) {
        self.image = image
        self.cachedImageView = nil
    }
}

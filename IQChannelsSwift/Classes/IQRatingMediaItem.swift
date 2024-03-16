import UIKit
//import JSQMessagesViewController

class IQRatingMediaItem: JSQMediaItem {
    
    private var rating: IQRating
//    private var ratingView: IQRatingView?

    init(rating: IQRating) {
        self.rating = rating
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    override func mediaView() -> UIView? {
//        if let ratingView = ratingView {
//            return ratingView
//        }
//
//        ratingView = IQRatingView.view(with: rating)
//        if let ratingView = ratingView {
//            JSQMessagesMediaViewBubbleImageMasker.applyBubbleImageMask(toMediaView: ratingView, isOutgoing: false)
//        }
//        return ratingView
//    }

    func mediaDataType() -> String {
        return "rating"
    }

    override func mediaViewDisplaySize() -> CGSize {
        return CGSize(width: 260.0, height: 105.0)
    }
}

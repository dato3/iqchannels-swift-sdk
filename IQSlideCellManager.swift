//
//  IQSlideCellManager.swift
//  IQChannelsSwift
//
//  Created by Muhammed Aralbek on 21.04.2024.
//

import UIKit

class IQSlideCellManager: NSObject, UIGestureRecognizerDelegate {
    
    private var cells: Set<UICollectionViewCell> = []
    
    func add(_ cell: UICollectionViewCell) {
        if cells.contains(cell) {
            cell.gestureRecognizers?.removeAll(where: { $0 is PanGestureRecognizer })
        } else {
            cells.insert(cell)
        }
        let gr = PanGestureRecognizer(target: self, action: #selector(panDidDetect))
        gr.delegate = self
        cell.addGestureRecognizer(gr)
    }
    
    @objc
    private func panDidDetect(_ gesture: UIPanGestureRecognizer) {
        guard let slidingView = gesture.view,
              let superView = slidingView.superview else { return }
        
        let translation = gesture.translation(in: superView)

        switch gesture.state {
        case .began:
            break
        case .changed:
            let newTransform = CGAffineTransform(translationX: translation.x, y: 0)
            slidingView.transform = newTransform
        case .ended, .cancelled:
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: [.curveEaseInOut]) {
                slidingView.transform = .identity
            }
        default:
            break
        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
//        if otherGestureRecognizer.view is UIScrollView { return false }
        return true
    }

}

fileprivate class PanGestureRecognizer: UIPanGestureRecognizer {
    
}

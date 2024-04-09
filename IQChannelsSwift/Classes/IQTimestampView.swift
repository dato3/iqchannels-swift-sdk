//
//  IQTimestampView.swift
//  IQChannelsSwift
//
//  Created by Muhammed Aralbek on 10.04.2024.
//

import UIKit
import SnapKit
import MessageKit

class IQTimestampView: UIView {
    
    private var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter
    }()
    
    private let readImageView = UIImageView()
    
    let dateLabel = UILabel()
    
    private var labelToImageConstraint: Constraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(dateLabel)
        addSubview(readImageView)
        dateLabel.snp.makeConstraints { make in
            make.right.equalToSuperview().priority(999)
            labelToImageConstraint = make.right.equalTo(readImageView.snp.left).inset(-4).constraint
            make.verticalEdges.left.equalToSuperview()
        }
        readImageView.snp.makeConstraints { make in
            make.verticalEdges.right.equalToSuperview()
            make.size.equalTo(16)
        }
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    func configure(with message: any MessageType) {
        guard let message = message as? IQChatMessage else { return }

        let attributedString = NSMutableAttributedString()
        attributedString.append(.init(string: dateFormatter.string(from: message.sentDate),
                                      attributes: [.font: UIFont.systemFont(ofSize: 13),
                                                   .foregroundColor: message.isMy ? UIColor.white.withAlphaComponent(0.63) : .init(hex: 0x919399)]))
        dateLabel.attributedText = attributedString
        
        readImageView.isHidden = !(message.isMy && (message.read || message.received))
        readImageView.image = message.read ? .init(named: "doubleCheckmark") : .init(named: "singleCheckmark")
        labelToImageConstraint?.isActive = message.isMy && message.read

    }
}

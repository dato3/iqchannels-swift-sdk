//
//  IQPendingReplyView.swift
//  IQChannelsSwift
//
//  Created by Muhammed Aralbek on 24.04.2024.
//

import UIKit

class IQPendingReplyView: UIView {
    
    var onCloseDidTap: (() -> ())?
    
    private let border: UIView = {
        let view = UIView()
        view.backgroundColor = .init(hex: 0xE4E8ED)
        return view
    }()
    
    private let sideLine: UIView = {
        let view = UIView()
        view.backgroundColor = .init(hex: 0xDD0A34)
        view.layer.cornerRadius = 1
        view.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 2, height: 32))
        }
        return view
    }()
    
    private let authorLabel: UILabel = {
       let label = UILabel()
        label.textColor = .init(hex: 0x919399)
        label.font = .systemFont(ofSize: 13, weight: .regular)
        return label
    }()
    
    private let messageLabel: UILabel = {
       let label = UILabel()
        label.textColor = .init(hex: 0x242729)
        label.font = .systemFont(ofSize: 15, weight: .regular)
        return label
    }()
    
    private lazy var labelsStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [authorLabel, messageLabel])
        stackView.axis = .vertical
        return stackView
    }()
    
    private lazy var stackView: UIStackView = {
       let stackView = UIStackView(arrangedSubviews: [sideLine, labelsStackView, closeButton])
        stackView.spacing = 8
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = .init(top: 0, left: 8, bottom: 0, right: 8)
        return stackView
    }()
    
    private lazy var closeButton: UIButton = {
       let button = UIButton()
        button.setImage(.init(named: "xmarkCircleFilled", in: .channelsAssetBundle(), with: nil), for: .normal)
        button.addTarget(self, action: #selector(closeDidTap), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func configure(_ message: IQChatMessage) {
        messageLabel.text = message.text
        authorLabel.text = message.chatMessageSenderDisplayName()
    }
    
    @objc private func closeDidTap(){
        onCloseDidTap?()
    }
    
    private func setupViews(){
        backgroundColor = .white
        addSubview(border)
        addSubview(stackView)
    }
    
    private func setupConstraints(){
        border.snp.makeConstraints { make in
            make.horizontalEdges.top.equalToSuperview()
            make.height.equalTo(1)
        }
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        closeButton.snp.makeConstraints { make in
            make.size.equalTo(24)
        }
        labelsStackView.snp.makeConstraints { make in
            make.width.equalTo(CGFloat.greatestFiniteMagnitude).priority(.high)
        }
    }

}

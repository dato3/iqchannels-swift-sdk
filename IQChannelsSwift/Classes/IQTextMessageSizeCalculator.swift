//
//  IQTextMessageSizeCalculator.swift
//  IQChannelsSwift
//
//  Created by Muhammed Aralbek on 07.04.2024.
//

import MessageKit

class IQTextMessageSizeCalculator: TextMessageSizeCalculator {
    
    override init(layout: MessagesCollectionViewFlowLayout? = nil) {
        super.init(layout: layout)
        
        incomingMessageLabelInsets.bottom = 28
        outgoingMessageLabelInsets.bottom = 28
    }
    
    override func messageContainerSize(for message: any MessageType) -> CGSize {
        var size = super.messageContainerSize(for: message)
        size.width = max(size.width, 56)
        return size
    }

}

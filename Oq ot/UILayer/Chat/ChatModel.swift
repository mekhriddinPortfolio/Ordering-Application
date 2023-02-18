//
//  ChatModel.swift
//  Oq ot
//
//  Created by Mekhriddin Jumaev on 21/08/22.
//

import Foundation

struct ChatUsersList: Codable {
    let chatUsers: [EachChatUser]
}

struct EachChatUser: Codable {
    let userId: String
    let firstName: String
    let lastName: String
    let avatarPhotoPath: String
}

struct ChatMessageList: Codable {
    let pageIndex: Int
    let totalCount: Int
    let pageCount: Int
    var data: [EachMessage]
}

struct EachMessage: Codable {
    let id: String
    let fromUserId: String
    let toUserId: String
    let messageType: Int
    let body: String
    let optional: String
    let createdAt: String
}

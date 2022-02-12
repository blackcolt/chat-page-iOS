//
//  ViewController.swift
//  chat-page
//
//  Created by idan on 11/02/2022.
//

import UIKit
import SocketIO
import MessageKit
import ChatViewController
import InputBarAccessoryView
import ObjectMapper

class ViewController: MessagesViewController {
    let manager = SocketManager(socketURL: Config.socketUrl, config: [.log(true), .compress])
    var socket: SocketIOClient? = nil
    var messages: [Message] = []
    var UserName: String = ""
    var socketId: String = ""
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        initCollectionView()
        displayLoginAlert()
    }
    func displayLoginAlert(){
        let alert = UIAlertController(title: "בחר שם משתמש", message: "שם משתמש", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "שם משתמש"
        }
        alert.addAction(UIAlertAction(title: "בחר", style: .default, handler: { [weak alert] (_) in
            APIManager.register(userName: alert?.textFields![0].text ?? "", socketId: self.socketId) { userRegistterResponse in
                self.initSocket(userName: userRegistterResponse.user?.displayName ?? "")
            } onFailure: { error in
                print(error)
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
}

extension ViewController { //Socket
    func initSocket(userName: String){
        socket = manager.defaultSocket
        socket?.on(clientEvent: .connect) {data, ack in
            print("socket connected")
            if let payload = data[1] as? [String:  Any] {
                self.socketId = payload["sid"] as! String
            }
        }
        socket?.on("recive chat message") {data, ack in
            if let payload = data as? [[String:String]] {
                let sender = User()
                let message = Message(messageText: payload[0]["message"] ?? "", sender: sender!,  socketId: payload[0]["socketId"] ?? "")
                self.messages.append(message)
                self.messagesCollectionView.reloadData()
            }
        }
        socket?.on(clientEvent: .error) {data, ack in
            print("socke error", data)
        }
        socket?.connect(withPayload: ["userName": userName])
    }
}

extension ViewController: MessageCellDelegate {
    func didSelectURL(_ url: URL) {
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
}

extension ViewController: MessagesDisplayDelegate {
    public func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
//        avatarView.af_setImage(withURL: HelperFunctions.formatimageUrl(imageUrl: (message.sender as? User)?.avatar ?? ""))
    }
    public func textColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return UIColor.black
    }
    public func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return .white
    }
    public func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
//        let tail: MessageStyle.TailCorner = isFromCurrentSender(message: message) ? .bottomRight : .bottomLeft
//        return .bubbleTail(tail, .curved)
        return .bubbleTail(.bottomLeft, .curved)
    }
    public func enabledDetectors(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> [DetectorType] {
        return  [DetectorType.address, DetectorType.url, DetectorType.date, DetectorType.phoneNumber]
    }
    func initCollectionView() {
        messagesCollectionView.backgroundColor = .white
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messagesCollectionView.messageCellDelegate = self
        messageInputBar.delegate = self
        messageInputBar.inputTextView.tintColor = .black
        messageInputBar.sendButton.setTitleColor(UIColor.brown, for: .normal)
        messageInputBar.sendButton.setTitleColor(
            UIColor.black.withAlphaComponent(0.3),
            for: .highlighted
        )
    }
}

extension ViewController: MessagesDataSource {
    public func currentSender() -> SenderType {
        return User()!
    }
    
    public func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return self.messages[indexPath.section]
    }
    
    public func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }
}

extension ViewController: MessagesLayoutDelegate {
    public func cellBottomLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 17
    }
    public func cellTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 15
    }
    public func messageTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 20
    }
    func cellTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        if !isPreviousMessageSameSender(at: indexPath) {
            return NSAttributedString(string: MessageKitDateFormatter.shared.string(from: message.sentDate),
            attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 10),
                         NSAttributedString.Key.foregroundColor: UIColor.green])
        }
        return nil
    }
    func cellBottomLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        let calendar = Calendar.current
        let time = calendar.dateComponents([.hour, .minute], from: message.sentDate)
        return NSAttributedString(string: "\(time.hour!):\(time.minute!)",
        attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 10),
                     NSAttributedString.Key.foregroundColor: UIColor.green])
    }
    func messageTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        if !isPreviousMessageSameSender(at: indexPath) {
            let name = message.sender.displayName
                return NSAttributedString(string: name, attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .caption1)])
               }
        return nil
    }
    func isPreviousMessageSameSender(at indexPath: IndexPath) -> Bool {
        guard indexPath.section - 1 >= 0 else { return false }
        return Calendar.current.isDate(self.messages[indexPath.section].sentDate, inSameDayAs: self.messages[indexPath.section - 1].sentDate)
    }
    func isPreviousMessageSameDate(at indexPath: IndexPath) -> Bool {
        guard indexPath.section - 1 >= 0 else { return false }
        return false
    }
}

extension ViewController: InputBarAccessoryViewDelegate {
    public func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        messageInputBar.sendButton.startAnimating()
        messageInputBar.inputTextView.placeholder = "Sending..."
        let components = inputBar.inputTextView.components
        insertMessages(components, inputBar: inputBar)
    }
    private func insertMessages(_ data: [Any], inputBar: InputBarAccessoryView) {
        for component in data {
            if let str = component as? String {
                let message = Message(messageText: str, sender: User()!, socketId: socketId)
                socket?.emit("chat message",message.messageText!) {
                    self.messageInputBar.inputTextView.text = ""
                    self.messageInputBar.inputTextView.placeholder = "Aa"
                    self.messageInputBar.sendButton.stopAnimating()
                    self.messagesCollectionView.scrollToLastItem()
                }
            }
        }
    }
    func insertMessage(_ message: Message) {
           messages.append(message)
           messagesCollectionView.performBatchUpdates({
               messagesCollectionView.insertSections([messages.count - 1])
               if messages.count >= 2 {
                   messagesCollectionView.reloadSections([messages.count - 2])
               }
           }, completion: { [weak self] _ in
               if self?.isLastSectionVisible() == true {
                   self?.messagesCollectionView.scrollToLastItem(animated: true)
               }
            self?.messageInputBar.sendButton.stopAnimating()
           })
    }
    func isLastSectionVisible() -> Bool {
        guard !messages.isEmpty else { return false }
        let lastIndexPath = IndexPath(item: 0, section: messages.count - 1)
        return messagesCollectionView.indexPathsForVisibleItems.contains(lastIndexPath)
    }
}

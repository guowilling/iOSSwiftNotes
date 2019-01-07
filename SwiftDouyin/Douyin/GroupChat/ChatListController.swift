
import Foundation

let COMMON_MSG_PADDING: CGFloat = 8

enum ChatCellMenuActionType: Int {
    case Delete
    case Copy
    case Paste
}

typealias OnChatCellMenuAction = (_ actionType: ChatCellMenuActionType) -> Void

class ChatListController: BaseViewController {
    
    var tableView: UITableView?
    var refreshControl = RefreshControl.init()
    var textView = ChatTextView.init()
    
    var chats = [GroupChat]()
    var pageIndex = 0;
    let pageSize = 20
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView = UITableView(frame: CGRect(x: 0, y: SafeAreaTopHeight, width: ScreenWidth, height: ScreenHeight - (self.navagationBarHeight() + StatusBarHeight) - 10 - SafeAreaBottomHeight))
        tableView?.backgroundColor = ColorClear
        tableView?.delegate = self
        tableView?.dataSource = self
        tableView?.alwaysBounceVertical = true
        tableView?.separatorStyle = .none
        tableView?.register(TimeCell.classForCoder(), forCellReuseIdentifier: TIME_CELL_ID)
        tableView?.register(SystemMessageCell.classForCoder(), forCellReuseIdentifier: SYSTEM_MESSAGE_CELL_ID)
        tableView?.register(ImageMessageCell.classForCoder(), forCellReuseIdentifier: IMAGE_MESSAGE_CELL_ID)
        tableView?.register(TextMessageCell.classForCoder(), forCellReuseIdentifier: TEXT_MESSAGE_CELL_ID)
        self.view.addSubview(tableView!)
        if #available(iOS 11.0, *) {
            tableView?.contentInsetAdjustmentBehavior = UIScrollView.ContentInsetAdjustmentBehavior.never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        
        refreshControl.onRefresh = { [weak self] in
            self?.loadData(page: self?.pageIndex ?? 0)
        }
        tableView?.addSubview(refreshControl)
        
        textView.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(wsDidReceiveMessage(notification:)), name: NSNotification.Name(rawValue: WebSocketDidReceiveMessageNotification), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.setStatusBarHidden(hidden: false)
        self.setStatusBarStyle(style: .lightContent)
        self.setStatusBarBackgroundColor(color: ColorThemeGrayDark)
        
        self.setNavigationBarTitle(title: "GroupChat")
        self.setNavigationBarTitleColor(color: ColorWhite)
        self.setNavigationBarBackgroundColor(color: ColorThemeGrayDark)
        
        textView.show()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        loadData(page: pageIndex)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        textView.dismiss()
    }
    
    func loadData(page: Int, _ size: Int = 20) {
        GroupChatListRequest.getGroupChatList(page: page, size, success: { [weak self] data in
            guard let self = self else { return }
            if let response = data as? GroupChatListResponse {
                UIView.setAnimationsEnabled(false)
                
                let preCount = self.chats.count
                if response.data.count > 0 {
                    var chatsTemp = [GroupChat]()
                    for chat in response.data {
                        if !("system" == chat.msg_type ?? "") &&
                            (chatsTemp.count == 0 || (chatsTemp.count > 0 && (labs((chatsTemp.last?.create_time ?? 0) - (chat.create_time ?? 0)) > 60 * 5))) {
                            let timeChat = chat.createTimeChat()
                            chatsTemp.append(timeChat)
                        }
                        chat.cellHeight = ChatListController.cellHeight(chat: chat)
                        chatsTemp.append(chat)
                    }
                    self.chats.insert(contentsOf: chatsTemp, at: 0)
                    self.tableView?.reloadData()
                }
                
                let curCount = self.chats.count
                if self.pageIndex == 0 || preCount == 0 || (curCount - preCount) <= 0 {
                    self.scrollToBottom()
                } else {
                    self.tableView?.scrollToRow(at: IndexPath(row: curCount - preCount, section: 0), at: .top, animated: false)
                }
                
                self.pageIndex += 1
                self.refreshControl.endRefresh()
                if response.has_more == 0 {
                    self.refreshControl.noMoreData()
                }
                
                UIView.setAnimationsEnabled(true)
            }
        }, failure: { [weak self] error in
            self?.refreshControl.endRefresh()
        })
    }
    
    func deleteChat(cell: UITableViewCell?) {
        guard cell != nil else {
            return
        }
        if let indexPath = tableView?.indexPath(for: cell!) {
            let index = indexPath.row
            if index < chats.count {
                let chat = chats[index]
                var indexPaths = [IndexPath]()
                if index - 1 < chats.count && chats[index - 1].msg_type == "time" {
                    indexPaths.append(IndexPath(row: index - 1, section: 0))
                }
                if index < chats.count {
                    indexPaths.append(IndexPath(row: index, section: 0))
                }
                if indexPaths.count == 0 {
                    return
                }
                DeleteGroupChatRequest.deleteGroupChat(id: chat.id ?? "", success: { [weak self] data in
                    self?.tableView?.beginUpdates()
                    var indexs = [Int]()
                    for indexPath in indexPaths {
                        indexs.append(indexPath.row)
                    }
                    for index in indexs.sorted(by: >) {
                        self?.chats.remove(at: index)
                    }
                    self?.tableView?.deleteRows(at: indexPaths, with: .right)
                    self?.tableView?.endUpdates()
                }, failure: { error in
                    UIWindow.showTips(text: "删除失败")
                })
            }
        }
    }
}

extension ChatListController {
    
    static func cellHeight(chat:GroupChat) -> CGFloat {
        if chat.msg_type == "system" {
            return SystemMessageCell.cellHeight(chat:chat)
        } else if chat.msg_type == "text" {
            return TextMessageCell.cellHeight(chat:chat)
        } else if chat.msg_type == "image" {
            return ImageMessageCell.cellHeight(chat:chat)
        } else {
            return TimeCell.cellHeight(chat:chat)
        }
    }
    
    func scrollToBottom() {
        if self.chats.count > 0 {
            tableView?.scrollToRow(at: IndexPath(row: self.chats.count - 1, section: 0), at: .bottom, animated: false)
        }
    }
}

extension ChatListController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chats.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let chat = chats[indexPath.row]
        if chat.msg_type == "system" {
            let cell = tableView.dequeueReusableCell(withIdentifier: SYSTEM_MESSAGE_CELL_ID) as! SystemMessageCell
            cell.chat = chat
            return cell
        } else if chat.msg_type == "text" {
            let cell = tableView.dequeueReusableCell(withIdentifier: TEXT_MESSAGE_CELL_ID) as! TextMessageCell
            cell.chat = chat
            cell.onMenuAction = { [weak self] actionType in
                if actionType == .Delete {
                    self?.deleteChat(cell: cell)
                } else if actionType == .Copy {
                    let pasteboard = UIPasteboard.general
                    pasteboard.string = chat.msg_content;
                }
            }
            return cell
        } else if chat.msg_type == "image" {
            let cell = tableView.dequeueReusableCell(withIdentifier: IMAGE_MESSAGE_CELL_ID) as! ImageMessageCell
            cell.chat = chat
            cell.onMenuAction = { [weak self] actionType in
                if actionType == .Delete {
                    self?.deleteChat(cell: cell)
                }
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: TIME_CELL_ID) as! TimeCell
            cell.chat = chat
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let chat = chats[indexPath.row]
        return chat.cellHeight
    }
}

extension ChatListController: ChatTextViewDelegate {
    
    func chatTextView(_ textView: ChatTextView, editBoardHeightDidChange height: CGFloat) {
        tableView?.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: height, right: 0)
        scrollToBottom()
    }
    
    func chatTextView(_ textView: ChatTextView, sendText text: String) {
        let chat = GroupChat.initTextChat(text: text)
        chat.visitor = Visitor.read()
        chat.cellHeight = ChatListController.cellHeight(chat: chat)
        
        UIView.setAnimationsEnabled(false)
        tableView?.beginUpdates()
        chats.append(chat)
        tableView?.insertRows(at: [IndexPath.init(row: chats.count - 1, section: 0)], with: .none)
        tableView?.endUpdates()
        UIView.setAnimationsEnabled(true)
        
        scrollToBottom()
        
        if let index = chats.index(of: chat) {
            PostGroupChatTextRequest.postGroupChatText(text: text, success: { [weak self] data in
                if let response = data as? GroupChatResponse {
                    chat.updateTempTextChat(chat: response.data!)
                    self?.tableView?.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
                }
                }, failure: { [weak self] error in
                    chat.isCompleted = false
                    chat.isFailed = true
                    self?.tableView?.reloadRows(at: [IndexPath.init(row: index, section: 0)], with: .none)
            })
        }
    }
    
    func chatTextView(_ textView: ChatTextView, sendImages images: [UIImage]) {
        for image in images {
            if let data: Data = image.jpegData(compressionQuality: 1.0) {
                let chat = GroupChat.initImageChat(image: image)
                chat.visitor = Visitor.read()
                chat.cellHeight = ChatListController.cellHeight(chat: chat)
                
                UIView.setAnimationsEnabled(false)
                tableView?.beginUpdates()
                self.chats.append(chat)
                tableView?.insertRows(at: [IndexPath.init(row: self.chats.count - 1, section: 0)], with: .none)
                tableView?.endUpdates()
                UIView.setAnimationsEnabled(true)
                
                if let index = self.chats.index(of: chat) {
                    PostGroupChatImageRequest.postGroupChatImage(data: data, { [weak self] percent in
                        chat.percent = Float(percent)
                        chat.isCompleted = false
                        chat.isFailed = false
                        if let cell = self?.tableView?.cellForRow(at: IndexPath.init(row: index, section: 0)) as? ImageMessageCell {
                            cell.updateUploadStatus(chat:chat)
                        }
                        }, success: { [weak self] data in
                            if let response = data as? GroupChatResponse {
                                chat.updateTempImageChat(chat: response.data!)
                                self?.tableView?.reloadRows(at: [IndexPath.init(row: index, section: 0)], with: .none)
                            }
                        }, failure: { [weak self] error in
                            chat.percent = 0
                            chat.isCompleted = false
                            chat.isFailed = true
                            if let cell = self?.tableView?.cellForRow(at: IndexPath.init(row: index, section: 0)) as? ImageMessageCell {
                                cell.updateUploadStatus(chat:chat)
                            }
                    })
                }
            }
        }
        scrollToBottom()
    }
}

extension ChatListController {
    @objc func wsDidReceiveMessage(notification: Notification) {
        let json = notification.object as! String
        if let chat = GroupChat.deserialize(from: json) {
            chat.cellHeight = ChatListController.cellHeight(chat: chat)
            var shouldScrollToBottom = false
            if (tableView?.visibleCells.count)! > 0 && (tableView?.indexPath(for: (tableView?.visibleCells.last)!)?.row ?? 0) == chats.count - 1 {
                shouldScrollToBottom = true
            }
            
            UIView.setAnimationsEnabled(false)
            tableView?.beginUpdates()
            chats.append(chat)
            tableView?.insertRows(at: [IndexPath.init(row: chats.count - 1, section: 0)], with: .none)
            tableView?.endUpdates()
            UIView.setAnimationsEnabled(true)
            
            if shouldScrollToBottom {
                scrollToBottom()
            }
        }
    }
}

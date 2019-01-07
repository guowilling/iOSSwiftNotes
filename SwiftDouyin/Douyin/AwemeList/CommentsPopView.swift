
import Foundation

class CommentsPopView: UIView, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate, UIScrollViewDelegate, CommentTextViewDelegate {
    
    let COMMENT_CELL_ID: String = "COMMENT_CELL_ID"
    
    var titleLabel = UILabel.init()
    var closeIcon = UIImageView.init(image:UIImage.init(named: "icon_closetopic"))
    
    var awemeId: String?
    var visitor: Visitor = Visitor.read()
    
    var pageIndex: Int = 0
    var pageSize: Int = 20
    
    var container = UIView.init()
    var tableView = UITableView.init()
    
    var comments = [Comment]()
    
    var commentTextView = CommentTextView()
    var loadMoreControl: LoadMoreControl?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupSubView()
    }
    
    init(awemeId: String) {
        super.init(frame: ScreenFrame)
        
        self.awemeId = awemeId
        
        setupSubView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func setupSubView() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapGuesture(sender:)))
        tapGestureRecognizer.delegate = self
        self.addGestureRecognizer(tapGestureRecognizer)
        
        container.frame = CGRect(x: 0, y: ScreenHeight, width: ScreenWidth, height: ScreenHeight * 3 / 4)
        container.backgroundColor = ColorBlackAlpha60
        self.addSubview(container)
        
        let roundedPath = UIBezierPath.init(roundedRect: CGRect(origin: .zero, size: CGSize(width: ScreenWidth, height: ScreenHeight * 3 / 4)), byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 10.0, height: 10.0))
        let maskLayer = CAShapeLayer.init()
        maskLayer.path = roundedPath.cgPath
        container.layer.mask = maskLayer
        
        let visualEffectView = UIVisualEffectView.init(effect: UIBlurEffect(style: .dark))
        visualEffectView.frame = self.bounds
        visualEffectView.alpha = 1.0
        container.addSubview(visualEffectView)
        
        titleLabel.frame = CGRect.init(origin: .zero, size: CGSize(width: ScreenWidth, height: 35))
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        titleLabel.text = "0条评论"
        titleLabel.textColor = ColorGray
        titleLabel.font = SmallFont
        container.addSubview(titleLabel)
        
        closeIcon.frame = CGRect.init(x: ScreenWidth - 40, y: 0, width: 30, height: 30)
        closeIcon.contentMode = .center
        closeIcon.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onCloseIconTap(sender:))))
        closeIcon.isUserInteractionEnabled = true
        container.addSubview(closeIcon)
        
        tableView = UITableView.init(frame: CGRect(x: 0, y: 35, width: ScreenWidth, height: ScreenHeight*3 / 4 - 35 - 50 - SafeAreaBottomHeight), style: .grouped)
        tableView.backgroundColor = ColorClear
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
        tableView.register(CommentListCell.classForCoder(), forCellReuseIdentifier: COMMENT_CELL_ID)
        tableView.tableHeaderView = UIView(frame: CGRect(origin: .zero, size: CGSize(width: self.tableView.bounds.width, height: 0.01)))
        container.addSubview(tableView)
        
        loadMoreControl = LoadMoreControl.init(frame: CGRect(x: 0, y: 100, width: ScreenWidth, height: 50), surplusCount: 10)
        loadMoreControl?.beginLoading()
        loadMoreControl?.onLoad = {[weak self] in
            self?.loadData(page: self?.pageIndex ?? 0)
        }
        tableView.addSubview(loadMoreControl!)
        
        commentTextView.delegate = self
        
        loadData(page: pageIndex)
    }
    
    func loadData(page: Int, _ size: Int = 20) {
        CommentListRequest.getComments(aweme_id: awemeId ?? "", page: pageIndex, success: { [weak self] data in
            guard let self = self else { return }
            self.pageIndex += 1
            
            let response = data as! CommentListResponse
            let comments = response.data
            
            UIView.setAnimationsEnabled(false)
            self.tableView.beginUpdates()
            self.comments += comments
            var indexPaths = [IndexPath]()
            for row in (self.comments.count - comments.count)..<self.comments.count {
                let indexPath = IndexPath(row: row, section: 0)
                indexPaths.append(indexPath)
            }
            self.tableView.insertRows(at: indexPaths, with: .none)
            self.tableView.endUpdates()
            UIView.setAnimationsEnabled(true)
            
            self.loadMoreControl?.endLoading()
            if response.has_more == 0 {
                self.loadMoreControl?.loadingNoMore()
            }
            self.titleLabel.text = String.init(response.total_count) + "条评论"
            }, failure: {[weak self] error in
                self?.loadMoreControl?.loadingFailed()
        })
    }
    
    func commentTextView(_ textView: CommentTextView, sendText text: String) {
        PostCommentRequest.postCommentText(aweme_id: awemeId ?? "", text: text, success: {[weak self] data in
            let response = data as? CommentResponse
            if let comment = response?.data {
                UIView.setAnimationsEnabled(false)
                self?.tableView.beginUpdates()
                self?.comments.insert(comment, at: 0)
                var indexPaths = [IndexPath]()
                indexPaths.append(IndexPath.init(row: 0, section: 0))
                self?.tableView.insertRows(at: indexPaths, with: .none)
                self?.tableView.endUpdates()
                self?.tableView.scrollToRow(at: IndexPath.init(row: 0, section: 0), at: .top, animated: false)
                UIView.setAnimationsEnabled(true)
                UIWindow.showTips(text: "评论成功")
            } else {
                UIWindow.showTips(text: "评论失败")
            }
            }, failure: { error in
                UIWindow.showTips(text: "评论失败")
        })
    }
    
    func deleteComment(comment: Comment) {
        DeleteCommentRequest.deleteComment(cid: comment.cid ?? "", success: {[weak self] data in
            if let index = self?.comments.index(of: comment) {
                self?.tableView.beginUpdates()
                self?.comments.remove(at: index)
                var indexPaths = [IndexPath]()
                indexPaths.append(IndexPath(row: index, section: 0))
                self?.tableView.deleteRows(at: indexPaths, with: .right)
                self?.tableView.endUpdates()
                UIWindow.showTips(text: "评论删除成功")
            } else {
                UIWindow.showTips(text: "评论删除失败")
            }
        }, failure: { error in
            UIWindow.showTips(text: "评论删除失败")
        })
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CommentListCell.cellHeight(comment: comments[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: COMMENT_CELL_ID) as! CommentListCell
        cell.comment = comments[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let comment = comments[indexPath.row]
        if !comment.isTemp && comment.user_type == "visitor" && UDID_MD5 == comment.visitor?.udid {
            let menu = MenuPopView.init(titles: ["删除"])
            menu.onAction = {[weak self] index in
                self?.deleteComment(comment: comment)
            }
            menu.show()
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        if offsetY < 0 {
            self.frame = CGRect(x: 0, y: -offsetY, width: self.frame.width, height: self.frame.height)
        }
        if offsetY < -100 && scrollView.isDragging {
            dismiss()
        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if NSStringFromClass((touch.view?.superview?.classForCoder)!).contains("CommentListCell")  {
            return false
        } else {
            return true
        }
    }
    
    @objc func handleTapGuesture(sender: UITapGestureRecognizer) {
        let point = sender.location(in: container)
        if !container.layer.contains(point) {
            dismiss()
        }
    }
    
    @objc func onCloseIconTap(sender: UITapGestureRecognizer) {
        dismiss()
    }
    
    func show() {
        if let window = UIApplication.shared.delegate?.window as? UIWindow {
            window.addSubview(self)
            UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveEaseOut, animations: {
                self.container.frame.origin.y = self.container.frame.origin.y - self.container.frame.size.height
            })
            commentTextView.show()
        }
    }
    
    func dismiss() {
        UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveEaseOut, animations: {
            self.container.frame.origin.y = self.container.frame.origin.y + self.container.frame.size.height
        }) { finished in
            self.removeFromSuperview()
        }
        self.commentTextView.dismiss()
    }
}

// MARK: -

class CommentListCell: UITableViewCell {
    
    static let MaxContentWidth: CGFloat = ScreenWidth - 55 - 35
    
    var avatarIcon = UIImageView.init(image: UIImage(named: "img_find_default"))
    var likeIcon = UIImageView.init(image: UIImage(named: "icCommentLikeBefore_black"))
    var nicknameLabel = UILabel.init()
    var contentLabel = UILabel.init()
    var dateLabel = UILabel.init()
    var likeNumLabel = UILabel.init()
    var splitLine = UIView.init()
    
    var comment: Comment? {
        didSet {
            guard let comment = comment else { return }
            var avatarURL: URL?
            if comment.user_type == "user" {
                avatarURL = URL.init(string: comment.user?.avatar_thumb?.url_list.first ?? "")
                nicknameLabel.text = comment.user?.nickname
            } else {
                avatarURL = URL.init(string: comment.visitor?.avatar_thumbnail?.url ?? "")
                nicknameLabel.text = Visitor.formatUDID(udid: comment.visitor?.udid ?? "")
            }
            avatarIcon.setImageWithURL(imageURL: avatarURL!) { [weak self] (image, error) in
                self?.avatarIcon.image = image?.drawCircleImage()
            }
            contentLabel.text = comment.text
            dateLabel.text = Date.formatTime(timeInterval: TimeInterval(comment.create_time ?? 0))
            likeNumLabel.text = String.formatCount(count: comment.digg_count ?? 0)
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .none
        self.backgroundColor = ColorClear
        
        setupSubView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupSubView() {
        avatarIcon.clipsToBounds = true
        avatarIcon.layer.cornerRadius = 14
        self.addSubview(avatarIcon)
        
        likeIcon.contentMode = .center
        self.addSubview(likeIcon)
        
        nicknameLabel.numberOfLines = 1
        nicknameLabel.textColor = ColorWhiteAlpha60
        nicknameLabel.font = SmallFont
        self.addSubview(nicknameLabel)
        
        contentLabel.numberOfLines = 0
        contentLabel.textColor = ColorWhiteAlpha80
        contentLabel.font = MediumFont
        self.addSubview(contentLabel)
        
        dateLabel.numberOfLines = 1
        dateLabel.textColor = ColorGray
        dateLabel.font = SmallFont
        self.addSubview(dateLabel)
        
        likeNumLabel.numberOfLines = 1
        likeNumLabel.textColor = ColorGray
        likeNumLabel.font = SmallFont
        self.addSubview(likeNumLabel)
        
        splitLine.backgroundColor = ColorWhiteAlpha10
        self.addSubview(splitLine)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        avatarIcon.image = UIImage.init(named: "img_find_default")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        avatarIcon.snp.makeConstraints { make in
            make.top.left.equalTo(self).inset(15)
            make.width.height.equalTo(28)
        }
        
        likeIcon.snp.makeConstraints { make in
            make.top.right.equalTo(self).inset(15)
            make.width.height.equalTo(20)
        }
        
        nicknameLabel.snp.makeConstraints { make in
            make.top.equalTo(self).offset(10)
            make.left.equalTo(self.avatarIcon.snp.right).offset(10)
            make.right.equalTo(self.likeIcon.snp.left).inset(25)
        }
        
        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(self.nicknameLabel.snp.bottom).offset(5)
            make.left.equalTo(self.nicknameLabel)
            make.width.lessThanOrEqualTo(CommentListCell.MaxContentWidth)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(self.contentLabel.snp.bottom).offset(5)
            make.left.right.equalTo(self.nicknameLabel)
        }
        
        likeNumLabel.snp.makeConstraints { make in
            make.centerX.equalTo(self.likeIcon)
            make.top.equalTo(self.likeIcon.snp.bottom).offset(5)
        }
        
        splitLine.snp.makeConstraints { make in
            make.left.equalTo(self.dateLabel)
            make.right.equalTo(self.likeIcon)
            make.bottom.equalTo(self)
            make.height.equalTo(0.5)
        }
    }
    
    static func cellHeight(comment:Comment) -> CGFloat {
        let attributedString = NSMutableAttributedString(string: comment.text ?? "")
        attributedString.addAttributes([NSAttributedString.Key.font : MediumFont], range: NSRange(location: 0, length: attributedString.length))
        let size: CGSize = attributedString.multiLineSize(width: MaxContentWidth)
        return size.height + 30 + 30
    }
}

// MARK: -

protocol CommentTextViewDelegate: NSObjectProtocol {
    func commentTextView(_ textView: CommentTextView, sendText text: String)
}

class CommentTextView:UIView, UITextViewDelegate {
    
    let LEFT_INSET: CGFloat = 15
    let RIGHT_INSET: CGFloat = 85
    let TOP_BOTTOM_INSET: CGFloat = 15
    
    var textHeight: CGFloat = 0
    var keyboardHeight: CGFloat = 0
    
    var delegate: CommentTextViewDelegate?
    
    var container = UIView.init()
    var textView = UITextView.init()
    var placeHolderLabel = UILabel.init()
    var atImageView = UIImageView.init(image: UIImage.init(named: "iconWhiteaBefore"))
    var visualEffectView = UIVisualEffectView.init()
    
    init() {
        super.init(frame: ScreenFrame)
        
        setupSubView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupSubView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupSubView() {
        self.frame = ScreenFrame
        self.backgroundColor = ColorClear
        self.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(handleTapGuestrue(sender:))))
        
        container.backgroundColor = ColorBlackAlpha40
        self.addSubview(container)
        
        textView = UITextView.init()
        textView.backgroundColor = ColorClear
        textView.delegate = self
        textView.font = BigFont
        textView.textColor = ColorWhite
        textView.clipsToBounds = false
        textView.returnKeyType = .send
        textView.isScrollEnabled = false
        textView.textContainer.lineBreakMode = .byTruncatingTail
        textView.textContainer.lineFragmentPadding = 0
        textView.textContainerInset = UIEdgeInsets(top: TOP_BOTTOM_INSET, left: LEFT_INSET, bottom: TOP_BOTTOM_INSET, right: RIGHT_INSET)
        container.addSubview(textView)
        
        placeHolderLabel.frame = CGRect.init(x: LEFT_INSET, y: 0, width: ScreenWidth - LEFT_INSET - RIGHT_INSET, height: 50)
        placeHolderLabel.text = "有爱评论，说点儿好听的~"
        placeHolderLabel.textColor = ColorGray
        placeHolderLabel.font = BigFont
        textView.addSubview(placeHolderLabel)
        
        atImageView.contentMode = .center
        textView.addSubview(atImageView)
        
        textHeight = textView.font?.lineHeight ?? 0
        keyboardHeight = SafeAreaBottomHeight
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        atImageView.frame = CGRect.init(x: ScreenWidth - 50, y: 0, width: 50, height: 50)
        
        let roundedPath = UIBezierPath.init(roundedRect: self.bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize.init(width: 10.0, height: 10.0))
        let maskShape = CAShapeLayer.init()
        maskShape.path = roundedPath.cgPath
        container.layer.mask = maskShape
        
        updateSubViewsFrame()
    }
    
    func updateSubViewsFrame() {
        let textViewHeight = keyboardHeight > SafeAreaBottomHeight ? textHeight + 2 * TOP_BOTTOM_INSET : (textView.font?.lineHeight ?? 0) + 2 * TOP_BOTTOM_INSET
        textView.frame = CGRect.init(x: 0, y: 0, width: ScreenWidth, height: textViewHeight)
        container.frame = CGRect.init(x: 0, y: ScreenHeight - keyboardHeight - textViewHeight, width: ScreenWidth, height: textViewHeight + keyboardHeight)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let attributedText = NSMutableAttributedString.init(attributedString: textView.attributedText)
        if !textView.hasText {
            placeHolderLabel.isHidden = false
            textHeight = textView.font?.lineHeight ?? 0
        } else {
            placeHolderLabel.isHidden = true
            textHeight = attributedText.multiLineSize(width: ScreenWidth - LEFT_INSET - RIGHT_INSET).height
        }
        updateSubViewsFrame()
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            delegate?.commentTextView(self, sendText: textView.text)
            textView.text = ""
            placeHolderLabel.isHidden = false
            textHeight = textView.font?.lineHeight ?? 0
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    @objc func keyboardWillShow(notification:Notification) {
        keyboardHeight = notification.keyBoardHeight()
        updateSubViewsFrame()
        
        atImageView.image = UIImage.init(named: "iconBlackaBefore")
        container.backgroundColor = ColorWhite
        textView.textColor = ColorBlack
        self.backgroundColor = ColorBlackAlpha60
    }
    
    @objc func keyboardWillHide(notification:Notification) {
        keyboardHeight = SafeAreaBottomHeight
        updateSubViewsFrame()
        
        atImageView.image = UIImage.init(named: "iconWhiteaBefore")
        container.backgroundColor = ColorBlackAlpha40
        textView.textColor = ColorWhite
        self.backgroundColor = ColorClear
    }
    
    @objc func handleTapGuestrue(sender: UITapGestureRecognizer) {
        let point = sender.location(in: textView)
        if !textView.layer.contains(point) {
            textView.resignFirstResponder()
        }
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let hitView = super.hitTest(point, with: event)
        if hitView == self && hitView?.backgroundColor == ColorClear {
            return nil
        } else {
            return hitView
        }
    }
    
    func show() {
        (UIApplication.shared.delegate?.window as? UIWindow)?.addSubview(self)
    }

    func dismiss() {
        self.removeFromSuperview()
    }
}

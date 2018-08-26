
import UIKit
import SVProgressHUD

/// 加载视图控制器时, 如果 xib 和控制器同名, 默认的构造函数会优先加载 xib
class WBComposeViewController: UIViewController {

    @IBOutlet weak var textView: WBComposeTextView!
    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var toolbarBottomCons: NSLayoutConstraint!
    
    lazy var emoticonView: EmoticonInputView = EmoticonInputView.inputView { [weak self] (emoticon) in
        self?.textView.insertEmoticon(em: emoticon)
    }
    
    // MARK: - 生命周期
    override func viewDidLoad() {
        super.viewDidLoad()

        // 强行更新约束
        //view.layoutIfNeeded()
        
        setupUI()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardChanged),
                                               name: NSNotification.Name.UIKeyboardWillChangeFrame,
                                               object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        textView.becomeFirstResponder()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        textView.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        textView.resignFirstResponder()
    }
}

extension WBComposeViewController {
    
    @objc fileprivate func keyboardChanged(notification: Notification) {
        guard let rect = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,
            let duration = (notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue else {
                return
        }
        let offset = view.bounds.height - rect.origin.y
        toolbarBottomCons.constant = offset // 更新约束
        UIView.animate(withDuration: duration) { // 动画
            self.view.layoutIfNeeded()
        }
    }
    
    @objc fileprivate func close() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func emoticonKeyboard() {
        // textView.inputView 就是文本框的输入视图
        // textView.inputView == nil 即为系统默认的键盘
        textView.inputView = (textView.inputView == nil) ? emoticonView : nil
        textView.reloadInputViews() // Must!
    }
    
    @IBAction func postStatus() {
        let text = textView.emoticonText
        //let image: UIImage? = UIImage(named: "icon_small_kangaroo_loading_1") // 测试发布带图片的微博
        let image: UIImage? = nil
        WBNetworkManager.shared.postStatus(text: text, image: image) { (result, isSuccess) in
            SVProgressHUD.setDefaultStyle(.dark)
            let message = isSuccess ? "发布成功" : "网络不给力"
            SVProgressHUD.showInfo(withStatus: message)
            if isSuccess {
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                    SVProgressHUD.setDefaultStyle(.light)
                    self.close()
                }
            }
        }
    }
}

// MARK: - UITextViewDelegate

extension WBComposeViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        sendButton.isEnabled = textView.hasText
    }
}

private extension WBComposeViewController {
    
    func setupUI() {
        view.backgroundColor = UIColor.white
        setupNavigationBar()
        setupToolbar()
    }
    
    func setupNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "关闭", target: self, action: #selector(close))
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: sendButton)
        navigationItem.titleView = titleLabel
        sendButton.isEnabled = false
    }
    
    func setupToolbar() {
        let itemSettings = [["imageName": "compose_toolbar_picture"],
                            ["imageName": "compose_mentionbutton_background"],
                            ["imageName": "compose_trendbutton_background"],
                            ["imageName": "compose_emoticonbutton_background", "actionName": "emoticonKeyboard"],
                            ["imageName": "compose_add_background"]]
        
        var itemsM = [UIBarButtonItem]()
        for settting in itemSettings {
            guard let imageName = settting["imageName"] else {
                continue
            }
            let image = UIImage(named: imageName)
            let imageHL = UIImage(named: imageName + "_highlighted")
            let btn = UIButton()
            btn.setImage(image, for: [])
            btn.setImage(imageHL, for: .highlighted)
            btn.sizeToFit()
            if let actionName = settting["actionName"] {
                btn.addTarget(self, action: Selector(actionName), for: .touchUpInside)
            }
            itemsM.append(UIBarButtonItem(customView: btn))
            itemsM.append(UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil))
        }
        itemsM.removeLast() // 删除末尾弹簧
        toolbar.items = itemsM
    }
}


import UIKit
import SVProgressHUD

class WBOAuthViewController: UIViewController {
    
    private lazy var webView = UIWebView()
    
    override func loadView() {
        view = webView
        
        title = "新浪微博"
        
        view.backgroundColor = UIColor.white
        
        webView.scrollView.isScrollEnabled = false
        webView.delegate = self
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "返回",
                                                           target: self,
                                                           action: #selector(close),
                                                           isBack: true)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "自动填充",
                                                            target: self,
                                                            action: #selector(autoFill))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let urlString = "https://api.weibo.com/oauth2/authorize?client_id=\(WBAppKey)&redirect_uri=\(WBRedirectURI)"
        guard let url = URL(string: urlString) else {
            return
        }
        let request = URLRequest(url: url)
        webView.loadRequest(request)
    }
    
    @objc fileprivate func close() {
        SVProgressHUD.dismiss()
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func autoFill() {
        let js = "document.getElementById('userId').value = '18508235598';" + " " + "document.getElementById('passwd').value = 'xxxxxx';"
        webView.stringByEvaluatingJavaScript(from: js)
    }
}

extension WBOAuthViewController: UIWebViewDelegate {
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebView.NavigationType) -> Bool {
        if request.url?.absoluteString.hasPrefix(WBRedirectURI) == false {
            return true
        }
        
        // query 得到的是 URL 中 '?' 后面的所有部分.
        // http://localhost/?code=a8b5e58faf706c95a8d1ac9001184fb9
        if request.url?.query?.hasPrefix("code=") == false {
            print("取消授权")
            return false
        }
        
        let code = request.url?.query?.substring(from: "code=".endIndex) ?? ""
        //print("code: \(code)")
        
        // 使用 code 得到 access_token
        WBNetworkManager.shared.loadAccessToken(code: code) { (isSuccess) in
            if !isSuccess {
                SVProgressHUD.showInfo(withStatus: "网络错误")
            } else {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: WBUserLoginSuccessedNotification), object: nil)
                self.close()
            }
        }
        return false
    }
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        SVProgressHUD.show()
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        SVProgressHUD.dismiss()
    }
}

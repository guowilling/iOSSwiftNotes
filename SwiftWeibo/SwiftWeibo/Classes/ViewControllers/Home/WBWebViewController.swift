
import UIKit

class WBWebViewController: WBBaseViewController {

    fileprivate lazy var webView = UIWebView(frame: UIScreen.main.bounds)
    
    var urlString: String? {
        didSet {
            guard let urlString = urlString,
                let url = URL(string: urlString) else {
                    return
            }
            webView.loadRequest(URLRequest(url: url))
        }
    }
}

extension WBWebViewController {
    
    override func setupTableView() {
        webView.backgroundColor = UIColor.white
        self.view.addSubview(webView)
    }
}

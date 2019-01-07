
import Foundation

class BaseViewController: UIViewController {
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = ColorThemeBackground;
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        initNavigationBarTransparent()
    }
    
    func initNavigationBarTransparent() {
        setNavigationBarTitleColor(color: ColorWhite)
        setNavigationBarBackgroundImage(image: UIImage.init())
        
        setStatusBarStyle(style: .lightContent)
        
        self.navigationController?.navigationBar.shadowImage = UIImage.init();
        
        let popButton = UIBarButtonItem.init(image: UIImage.init(named: "icon_titlebar_whiteback"), style: .plain, target: self, action: #selector(popButtonAction))
        popButton.tintColor = ColorWhite
        self.navigationItem.leftBarButtonItem = popButton;
    }
    
    func setNavigationBarTitleColor(color:UIColor) {
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:color]
    }
    
    func setNavigationBarBackgroundColor(color:UIColor) {
        self.navigationController?.navigationBar.backgroundColor = color;
    }
    
    func setNavigationBarBackgroundImage(image:UIImage) {
        self.navigationController?.navigationBar.setBackgroundImage(image, for: .default)
    }
    
    func setNavigationBarTitle(title:String) {
        self.navigationItem.title = title
    }
    
    func setStatusBarHidden(hidden: Bool) {
        UIApplication.shared.isStatusBarHidden = hidden;
    }
    
    func setStatusBarStyle(style:UIStatusBarStyle) {
        UIApplication.shared.statusBarStyle = style
    }
    
    func setStatusBarBackgroundColor(color: UIColor) {
        UIApplication.shared.statusBar?.backgroundColor = color
    }
    
    func navagationBarHeight() -> CGFloat {
        return self.navigationController?.navigationBar.frame.size.height ?? 0;
    }
    
    @objc func popButtonAction() {
        self.navigationController?.popViewController(animated: true);
    }
}

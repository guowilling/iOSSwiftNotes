
import Foundation

let EMOTION_SELECTOR_HEIGHT: CGFloat = 220 + SafeAreaBottomHeight

protocol EmotionSelectorDelegate: NSObjectProtocol {
    
    func emotionSelector(_ selector: EmotionSelector, select emotionKey: String)
    
    func emotionSelectorOnSend(_ selector: EmotionSelector)
    
    func emotionSelectorOnDelete(_ selector: EmotionSelector)
}

class EmotionSelector: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UIGestureRecognizerDelegate, UIScrollViewDelegate {
    
    let EMOTION_CELL_ID = "EmotionCell"
    
    var delegate: EmotionSelectorDelegate?
    
    var collectionView: UICollectionView?
    
    var itemWidth: CGFloat = 0
    var itemHeight: CGFloat = 0
    
    var currentIndex: Int = 0
    
    var pointViews = [UIView]()
    var bottomView = UIView.init()
    var send = UIButton.init()
    
    init() {
        super.init(frame: CGRect(origin: .zero, size: CGSize(width: ScreenWidth, height: EMOTION_SELECTOR_HEIGHT)))
        
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
        self.backgroundColor = ColorSmoke;
        self.clipsToBounds = false;
        
        itemWidth = ScreenWidth / 7.0
        itemHeight = 50
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: itemHeight * 3), collectionViewLayout: layout)
        collectionView?.backgroundColor = ColorClear
        collectionView?.delegate = self
        collectionView?.dataSource = self
        collectionView?.alwaysBounceHorizontal = false
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.register(EmotionCell.classForCoder(), forCellWithReuseIdentifier: EMOTION_CELL_ID)
        self.addSubview(collectionView!)
        
        currentIndex = 0
        let indicatorWith: CGFloat = 5
        let indicatorHeight: CGFloat = 5
        let indicatorSpacing: CGFloat = 8
        for index in 0..<EmotionHelper.emotionPageData.count {
            let pointView = UIView(frame: CGRect(x: ScreenWidth/2 - (indicatorWith * CGFloat(EmotionHelper.emotionPageData.count) + indicatorSpacing * CGFloat(EmotionHelper.emotionPageData.count-1))/2 + (indicatorWith + indicatorSpacing) * CGFloat(index),
                                                 y: (collectionView?.frame.height)!,
                                                 width: indicatorWith,
                                                 height: indicatorHeight))
            if currentIndex == index {
                pointView.backgroundColor = ColorThemeRed;
            } else {
                pointView.backgroundColor = ColorGray;
            }
            pointView.layer.cornerRadius = indicatorWith/2;
            self.addSubview(pointView)
            pointViews.append(pointView)
            
            bottomView = UIView(frame: CGRect.init(x: 0, y: (collectionView?.frame.height)! + 25, width: ScreenWidth, height: 45 + SafeAreaBottomHeight))
            bottomView.backgroundColor = ColorWhite
            self.addSubview(bottomView)
            
            let leftView = UIView.init(frame: CGRect(x: 0, y: 0, width: itemWidth, height: 45 + SafeAreaBottomHeight))
            leftView.backgroundColor = ColorSmoke
            bottomView.addSubview(leftView)
            
            let defaultEmotion = UIImageView.init(frame: CGRect.init(origin: .zero, size: CGSize.init(width: itemWidth, height: 45)))
            defaultEmotion.contentMode = .center
            defaultEmotion.image = UIImage.init(named: "default_emoticon_cover")
            leftView.addSubview(defaultEmotion)
            
            send = UIButton(frame: CGRect.init(x: ScreenWidth - 60 - 15, y: 10, width: 60, height: 25))
            send.isEnabled = false
            send.backgroundColor = ColorSmoke
            send.setTitle("发送", for: .normal)
            send.titleLabel?.font = MediumFont
            send.tintColor = ColorWhite
            send.layer.cornerRadius = 2
            send.addTarget(self, action: #selector(sendMessage), for: .touchUpInside)
            bottomView.addSubview(send)
        }
    }
    
    func updatePoints() {
        for index in 0..<pointViews.count {
            let pointView = pointViews[index]
            if currentIndex == index {
                pointView.backgroundColor = ColorThemeRed;
            } else {
                pointView.backgroundColor = ColorGray;
            }
        }
    }
    
    @objc func sendMessage() {
        delegate?.emotionSelectorOnSend(self)
    }
    
    func addTextViewObserver(textView:UITextView) {
        textView.addObserver(self, forKeyPath: "attributedText", options: .new, context: nil)
    }
    
    func removeTextViewObserver(textView:UITextView) {
        textView.removeObserver(self, forKeyPath: "attributedText");
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "attributedText" {
            let attributedString = change![NSKeyValueChangeKey.newKey] as? NSAttributedString
            if (attributedString != nil && (attributedString?.length ?? 0) > 0) {
                send.backgroundColor = ColorThemeRed
                send.isEnabled = true
            } else {
                send.backgroundColor = ColorSmoke
                send.isEnabled = false
            }
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
}

extension EmotionSelector {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return EmotionHelper.emotionPageData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 21
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EMOTION_CELL_ID, for: indexPath) as! EmotionCell
        let array: [String] = EmotionHelper.emotionPageData[indexPath.section]
        if indexPath.section < EmotionHelper.emotionPageData.count - 1 {
            if indexPath.row < array.count {
                cell.emotionKey = array[indexPath.row]
            }
        } else {
            if indexPath.row % 3 != 2 {
                cell.emotionKey = array[indexPath.row - indexPath.row/3]
            }
        }
        if indexPath.row == 20 {
            cell.setDelte()
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 20 {
            delegate?.emotionSelectorOnDelete(self)
        } else {
            let emotionKey = EmotionHelper.emotionPageData[indexPath.section][indexPath.row]
            delegate?.emotionSelector(self, select: emotionKey)
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let translatedPoint = scrollView.panGestureRecognizer.translation(in: scrollView)
        scrollView.panGestureRecognizer.isEnabled = false
        DispatchQueue.main.async { [weak self] in
            if (translatedPoint.x < 0 && (self?.currentIndex)! < (EmotionHelper.emotionPageData.count ?? 0) - 1) {
                self?.currentIndex += 1
            }
            if (translatedPoint.x > 0 && (self?.currentIndex)! > 0) {
                self?.currentIndex -= 1
            }
            UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseOut, animations: {
                self?.updatePoints()
                self?.collectionView?.scrollToItem(at: IndexPath.init(row: 0, section: self?.currentIndex ?? 0), at: .left, animated: false)
            }, completion: { finished in
                scrollView.panGestureRecognizer.isEnabled = true
            })
        }
    }
}

class EmotionCell: UICollectionViewCell {
    
    var emotion = UIImageView()
    
    var emotionKey: String? {
        didSet {
            guard let key = emotionKey else { return }
            let emoticonsPath:String = Bundle.main.path(forResource: "Emoticons", ofType: "bundle") ?? ""
            let emotionPath = emoticonsPath + "/" + key
            emotion.image = UIImage.init(contentsOfFile: emotionPath)
        }
    }
    
    var _isHighlighted: Bool = false
    override var isHighlighted: Bool {
        set {
            _isHighlighted = newValue
        }
        get {
            return false
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        emotion.frame = self.bounds
        emotion.contentMode = .center
        self.contentView.addSubview(emotion)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    func setDelte() {
        emotion.image = UIImage.init(named: "iconLaststep")
    }
}

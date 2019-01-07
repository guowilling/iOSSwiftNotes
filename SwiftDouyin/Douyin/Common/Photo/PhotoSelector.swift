
import Foundation
import Photos

let PHOTO_SELECTOR_HEIGHT: CGFloat = 220 + SafeAreaBottomHeight
let PHOTO_SELECTOR_ITEM_HEIGHT: CGFloat = 170

protocol PhotoSelectorDelegate: NSObjectProtocol {
    func photoSelector(_ selector: PhotoSelector, sendImages images: [UIImage])
}

class PhotoSelector: UIView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    let PHOTO_CELL_ID: String = "PhotoCell"
    
    let ALBUM_BTN_TAG: Int = 1000
    let ORIGINAL_PHOTO_BTN_TAG: Int = 2000
    let SEND_BTN_TAG: Int = 3000
    
    var container = UIView.init()
    var collectionView: UICollectionView?
    var bottomView = UIView.init()
    var albumBtn = UIButton.init()
    var originalPhotoBtn = UIButton.init()
    var sendBtn = UIButton.init()
    
    var delegate: PhotoSelectorDelegate?
    
    var photoAssets = [PHAsset]()
    var selectedPhotoAssets = [PHAsset]()
    
    init() {
        super.init(frame: CGRect(origin: .zero, size: CGSize(width: ScreenWidth, height: PHOTO_SELECTOR_HEIGHT)))
        
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
        
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        let result = PHAsset.fetchAssets(with: .image, options: fetchOptions)
        result.enumerateObjects { [weak self] (asset, index, stop) in
            self?.photoAssets.append(asset)
            self?.collectionView?.reloadData()
        }
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top:0, left:0, bottom:0, right:0)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 2.5
        collectionView = UICollectionView(frame: CGRect(x: 0, y: 2.5, width: ScreenWidth, height: PHOTO_SELECTOR_ITEM_HEIGHT), collectionViewLayout: layout)
        collectionView?.backgroundColor = ColorClear
        collectionView?.delegate = self
        collectionView?.dataSource = self
        collectionView?.alwaysBounceHorizontal = false
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.register(PhotoCell.classForCoder(), forCellWithReuseIdentifier: PHOTO_CELL_ID)
        self.addSubview(collectionView!)
        
        bottomView.frame = CGRect(x: 0, y: (collectionView?.frame.maxY)! + 2.5, width: ScreenWidth, height: 45 + SafeAreaBottomHeight)
        bottomView.backgroundColor = ColorWhite
        self.addSubview(bottomView)
        
        albumBtn = UIButton(frame: CGRect(x: 15, y: 10, width: 40, height: 25))
        albumBtn.tag = ALBUM_BTN_TAG
        albumBtn.setTitle("相册", for: .normal)
        albumBtn.setTitleColor(ColorThemeRed, for: .normal)
        albumBtn.titleLabel?.font = BigFont
        albumBtn.addTarget(self, action: #selector(onButtonAction(sender:)), for: .touchUpInside)
        bottomView.addSubview(albumBtn)
        
        originalPhotoBtn = UIButton(frame: CGRect(x: albumBtn.frame.maxX + 10, y: 10, width: 60, height: 25))
        originalPhotoBtn.tag = ORIGINAL_PHOTO_BTN_TAG
        originalPhotoBtn.titleLabel?.font = BigFont
        originalPhotoBtn.setTitle("原图", for: .normal)
        originalPhotoBtn.setTitleColor(ColorThemeRed, for: .normal)
        originalPhotoBtn.setImage(UIImage(named: "radio_button_unchecked_white"), for: .normal)
        originalPhotoBtn.setImage(UIImage(named: "radio_button_checked_red"), for: .selected)
        originalPhotoBtn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 2, bottom: 0, right: 0)
        originalPhotoBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: -2, bottom: 0, right: 0)
        originalPhotoBtn.addTarget(self, action: #selector(onButtonAction(sender:)), for: .touchUpInside)
        bottomView.addSubview(originalPhotoBtn)
        
        sendBtn = UIButton(frame: CGRect(x: ScreenWidth - 60 - 15, y: 10, width: 60, height: 25))
        sendBtn.backgroundColor = ColorSmoke
        sendBtn.tag = SEND_BTN_TAG
        sendBtn.titleLabel?.font = MediumFont
        sendBtn.setTitle("发送", for: .normal)
        sendBtn.setTitleColor(ColorWhite, for: .normal)
        sendBtn.layer.cornerRadius = 2
        sendBtn.addTarget(self, action: #selector(onButtonAction(sender:)), for: .touchUpInside)
        sendBtn.isEnabled = false
        bottomView.addSubview(sendBtn)
    }
    
    @objc func onButtonAction(sender: UIButton) {
        switch (sender.tag) {
        case ALBUM_BTN_TAG:
            break
        case ORIGINAL_PHOTO_BTN_TAG:
            originalPhotoBtn.isSelected = !originalPhotoBtn.isSelected
            break
        case SEND_BTN_TAG:
            if selectedPhotoAssets.count > 9 {
                UIWindow.showTips(text: "最多选择9张图片")
                return
            }
            if let delegate = delegate {
                let requestOptions = PHImageRequestOptions.init()
                requestOptions.isNetworkAccessAllowed = true
                requestOptions.isSynchronous = true
                var images = [UIImage]()
                for asset in selectedPhotoAssets {
                    let imageHeight: CGFloat = originalPhotoBtn.isSelected ? CGFloat(asset.pixelHeight) : CGFloat(asset.pixelHeight > 1000 ? 1000 : asset.pixelHeight)
                    PHImageManager.default().requestImage(for: asset,
                                                          targetSize: CGSize(width: imageHeight * (CGFloat(asset.pixelWidth) / CGFloat(asset.pixelHeight)),
                                                                             height: imageHeight),
                                                          contentMode: PHImageContentMode.aspectFit,
                                                          options: requestOptions,
                                                          resultHandler: { (result, info) in
                        if let img = result {
                            images.append(img)
                        }
                        if images.count == self.selectedPhotoAssets.count {
                            delegate.photoSelector(self, sendImages: images)
                            self.selectedPhotoAssets.removeAll()
                            self.collectionView?.reloadData()
                        }
                    })
                }
            }
        default:
            break
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoAssets.count > 50 ? 50 : photoAssets.count;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PHOTO_CELL_ID, for: indexPath) as! PhotoCell
        let asset = photoAssets[indexPath.row];
        cell.setAsset(asset: asset, selected: selectedPhotoAssets.contains(asset))
        cell.onSelect = { [weak self] isSelected in
            guard let self = self else { return }
            if isSelected {
                self.selectedPhotoAssets.append(asset)
            } else {
                if let index = self.selectedPhotoAssets.index(of: asset) {
                    self.selectedPhotoAssets.remove(at: index)
                }
            }
            if self.selectedPhotoAssets.count > 0 {
                self.sendBtn.isEnabled = true
                self.sendBtn.backgroundColor = ColorThemeRed
            } else {
                self.sendBtn.isEnabled = false
                self.sendBtn.backgroundColor = ColorSmoke
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let asset = photoAssets[indexPath.row];
        return CGSize(width: PHOTO_SELECTOR_ITEM_HEIGHT * (CGFloat(asset.pixelWidth) / CGFloat(asset.pixelHeight)), height: PHOTO_SELECTOR_ITEM_HEIGHT)
    }
}

class PhotoCell: UICollectionViewCell {
    
    var photo = UIImageView.init()
    var checkboxBtn = UIButton.init()
    var coverLayer = CALayer.init()
    
    var onSelect: ((_ isSelected: Bool) -> Void)?
    
    var _isHighlighted: Bool = false
    override var isHighlighted: Bool {
        get {
            return false
        }
        set {
            _isHighlighted = newValue
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        photo.contentMode = .scaleAspectFill;
        self.contentView.addSubview(photo)
        
        coverLayer.backgroundColor = ColorBlackAlpha60.cgColor
        coverLayer.isHidden = true
        photo.layer.addSublayer(coverLayer)
        
        checkboxBtn.setImage(UIImage.init(named: "radio_button_unchecked_white"), for: .normal)
        checkboxBtn.setImage(UIImage.init(named: "check_circle_white"), for: .selected)
        checkboxBtn.addTarget(self, action: #selector(onCheckboxBtnAction), for: .touchUpInside)
        self.contentView.addSubview(checkboxBtn)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        photo.image = nil
        photo.transform = CGAffineTransform.identity
        coverLayer.isHidden = true
        checkboxBtn.isSelected = false
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        photo.frame = self.bounds
        photo.transform = checkboxBtn.isSelected ? CGAffineTransform.init(scaleX: 1.1, y: 1.1) : CGAffineTransform.identity
        
        checkboxBtn.frame = CGRect.init(x:self.bounds.size.width - 30, y:0, width:30, height:30)
        
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        coverLayer.frame = photo.bounds
        CATransaction.commit()
    }
    
    @objc func onCheckboxBtnAction() {
        checkboxBtn.isSelected = !checkboxBtn.isSelected
        coverLayer.isHidden = !checkboxBtn.isSelected;
        UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveEaseInOut, animations: {
            self.photo.transform = self.checkboxBtn.isSelected ? CGAffineTransform.init(scaleX: 1.1, y: 1.1) : CGAffineTransform.identity
        })
        onSelect?(checkboxBtn.isSelected)
    }
    
    func setAsset(asset: PHAsset, selected: Bool) {
        if self.tag != 0 {
            PHImageManager.default().cancelImageRequest(PHImageRequestID(self.tag))
        }
        PHImageManager.default().requestImage(for: asset,
                                              targetSize: CGSize(width: PHOTO_SELECTOR_ITEM_HEIGHT * (CGFloat(asset.pixelWidth)/CGFloat(asset.pixelHeight)),
                                                                 height: PHOTO_SELECTOR_ITEM_HEIGHT),
                                              contentMode: PHImageContentMode.aspectFit,
                                              options: nil,
                                              resultHandler: { (result, info) in
            self.photo.image = result
        })
        checkboxBtn.isSelected = selected
        coverLayer.isHidden = !checkboxBtn.isSelected
    }
}

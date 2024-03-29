

import UIKit

internal final class TextCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Internal Properties
    
    internal var colorView: UIView!
    
    internal var label: UILabel!
    
    internal var iconImage: UIButton!
    
    // MARK: - Object Lifecycle
    
    internal override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        self.colorView = UIView()
        self.label = UILabel()
        self.iconImage = UIButton()
        self.iconImage  = UIButton(type: .custom)
        let image = UIImage(named: "light-bulb")?.withRenderingMode(.alwaysTemplate)
        self.iconImage.setImage(image, for: .normal)
        self.iconImage.tintColor = UIColor.gray
     
        self.contentView.addSubview(self.colorView)
        self.contentView.addSubview(self.label)
        self.contentView.addSubview(self.iconImage)
    }
    
    internal required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Layout
    
    internal override func layoutSubviews() {
        
        super.layoutSubviews()
        
        self.colorView.frame = CGRect(origin: CGPoint.zero, size: self.contentView.bounds.size)
        self.label.frame = CGRect(origin: CGPoint.init(x: 10, y: 35), size: CGSize.init(width: self.contentView.bounds.size.width-5, height: self.contentView.bounds.size.height-35) )
        self.iconImage.frame = CGRect(origin: CGPoint.init(x: 10, y: 10), size: CGSize.init(width: 20, height: 35))
    }
    
    internal override class var requiresConstraintBasedLayout: Bool {
        
        return false
    }
}

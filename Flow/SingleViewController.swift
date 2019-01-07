//
//  SingleViewController.swift
//  Flow
//
//  Created by adb on 1/7/19.
//  Copyright © 2019 Arena. All rights reserved.
//

import UIKit
import RSKCollectionViewRetractableFirstItemLayout

class SingleViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    var groupId:Int!
    var groupName:String!
    @IBOutlet fileprivate weak var connectionStatus: UILabel!
    @IBOutlet fileprivate weak var groupNameLabel: UILabel!
    @IBOutlet fileprivate weak var collectionView: UICollectionView!
    
    var accessoryList:[Accessory] = [Accessory]()
    
    fileprivate var readyForPresentation = false
    
    internal override func viewDidLoad() {
        
        super.viewDidLoad()
        SetGradientBackground()
        groupNameLabel.text = groupName == "اتاق" ? "Room" : "Hall"
            
        
        self.collectionView.register(TextCollectionViewCell.self, forCellWithReuseIdentifier: "TextCollectionViewCell.identifier")
        self.collectionView.backgroundColor = UIColor.clear
        self.collectionView.backgroundView?.backgroundColor = UIColor.clear
        if let collectionViewLayout = self.collectionView.collectionViewLayout as? RSKCollectionViewRetractableFirstItemLayout {
            
            collectionViewLayout.firstItemRetractableAreaInset = UIEdgeInsets(top: 8.0, left: 0.0, bottom: 8.0, right: 0.0)
        }
    }
    
    internal override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        let manager = DataManager()
        
        manager.GetAccessories(groupId: groupId, completion: {(APIResponse)-> Void in
            
            
            if (APIResponse.count > 0)
            {
                self.connectionStatus.text = "Connected"
                self.accessoryList = APIResponse
                self.collectionView.reloadData()
            }
            else
            {
                
            }
            
        })
    }
    // MARK: - Layout
    
    internal override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()
        
        guard self.readyForPresentation == false else {
            
            return
        }
        
        self.readyForPresentation = true
        
        //        let searchItemIndexPath = IndexPath(item: 0, section: 0)
        self.collectionView.contentOffset = CGPoint(x: 0.0, y:0)// self.collectionView(self.collectionView, layout: self.collectionView.collectionViewLayout, sizeForItemAt: searchItemIndexPath).height)
    }
    
    internal func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch indexPath.section {
            
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TextCollectionViewCell.identifier", for: indexPath) as! TextCollectionViewCell
            
            let accessory:Accessory = self.accessoryList[indexPath.item]
            
            cell.colorView.layer.cornerRadius = 15.0
            cell.colorView.layer.masksToBounds = true
            cell.colorView.backgroundColor = UIColor.init(white: 1, alpha: 0.7)
            
            cell.label.textColor = UIColor.darkGray
            cell.label.font = UIFont.systemFont(ofSize: 13, weight: .bold)
            cell.label.numberOfLines = 0
            cell.label.textAlignment = .left
            cell.label.text = accessory.Name
            let image = UIImage(named: "light-bulb")?.withRenderingMode(.alwaysTemplate)
            cell.iconImage.setImage(image, for: .normal)
            cell.iconImage.tintColor = UIColor.gray
            if accessory.State == true
            {
                cell.label.textColor = UIColor.black
                cell.colorView.backgroundColor = UIColor.init(white: 1, alpha: 0.9)
                cell.iconImage.setImage(UIImage.init(named: "light-bulb"), for: .normal)
            }
            
            return cell
            
        default:
            assert(false)
        }
    }
    
    internal func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch section {
            
        case 0:
            return self.accessoryList.count
            
        default:
            assert(false)
        }
    }
    
    internal func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    internal func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        switch section {
            
        case 0:
            return UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
            
        default:
            assert(false)
        }
    }
    
    internal func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 10.0
    }
    
    internal func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 10.0
    }
    
    internal func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        switch indexPath.section {
            
        case 0:
            let numberOfItemsInLine: CGFloat = 3
            
            let inset = self.collectionView(collectionView, layout: collectionViewLayout, insetForSectionAt: indexPath.section)
            let minimumInteritemSpacing = self.collectionView(collectionView, layout: collectionViewLayout, minimumInteritemSpacingForSectionAt: indexPath.section)
            
            let itemWidth = (collectionView.frame.width - inset.left - inset.right - minimumInteritemSpacing * (numberOfItemsInLine - 1)) / numberOfItemsInLine
            let itemHeight = itemWidth
            
            return CGSize(width: itemWidth, height: itemHeight)
            
        default:
            assert(false)
        }
    }
    
    internal func collectionView(_ collectionView: UICollectionView,
                                 shouldSelectItemAt indexPath: IndexPath) -> Bool {
        
        let accessory:Accessory = self.accessoryList[indexPath.item]
        if accessory.State == false
        {
            let cell = collectionView.cellForItem(at: indexPath) as! TextCollectionViewCell
            
            
            UIView.animate(withDuration: 0.4,
                           delay: 0.1,
                           options: UIView.AnimationOptions.curveEaseIn,
                           animations: { () -> Void in
                            cell.label.textColor = UIColor.black
                            cell.colorView.backgroundColor = UIColor.init(white: 1, alpha: 0.9)
                            
            }, completion: { (finished) -> Void in
                cell.iconImage.setImage(UIImage.init(named: "light-bulb"), for: .normal)
            })
            
            
            accessory.State = true
            SendCommand(id: accessory.Id!, command: "True")
        }
        else
        {
            let cell = collectionView.cellForItem(at: indexPath) as! TextCollectionViewCell
            
            UIView.animate(withDuration: 0.4,
                           delay: 0.1,
                           options: UIView.AnimationOptions.curveEaseIn,
                           animations: { () -> Void in
                            cell.label.textColor = UIColor.darkGray
                            cell.colorView.backgroundColor = UIColor.init(white: 1, alpha: 0.7)
                            
            }, completion: { (finished) -> Void in
                let image = UIImage(named: "light-bulb")?.withRenderingMode(.alwaysTemplate)
                cell.iconImage.setImage(image, for: .normal)
                cell.iconImage.tintColor = UIColor.gray
            })
            
            
            accessory.State = false
            SendCommand(id: accessory.Id!, command: "False")
        }
        return false
    }
    
    internal func collectionView(_ collectionView: UICollectionView,
                                 didDeselectItemAt indexPath: IndexPath) {
        
        //        guard sharing else {
        //            return
        //        }
        //
        //        let photo = photoForIndexPath(indexPath)
        //
        //        if let index = selectedPhotos.indexOf(photo) {
        //            selectedPhotos.removeAtIndex(index)
        //            updateSharedPhotoCount()
        //        }
    }
    
    internal func SendCommand(id:Int,command:String)
    {
        let manager = DataManager()
        
        manager.SendCommand(Id:id,Command:command, completion: {(APIResponse)-> Void in
            
        })
        
    }

    @IBAction func BackAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func SetGradientBackground() {
        let colorTop =  UIColor(red: 56.0/255.0, green: 53.0/255.0, blue: 140.0/255.0, alpha: 1.0).cgColor
        let colorBottom = UIColor(red: 46.0/255.0, green: 43.0/255.0, blue: 100/255.0, alpha: 1.0).cgColor
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop, colorBottom]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = self.view.bounds
        
        self.view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
}

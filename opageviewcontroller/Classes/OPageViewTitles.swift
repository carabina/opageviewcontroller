//
//  OPageViewTitles.swift
//  PageViewControllerProject
//
//  Created by Abhishek Singh on 27/06/17.
//  Copyright © 2017 Abhishek Singh. All rights reserved.
//

import UIKit

protocol OPageViewTitlesDelegate {
    func didSelectTitleAtIndexPath(_ indexPath:IndexPath, orderAscending:Bool)
}

class OPageViewTitles: UICollectionView {
    
    fileprivate static let kTitleCellIdentifier:String = "OPageTitleCell"
    fileprivate var selectedIndex:Int = 0
    
    public var pages:[OPage] = [OPage](){
        didSet{
            self.reloadData()
        }
    }
    public var customDelegate:OPageViewTitlesDelegate?
    public let uiConfig:OPageViewTitleUI = OPageViewTitleUI()
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    private func setupView(){
        registerCells()
        
        self.delegate = self
        self.dataSource = self
        self.isScrollEnabled = false
    }
    
    private func registerCells(){
        self.register(UINib.init(nibName: "OPageTitleCell", bundle: Bundle(for: self.classForCoder)), forCellWithReuseIdentifier: OPageViewTitles.kTitleCellIdentifier)
    }
    
    fileprivate func getItemSizeFromNumber(of items:Int) -> CGSize{
        let itemSize:CGSize = CGSize(width:self.bounds.width / CGFloat(items), height:self.bounds.height)
        return itemSize
    }
    
    public func selectIndex(at index:Int){
        self.collectionView(self, didSelectItemAt: IndexPath(item: index, section: 0))
    }
}

extension OPageViewTitles: UICollectionViewDataSource{
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return pages.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let cell:OPageTitleCell = collectionView.dequeueReusableCell(withReuseIdentifier: OPageViewTitles.kTitleCellIdentifier, for: indexPath) as! OPageTitleCell
        
        let page:OPage = pages[indexPath.item]
        let _isSelected:Bool = (indexPath.item == selectedIndex)
        let _hideBottomSeparator:Bool = _isSelected
        let _hideRightSeparator:Bool = true
        let _hideLeftSeparator:Bool = (indexPath.item == 0)
        let _titleColor:UIColor = _isSelected ? self.uiConfig.highlightedTitleColor :self.uiConfig.titleColor
        let _titleFont:UIFont = _isSelected ? self.uiConfig.highlightedFont :self.uiConfig.font
        let _indicatorColor:UIColor = _isSelected ? self.uiConfig.highlightedColor :self.uiConfig.separatorColor
        
        cell.configureWithData(
            OPageViewTitlesData(
            hideBottomSeparator: _hideBottomSeparator,
            hideRightSeparator: _hideRightSeparator,
            hideLeftSeparator: _hideLeftSeparator,
            isSelected:_isSelected,
            titleColor:_titleColor,
            titleFont:_titleFont,
            indicatorColor: _indicatorColor,
            title:page.title,
            model : page)
        )
        return cell
    }
}

extension OPageViewTitles: UICollectionViewDelegate{
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        if indexPath.item != selectedIndex {
            let prevSelectedIndex:Int = selectedIndex
            selectedIndex = indexPath.item
            self.reloadItems(at: [IndexPath.init(item: prevSelectedIndex, section: 0), IndexPath.init(item: selectedIndex, section: 0)])
            guard let _ = customDelegate?.didSelectTitleAtIndexPath(indexPath, orderAscending:selectedIndex > prevSelectedIndex) else{return}
            customDelegate!.didSelectTitleAtIndexPath(indexPath, orderAscending:selectedIndex > prevSelectedIndex)
        }
    }
}

extension OPageViewTitles: UICollectionViewDelegateFlowLayout{
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        return self.getItemSizeFromNumber(of: pages.count)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets{
        return UIEdgeInsetsMake(0, 0, 0, 0)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat{
        return 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat{
        return 0
    }
}

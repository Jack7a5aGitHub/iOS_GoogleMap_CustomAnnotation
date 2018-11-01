//
//  CustoMarkerView.swift
//  GoogleMapCustomAnnotation
//
//  Created by Jack Wong on 2018/04/28.
//  Copyright © 2018 Jack. All rights reserved.
//

import UIKit
import Foundation

final class CustoMarkerView: UIView {
    
    var cusineImg: UIImage?
    var boarderColor: UIColor?
    
    init(frame: CGRect, image:UIImage, boarderColor: UIColor, tag: Int) {
        super.init(frame: frame)
        self.cusineImg = image
        self.boarderColor = boarderColor
        // to recognize which photo clicked
        self.tag = tag
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        let imgView = UIImageView(image: cusineImg)
        imgView.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        imgView.layer.cornerRadius = 25
        imgView.layer.borderColor = boarderColor?.cgColor
        imgView.layer.borderWidth = 4
        imgView.clipsToBounds = true
        let label = UILabel(frame: CGRect(x: 0, y: 45, width: 50, height: 10))
        label.text = "*"
        label.font = UIFont.systemFont(ofSize: 24)
        label.textColor = boarderColor
        label.textAlignment = .center
        self.addSubview(imgView)
        self.addSubview(label)
    }

}

//
//  RestaurantPreview.swift
//  GoogleMapCustomAnnotation
//
//  Created by Jack Wong on 2018/04/28.
//  Copyright © 2018 Jack. All rights reserved.
//

import Foundation
import UIKit

final class RestaurantPreviewView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        self.clipsToBounds = true
        self.layer.masksToBounds = true
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setupViews(){
        addSubview(containerView)
        containerView.addSubview(labelTitle)
        addSubview(imgView)
        
    }
   func setData(title:String, img: UIImage){
        labelTitle.text = title
        imgView.image = img
    }
    let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let imgView: UIImageView = {
        let imgView = UIImageView()
        imgView.backgroundColor = .blue
        imgView.translatesAutoresizingMaskIntoConstraints = false
        return imgView
    }()
    let labelTitle: UILabel = {
        let label = UILabel()
        label.text = "Name Test"
        label.font = UIFont.boldSystemFont(ofSize: 28)
        label.textColor = .black
        label.backgroundColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
}

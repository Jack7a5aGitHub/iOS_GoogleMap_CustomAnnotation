//
//  DetailsVC.swift
//  GoogleMapCustomAnnotation
//
//  Created by Jack Wong on 2018/04/29.
//  Copyright © 2018 Jack. All rights reserved.
//

import UIKit

final class DetailsVC: UIViewController {
    
    var passedData = (title: "Name", img: #imageLiteral(resourceName: "image1") )
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        setupViews()
    }
    private func setupViews(){
//        self.view.addSubview(containerView)
//        
//        let containerView: UIView = {
//           let containerView = UIView()
//            containerView.translatesAutoresizingMaskIntoConstraints = false 
//            containerView.backgroundColor = .red
//            return containerView
//        }()
    }
}

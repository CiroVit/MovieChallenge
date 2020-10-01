//
//  ShowDetailsViewController.swift
//  Ciroflix
//
//  Created by Ciro Vitale on 30/09/2020.
//  Copyright © 2020 Ciro Vitale. All rights reserved.
//

import UIKit

class ShowDetailsViewController: UIViewController {
    
    lazy var ContentViewSize = CGSize(width: self.view.frame.width, height: self.view.frame.height + 400)
    
    lazy var scrollView : UIView = {
        let view = UIScrollView(frame: .zero)
        view.backgroundColor = UIColorFromRGB(rgbValue: 0xa6f6f1)
        view.contentSize = ContentViewSize
        view.frame = self.view.bounds
        view.autoresizingMask = .flexibleHeight
        view.showsHorizontalScrollIndicator = false
        view.bounces = true
        return view
    }()
    
    lazy var containerView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColorFromRGB(rgbValue: 0xa6f6f1)
        view.frame.size = ContentViewSize
        return view
    }()
    
    lazy var RateView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColorFromRGB(rgbValue: 0xa6f6f1)
        view.frame.size = CGSize(width: 30, height: 30)
        return view
    }()
    
    var DetailsPoster = UIImageView()
    var DetailsTitle = UILabel()
    var DetailsYear = UILabel()
    var DetailsDescription = UILabel()
    var DetailsRate = UILabel()
    var RateAsDouble : Double = 0.0
    let backLayer = CAShapeLayer()
    let shapeLayer = CAShapeLayer()
    let textLayer = CATextLayer()
    var yearAsString : String = ""
    
    func PickDoubleFromLabel() {
        guard let DoubleRate = DetailsRate.text else {return}
        RateAsDouble = Double(DoubleRate)!
        guard let stringYear = DetailsYear.text else {return}
        yearAsString = String(stringYear)
            
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        PickDoubleFromLabel()
//        MARK - RATE ANIMATION
//        createRateCircle()
        visual()
        
    }
    
    func visual() {
        view.addSubview(scrollView)
        scrollView.addSubview(containerView)
        containerView.addSubview(RateView)
        containerView.addSubview(DetailsTitle)
        containerView.addSubview(DetailsRate)
        containerView.addSubview(DetailsDescription)
        containerView.addSubview(DetailsPoster)
        containerView.addSubview(DetailsYear)
        DetailsYear.textColor = UIColorFromRGB(rgbValue: 0x213e3b)
        DetailsYear.textAlignment = .center
        DetailsTitle.font = UIFont.boldSystemFont(ofSize: 24)
        DetailsYear.anchor(top: DetailsRate.bottomAnchor, leading: containerView.leadingAnchor, trailing: containerView.trailingAnchor, bottom: nil,padding: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
        DetailsYear.text = "year: \(yearAsString)"
        DetailsRate.textColor = UIColorFromRGB(rgbValue: 0x213e3b)
        DetailsRate.textAlignment = .center
        DetailsDescription.contentMode = .scaleAspectFit
        DetailsRate.anchor(top: DetailsDescription.bottomAnchor, leading: containerView.leadingAnchor, trailing: containerView.trailingAnchor, bottom: nil,padding: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
        DetailsRate.text = "Rate: \(RateAsDouble)/10"
        DetailsTitle.textColor = UIColorFromRGB(rgbValue: 0x213e3b)
        DetailsTitle.textAlignment = NSTextAlignment.center
        DetailsTitle.anchor(top: containerView.topAnchor, leading: containerView.leadingAnchor, trailing: containerView.trailingAnchor, bottom: nil, padding: UIEdgeInsets(top: 50, left: 40, bottom: 0, right: 40))
        
        
        DetailsPoster.layer.cornerRadius = 10
        DetailsPoster.clipsToBounds = true
        DetailsPoster.contentMode = .scaleAspectFit
        DetailsPoster.anchor(top: DetailsTitle.bottomAnchor, leading: containerView.leadingAnchor, trailing: containerView.trailingAnchor, bottom: nil,padding: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
        
        
        DetailsDescription.textColor = UIColorFromRGB(rgbValue: 0x213e3b)
        DetailsTitle.textAlignment = NSTextAlignment.center
//        DetailsTitle.contentMode = .scaleToFill
        DetailsDescription.numberOfLines = 0
        DetailsDescription.anchor(top: DetailsPoster.bottomAnchor, leading: containerView.leadingAnchor, trailing: containerView.trailingAnchor, bottom: nil,padding: UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10))
        
//       RateView.anchor(top: DetailsRate.bottomAnchor, leading: containerView.leadingAnchor, trailing: containerView.trailingAnchor, bottom: nil)
    }
    
    func createRateCircle() {
        let width = 30
        let height = 30
        
        let fontsize = min(width, height)/4
        let offset = Double(min(width, height)) * 0.1
        
        textLayer.string = RateAsDouble
        textLayer.foregroundColor = UIColor.white.cgColor
        textLayer.fontSize = CGFloat(fontsize)
        textLayer.frame = CGRect(x: 0, y: (height - fontsize - Int(offset)) / 2, width : width, height: fontsize + Int(offset))
        textLayer.alignmentMode = .center
        
        self.perform(#selector(animateProgress),with: nil, afterDelay: 1.5)
        
        let center = self.view.center
        let circlePath = UIBezierPath(arcCenter: center, radius: 100, startAngle: -CGFloat.pi / 2 , endAngle: 2 * CGFloat.pi, clockwise: true)
        backLayer.path = circlePath.cgPath
        
        backLayer.fillColor = UIColor.clear.cgColor
        backLayer.strokeColor = UIColor.lightGray.cgColor
        backLayer.strokeEnd = 1
        backLayer.lineWidth = 8
        backLayer.lineCap = CAShapeLayerLineCap.round
       
        shapeLayer.path = circlePath.cgPath
        
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = UIColor.red.cgColor
        
        shapeLayer.lineWidth = 8
        shapeLayer.lineCap = CAShapeLayerLineCap.round
        shapeLayer.strokeEnd = 0
        
        
        RateView.layer.addSublayer(backLayer)
        RateView.layer.addSublayer(shapeLayer)
        RateView.layer.addSublayer(textLayer)
    }
    
    @objc func animateProgress() {
        setProgress(duration: 1, value: RateAsDouble / 10 )
    }
    
    func setProgress(duration: TimeInterval, value: Double) {
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
            basicAnimation.fromValue = 0
        basicAnimation.toValue = value
        basicAnimation.duration = duration
            basicAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        basicAnimation.fillMode = CAMediaTimingFillMode.forwards
            shapeLayer.strokeEnd = CGFloat(value)
        shapeLayer.add(basicAnimation, forKey: "clockAnimation")
    }
    
   
    func createTextLayer(rect: CGRect, textColor: CGColor) -> CATextLayer {
        let width = rect.width
        let height = rect.height
        
        let fontsize = min(width, height)/4
        let offset = min(width, height) * 0.1
        
        let layer = CATextLayer()
        layer.string = DetailsRate.text
        layer.foregroundColor = textColor
        layer.fontSize = fontsize
        layer.frame = CGRect(x: 0, y: (height - fontsize - offset) / 2, width : width, height: fontsize + offset)
        layer.alignmentMode = .center
        return layer
    }
    
}

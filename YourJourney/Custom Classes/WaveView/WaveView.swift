//
//  VaweView.swift
//  YourJourney
//
//  Created by Apple on 18.05.2018.
//  Copyright © 2018 md. All rights reserved.
//

import Foundation

class WaveView: UIView {
    var offsetX: CGFloat!
    var waveDisplayLink: CADisplayLink!
    var waveShapeLayer: CAShapeLayer!
    
    var angularSpeed: CGFloat!
    var waveSpeed: CGFloat!
    var waveTime: TimeInterval!
    var waveColor: UIColor!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        angularSpeed = 4.0
        waveSpeed = 9.0
        waveTime = 1.5
        waveColor = UIColor.white
        offsetX = 150
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func currentWave() {
        self.offsetX = self.offsetX - (self.waveSpeed * self.superview!.frame.size.width / 320.0)
        
        let width = self.frame.width
        let height = self.frame.height
        
        let path: CGMutablePath = CGMutablePath()
        path.move(to: CGPoint(x: 0, y: height / 2))
        
        var y: CGFloat = 0.0
        
        for x in stride(from: 0.0, to: width, by: 1) {
            y = CGFloat(height * sin(0.01 * (self.angularSpeed * x + self.offsetX)))
            path.addLine(to: CGPoint(x: x, y: y))
        }
        
        path.addLine(to: CGPoint(x: width, y: height))
        path.addLine(to: CGPoint(x: 0, y: height))
        
        waveShapeLayer.path = path
        path.closeSubpath()
    }
    
    
    func wave() {
        if (self.waveShapeLayer != nil) {
            return
        }
        
        self.waveShapeLayer = CAShapeLayer(layer: layer)
        self.waveShapeLayer.fillColor = self.waveColor.cgColor
        
        self.layer.addSublayer(waveShapeLayer)
        
        self.waveDisplayLink = CADisplayLink(target: self, selector: #selector(currentWave))
        self.waveDisplayLink.add(to: RunLoop.main, forMode: .commonModes)
    }
    
    func stop() {
        self.waveDisplayLink.invalidate()
        self.waveDisplayLink = nil
        self.waveShapeLayer = nil
    }
}

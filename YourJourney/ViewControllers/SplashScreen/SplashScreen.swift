//
//  SplashScreen.swift
//  YourJourney
//
//  Created by Apple on 16.05.2018.
//  Copyright © 2018 md. All rights reserved.
//

import UIKit
import SwiftyJSON

class SplashScreen: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    var waveView1: WaveView!
    var waveView2: WaveView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if DataManager.getValue(key: "refresh_token") == nil {
            loadMapModule()
            return
        }
        
        animateSailboat()
        
        initWaves()
        
        _ = APIService.shared().updateToken(completionHandler: {(responce: (code: Int?, body: JSON?)?, error) in
            
            if error != nil {
                
                DataManager.removeValue(key: "token")
                DataManager.removeValue(key: "refresh_token")
                
                self.loadMapModule()
                
                return
            }
            
            if responce!.code == 0 {
                DataManager.set(
                    value: responce!.body!["access_token"].string!,
                    forKey: "token")
                
                DataManager.set(
                    value: responce!.body!["refresh_token"].string!,
                    forKey: "refresh_token")
                
                self.loadMapModule()
            } else {
                
                DataManager.removeValue(key: "token")
                DataManager.removeValue(key: "refresh_token")
                
                self.loadMapModule()
                
                return
            }
        })
    }
    
    func animateSailboat() {
        let scaledTransform = self.imageView.transform.scaledBy(x: 2.0, y: 2.0)
        let height = self.imageView.frame.height
        let translatedAndScaledTransform = scaledTransform.translatedBy(x: 0, y: -height/4)
        
        UIView.animate(withDuration: 10.0) {
            self.imageView.transform = translatedAndScaledTransform
        }
    }
    
    func initWaves() {
        
        let viewSea = UIView(frame: CGRect(x: 0, y: (view.frame.height / 2) + 45, width: view.frame.width, height: (view.frame.height / 2)))
        viewSea.backgroundColor = ColorHelper.color(for: .waterColor)
        
        waveView1 = WaveView(frame: CGRect(x: 0, y: -3, width: view.frame.width, height: 3))
        waveView2 = WaveView(frame: CGRect(x: -50, y: -3, width: view.frame.width + 100, height: 3))
        
        viewSea.addSubview(waveView1)
        viewSea.addSubview(waveView2)
        
        self.view.addSubview(viewSea)
        
        waveView1.waveColor = UIColor.white
        waveView2.waveColor = ColorHelper.color(for: .waterColor)
        
        waveView1.waveSpeed = 9.0
        waveView2.waveSpeed = 13.0
        
        waveView1.angularSpeed = 9.0
        waveView2.angularSpeed = 8.0
        
        waveView1.wave()
        waveView2.wave()
    }
    
    func deinitWaves() {
        if waveView1 != nil {
            waveView1.stop()
        }
        
        if waveView2 != nil {
            waveView2.stop()
        }
    }
    
    func loadMapModule() {
        deinitWaves()
        
        let storyboard = UIStoryboard(name: "MapAndMenu", bundle: nil)
        let nextVc = storyboard.instantiateInitialViewController()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = nextVc
    }
    
}

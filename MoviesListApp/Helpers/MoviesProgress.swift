//
//  MoviesProgress.swift
//  MoviesListApp
//
//  Created by Ashvin Gudaliya on 10/09/22.
//

import UIKit
import MBProgressHUD

class MoviesProgress: NSObject {
    
    static var shared: MoviesProgress = MoviesProgress()
    
    var hub: MBProgressHUD?
    
    func showProgress(with title: String = "Loading...") {
        
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let sceneDelegate = windowScene.delegate as? SceneDelegate else {
            return
        }
        
        guard let window = sceneDelegate.window else { return }
        
        self.hideProgress()
        
        DispatchQueue.main.async {
            self.hub = MBProgressHUD.showAdded(to: window, animated: true)
            self.hub?.label.text = title
            self.hub?.contentColor = UIColor.black
            self.hub?.bezelView.color = UIColor.black
        }
    }
    
    func hideProgress(){
        if hub != nil {
            DispatchQueue.main.async {
                self.hub?.hide(animated: true)
                self.hub = nil
            }
        }
    }
}

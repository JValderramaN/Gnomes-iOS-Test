//
//  MainViewController.swift
//  Gnomes
//
//  Created by José Valderrama on 3/16/18.
//  Copyright © 2018 José Valderrama. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var startButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animateLogo()
        animateStartButton()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    fileprivate func animateLogo() {
        UIView.animate(
            withDuration: 1.5,
            animations: {
                self.logoImageView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        },
            completion: { finish in
                UIView.animate(
                    withDuration: 1.5,
                    animations: {
                        self.logoImageView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                },
                    completion: { finish in
                        self.animateLogo()
                })
        })
    }
    
    fileprivate func animateStartButton() {
        self.startButton.transform = CGAffineTransform(scaleX: 0, y: 0)
        
        UIView.animate(withDuration: 2, animations: {
            self.startButton.transform = CGAffineTransform(scaleX: 1, y: 1)
        })
    }
}


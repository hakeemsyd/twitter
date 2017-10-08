//
//  MenuViewController.swift
//  twitter
//
//  Created by Syed Hakeem Abbas on 10/6/17.
//  Copyright © 2017 codepath. All rights reserved.
//

import UIKit

class HamburgerViewController: UIViewController {

    @IBOutlet weak var leftMarginConstraint: NSLayoutConstraint!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var menuView: UIView!
    var orignalLeftMargin: CGFloat!
    
    var menuViewController: UIViewController! {
        didSet(oldMenuViewController) {
            view.layoutIfNeeded()
            
            if oldMenuViewController != nil {
                oldMenuViewController.willMove(toParentViewController: nil)
                oldMenuViewController.view.removeFromSuperview()
                oldMenuViewController.didMove(toParentViewController: nil)
            }
            
            menuView.addSubview(menuViewController.view)
            menuViewController.willMove(toParentViewController: self)
            
            contentView.addSubview(contentViewController.view)
            
            menuViewController.didMove(toParentViewController: self)
        }
    }
    
    var contentViewController: UIViewController! {
        didSet(oldContentViewController) {
            view.layoutIfNeeded()
            
            if oldContentViewController != nil {
                oldContentViewController.willMove(toParentViewController: nil)
                oldContentViewController.view.removeFromSuperview()
                oldContentViewController.didMove(toParentViewController: nil)
            }
            
            contentViewController.willMove(toParentViewController: self)
            
            contentView.addSubview(contentViewController.view)
            
            contentViewController.didMove(toParentViewController: self)
            self.closeMenu()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
    }
    
    
    @IBAction func onPan(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)
        let velocity = sender.velocity(in: view)
        
        if sender.state == .began {
            orignalLeftMargin = leftMarginConstraint.constant
        } else if sender.state == .changed {
            print("translation: \(translation.x)")
            if(translation.x > 0) {
                leftMarginConstraint.constant = orignalLeftMargin + translation.x
            }
        } else if sender.state == .ended {
            UIView.animate(withDuration: 0.3, animations: {
                if(velocity.x > 0 ){
                    print("opening")
                    self.leftMarginConstraint.constant = self.view.frame.size.width - self.view.frame.size.width/2
                } else {
                    print("closing")
                    self.leftMarginConstraint.constant = 0
                }
                self.view.layoutIfNeeded()
            })
        }
        
    }
    
    func closeMenu() {
        UIView.animate(withDuration: 0.3) { 
            self.leftMarginConstraint.constant = 0
            self.view.layoutIfNeeded()
        }
    }

    @IBOutlet var onPanGesture: UIPanGestureRecognizer!
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

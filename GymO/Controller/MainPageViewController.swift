//
//  MainPageViewController.swift
//  GymO
//
//  Created by Catherine on 11/22/18.
//  Copyright © 2018 GymO. All rights reserved.
//

import UIKit
import Foundation


//NOT USING THIS ONE FOR NOW JUST PUT HERE IN CASE NEED
class MainPageViewController: UIPageViewController {
    
    
    
    lazy var subViewControllers:[UIViewController] = {
        
        return[
            UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MasterViewController") as! MasterViewController,
            UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "EditViewController") as! EditTableViewController
        ]
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.dataSource = self
        // Do any additional setup after loading the view.
        setViewControllers([subViewControllers[1]], direction: .forward, animated: true, completion: nil)
        NotificationCenter.default.addObserver(self, selector:#selector(MainPageViewController.enableSwipe), name: NSNotification.Name(rawValue: "enableSwipe"), object: nil)
        NotificationCenter.default.addObserver(self, selector:#selector(MainPageViewController.disableSwipe), name: NSNotification.Name(rawValue: "disableSwipe"), object: nil)
        //print(self.pageViewController(self, viewControllerAfter: MatchViewController))
    }
    
}

extension MainPageViewController{
    @objc func enableSwipe(notification: NSNotification){
        self.dataSource = self
        print("allow")
    }
    
    @objc func disableSwipe(notification: NSNotification){
        self.dataSource = nil
        print("deny")
    }
    
    func onClick(button senderTitle: String){
        print("Clicked")
        //(Doesnt work)     setViewControllers([subViewControllers[0]], direction: .reverse, animated: true, completion: nil)
    }
}

extension MainPageViewController:UIPageViewControllerDelegate, UIPageViewControllerDataSource{
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return subViewControllers.count
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController?{
        let currentIndex:Int = subViewControllers.index(of: viewController) ?? 0
        if(currentIndex <= 0){
            return nil
        }
        return subViewControllers[currentIndex-1]
    }
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        print (pageViewController)
        let currentIndex:Int = subViewControllers.index(of: viewController) ?? 0
        if(currentIndex >= subViewControllers.count-1){
            return nil
        }
        return subViewControllers[currentIndex+1]
    }
}


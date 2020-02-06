//
//  eBook.swift
//  Demo
//
//  Created by 黃崇漢 on 2018/7/31.
//  Copyright © 2018年 Tony Huang (黃崇漢). All rights reserved.
//

import UIKit

class eBook: UIViewController, UIPageViewControllerDataSource {
    
    var pageViewController: UIPageViewController?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let story = UIStoryboard.init(name: "Main", bundle: nil)
        if let vc = story.instantiateViewController(withIdentifier: "pqgeViewController") as? UIPageViewController {
            vc.dataSource = self
            vc.view.frame = self.view.frame
            self.addChild(vc)
            self.view.addSubview(vc.view)
            vc.didMove(toParent: self)
            
            guard let contentView = self.viewControllerAtIndex(index: 0) else { return }
            
            vc.setViewControllers([contentView], direction: .forward, animated: true, completion: nil)
        }
    }
    
    func viewControllerAtIndex(index: Int) -> ContentViewController? {
        let story = UIStoryboard.init(name: "Main", bundle: nil)
        let vc = story.instantiateViewController(withIdentifier: "mainContentViewController") as? ContentViewController
        vc?.nowPageNumber = index
        
        return vc
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let vc = viewController as? ContentViewController
        guard let index = vc?.nowPageNumber else { return nil }
        
        if index == 0 || index == NSNotFound {
            return nil
        }
        else {
            return self.viewControllerAtIndex(index: index - 1)
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let vc = viewController as? ContentViewController
        guard let index = vc?.nowPageNumber else { return nil }
        
        if index == 2 || index == NSNotFound {
            return nil
        }
        else {
            return self.viewControllerAtIndex(index: index + 1)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

//
//  ViewController.swift
//  Dr-Soldier
//
//  Created by LDH on 2020/04/21.
//  Copyright © 2020 LDH. All rights reserved.
//

import UIKit

class FitnessViewController: UIViewController {

     @IBOutlet weak var subNavigation: UISegmentedControl!
       let menus = ["Goal", "Fitness", "Body"]

       override func viewDidLoad() {
           super.viewDidLoad()
           // Do any additional setup after loading the view.
           subNavigation.removeAllSegments();
           for menu in menus{
               subNavigation.insertSegment(withTitle: menu, at: menus.count, animated: false)
           }
           subNavigation.selectedSegmentIndex = 1;
           
           self.navigationItem.hidesBackButton = true;
           self.navigationItem.leftBarButtonItem = nil;
           self.navigationItem.titleView = UIImageView(image: UIImage(named: "doctor3.png"))
       }
       
       @IBAction func _changeMenu(_ sender: Any) {
           let nextMenu = menus[subNavigation.selectedSegmentIndex];
           if let nextView = self.storyboard?.instantiateViewController(withIdentifier: nextMenu){
           self.navigationController?.pushViewController(nextView, animated: false)
           }
           
       }


}


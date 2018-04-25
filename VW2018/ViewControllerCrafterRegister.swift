//
//  ViewControllerCrafterRegister.swift
//  VW2018
//
//  Created by Alumno on 24/04/18.
//  Copyright © 2018 Gekko. All rights reserved.
//

import UIKit

class ViewControllerCrafterRegister: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func notifications(_ sender: Any) {
        self.performSegue(withIdentifier: "toNotifications", sender: self)
    }
    
    @IBAction func profile(_ sender: Any) {
        self.performSegue(withIdentifier: "toProfile", sender: self)
    }
    
    @IBAction func seleccionar(_ sender: Any) {
        self.performSegue(withIdentifier: "back", sender: self)
    }
}

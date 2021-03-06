//
//  ViewControllerChangePassword.swift
//  VW2018
//
//  Created by Alumno on 27/04/18.
//  Copyright © 2018 Gekko. All rights reserved.
//

import UIKit

class ViewControllerChangePassword: UIViewController, UITextFieldDelegate {

    var driver = Driver()
    
    @IBOutlet weak var actual: UITextField!
    @IBOutlet weak var new: UITextField!
    @IBOutlet weak var new2: UITextField!
    
    let defaultSession = URLSession(configuration: .default)
    var dataTask: URLSessionDataTask?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        actual.delegate = self
        new.delegate = self
        new2.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.tag == 0{
            actual.resignFirstResponder()
        }
        else if textField.tag == 1{
            new.resignFirstResponder()
        }
        else {
            new2.resignFirstResponder()
        }
        return true
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    //Acción activada por el botón
    @IBAction func changePass(_ sender: Any) {
        //Verificación de campos
        if (actual.text?.isEmpty)! || (new.text?.isEmpty)! || (new2.text?.isEmpty)! {
            //Mesaje de error
            let alert = UIAlertController(title: "Contraseña", message: "Debe llenar todos los campos", preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .default)
            alert.addAction(action)
            self.present(alert, animated: true)
        }
        else{
            //Verificación de validez
            if driver.password == actual.text {
                if new.text == new2.text{
                    
                    driver.password = new2.text!
                    self.putDriver()
                    
                    let alert = UIAlertController(title: "Contraseña", message: "La contraseña se ha cambiado exitosamente", preferredStyle: .alert)
                    let action = UIAlertAction(title: "Ok", style: .default)
                    alert.addAction(action)
                    self.present(alert, animated: true)
                }
                else{
                    let alert = UIAlertController(title: "Contraseña", message: "La contraseña nueva no corresponde a la confirmación", preferredStyle: .alert)
                    let action = UIAlertAction(title: "Ok", style: .default)
                    alert.addAction(action)
                    self.present(alert, animated: true)
                }
                
            }
            else{
                print(driver)
                let alert = UIAlertController(title: "Contraseña", message: "Su contraseña actual es incorrecta", preferredStyle: .alert)
                let action = UIAlertAction(title: "Ok", style: .default)
                alert.addAction(action)
                self.present(alert, animated: true)
            }
        }
    }
    
    //Si sí es correcta, se llega a esta función
    func putDriver(){
        if dataTask != nil {
            dataTask?.cancel()
        }
        let jsonEncoder = JSONEncoder()
        let jsonData = try? jsonEncoder.encode(driver)
        //URL para petición
        let url = NSURL(string: "https://fake-backend-mobile-app.herokuapp.com/drivers/\(driver.id)")
        let request = NSMutableURLRequest(url: url! as URL)
        request.addValue("application/JSON", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "PUT"
        request.httpBody = jsonData
        
        dataTask = defaultSession.dataTask(with: request as URLRequest){
            data, response, error in
            DispatchQueue.main.async{
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
            if let error = error {
                print(error.localizedDescription)
            }
            else{
                //Se actualizó la información correctamente
                if let httpsResponse = response as? HTTPURLResponse {
                    if httpsResponse.statusCode == 200 {
                    }
                }
            }
        }
        dataTask?.resume()
    }
    
}

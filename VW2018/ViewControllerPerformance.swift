//
//  ViewControllerPerformance.swift
//  VW2018
//
//  Created by Alumno on 24/04/18.
//  Copyright © 2018 Gekko. All rights reserved.
//

import UIKit

class ViewControllerPerformance: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var chart: Chart!
    @IBOutlet weak var picker: UIPickerView!
    var lapse = NSMutableArray()
    var category = NSMutableArray()
    let defaultSession = URLSession(configuration: .default)
    var dataTask: URLSessionDataTask?
    var stats = [Statistics]()
    
    
    //Hace el precargado, donde se definen los valores disponibles para el pickerview
    override func viewDidLoad() {
        super.viewDidLoad()
        lapse.add("1 semana")
        lapse.add("1 mes")
        lapse.add("3 meses")
        lapse.add("1 año")
        category.add("Frenados en seco")
        category.add("Retrasos")
        picker.dataSource = self
        picker.delegate = self
        doQuery()

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

    //Número de componentes en el picker
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    //Número de filas en el picker, que varían de acuerdo al componente
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0{
            return 2
        }
        else if component == 1{
            return 4
        }
        else {
            return 0
        }
    }
    
    //Define los strings para los componentes
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return (category[row] as! String)
        }
        else if component == 1 {
            return (lapse[row] as! String)
        }
        else{
            return ""
        }
    }
    
    //Obtiene las fechas con relación a la fecha actual de acuerdo a la fila escogida en el componente.
    func getDateByLapse() -> String{
        let formater = DateFormatter()
        //Define el formato de la fecha
        formater.dateFormat = "yyyy-MM-dd"
        
        //Lapso de 1 semana
        if picker.selectedRow(inComponent: 1) == 0{
            let pastWeek = Date.init(timeIntervalSinceNow: -604800)
            return formater.string(from: pastWeek)
        }
            //Lapso de un mes
        else if picker.selectedRow(inComponent: 1) == 1{
            let pastMonth = Date.init(timeIntervalSinceNow: -2592000)
            return formater.string(from: pastMonth)
        }
            //Lapso de 3 meses
        else if picker.selectedRow(inComponent: 1) == 2{
            let past3Months = Date.init(timeIntervalSinceNow: -7776000)
            return formater.string(from: past3Months)
        }
            //Lapso de 1 año
        else if picker.selectedRow(inComponent: 1) == 3{
            let pastYear = Date.init(timeIntervalSinceNow: -31536000)
            return formater.string(from: pastYear)
        }
        else {
            return ""
        }
    }
    
    //Define el tipo de información a mostrar de acuerdo al tipo seleccionado
    func getType() -> String{
        if picker.selectedRow(inComponent: 0) == 0 {
            return "brake"
        }
        else if picker.selectedRow(inComponent: 0) == 1 {
            return "delay"
        }
        else{
            return ""
        }
    }
    
    //Realiza la query para obtener el rendimiento correspondiente al tipo y fecha de la información
    func doQuery(){
        let id = UserDefaults.standard.string(forKey: "id")
        let date = getDateByLapse()
        let type = getType();
        let query = "drivers/\(id!)/statistics?_sort=date&type=\(type)&date_gte=\(date)"
        //print(query as Any)
        getStatistics(query: query)
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        doQuery()
    }
    
    //Hace el get con la query y el URL adecuado
    func getStatistics(query: String!){
        if dataTask != nil {
            dataTask?.cancel()
        }
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        let q = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let url = NSURL(string: "https://fake-backend-mobile-app.herokuapp.com/\(q)")
        let request = URLRequest(url: url! as URL)
        
        dataTask = defaultSession.dataTask(with: request){
            data, response, error in
            DispatchQueue.main.async{
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
            if let error = error {
                print(error.localizedDescription)
            }
            else{
                //Si el resultado es correcto, entonces procesa la información
                if let httpsResponse = response as? HTTPURLResponse {
                    if httpsResponse.statusCode == 200 {
                        DispatchQueue.main.async {
                            self.processData(data: data!)
                        }
                    }
                }
            }
        }
        dataTask?.resume()
    }
    
    //Procesa el json como estadística
    func processData(data: Data){
        let jsonDecoder = JSONDecoder()
        stats = try! jsonDecoder.decode([Statistics].self, from: data)
        //Llama el "constructor" de la gráfica
        self.buildChart()
    }
    
    //Realiza la gráfica de acuerdo a las estadísticas
    func buildChart(){
        var xs = [ Double]()
        var labels = [Double]()
        var labelString = [String]()
        var i = 0
        for stat in stats {
            xs.append(Double(stat.value))
            labels.append(Double(i))
            labelString.append(stat.date)
            i = i + 1
        }
        //Reinicia la gráfica
        chart.removeAllSeries()
        let series = ChartSeries(xs)
        //Define el color
        series.color = ChartColors.blueColor()
        chart.xLabels = labels
        chart.xLabelsFormatter = {
            (labelIndex: Int, labelValue: Double) -> String in
            return labelString[labelIndex]
        }
        chart.add(series)
    }
    
}

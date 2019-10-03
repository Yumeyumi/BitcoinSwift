//
//  ViewController.swift
//  BitcoinTicker
//


import UIKit

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    
    let baseURL = "https://apiv2.bitcoinaverage.com/indices/global/ticker/BTC"
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    var finalURL = ""
   


    //Pre-setup IBOutlets
    @IBOutlet weak var bitcoinpiker: UILabel!
    @IBOutlet weak var bitcoinpiker2: UILabel!
    @IBOutlet weak var bitcoinPriceLabel: UILabel!
    @IBOutlet weak var bitcoinPriceLabel2: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
       self.currencyPicker.delegate = self
       self.currencyPicker.dataSource = self
    }

    
    //TODO: Place your 3 UIPickerView delegate methods here
    
    //Number of columns of data
    func numberOfComponents(in pickView: UIPickerView) -> Int {
        return 2
    }
    
    // The number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencyArray.count
    }

    // The data to return fopr the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currencyArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
     let celda = component
        getCurrency(piker: currencyArray[row], component: celda)
    }
    
    
    
    
//    
//    //MARK: - Networking URLSesion
//    /***************************************************************/
//    
    func getCurrency(piker : String, component : Int) {
   guard let  url = URL(string: baseURL + piker) else {
    print ("No hay url")
    return }
        print(url)
    
    let urlrequest = URLRequest(url:url)
    let config =  URLSessionConfiguration.default
    let session = URLSession(configuration: config)
    
    let task = session.dataTask(with: urlrequest){
        (data, response, error) in
       
        if error != nil || data == nil {
            print("Client error!")
            return
        }
        
        guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
            print("Server error!")
            return
        }
        
        guard let mime = response.mimeType, mime == "application/json" else {
            print("Wrong MIME type!")
            return
        }
        
        do {
            let json = try JSONSerialization.jsonObject(with: data!, options: [ ]) as! Dictionary<String, Any>
           print(json)

            guard let bid = json["bid"] else {
                print ("Could not get bid form json")
                return
            }
            let str = String(describing: bid)
            DispatchQueue.main.async {
                if(component == 0) {
                    self.bitcoinPriceLabel.text = str
                    self.bitcoinpiker.text = piker
                } else {
                self.bitcoinPriceLabel2.text = str
                self.bitcoinpiker2.text = piker
                }
            }
            
        } catch {
            print("JSON error: \(error.localizedDescription)")
        }
    }
    
    task.resume()
  }

//    //MARK: - JSON Parsing without SwiftyJSON
//    /***************************************************************/
//
//
//
//    //MARK: - Update UI
//    /***************************************************************/

}


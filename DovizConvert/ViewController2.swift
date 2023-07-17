//
//  ViewController2.swift
//  DovizConvert
//
//  Created by Bircan Sezgin on 11.06.2023.
//
import FirebaseDatabase
import UIKit
import GoogleMobileAds
import AppTrackingTransparency
import AdSupport

class ViewController2: UIViewController, GADFullScreenContentDelegate {
    
    
    @IBOutlet weak var loading: UIActivityIndicatorView!
    @IBOutlet weak var dolarsWeekRates: UILabel!
    
    @IBOutlet weak var baseCurrentLabel: UILabel!
    @IBOutlet weak var secondCurrentLabel: UILabel!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var lastUpdateLabel: UILabel!
    var api_key_VC2 = ""
    var lastUpdate = ""
    var moneyBirim = ""
    var showMoney = ""
    var secondSendMoney = 0.0
    private var interstitial: GADInterstitialAd?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loading.startAnimating()
        self.loading.isHidden = false
        DispatchQueue.global().async {
            self.fetchAPIkey(complition: { Apikey in
                guard let firebaseApiKey = Apikey else{
                    print("Api anahtari bulunamadi")
                    return
                }
                self.api_key_VC2 = firebaseApiKey
                //print("API KEY GELDI MI : \(self.api_key_VC2)")
               
            })
            
        }
        secondCurrentLabel.text = "\(secondSendMoney) \(moneyBirim)"
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            
            self.dolarsWeek(moneyUnit: self.moneyBirim)
            
        }
        
        
        lastUpdateLabel.text = "Updated : \(lastUpdate)"
        baseCurrentLabel.text = "USD : 1.0$"
        
        self.navigationItem.title = "USD  TO  \(moneyBirim)"
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(turnOffAll))
        view.addGestureRecognizer(gesture)
        self.loading.isHidden = true
        
        self.adMobStarter()
        
        amountTextField.placeholder = "$ to Change \(moneyBirim) Enter Here"

    }// Finish ViewDidLoad!
    
        @objc func turnOffAll(){
            view.endEditing(true)
        }
                        
    
    // MARK: - Ad Func Start
    /// Tells the delegate that the ad failed to present full screen content.
    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        print("Ad did fail to present full screen content.")
    }
    
    /// Tells the delegate that the ad will present full screen content.
    func adWillPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("Ad will present full screen content.")
    }
    
    /// Tells the delegate that the ad dismissed full screen content.
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        if self.interstitial != nil {
            self.interstitial!.present(fromRootViewController: self)
        } else {
            print("Ad wasn't ready")
        }
    }
    // MARK: - Ad Func End
    
    


    @IBAction func calculateButtonClick(_ sender: Any) {
        if let inputMoney = Double(amountTextField.text ?? "") {
            let toplam = secondSendMoney * inputMoney
            let formattedToplam = String(format: "%.2f", toplam)
            let formattedInputMoney = String(format: "%.2f", inputMoney)

            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center
    

            let messageText = "\n\(formattedInputMoney) $ = \(formattedToplam) \(moneyBirim)\n ----------------------------\n \(formattedToplam) \(moneyBirim) = \(formattedInputMoney)$  \n\n\n\n\n\nUpdated Date: \(lastUpdate)"

            let attributedString = NSAttributedString(string: messageText, attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])

            let alertController = UIAlertController(title: "Exchange Results", message: nil, preferredStyle: .alert)
            alertController.setValue(attributedString, forKey: "attributedMessage")

            let okAction = UIAlertAction(title: "Close", style: .cancel) { UIAlertAction in
                
            }
            alertController.addAction(okAction)

            self.present(alertController, animated: true)
        } else {
            let alert = UIAlertController(title: "Error", message: "Please enter a valid number.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            present(alert, animated: true)
        }
    }

    
    
    // MARK: - Firebase Data read
    func fetchAPIkey(complition : @escaping (String?) -> Void){
        Database.database().reference().child("api_keys").observeSingleEvent(of: .value) { DataSnapshot in
            guard let api_Key = DataSnapshot.value as? String else{
                complition(nil)
                return
            }
            complition(api_Key)
        }
    }
    func adMobStarter(){
         //MARK: - Ad Launcher
         let request = GADRequest()
         ATTrackingManager.requestTrackingAuthorization{status in
             
             GADInterstitialAd.load(withAdUnitID:"ca-app-pub-3940256099942544/4411468910", // Ad key.
                                    request: request,
                                    completionHandler: { [self] ad, error in
                 if let error = error {
                     print("Failed to load interstitial ad with error: \(error.localizedDescription)")
                     return
                 }
                 interstitial = ad
                 interstitial?.fullScreenContentDelegate = self
             }
             )
             
             if status == .authorized{
                 
             }else if status == .denied{
                 
             }
             
         } //- ad Launcher Finish
     }
    
    func startApi(){
        // 1) Request & Session (Istek Yollamak)
        
        let url = URL(string: "https://api.fastforex.io/fetch-all?api_key=\(api_key_VC2)")
        //"http://data.fixer.io/api/latest?access_key=65c9f5e1913452a764636d551a167c89"
        
        // Session
        let session = URLSession.shared
        
        
        let task = session.dataTask(with: url!) { data, response, error in
            if error != nil{
                let alerts = UIAlertController(title: "ERROR", message: error?.localizedDescription, preferredStyle: .alert)
                let ok = UIAlertAction(title: "Ok", style: .cancel)
                alerts.addAction(ok)
                self.present(alerts, animated: true)
            }else{
                // 2) Response & Data (IStek Almak)
                if data != nil{
                    do{
                        // 3) Parsing & JSON Serialization
                        let jsonResponse = try JSONSerialization.jsonObject(with: data! ,options: JSONSerialization.ReadingOptions.mutableContainers) as! Dictionary<String, Any>
                        //ASYNC
                        DispatchQueue.main.async {
                            if let rates = jsonResponse["results"] as? [String : Any]{
                                print(rates)
                                if let usd = rates["USD"] as? Double{
                                    self.baseCurrentLabel.text = "USD: \(usd)$"
                                }
                            }
                            
                            if let dateRates = jsonResponse["updated"] as? String{
                                self.lastUpdateLabel.text = dateRates
                            }
                        }
                        
                    }catch{
                        print("Error")
                    }
                }
            }
        }
        
        task.resume()
        
    }
    
    
    func dolarsWeek(moneyUnit: String){
        let apiKey = "\(api_key_VC2)"
        let urlStr = "https://api.fastforex.io/time-series?from=USD&to=\(moneyUnit)&interval=P1D&api_key=\(apiKey)"
        
        guard let url = URL(string: urlStr) else {
            print("Geçersiz URL.")
            return
        }
        
        let session = URLSession.shared
        let task = session.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("İstek hatası: \(error.localizedDescription)")
                return
            }
            else{
                if data != nil{
                    
                    do {
                        let jsonResponse = try JSONSerialization.jsonObject(with: data!, options: []) as! [String: Any]
                        DispatchQueue.main.async {
                            if let results = jsonResponse["results"] as? [String: Any],
                               let tryRates = results["\(moneyUnit)"] as? [String: Double] {
                                var ratesText = ""
                                for (date, rate) in tryRates {
                                    print("\(date), \(rate)")
                                    ratesText += "\(date), \(rate) \(self.moneyBirim)\n"
                                }
                                //self.dolarsWeekRates.text = "Money History \n\n\(ratesText)"
                                
                                let moneyHistoryText = "Money History\n------------------------- "
                                let attributedText = NSMutableAttributedString(string: moneyHistoryText, attributes: [
                                    NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 17)
                                ])
                                attributedText.append(NSAttributedString(string: "\n\(ratesText)"))

                                self.dolarsWeekRates.attributedText = attributedText

                            }
                        }
                    } catch {
                        print("JSON dönüştürme hatası: \(error.localizedDescription)")
                    }

                }
            }
            
        }
        task.resume()
    }
    
}

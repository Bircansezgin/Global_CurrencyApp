//
//  ViewController.swift
//  DovizConvert
//
//  Created by Bircan Sezgin on 25.05.2023.
//

import UIKit
import Firebase
import FirebaseDatabase
import GoogleMobileAds
import AppTrackingTransparency


/*
 DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
 
 }
 */

class ViewController: UIViewController, GADFullScreenContentDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var api_keys = ""
    var admobApi_key = ""
    var currencies: [Currency] = [Currency]()
    var searchCurrencies: [Currency] = [Currency]()
    var aramaYapiliyorMu = false
    
    private var interstitial: GADInterstitialAd?
    //http://data.fixer.io/api/latest?access_key=65c9f5e1913452a764636d551a167c89
    
    @IBOutlet weak var calculateButton: UIButton!
    @IBOutlet weak var loading: UIActivityIndicatorView!
    @IBOutlet weak var euroLabel: UILabel!
    @IBOutlet weak var gbpLabel: UILabel!
    @IBOutlet weak var usdLabel: UILabel!
    @IBOutlet weak var tryLabel: UILabel!
    @IBOutlet weak var lastUpdateLabel: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    var dataVarmi = true
    var dateUpdate = ""
    var noOpTry = 0.0
    var noOpGPB = 0.0
    var noOpEuro = 0.0
    var noOpRub = 0.0
    var noOpDinar = 0.0
    var noOpJPY = 0.0
    var noOpAud = 0.0
    var noOpcad = 0.0
    var noOpCHF = 0.0
    var noOpHKD = 0.0
    var noOpSek = 0.0
    var noOpNok = 0.0
    var noOpInr = 0.0
    var noOpMxn = 0.0
    var noOpBrl = 0.0
    var noOpDkk = 0.0
    var noOpPln = 0.0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        
        searchBar.delegate = self
        
        // Api Key Islem!
        DispatchQueue.global().async {
            self.fetchAPIkey(complition: { Apikey in
                DispatchQueue.main.async {
                    if let firebaseApiKey = Apikey {
                        self.api_keys = firebaseApiKey
                    } else {
                        print("API anahtarı bulunamadı")
                    }
                }
            })
            
            self.fetchAdMobApiKey(comliton: { admobkey in
                DispatchQueue.main.async {
                    if let firebaseAdmobKey = admobkey{
                        self.admobApi_key = firebaseAdmobKey
                        self.adMobStarter()
                    }else{
                        print("admob Key yok")
                    }
                }
                
            })
        }
        
        
        tableView.delegate = self
        tableView.dataSource = self
        
        hidesLabel()
        //dolarsWeek()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.5) {
            self.unHidesLabel()
            self.startApi()
        }
        
       
        // TableView no see and just close keyboard!
        let gesture = UITapGestureRecognizer(target: self, action: #selector(turnOffAll))
        gesture.cancelsTouchesInView = false
        view.addGestureRecognizer(gesture)
        
        
    }//Finish viewController
    
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
        print("Ad did dismiss full screen content.")
    }
    
    private func adMobStarter(){
        //MARK: - Ad Launcher
        let request = GADRequest()
        ATTrackingManager.requestTrackingAuthorization{status in
            
            GADInterstitialAd.load(withAdUnitID: "\(self.admobApi_key)" , // Ad key.
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "go2" {
            if let navigationController = segue.destination as? UINavigationController,
               let des = navigationController.topViewController as? ViewController2 {
                
                if let senderString = sender as? String {
                    if senderString == "TRY" {
                        des.secondSendMoney = noOpTry
                        des.moneyBirim = "TRY"
                        des.lastUpdate = dateUpdate
                    }
                    
                    if senderString == "EUR" {
                        des.secondSendMoney = noOpEuro
                        des.moneyBirim = "EUR"
                        des.lastUpdate = dateUpdate
                    }
                    
                    if senderString == "GBP" {
                        des.secondSendMoney = noOpGPB
                        des.moneyBirim = "GBP"
                        des.lastUpdate = dateUpdate
                    }
                    
                    if senderString == "RUB"{
                        des.secondSendMoney = noOpRub
                        des.moneyBirim = "RUB"
                        des.lastUpdate = dateUpdate
                    }
                    
                    if senderString == "KWD"{
                        des.secondSendMoney = noOpDinar
                        des.moneyBirim = "KWD"
                        des.lastUpdate = dateUpdate
                    }
                    
                    if senderString == "JPY"{
                        des.secondSendMoney = noOpJPY
                        des.moneyBirim = "JPY"
                        des.lastUpdate = dateUpdate
                    }
                    
                    
                    if senderString == "AUD"{
                        des.secondSendMoney = noOpAud
                        des.moneyBirim = "AUD"
                        des.lastUpdate = dateUpdate
                    }
                    
                    if senderString == "CAD"{
                        des.secondSendMoney = noOpcad
                        des.moneyBirim = "CAD"
                        des.lastUpdate = dateUpdate
                    }
                    
                    if senderString == "CHF"{
                        des.secondSendMoney = noOpCHF
                        des.moneyBirim = "CHF"
                        des.lastUpdate = dateUpdate
                    }
                    
                    if senderString == "HKD"{
                        des.secondSendMoney = noOpHKD
                        des.moneyBirim = "HKD"
                        des.lastUpdate = dateUpdate
                    }
                    
                    if senderString == "NOK"{
                        des.secondSendMoney = noOpNok
                        des.moneyBirim = "NOK"
                        des.lastUpdate = dateUpdate
                    }
                    
                    if senderString == "INR"{
                        des.secondSendMoney = noOpInr
                        des.moneyBirim = "INR"
                        des.lastUpdate = dateUpdate
                    }
                    
                    if senderString == "SEK"{
                        des.secondSendMoney = noOpSek
                        des.moneyBirim = "SEK"
                        des.lastUpdate = dateUpdate
                    }
                    
                    if senderString == "MXN"{
                        des.secondSendMoney = noOpMxn
                        des.moneyBirim = "MXN"
                        des.lastUpdate = dateUpdate
                    }
                    
                    if senderString == "BRL"{
                        des.secondSendMoney = noOpBrl
                        des.moneyBirim = "BRL"
                        des.lastUpdate = dateUpdate
                    }
                    
                    if senderString == "PLN"{
                        des.secondSendMoney = noOpPln
                        des.moneyBirim = "PLN"
                        des.lastUpdate = dateUpdate
                    }
                    
                    if senderString == "DKK"{
                        des.secondSendMoney = noOpDkk
                        des.moneyBirim = "DKK"
                        des.lastUpdate = dateUpdate
                    }
                }
            }
        }
    }
    
    @IBAction func getRatesButton(_ sender: Any) {
        if self.interstitial != nil {
            self.interstitial!.present(fromRootViewController: self)
        } else {
            print("Ad wasn't ready")
        }
        //self.performSegue(withIdentifier: "hesapla", sender: nil)
    }
    
    
    func hidesLabel(){
        loading.isHidden = false
        loading.startAnimating()
        // tableView.isHidden = true
        calculateButton.isHidden = true
    }
    
    func unHidesLabel(){
        loading.isHidden = true
        loading.startAnimating()
        
        // tableView.isHidden = false
        calculateButton.isHidden = false
    }
    
    
    func startApi(){
        // 1) Request & Session (Istek Yollamak)
        
        let url = URL(string: "https://api.fastforex.io/fetch-all?api_key=\(api_keys)")
        //"http://data.fixer.io/api/latest?access_key=65c9f5e1913452a764636d551a167c89"
        
        // Session
        let session = URLSession.shared
        
        
        let task = session.dataTask(with: url!) { data, response, error in
            if error != nil{
                
            }else{
                // 2) Response & Data (IStek Almak)
                if data != nil{
                    do{
                        // 3) Parsing & JSON Serialization
                        let jsonResponse = try JSONSerialization.jsonObject(with: data! ,options: JSONSerialization.ReadingOptions.mutableContainers) as! Dictionary<String, Any>
                        //ASYNC
                        DispatchQueue.main.async {
                            if let rates = jsonResponse["results"] as? [String : Any]{
                                
                                if let usd = rates["USD"] as? Double{
                                    self.usdLabel.text = "USD: \(usd)$"
                                    
                                    // AdMob Show
                                    if self.interstitial != nil {
                                        self.interstitial!.present(fromRootViewController: self)
                                    } else {
                                        print("Ad wasn't ready")
                                    }
                                    
                                }
                                
                                if let trY = rates["TRY"] as? Double{
                                    let formattedTtry = String(format: "%.2f", trY)
                                    let currency = Currency(name: "TRY", flagImage: UIImage(named: "try_flag")!, value: "1 USD = \(formattedTtry)₺")
                                    self.currencies.append(currency)
                                    self.tableView.reloadData()
                                    self.noOpTry = trY
                                }
                                
                                if let gbp = rates["GBP"] as? Double{
                                    let formattedTgbp = String(format: "%.2f", gbp)
                                    let currency = Currency(name: "GBP", flagImage: UIImage(named: "gbp_flag.jpg")!, value: "1 USD = \(formattedTgbp)£")
                                    self.tableView.reloadData()
                                    self.currencies.append(currency)
                                    
                                    self.noOpGPB = gbp
                                }
                                
                                if let eurO = rates["EUR"] as? Double{
                                    let formattedTeuro = String(format: "%.2f", eurO)
                                    let currency = Currency(name: "EUR", flagImage: UIImage(named: "eur_flag")!, value: "1 USD = \(formattedTeuro)€")
                                    self.currencies.append(currency)
                                    self.tableView.reloadData()
                                    self.noOpEuro = eurO
                                }
                                
                                if let rub = rates["RUB"] as? Double{
                                    let formattedrub = String(format: "%.2f", rub)
                                    let currency = Currency(name: "RUB", flagImage: UIImage(named: "rub.flag")!, value: "1 USD = \(formattedrub)₽")
                                    self.currencies.append(currency)
                                    self.tableView.reloadData()
                                    self.noOpRub = rub
                                }
                                
                                if let dinar = rates["KWD"] as? Double{
                                    let formattedDinar = String(format: "%.2f", dinar)
                                    let currency = Currency(name: "KWD", flagImage: UIImage(named: "kuvety_flag")!, value: "1 USD = \(formattedDinar)د.ك")
                                    self.currencies.append(currency)
                                    self.tableView.reloadData()
                                    self.noOpDinar = dinar
                                    
                                }
                                
                                if let jpyYen = rates["JPY"] as? Double{
                                    let formattedjpyYen = String(format: "%.2f", jpyYen)
                                    let currency = Currency(name: "JPY", flagImage: UIImage(named: "yen_flag.jpg")!, value: "1 USD = \(formattedjpyYen)¥")
                                    self.currencies.append(currency)
                                    self.tableView.reloadData()
                                    self.noOpJPY = jpyYen
                                    
                                }
                                
                                if let aud = rates["AUD"] as? Double{
                                    let formattedAvusAud = String(format: "%.2f", aud)
                                    let currency = Currency(name: "AUD", flagImage: UIImage(named: "aug_flag")!, value: "1 USD = \(formattedAvusAud)A$")
                                    self.currencies.append(currency)
                                    self.tableView.reloadData()
                                    self.noOpAud = aud
                                }
                                
                                if let cad = rates["CAD"] as? Double{
                                    let formattedCanadaCAD = String(format: "%.2f", cad)
                                    let currency = Currency(name: "CAD", flagImage: UIImage(named: "cad_flag")!, value: "1 USD = \(formattedCanadaCAD)C$")
                                    self.currencies.append(currency)
                                    self.tableView.reloadData()
                                    self.noOpcad = cad
                                }
                                
                                if let chf = rates["CHF"] as? Double{
                                    let formattedCHD = String(format: "%.2f", chf)
                                    let currency = Currency(name: "CHF", flagImage: UIImage(named: "isvicre_flag")!, value: "1 USD = \(formattedCHD)CHF")
                                    self.currencies.append(currency)
                                    self.tableView.reloadData()
                                    self.noOpCHF = chf
                                }
                                
                                if let hkd = rates["HKD"] as? Double{
                                    let formattedHKD = String(format: "%.2f", hkd)
                                    let currency = Currency(name: "HKD", flagImage: UIImage(named: "hongKong_flag")!, value: "1 USD = \(formattedHKD)HK$")
                                    self.currencies.append(currency)
                                    self.tableView.reloadData()
                                    self.noOpHKD = hkd
                                }
                                
                                
                                if let sek = rates["SEK"] as? Double{
                                    let formattedHKD = String(format: "%.2f", sek)
                                    let currency = Currency(name: "SEK", flagImage: UIImage(named: "isvec_flag")!, value: "1 USD = \(formattedHKD)kr")
                                    self.currencies.append(currency)
                                    self.tableView.reloadData()
                                    self.noOpSek = sek
                                }
                                
                                if let nok = rates["NOK"] as? Double{
                                    let formattedHKD = String(format: "%.2f", nok)
                                    let currency = Currency(name: "NOK", flagImage: UIImage(named: "norvec_flag")!, value: "1 USD = \(formattedHKD)kr")
                                    self.currencies.append(currency)
                                    self.tableView.reloadData()
                                    self.noOpNok = nok
                                }
                                
                                if let inr = rates["INR"] as? Double{
                                    let formattedHKD = String(format: "%.2f", inr)
                                    let currency = Currency(name: "INR", flagImage: UIImage(named: "hindistan_flag")!, value: "1 USD = \(formattedHKD)₹")
                                    self.currencies.append(currency)
                                    self.tableView.reloadData()
                                    self.noOpInr = inr
                                }
                                
                                if let mxn = rates["MXN"] as? Double{
                                    let formattedHKD = String(format: "%.2f", mxn)
                                    let currency = Currency(name: "MXN", flagImage: UIImage(named: "mexica_flag")!, value: "1 USD = \(formattedHKD)$")
                                    self.currencies.append(currency)
                                    self.tableView.reloadData()
                                    self.noOpMxn = mxn
                                }
                                
                                if let brl = rates["BRL"] as? Double{
                                    let formattedHKD = String(format: "%.2f", brl)
                                    let currency = Currency(name: "BRL", flagImage: UIImage(named: "brezilya_flag")!, value: "1 USD = \(formattedHKD)R$")
                                    self.currencies.append(currency)
                                    self.tableView.reloadData()
                                    self.noOpBrl = brl
                                }
                                
                                if let dkk = rates["DKK"] as? Double{
                                    let formattedHKD = String(format: "%.2f", dkk)
                                    let currency = Currency(name: "DKK", flagImage: UIImage(named: "danimarka_flag")!, value: "1 USD = \(formattedHKD)kr")
                                    self.currencies.append(currency)
                                    self.tableView.reloadData()
                                    self.noOpDkk = dkk
                                }
                                
                                if let pln = rates["PLN"] as? Double{
                                    let formattedHKD = String(format: "%.2f", pln)
                                    let currency = Currency(name: "PLN", flagImage: UIImage(named: "polonya_flag")!, value: "1 USD = \(formattedHKD)kr")
                                    self.currencies.append(currency)
                                    self.tableView.reloadData()
                                    self.noOpPln = pln
                                }
                                
                                
                                
                                
                                
                                if let dateRates = jsonResponse["updated"] as? String{
                                    self.lastUpdateLabel.text = dateRates
                                    self.dateUpdate = dateRates
                                }
                            }// Finish Rates!
                        }
                        
                    }catch{
                        print("Error")
                    }
                }
            }
        }
        
        task.resume()
        
    }
    
    //MARK: - Firebase ADmod key Fetch
    func fetchAdMobApiKey(comliton : @escaping (String?) -> Void){
        Database.database().reference().child("admob_keys").observeSingleEvent(of: .value) { DataSnapshot in
            guard let admobkey = DataSnapshot.value as? String else{
                comliton(nil)
                return
            }
            comliton(admobkey)
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
    
    
}


extension ViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            aramaYapiliyorMu = false
        } else {
            aramaYapiliyorMu = true
            searchCurrencies = currencies.filter({ $0.name.lowercased().contains(searchText.lowercased()) })
        }
        tableView.reloadData()
    }
}


extension ViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
          if aramaYapiliyorMu == true {
              return searchCurrencies.count
          } else {
              return currencies.count
          }
      }
      
      func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          let sendData: Currency
          if aramaYapiliyorMu {
              sendData = searchCurrencies[indexPath.row]
          } else {
              sendData = currencies[indexPath.row]
          }
          
          let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! cellViewController
          cell.moneyFlagImage.image = sendData.flagImage
          cell.moneyProvision.text = "\(sendData.value)"
          cell.moneyUnitLabel.text = sendData.name
          
          return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row % 1 == 0 {
            return 130 //her bir hücrenin yüksekliğini 100 puan olarak ayarlar
        } else {
            return 130 //diğer hücrelerin yüksekliğini 130 puan olarak ayarlar
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let feedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
        feedbackGenerator.prepare()
         
        let selectedCurrency: Currency
        if aramaYapiliyorMu == true {
            selectedCurrency = searchCurrencies[indexPath.row]
        } else {
            selectedCurrency = currencies[indexPath.row]
        }
        
        if let cell = tableView.cellForRow(at: indexPath) as? cellViewController {
            UIView.animate(withDuration: 0.1, animations: {
                cell.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
                cell.alpha = 0.7
                feedbackGenerator.impactOccurred()
            }, completion: { _ in
                UIView.animate(withDuration: 0.1, animations: {
                    cell.transform = CGAffineTransform.identity
                    cell.alpha = 1.0
                })
            })
            
            switch selectedCurrency.name {
            case "TRY":
                self.performSegue(withIdentifier: "go2", sender: "TRY")
            case "EUR":
                performSegue(withIdentifier: "go2", sender: "EUR")
            case "GBP":
                performSegue(withIdentifier: "go2", sender: "GBP")
            case "RUB":
                performSegue(withIdentifier: "go2", sender: "RUB")
            case "KWD":
                performSegue(withIdentifier: "go2", sender: "KWD")
            case "JPY":
                performSegue(withIdentifier: "go2", sender: "JPY")
            case "AUD":
                performSegue(withIdentifier: "go2", sender: "AUD")
            case "CAD":
                performSegue(withIdentifier: "go2", sender: "CAD")
            case "CHF":
                performSegue(withIdentifier: "go2", sender: "CHF")
            case "HKD":
                performSegue(withIdentifier: "go2", sender: "HKD")
            case "SEK":
                performSegue(withIdentifier: "go2", sender: "SEK")
            case "NOK":
                performSegue(withIdentifier: "go2", sender: "NOK")
            case "INR":
                performSegue(withIdentifier: "go2", sender: "INR")
            case "MXN":
                performSegue(withIdentifier: "go2", sender: "MXN")
            case "BRL":
                performSegue(withIdentifier: "go2", sender: "BRL")
            case "DKK":
                performSegue(withIdentifier: "go2", sender: "DKK")
            case "PLN":
                performSegue(withIdentifier: "go2", sender: "PLN")
            default:
                break
            }
        }
    }

    
}

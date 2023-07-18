import UIKit

class CalculateCurrencyViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var pickerView1: UIPickerView!
    @IBOutlet weak var pickerView2: UIPickerView!
    
    let currencies = ["USD", "TRY", "GBP", "EUR", "RUB"] // Örnek olarak bazı para birimlerini içeren bir dizi
    
    var selectedCurrency1: String?
    var selectedCurrency2: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerView1.delegate = self
        pickerView1.dataSource = self
        
        pickerView2.delegate = self
        pickerView2.dataSource = self
    }
    
    // MARK: - UIPickerViewDataSource
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1 // Her bir picker view sadece bir bileşen içerecek
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencies.count // Her bir picker view için para birimi sayısı kadar satır olacak
    }
    
    // MARK: - UIPickerViewDelegate
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currencies[row] // Para birimlerini satır başlıkları olarak döndür
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == pickerView1 {
            selectedCurrency1 = currencies[row] // İlk picker view'den seçilen para birimini depola
        } else if pickerView == pickerView2 {
            selectedCurrency2 = currencies[row] // İkinci picker view'den seçilen para birimini depola
        }
    }
    
    // MARK: - Actions
    
    @IBAction func convertButtonTapped(_ sender: UIButton) {
        guard let currency1 = selectedCurrency1, let currency2 = selectedCurrency2 else {
            // Kullanıcı henüz her iki para birimini seçmedi
            return
        }
        
        // Burada seçilen para birimleri ile dönüşüm işlemini gerçekleştirebilirsiniz
        // Örnek olarak, API'ye istek gönderip dönüşüm oranlarını alabilir veya bir döviz hesaplayıcı fonksiyonunu kullanabilirsiniz
        
        // Sonucu kullanıcıya gösterebilir veya başka bir işlem yapabilirsiniz
    }
}

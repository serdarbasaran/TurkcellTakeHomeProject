
import UIKit

class PackagesVC: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var filterTopView: UIView!
    @IBOutlet weak var filterTypeTextField: UITextField!
    @IBOutlet weak var filterValueTextField: UITextField!
    
    @IBOutlet weak var sortTopView: UIView!
    @IBOutlet weak var sortTextField: UITextField!
    
    @IBOutlet weak var listTableView: UITableView!
    
    var originalArray = [PackageModel]()
    var arrayToShow = [PackageModel]()
    
    var cellHeightDictionary = [Int: CGFloat]()
    
    var filterTypePickerToolBar = UIToolbar()
    var filterTypePicker = UIPickerView()
    var filterTypePickerArray = ["Tümü", "Üyelik tipi", "Son geçerlilik tarihi"]
    
    var filterValuePickerToolBar = UIToolbar()
    var filterValuePicker = UIPickerView()
    var filterValuePickerArraySubscriptionType = ["Tümü", "Yıllık üyelik", "Aylık üyelik", "Haftalık üyelik"]
    var filterValuePickerArrayAvailableUntil = [String]()
    
    var sortPickerToolBar = UIToolbar()
    var sortPicker = UIPickerView()
    var sortPickerArray = ["Fiyat", "Favoriler", "Üyelik tipi", "İnternet", "Dakika", "SMS"]
    
    var selectedFilterTypeOption: String?
    var selectedFilterValueOption: String?
    var selectedSortOption: String?
    
    override func viewDidLoad() { super.viewDidLoad()
        
        filterTopView.layer.cornerRadius = 40
        sortTopView.layer.cornerRadius = 25
        
        searchBar.delegate = self
        
        filterTypePicker.delegate = self
        filterTypePicker.dataSource = self
        filterValuePicker.delegate = self
        filterValuePicker.dataSource = self
        sortPicker.delegate = self
        sortPicker.dataSource = self
        
        filterTypeTextField.text = "Tümü"
        selectedFilterTypeOption = "Tümü"
        filterTypeTextField.inputView = filterTypePicker
        
        filterValueTextField.text = "Tümü"
        selectedFilterValueOption = nil
        filterValueTextField.isUserInteractionEnabled = false
        filterValueTextField.alpha = 0.5
        filterValueTextField.inputView = filterValuePicker
        
        sortTextField.text = "Fiyat"
        selectedSortOption = nil
        sortTextField.inputView = sortPicker
        
        setFilterTypePickerToolBar()
        setFilterValuePickerToolBar()
        setSortPickerToolBar()
        
        listTableView.delegate = self
        listTableView.dataSource = self
        
        loadArrayToShow()
        
        for obj in arrayToShow {
            
            filterValuePickerArrayAvailableUntil.append(obj.availableUntil!)
            
        }
        
        filterValuePickerArrayAvailableUntil = Array(Set(filterValuePickerArrayAvailableUntil)) //duplike elemanlari siliyor
        filterValuePickerArrayAvailableUntil = filterValuePickerArrayAvailableUntil.sorted()
        filterValuePickerArrayAvailableUntil.insert("Tümü", at: 0)
        
        sortByPrice()
        
        originalArray = arrayToShow
        
        printCurrentSelectedOptions()
        
    }
    
    
    
    
    
    
    
    @IBAction func favStarButtonTapped(_ sender: UIButton) {
        
        let tappedObject = arrayToShow[sender.tag]
        
        tappedObject.isFavorited = !tappedObject.isFavorited!
        
        listTableView.reloadData()
        
        for obj in originalArray {
            
            if obj.name == tappedObject.name {
                
                obj.isFavorited = tappedObject.isFavorited
                
            }
        }
        
        saveOriginalArray()
        
    }
}

//MARK: - PICKERVIEW METHODS
extension PackagesVC: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        return 1
        
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        switch pickerView {
            
        case filterTypePicker:
            return filterTypePickerArray.count
            
        case filterValuePicker:
            
            if selectedFilterTypeOption == "Üyelik tipi" {
                
                return filterValuePickerArraySubscriptionType.count
                
            }else if selectedFilterTypeOption == "Son geçerlilik tarihi" {
                
                return filterValuePickerArrayAvailableUntil.count
                
            }else{
                
                return 0
                
            }
            
        case sortPicker:
            return sortPickerArray.count
            
        default:
            return 0
            
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        switch pickerView {
            
        case filterTypePicker:
            return filterTypePickerArray[row]
            
        case filterValuePicker:
            
            if selectedFilterTypeOption == "Üyelik tipi" {
                
                return filterValuePickerArraySubscriptionType[row]
                
            }else if selectedFilterTypeOption == "Son geçerlilik tarihi" {
                
                return filterValuePickerArrayAvailableUntil[row]
                
            }else{
                
                return nil
                
            }
            
        case sortPicker:
            return sortPickerArray[row]
            
        default:
            return nil
            
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        switch pickerView {
            
        case filterTypePicker:
            selectedFilterTypeOption = filterTypePickerArray[row]
            
        case filterValuePicker:
            
            if selectedFilterTypeOption == "Üyelik tipi" {
                
                selectedFilterValueOption = filterValuePickerArraySubscriptionType[row]
                
            }else if selectedFilterTypeOption == "Son geçerlilik tarihi" {
                
                selectedFilterValueOption = filterValuePickerArrayAvailableUntil[row]
                
            }
            
        case sortPicker:
            selectedSortOption = sortPickerArray[row]
            
        default:
            
            AlertService.showAlert(vc: self, title: "Seçenekler bulunamadı", message: "Lütfen tekrar deneyiniz", button: "Tamam")
            
            return
            
        }
    }
}

//MARK: - TABLEVIEW METHODS
extension PackagesVC: UITableViewDelegate, UITableViewDataSource {
    
    //"willDisplay cell" ve "estimatedHeightForRowAt indexPath" methodularinin eklenme amaci;
    //"favStarButtonTapped()" methodu icindeki ".reloadData()" methodu calistigi zaman tablonun scroll offset'inin kaymamasi
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        cellHeightDictionary[indexPath.row] = cell.frame.size.height
        
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let height = cellHeightDictionary[indexPath.row]
        
        return height ?? UITableView.automaticDimension
        
    }
    //----------
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return arrayToShow.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = listTableView.dequeueReusableCell(withIdentifier: "BasicCell", for: indexPath) as? CustomCell else {
            
            AlertService.showAlert(vc: self, title: "Liste yüklenemedi", message: "Lütfen tekrar deneyiniz", button: "Tamam")
            
            return UITableViewCell()
            
        }
        
        cell.favStarButton.tag = indexPath.row
        
        let rowObject = arrayToShow[indexPath.row]
        
        if rowObject.isFavorited! {
            
            cell.favStarButton.setImage(UIImage(named: "filledStar"), for: .normal)
            
        }else{
            
            cell.favStarButton.setImage(UIImage(named: "emptyStar"), for: .normal)
            
        }
        
        cell.nameLabel.text = rowObject.name
        
        cell.descLabel.text = rowObject.desc
        
        var benefitsArrayElements = ""
        
        if rowObject.benefits!.count == 1 && rowObject.benefits![0] == "" {
            
            benefitsArrayElements = "Mevcut değil"
            
        }else{
            
            for benefit in rowObject.benefits! {
                
                benefitsArrayElements += "\(benefit) "
                
            }
        }
        
        cell.benefitsLabel.text = """
        Avantajlar
        \(benefitsArrayElements)
        """
        
        let MBtoGB = Int(rowObject.tariff!["data"]!)! / 1024
        let talkString = rowObject.tariff!["talk"]!
        let smsString = rowObject.tariff!["sms"]!
        
        if MBtoGB == 0 && talkString == "0" && smsString == "0" {
            
            cell.tariffLabel.text = "İnternet, Dakika, veya SMS mevcut değil"
            
        }else if MBtoGB != 0 && talkString == "0" && smsString == "0" {
            
            cell.tariffLabel.text = "\(MBtoGB) GB"
            
        }else if MBtoGB == 0 && talkString != "0" && smsString == "0" {
            
            cell.tariffLabel.text = "\(talkString) Dakika"
            
        }else if MBtoGB == 0 && talkString == "0" && smsString != "0" {
            
            cell.tariffLabel.text = "\(smsString) SMS"
            
        }else if MBtoGB != 0 && talkString != "0" && smsString == "0" {
            
            cell.tariffLabel.text = """
            \(MBtoGB) GB
            \(talkString) Dakika
            """
            
        }else if MBtoGB == 0 && talkString != "0" && smsString != "0" {
            
            cell.tariffLabel.text = """
            \(talkString) Dakika
            \(smsString) SMS
            """
            
        }else if MBtoGB != 0 && talkString != "0" && smsString != "0" {
            
            cell.tariffLabel.text = """
            \(MBtoGB) GB
            \(talkString) Dakika
            \(smsString) SMS
            """
            
        }
        
        switch rowObject.subscriptionType {
            
        case "weekly":
            cell.subscriptionTypeAndPriceLabel.text = """
            Haftalık üyelik
            \(rowObject.price!) TL
            """
            
        case "monthly":
            cell.subscriptionTypeAndPriceLabel.text = """
            Aylık üyelik
            \(rowObject.price!) TL
            """
            
        case "yearly":
            cell.subscriptionTypeAndPriceLabel.text = """
            Yıllık üyelik
            \(rowObject.price!) TL
            """
            
        default:
            cell.subscriptionTypeAndPriceLabel.text = "Üyelik tipi mevcut değil"
            
        }
        
        cell.didUseBeforeLabel.text = rowObject.didUseBefore! ? "Paket daha önce kullanıldı" : "Paket daha önce kullanılmadı"
        
        /*
        //"packageList.json" dosyasindaki paketlerin "availableUntil" degerleri tarih formatina uygun rakamlar degil
        //bu yuzden "GUN/AY/YIL SAAT/DAKIKA" gibi bir tarih gorunumune donusturmeyip rakamlari oldugu gibi kullandim
        //eger tarih formatina uygun rakamlar olsaydi asagida yoruma aldigim sekilde donusturecektim
        
        let availabilityDateString = rowObject.availableUntil!
        
        let newTypeString = NSString(string: availabilityDateString)
        
        let day = newTypeString.substring(to: 2)
        let month = NSString(string: newTypeString.substring(from: 2)).substring(to: 2)
        let year = NSString(string: newTypeString.substring(from: 4)).substring(to: 2)
        let hour = NSString(string: newTypeString.substring(from: 6)).substring(to: 2)
        let minute = NSString(string: newTypeString.substring(from: 8)).substring(to: 2)
        
        cell.availableUntilLabel.text = "Son geçerlilik tarihi \(day)/\(month)/\(year) \(hour):\(minute)"
        */
        cell.availableUntilLabel.text = "Son geçerlilik tarihi \(rowObject.availableUntil!)" //rakamlari oldugu gibi kullandim
        
        return cell
        
    }
}

//MARK: - SEARCHBAR METHODS
extension PackagesVC: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        guard !searchText.isEmpty else {
            
            arrayToShow = originalArray
            
            listTableView.reloadData()
            
            return
            
        }
        
        arrayToShow = originalArray.filter { (obj) -> Bool in
            
            if obj.name!.lowercased().contains(searchText.lowercased()) {
                
                return true
                
            }else{
                
                return false
                
            }
        }
        
        listTableView.reloadData()
        
        if arrayToShow.count > 0 {
            
            listTableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
            
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.resignFirstResponder()
        
    }
}

//MARK: - HELPER METHODS
extension PackagesVC {
    
    //MARK: - TOOLBAR SETTING METHODS
    func setFilterTypePickerToolBar() {
        
        filterTypePickerToolBar.sizeToFit()
        
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(filterTypeCancelButtonTapped))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(filterTypeDoneButtonTapped))
        
        filterTypePickerToolBar.setItems([cancelButton, flexibleSpace, doneButton], animated: true)
        
        filterTypeTextField.inputAccessoryView = filterTypePickerToolBar
        
    }
    
    func setFilterValuePickerToolBar() {
        
        filterValuePickerToolBar.sizeToFit()
        
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(filterValueCancelButtonTapped))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(filterValueDoneButtonTapped))
        
        filterValuePickerToolBar.setItems([cancelButton, flexibleSpace, doneButton], animated: true)
        
        filterValueTextField.inputAccessoryView = filterValuePickerToolBar
        
    }
    
    func setSortPickerToolBar() {
        
        sortPickerToolBar.sizeToFit()
        
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(sortCancelButtonTapped))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(sortDoneButtonTapped))
        
        sortPickerToolBar.setItems([cancelButton, flexibleSpace, doneButton], animated: true)
        
        sortTextField.inputAccessoryView = sortPickerToolBar
        
    }
    
    //MARK: - SORTING BY METHODS
    func sortByPrice() {
        
        arrayToShow = arrayToShow.sorted(by: { $0.price! > $1.price! })
        
    }
    
    func sortByFavorites() {
        
        var favoritesArray = [PackageModel]()
        var unFavoritesArray = [PackageModel]()
        
        for obj in arrayToShow {
            
            if obj.isFavorited! {
                
                favoritesArray.append(obj)
                
            }else{
                
                unFavoritesArray.append(obj)
                
            }
        }
        
        if favoritesArray.count > 0 {
            
            favoritesArray = favoritesArray.sorted(by: { $0.price! > $1.price! })
            
        }
        
        if unFavoritesArray.count > 0 {
            
            unFavoritesArray = unFavoritesArray.sorted(by: { $0.price! > $1.price! })
            
        }
        
        arrayToShow = favoritesArray + unFavoritesArray
        
    }
    
    func sortBySubscriptionType() {
        
        var yearlyArray = [PackageModel]()
        var monthlyArray = [PackageModel]()
        var weeklyArray = [PackageModel]()
        
        for obj in arrayToShow {
            
            switch obj.subscriptionType {
                
            case "yearly":
                yearlyArray.append(obj)
                
            case "monthly":
                monthlyArray.append(obj)
                
            case "weekly":
                weeklyArray.append(obj)
                
            default:
                
                AlertService.showAlert(vc: self, title: "Sıralama bulunamadı", message: "Lütfen tekrar deneyiniz", button: "Tamam")
                
                return
                
            }
        }
        
        if yearlyArray.count > 0 {
            
            yearlyArray = yearlyArray.sorted(by: { $0.price! > $1.price! })
            
        }
        
        if monthlyArray.count > 0 {
            
            monthlyArray = monthlyArray.sorted(by: { $0.price! > $1.price! })
            
        }
        
        if weeklyArray.count > 0 {
            
            weeklyArray = weeklyArray.sorted(by: { $0.price! > $1.price! })
            
        }
        
        arrayToShow = yearlyArray + monthlyArray + weeklyArray
        
    }
    
    func sortByData() {
        
        arrayToShow = arrayToShow.sorted(by: { Int($0.tariff!["data"]!)! > Int($1.tariff!["data"]!)! })
        
    }
    
    func sortByTalk() {
        
        arrayToShow = arrayToShow.sorted(by: { Int($0.tariff!["talk"]!)! > Int($1.tariff!["talk"]!)! })
        
    }
    
    func sortBySMS() {
        
        arrayToShow = arrayToShow.sorted(by: { Int($0.tariff!["sms"]!)! > Int($1.tariff!["sms"]!)! })
        
    }
    
    //MARK: - DATA METHODS
    func loadArrayToShow() {
        
        if let plistFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Packages.plist") {
            
            if let data = try? Data(contentsOf: plistFilePath) {
                
                let decoderObj = PropertyListDecoder()
                
                do{
                    
                    arrayToShow = try decoderObj.decode([PackageModel].self, from: data)
                    
                    return
                    
                }catch{
                    
                    print(".plist dosyası decode edilemedi: \(error)")
                    
                    AlertService.showAlert(vc: self, title: "Paketler yüklenemedi", message: "Lütfen tekrar deneyiniz", button: "Tamam")
                    
                    return
                    
                }
            }
        }
        
        parseJSON()
        
    }
    
    func parseJSON() {
        
        guard let filePath = Bundle.main.path(forResource: "packageList", ofType: ".json") else {
            
            AlertService.showAlert(vc: self, title: "Paket bulunamadı", message: "Lütfen tekrar deneyiniz", button: "Tamam")
            
            return
            
        }
        
        let fileURL = URL(fileURLWithPath: filePath)
        
        do{
            
            let fileData = try Data(contentsOf: fileURL)
            
            let fileArray = try JSONDecoder().decode([PackageModel].self, from: fileData)
            
            for obj in fileArray {
                
                if obj.name == nil { obj.name = "" }
                
                if obj.desc == nil { obj.desc = "" }
                
                if obj.subscriptionType == nil { obj.subscriptionType = "" }
                
                if obj.didUseBefore == nil { obj.didUseBefore = false }
                
                if obj.benefits == nil { obj.benefits = [""] }
                
                if obj.price == nil { obj.price = 0 }
                
                if obj.tariff == nil { obj.tariff = ["": ""] }
                
                if obj.availableUntil == nil { obj.availableUntil = "" }
                
            }
            
            arrayToShow = fileArray
            
            for obj in arrayToShow {
                
                obj.isFavorited = false
                
            }
            
        }catch{
            
            print("JSON dosyası decode edilemedi: \(error)")
            
            AlertService.showAlert(vc: self, title: "Paketler yüklenemedi", message: "Lütfen tekrar deneyiniz", button: "Tamam")
            
            return
            
        }
    }
    
    func saveOriginalArray() {
        
        if let plistFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Packages.plist") {
            
            let encoderObj = PropertyListEncoder()
            
            do{
                
                let data = try encoderObj.encode(originalArray)
                
                try data.write(to: plistFilePath)
                
            }catch{
                
                print(".plist dosyası encode edilemedi: \(error)")
                
                AlertService.showAlert(vc: self, title: "Paketler kaydedilemedi", message: "Lütfen tekrar deneyiniz", button: "Tamam")
                
                return
                
            }
        }
    }
    
    func printCurrentSelectedOptions() {
        
        let filterTypeOption = selectedFilterTypeOption ?? "Değer yok"
        let filterValueOption = selectedFilterValueOption ?? "Değer yok"
        let sortOption = selectedSortOption ?? "Değer yok"
        
        print("Filtre Tipi seçeneği: \(filterTypeOption)")
        print("Filtre Değer seçeneği: \(filterValueOption)")
        print("Sıralama seçeneği: \(sortOption)")
        
        print("arrayToShow eleman sayısı: \(arrayToShow.count)")
        
    }
}

//MARK: - SELECTOR METHODS
extension PackagesVC {
    
    @objc func filterTypeCancelButtonTapped() {
        
        filterTypeTextField.resignFirstResponder()
        
    }
    
    @objc func filterTypeDoneButtonTapped() {
        
        filterTypeTextField.text = selectedFilterTypeOption
        
        if selectedFilterTypeOption == "Son geçerlilik tarihi" {
            
            filterTypeTextField.text = "Tarih"
            
        }
        
        arrayToShow = originalArray
        
        switch selectedFilterTypeOption {
            
        case "Tümü":
            
            filterValueTextField.text = "Tümü"
            selectedFilterValueOption = nil
            filterValueTextField.isUserInteractionEnabled = false
            filterValueTextField.alpha = 0.5
            
            sortTextField.text = "Fiyat"
            selectedSortOption = nil
            
        case "Üyelik tipi":
            
            filterValueTextField.text = "Tümü"
            selectedFilterValueOption = nil
            filterValueTextField.isUserInteractionEnabled = true
            filterValueTextField.alpha = 1
            
            sortTextField.text = "Fiyat"
            selectedSortOption = nil
            
        case "Son geçerlilik tarihi":
            
            filterValueTextField.text = "Tümü"
            selectedFilterValueOption = nil
            filterValueTextField.isUserInteractionEnabled = true
            filterValueTextField.alpha = 1
            
            sortTextField.text = "Fiyat"
            selectedSortOption = nil
            
        default:
            
            AlertService.showAlert(vc: self, title: "Filtre bulunamadı", message: "Lütfen tekrar deneyiniz", button: "Tamam")
            
            return
            
        }
        
        listTableView.reloadData()
        
        filterTypeTextField.resignFirstResponder()
        
        listTableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
        
        printCurrentSelectedOptions()
        
    }
    
    @objc func filterValueCancelButtonTapped() {
        
        filterValueTextField.resignFirstResponder()
        
    }
    
    @objc func filterValueDoneButtonTapped() {
        
        filterValueTextField.text = selectedFilterValueOption
        
        arrayToShow = originalArray
        
        if selectedFilterTypeOption == "Üyelik tipi" {
            
            switch selectedFilterValueOption {
                
            case "Tümü":
                
                sortTextField.text = "Fiyat"
                selectedSortOption = nil
                
                arrayToShow = originalArray
                
            case "Yıllık üyelik":
                
                let filteredArray = arrayToShow.filter({ $0.subscriptionType == "yearly" })
                
                arrayToShow = filteredArray
                
            case "Aylık üyelik":
                
                let filteredArray = arrayToShow.filter({ $0.subscriptionType == "monthly" })
                
                arrayToShow = filteredArray
                
            case "Haftalık üyelik":
                
                let filteredArray = arrayToShow.filter({ $0.subscriptionType == "weekly" })
                
                arrayToShow = filteredArray
                
            default:
                
                AlertService.showAlert(vc: self, title: "Filtre bulunamadı", message: "Lütfen tekrar deneyiniz", button: "Tamam")
                
                return
                
            }
            
        }else if selectedFilterTypeOption == "Son geçerlilik tarihi" {
            
            if selectedFilterValueOption == "Tümü" {
                
                sortTextField.text = "Fiyat"
                selectedSortOption = nil
                
                arrayToShow = originalArray
                
            }else{
                
                sortTextField.text = "Fiyat"
                selectedSortOption = nil
                
                let filteredArray = arrayToShow.filter({ $0.availableUntil == selectedFilterValueOption })
                
                arrayToShow = filteredArray
                
            }
        }
        
        listTableView.reloadData()
        
        filterValueTextField.resignFirstResponder()
        
        listTableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
        
        printCurrentSelectedOptions()
        
    }
    
    @objc func sortCancelButtonTapped() {
        
        sortTextField.resignFirstResponder()
        
    }
    
    @objc func sortDoneButtonTapped() {
        
        sortTextField.text = selectedSortOption
        
        switch selectedSortOption {
            
        case "Fiyat":
            sortByPrice()
            
        case "Favoriler":
            sortByFavorites()
            
        case "Üyelik tipi":
            sortBySubscriptionType()
            
        case "İnternet":
            sortByData()
            
        case "Dakika":
            sortByTalk()
            
        case "SMS":
            sortBySMS()
            
        default:
            
            AlertService.showAlert(vc: self, title: "Sıralama bulunamadı", message: "Lütfen tekrar deneyiniz", button: "Tamam")
            
            return
            
        }
        
        listTableView.reloadData()
        
        sortTextField.resignFirstResponder()
        
        listTableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
        
        printCurrentSelectedOptions()
        
    }
}

//
//  ViewController.swift
//  Weather-App
//
//  Created by norelhoda on 14.01.2022.
//

import UIKit

class ViewController: UIViewController {
    
    //MARK:- Proporties
    
    @IBOutlet weak var searchTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var searchIsActive:Bool = false {
        didSet{
            searchTableView.reloadData()
        }
    }
    @IBOutlet weak var firstButton: UIButton!
    @IBOutlet weak var secondButton: UIButton!
    @IBOutlet weak var thirdButton: UIButton!
    @IBOutlet weak var firstButtonView: UIView!
    @IBOutlet weak var secondButtonView: UIView!
    @IBOutlet weak var thirdButtonView: UIView!
    @IBOutlet weak var weatherCollectionView: UICollectionView!
    @IBOutlet weak var weatherTableView: UITableView!
    var weatherByHour = [List]()
    var weatherByDay = [List]()
    var filteredData: [String]!
    
    var selectedCity : String = "paris" {
        didSet{
           
            fetchHoulryWeather(selectedCity:selectedCity)
            fetchDailyWeather(selectedCity: selectedCity)
        }
    }
    
    //MARK:- LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDelegateAndDataSource()
        configureUI()
        customCollectionViewCell()
        fetchHoulryWeather(selectedCity: self.selectedCity)
        fetchDailyWeather(selectedCity:self.selectedCity)
        
        if let searchTextField = self.searchBar.value(forKey: "searchField") as? UITextField , let clearButton = searchTextField.value(forKey: "_clearButton")as? UIButton {

             clearButton.addTarget(self, action: #selector(self.yourFunction), for: .touchUpInside)
        }
    }
    
    @objc func yourFunction (){
        searchTableView.alpha = 0
        self.searchIsActive = false
        self.weatherTableView.register(WeatherTableViewCell.self, forCellReuseIdentifier: "WeatherTableViewCell")
    }
    
    //MARK:- Helper Function
    
    func setDelegateAndDataSource() {
       
        weatherTableView.dataSource = self
        weatherTableView.delegate = self
        
        weatherCollectionView.dataSource = self
        weatherCollectionView.delegate = self

        searchTableView.dataSource = self
        searchBar.delegate = self
        filteredData = data
    }
    
    func configureUI(){
        secondButtonView.alpha = 0
        thirdButtonView.alpha = 0
        secondButton.titleLabel?.textColor = UIColor.darkGray
        thirdButton.titleLabel?.textColor = UIColor.darkGray
    }
    
    func customCollectionViewCell() {
       let flowLayout = UICollectionViewFlowLayout()
       flowLayout.itemSize = CGSize(width: (weatherCollectionView.bounds.width / 15) - 40, height: weatherCollectionView.bounds.height / 2 - 40)
       flowLayout.scrollDirection = .horizontal
       flowLayout.sectionInset = UIEdgeInsets(top: 10, left: 12, bottom: 10, right: 12)
       flowLayout.minimumLineSpacing = 10
       flowLayout.minimumInteritemSpacing = 10
       weatherCollectionView.setCollectionViewLayout(flowLayout, animated: false)
   }
    
    //MARK:-API
    
    func fetchHoulryWeather(selectedCity:String){
        WeatherByHour.shared.getWeatherDataFromApi(url: EndPiont.weatherUrl, parameters: ["q": String(selectedCity),"appid":EndPiont.apid]) { [weak self]  (response) in
            
            guard let self = self else { return }
            if (response.list != nil) {
                self.weatherByHour = response.list!
                
                DispatchQueue.main.async{
                    self.weatherCollectionView.reloadData()

                }
            }
        }
    }
    
    func fetchDailyWeather(selectedCity:String){
        WeatherByDay.shared.getWeatherDataFromApi(url: EndPiont.weatherUrl2, parameters: ["q": String(selectedCity),"appid":EndPiont.apid,"cnt":String(7)]) { [self]  (response) in
          
            if (response.list != nil) {
                self.weatherByDay = response.list!
                DispatchQueue.main.async{
                   self.weatherTableView.reloadData()
                }
            }
        }
    }
    
    //MARK:- Selector Function
    
    @IBAction func firstButtonAction(_ sender: Any) {
        selectedCity = "Paris"
        firstButton.titleLabel?.textColor = UIColor.black
        firstButtonView.alpha = 1
        
        secondButton.titleLabel?.textColor = UIColor.darkGray
        secondButtonView.alpha = 0
        
        thirdButton.titleLabel?.textColor = UIColor.darkGray
        thirdButtonView.alpha = 0
    }
    
    @IBAction func secondButtonAction(_ sender: Any) {
        selectedCity = "London"
        secondButton.titleLabel?.textColor = UIColor.black
        secondButtonView.alpha = 1
        
        firstButton.titleLabel?.textColor = UIColor.darkGray
        firstButtonView.alpha = 0
        
        thirdButton.titleLabel?.textColor = UIColor.darkGray
        thirdButtonView.alpha = 0
    }
    
    @IBAction func thirdButtonAction(_ sender: Any) {
        selectedCity = "America"
        thirdButton.titleLabel?.textColor = UIColor.black
        thirdButtonView.alpha = 1
        
        firstButton.titleLabel?.textColor = UIColor.darkGray
        firstButtonView.alpha = 0
        
        secondButton.titleLabel?.textColor = UIColor.darkGray
        secondButtonView.alpha = 0
    }
}
extension ViewController:UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.frame.width/5, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       
         return weatherByHour.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WeatherCollectionViewCell", for: indexPath)as! WeatherCollectionViewCell
        cell.setUp(with: self.weatherByHour[indexPath.row])
        
        return cell
    }
}

extension ViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       if searchIsActive {
          return  filteredData.count
        }
       
          return  weatherByDay.count
    }
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if searchIsActive {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "TableCell", for: indexPath) as UITableViewCell
            cell.textLabel?.text = filteredData[indexPath.row]
                return cell
           
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherTableViewCell", for: indexPath) as! WeatherTableViewCell
            cell.setUp(with: weatherByDay[indexPath.row])
            cell.date.text = dates[indexPath.row]
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if searchIsActive {
          return  20
        }
          return  100
    }
}


extension ViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchTableView.alpha = 1
        searchIsActive = true
        filteredData = searchText.isEmpty ? data : data.filter({(dataString: String) -> Bool in
                // If dataItem matches the searchText, return true to include it
                return dataString.range(of: searchText, options: .caseInsensitive) != nil
            })

            searchTableView.reloadData()
        if searchText == "" {
            searchTableView.alpha = 0
           
        }
    }
    
   
}

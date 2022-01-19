//
//  ViewController.swift
//  Weather-App
//
//  Created by norelhoda on 14.01.2022.
//

import UIKit

class WeatherViewController: UIViewController {
    
    //MARK:- Proporties
    
    @IBOutlet weak var searchTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var firstButton: UIButton!
    @IBOutlet weak var secondButton: UIButton!
    @IBOutlet weak var thirdButton: UIButton!
    @IBOutlet weak var firstButtonView: UIView!
    @IBOutlet weak var secondButtonView: UIView!
    @IBOutlet weak var thirdButtonView: UIView!
    @IBOutlet weak var weatherCollectionView: UICollectionView!
    @IBOutlet weak var weatherTableView: UITableView!
    
    lazy var viewModel : WeatherViewModel =  {
    
        return WeatherViewModel()
    }()
    

    var filteredData: [String]!
    
    
    //MARK:- LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
        initVM()
    }
    
    //MARK:- Intialize ViewModel
    
    func initVM() {
        
        viewModel.fetchHoulryWeather()
        viewModel.fetchDailyWeather()
        viewModel.reloadCollectionView = {
            [weak self] in
            DispatchQueue.main.async {
                self?.weatherCollectionView.reloadData()
            }
        }
        
        viewModel.reloadTableView = { [weak self] in
            DispatchQueue.main.async {
                self?.weatherTableView.reloadData()
            }
        }
        viewModel.showSearchResult = { [weak self] in
            DispatchQueue.main.async {
                self?.searchTableView.reloadData()
            }
        }
    }
    
    
    //MARK:- Intialize view
    

    func initView(){
        
        setDelegateAndDataSource()
        secondButtonView.alpha = 0
        thirdButtonView.alpha = 0
        secondButton.titleLabel?.textColor = UIColor.darkGray
        thirdButton.titleLabel?.textColor = UIColor.darkGray
        
        
        if let searchTextField = self.searchBar.value(forKey: "searchField") as? UITextField , let clearButton = searchTextField.value(forKey: "_clearButton")as? UIButton {

             clearButton.addTarget(self, action: #selector(self.yourFunction), for: .touchUpInside)
        }
        
        customCollectionViewCell()
    }
    
    func setDelegateAndDataSource() {
       
        weatherTableView.dataSource = self
        weatherTableView.delegate = self
        
        weatherCollectionView.dataSource = self
        weatherCollectionView.delegate = self

        searchTableView.dataSource = self
        searchBar.delegate = self
        filteredData = viewModel.cityData
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
    
    //MARK:- Selector Function
    
    @IBAction func firstButtonAction(_ sender: Any) {
        viewModel.selectedCity = "Paris"
        firstButton.titleLabel?.textColor = UIColor.black
        firstButtonView.alpha = 1
        
        secondButton.titleLabel?.textColor = UIColor.darkGray
        secondButtonView.alpha = 0
        
        thirdButton.titleLabel?.textColor = UIColor.darkGray
        thirdButtonView.alpha = 0
    }
    
    @IBAction func secondButtonAction(_ sender: Any) {
        viewModel.selectedCity = "London"
        secondButton.titleLabel?.textColor = UIColor.black
        secondButtonView.alpha = 1
        
        firstButton.titleLabel?.textColor = UIColor.darkGray
        firstButtonView.alpha = 0
        
        thirdButton.titleLabel?.textColor = UIColor.darkGray
        thirdButtonView.alpha = 0
    }
    
    @IBAction func thirdButtonAction(_ sender: Any) {
        viewModel.selectedCity = "America"
        thirdButton.titleLabel?.textColor = UIColor.black
        thirdButtonView.alpha = 1
        
        firstButton.titleLabel?.textColor = UIColor.darkGray
        firstButtonView.alpha = 0
        
        secondButton.titleLabel?.textColor = UIColor.darkGray
        secondButtonView.alpha = 0
    }
    
    @objc func yourFunction (){
        searchTableView.alpha = 0
        self.viewModel.searchIsActive = false
    }
}

//MARK:- CollectionViewDataSource & Delegate

extension WeatherViewController:UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.frame.width/5, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       
        return viewModel.weatherByHour.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WeatherCollectionViewCell", for: indexPath)as! WeatherCollectionViewCell
        cell.setUp(with: self.viewModel.collectionCellViewModel[indexPath.row])
        return cell
    }
}

//MARK:- TableView Delegate & Data Source

extension WeatherViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if viewModel.searchIsActive {
          return  filteredData.count
        }
        return  viewModel.weatherByDay.count
    }
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if viewModel.searchIsActive {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "TableCell", for: indexPath) as UITableViewCell
            cell.textLabel?.text = filteredData[indexPath.row]
                return cell
           
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherTableViewCell", for: indexPath) as! WeatherTableViewCell
            cell.setUp(with: viewModel.tableCellViewModel[indexPath.row])
            cell.date.text = viewModel.datesArray[indexPath.row]
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if viewModel.searchIsActive {
          return  20
        }
          return  100
    }
}

//MARK:- Serach Delegate

extension WeatherViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchTableView.alpha = 1
        viewModel.searchIsActive = true
        filteredData = searchText.isEmpty ? viewModel.cityData : viewModel.cityData.filter({(dataString: String) -> Bool in
                // If dataItem matches the searchText, return true to include it
                return dataString.range(of: searchText, options: .caseInsensitive) != nil
            })

            searchTableView.reloadData()
        if searchText == "" {
            searchTableView.alpha = 0
           
        }
    }
}

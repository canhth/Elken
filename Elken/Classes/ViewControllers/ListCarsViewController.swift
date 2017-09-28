//
//  ListCarViewController.swift
//  Elken
//
//  Created by Canh Tran on 9/28/17.
//  Copyright © 2017 Canh Tran. All rights reserved.
//

import UIKit
import RealmSwift
import RxSwift
import RxCocoa

class ListCarsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CarManagementDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    private var listCars: [Car] = [Car]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.loadDataModel()
        self.setupViews()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: Setup model first
    private func loadDataModel() {
        listCars = Car.getAllCars()
    }
    
    private func setupViews() {
        tableView.estimatedRowHeight = 70
        tableView.rowHeight = UITableViewAutomaticDimension
        
        // In progress. Not done yet
        self.searchBar.rx.text
            .orEmpty
            .debounce(0.3, scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] (name) in
                guard let strongSelf = self else {return}
                let cars = strongSelf.listCars.filter {$0.name.hasPrefix(name)}
                strongSelf.listCars = cars
                strongSelf.tableView.reloadData()
            })
            .addDisposableTo(DisposeBag())
    }
    
     
    @IBAction func addCarBarButtonTapped(_ sender: UIBarButtonItem) {
        let addNewCarViewController = CarDetailsViewController.instantiateFromStoryboard()
        addNewCarViewController.delegate = self
        self.navigationController?.present(addNewCarViewController, animated: true, completion: nil)
    }
    
    // MARK: UITableviewDelegate & UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listCars.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CarTableViewCell", for: indexPath) as! CarTableViewCell
        cell.setupCellWithModel(car: listCars[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let addNewCarViewController = CarDetailsViewController.instantiateFromStoryboard()
        addNewCarViewController.delegate = self
        addNewCarViewController.currentCarModel = self.listCars[indexPath.row]
        addNewCarViewController.indexPath = indexPath
        self.navigationController?.pushViewController(addNewCarViewController, animated: true)
    }
    
    // MARK: CarManagementDelegate
    func didAddTheNewCar(car: Car) {
        self.listCars.insert(car, at: 0)
        self.tableView.reloadData() 
    }
    
    func didEditingCar(car: Car, indexPath: IndexPath) {
        self.listCars[indexPath.row] = car
        
        self.tableView.reloadRows(at: [indexPath], with: .automatic)
    }

}

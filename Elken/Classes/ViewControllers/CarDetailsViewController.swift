//
//  CarDetailsViewController.swift
//  Elken
//
//  Created by Canh Tran on 9/28/17.
//  Copyright © 2017 Canh Tran. All rights reserved.
//

import UIKit

protocol CarManagementDelegate: NSObjectProtocol {
    func didAddTheNewCar(car: Car)
    func didEditingCar(car: Car, indexPath: IndexPath)
}

class CarDetailsViewController: UIViewController {

    @IBOutlet weak var carNameTextField: UITextField!
    @IBOutlet weak var brandOfCarTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    
    var currentCarModel: Car?
    var indexPath: IndexPath?
    
    weak var delegate: CarManagementDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupViews()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func setupViews() {
        if let carModel = currentCarModel {
            self.carNameTextField.text = carModel.name
            self.brandOfCarTextField.text = carModel.brand
            self.priceTextField.text = carModel.price
        }
    }

    @IBAction func doneButtonTapped(_ sender: Any) {
        // Will show error empty message later
        guard let name = carNameTextField.text, let brand = brandOfCarTextField.text, let price = priceTextField.text else { return }
        
        let car: Car = currentCarModel ?? Car()
        car.name = name
        car.brand = brand
        car.price = price
        
        car.saveToLocal()
        
        if let carDelegate = delegate {
            if let carModel = currentCarModel, let indexPath = indexPath {
                carDelegate.didEditingCar(car: carModel, indexPath: indexPath)
                self.navigationController?.popViewController(animated: true)
            } else {
                carDelegate.didAddTheNewCar(car: car)
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
}

//
//  AddEditViewController.swift
//  Carangas
//
//  Created by Eric Brito on 16/10/17.
//  Copyright © 2017 Eric Brito. All rights reserved.
//

import UIKit

class AddEditViewController: UIViewController {

    @IBOutlet weak var tfBrand: UITextField!
    @IBOutlet weak var tfName: UITextField!
    @IBOutlet weak var tfPrice: UITextField!
    @IBOutlet weak var scGasType: UISegmentedControl!
    @IBOutlet weak var btAddEdit: UIButton!
    
    var car: Car!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if car != nil {
            tfBrand.text = car.brand
            tfName.text = car.name
            tfPrice.text = "\(car.price)"
            scGasType.selectedSegmentIndex = car.gasType
            title = "Edição"
            btAddEdit.setTitle("Editar carro", for: .normal)
        }
        
    }
    
    @IBAction func addEdit(_ sender: UIButton) {
        if car == nil {
            car = Car()
        }
        
        car.name = tfName.text!
        car.brand = tfBrand.text!
        car.gasType = scGasType.selectedSegmentIndex
        car.price = Double(tfPrice.text!) ?? 0.0
        
        let restOperation: RESTOperation = car._id == nil ? .save : .update
        
        
        API.restOperation(car: car, restOperation: restOperation) { (success) in
            if success {
                DispatchQueue.main.async {                    
                    self.navigationController?.popViewController(animated: true)
                }
            } else {
                print("Deu ruim")
            }
        }
        
    }
    
}

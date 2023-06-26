//
//  ViewController.swift
//  Core Data
//
//  Created by Prakash on 25/05/20.
//  Copyright © 2020 Prakash. All rights reserved.
//

import UIKit
import CoreData

var isEdit = false

@available(iOS 13.0, *)
class ViewController: UIViewController, EditDataProtocol {
   
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtAge: UITextField!
    @IBOutlet weak var btnAdd: UIButton!
        
    let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    var editIndex : Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.txtName.text = ""
        self.txtAge.text = ""
    }

    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    @IBAction func btnAdd_Action(_ sender: UIButton) {
        
        if isEdit
        {
            UpdateData()
            isEdit = false
        }else{
            InsertData()
            isEdit = true
        }
        
        self.txtName.text = ""
        self.txtAge.text = ""
        
        let PersonVC = self.storyboard?.instantiateViewController(withIdentifier: "PersonVC") as! PersonVC
        PersonVC.delegate = self
        self.navigationController?.pushViewController(PersonVC, animated: true)
    }
    
    @IBAction func btnShow_Action(_ sender: UIButton) {
        let PersonVC = self.storyboard?.instantiateViewController(withIdentifier: "PersonVC") as! PersonVC
        PersonVC.delegate = self
        self.navigationController?.pushViewController(PersonVC, animated: true)
    }
    
    // Insert Data
    func InsertData(){
               
        //Now let’s create an entity and new user records.
        let userEntity = NSEntityDescription.entity(forEntityName: "Person", in: managedContext)!
        
        //final, we need to add some data to our newly created record for each keys using
                    
        let user = NSManagedObject(entity: userEntity, insertInto: managedContext)
        user.setValue(txtName.text ?? "", forKeyPath: "name")
        user.setValue(txtAge.text ?? "", forKey: "age")

        //Now we have set all the values. The next step is to save them inside the Core Data
        
        do {
            try managedContext.save()
           
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        
    }
    
    func UpdateData() {
                
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "Person")
        do
        {
            let test = try managedContext.fetch(fetchRequest)
            
            let objectUpdate = test[editIndex ?? 0] as! NSManagedObject
            objectUpdate.setValue(txtName.text ?? "", forKeyPath: "name")
            objectUpdate.setValue(txtAge.text ?? "", forKey: "age")
            
            do{
                try managedContext.save()
            }
            catch
            {
                print(error)
            }
        }
        catch
        {
            print(error)
        }
    }
    
    // Get Data From Person VC Using DElegate Protocol
    func EditPersonData(_ index: Int,_ name: String, _ age: String) {
        
        if isEdit
        {
            btnAdd.setTitle("Edit", for: .normal)
        }else{
            btnAdd.setTitle("Add", for: .normal)
        }
        
        editIndex = index
        self.txtName.text = name
        self.txtAge.text = age
    }
       
}


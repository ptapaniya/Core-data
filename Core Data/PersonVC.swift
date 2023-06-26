//
//  PersonVC.swift
//  Core Data
//
//  Created by Prakash on 25/05/20.
//  Copyright © 2020 Prakash. All rights reserved.
//

import UIKit
import CoreData

protocol EditDataProtocol : class {
    
    func EditPersonData(_ index: Int, _ name: String, _ age: String)
    
}

@available(iOS 13.0, *)
class PersonVC: UIViewController,UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var tblPerson: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var arrPerson : [Person] = []
    
    weak var delegate : EditDataProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tblPerson.register(UINib(nibName: "PersonTVC", bundle: nil), forCellReuseIdentifier: "PersonTVC")
        
        getData()
        
        // Do any additional setup after loading the view.
    }

    // Get Data
    func getData() {
        do {
             let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Person")
            arrPerson = try managedContext.fetch(fetchRequest) as! [Person]
                        
            self.tblPerson.reloadData()
        }
        catch {
            print("Fetching Failed")
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrPerson.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PersonTVC", for: indexPath) as! PersonTVC
        
        let person = arrPerson[indexPath.row]
        
        cell.lblPersonDetails.text = "Name : \(person.value(forKey: "name") as? String ?? "") , Age : \(person.value(forKey: "age") as? String ?? "")"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        isEdit = true

        let person = arrPerson[indexPath.row]
        
        delegate?.EditPersonData(indexPath.row,person.value(forKey: "name") as? String ?? "", person.value(forKey: "age") as? String ?? "")
        self.navigationController?.popViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        let person = arrPerson[indexPath.row]

        managedContext.delete(person)
        
        do{
            try managedContext.save()
            getData()
        }
        catch
        {
            print(error)
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if !searchText.isEmpty {
            var predicate: NSPredicate = NSPredicate()
            predicate = NSPredicate(format: "name CONTAINS[cd] %@",searchBar.text!)
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName:"Person")
            fetchRequest.predicate = predicate
            do {
                arrPerson = try managedContext.fetch(fetchRequest) as! [Person]
            } catch let error as NSError {
                print("Could not fetch. \(error)")
            }
        }else{
            getData()
        }
        
        tblPerson.reloadData()
    }
  
}

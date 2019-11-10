//
//  DataToDB.swift
//  Celo Tech Interview
//
//  Get data from URL and save to local sqlite db
//
//  Created by Ellen Zhang on 7/11/19.
//  Copyright © 2019 Ellen Zhang. All rights reserved.
//

import Foundation
import UIKit
import CoreData

public class DataToDB {
    
    var arrayDocs:[Doctors]=[]
    var listOfDocs: [DoctorDetail]=[]
    var doctors: [Doctors] = []
    
    
    /// Get data from Restful API
    /// - Parameter numberOfDocs: number of data
    func getDataFromAPI(numberOfDocs: String){
        let doctorsRequest = DataRequest(numberOfDocs: numberOfDocs)
        doctorsRequest.getDoctors{ result in
            switch result{
                case .failure(let error):
                    print(error)
                case .success(let doctors):
//                    print(doctors)
                    
                    print(doctors.count)
                    print(doctors[1].name.first)
                    self.saveDataToDB(listOfDocs: doctors)
                    
            }
        }
    }
    
    
    
    /// save data into local sqlite
    /// - Parameter listOfDocs: list of data
    func saveDataToDB(listOfDocs: [DoctorDetail]){
        DispatchQueue.main.async {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
            return
        }
        let context = appDelegate.persistentContainer.viewContext

//        print(listOfDocs)
        
        for i in 0..<listOfDocs.count {

            let doctor = Doctors.init(context: context)
            
            // Match DB properties and JSON
            doctor.cell = listOfDocs[i].cell
            doctor.phone = listOfDocs[i].phone
            doctor.gender = listOfDocs[i].gender
            
            doctor.id = listOfDocs[i].login.uuid

            doctor.dob = listOfDocs[i].dob.date
            doctor.age = String(listOfDocs[i].dob.age)

            doctor.title = listOfDocs[i].name.title
            doctor.firstName = listOfDocs[i].name.first
            doctor.lastName = listOfDocs[i].name.last
            
            doctor.medium = listOfDocs[i].picture.medium
            doctor.large = listOfDocs[i].picture.large
            doctor.thumbnail = listOfDocs[i].picture.thumbnail
            
            doctor.city = listOfDocs[i].location.city
            doctor.state = listOfDocs[i].location.state
            doctor.country = listOfDocs[i].location.country
                        
            self.arrayDocs.append(doctor)
//            print(arrayDocs)
        }
            
        do{
                try context.save()
                print("Save!")
            }catch{
                print("Error saving doctors data!")
            }
    }
        
        
        
    }
    
    
    /// Delete data from sqlite DB
    func deleteAllData()  {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
            return
        }
        let context = appDelegate.persistentContainer.viewContext
        
//        let context = CoreDataHelper.sharedManager.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<Doctors>(entityName: "Doctors")
        
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest as! NSFetchRequest<NSFetchRequestResult>)
        do{
            try context.execute(batchDeleteRequest)
        }
        catch{
            print("Error deleting DB!")
        }

    }
    
    
    
    /// Retrieve data from sqlite
    /// - returns
    ///  1. numbers of data
    ///  2. array of data
    func getDataFromDB() -> (Int, [Doctors]){
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
                return (0, [])
            }
            let context = appDelegate.persistentContainer.viewContext
    //        let context = CoreDataHelper.sharedManager.persistentContainer.viewContext
                    
    //        Fetch doctors from core data db
            let fetchRequest : NSFetchRequest<Doctors> = Doctors.fetchRequest()
            do {
                doctors = try context.fetch(fetchRequest)
    //            print("sorted doctors \(sortedDoctors.count)")
            }catch{
                print("Error fetching data! \(error)")
            }
            return (doctors.count, doctors)
        }

}

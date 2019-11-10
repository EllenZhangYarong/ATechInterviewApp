//
//  DoctorsTableViewController.swift
//  Celo Tech Interview
//
//  Created by Ellen Zhang on 7/11/19.
//  Copyright © 2019 Ellen Zhang. All rights reserved.
//

import UIKit
import CoreData

struct cellData{
    var opened = Bool()
    var initialOfName = String()
    var sectionData = [Doctors]()
}

class DoctorsTableViewController: UITableViewController {
    
    var tableViewData = [cellData]()
    var listOfInitialLastName: [Character]=[];
    var doctors: [Doctors] = []
    var sortedDoctors: [Doctors] = []
    var filteredData = [[Doctors]]()
    var shouldBeOpenedSection = [String]()
    
    var isSearch: Bool = false
    
    let searchController = UISearchController(searchResultsController: nil)
    
    // For pagination
    var isDataLoading:Bool=false
    var pageNo:Int=0
    var limit:Int=20
    var offset:Int=0 //pageNo*limit
    var didEndReached:Bool=false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let docsToDB = DataToDB()
        let results = docsToDB.getDataFromDB()
        doctors = results.1
        sortedDoctors = doctors.sorted(by: {$0.lastName! < $1.lastName! })


        // Generate an alphabet list for initial of name.
        let aScalars = "a".unicodeScalars
        let aCode = aScalars[aScalars.startIndex].value

        let letters: [Character] = (0..<26).map {
            i in Character(UnicodeScalar(aCode + i)!)
        }
        
        listOfInitialLastName = letters
                    
       //construct data structure for table view
       for i in 0..<listOfInitialLastName.count{
           
           var arrayDocs = [Doctors]()
           
//               print("Processing initial is \(listOfInitialLastName[i])")
           
           for j in 0..<sortedDoctors.count{
               
               if (sortedDoctors[j].lastName!.contains(listOfInitialLastName[i].uppercased())){
                   
//                    print("Doctor's last name is:  \(sortedDoctors[j].last!)")
                   
                   arrayDocs.append(sortedDoctors[j])
                   
               }
           }
//         print("\(listOfInitialLastName[i])  has \(arrayDocs.count) records!")

        
            //By default, section 1 will be opened when app launched
            if i == 1 {
                tableViewData.append(cellData.init(opened: true, initialOfName: String(listOfInitialLastName[i].uppercased()), sectionData: arrayDocs))
            }else{
               tableViewData.append(cellData.init(opened: false, initialOfName: String(listOfInitialLastName[i].uppercased()), sectionData: arrayDocs))
            }
           
       }
            
    
        // add a search bar on top of tableview
        configureSearchBar()
        
    }
    
    
    //config Search Bar hidden
    func configureSearchBar()  {
        
        //Hiding search bar
        let offset = CGPoint(x:0, y:44)
        tableView.setContentOffset(offset, animated: false)
        searchController.searchBar.delegate = self
        self.tableView.tableHeaderView = searchController.searchBar
        
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
//        print(tableViewData.count)
        return tableViewData.count
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearch{
            if filteredData[section].count == 0{
                return 0
            }else{
                return filteredData[section].count +  1
            }
        }else{
            if tableViewData[section].opened == true{
                return tableViewData[section].sectionData.count + 1
            }else{
                return 1
            }
        }
        
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "initialNameCell", for: indexPath)
            cell.textLabel?.text = tableViewData[indexPath.section].initialOfName
            return cell
            
        }else{
            
            if isSearch{
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "docCell", for: indexPath) as! DoctorCell
                    cell.configureDocCell(doctor: filteredData[indexPath.section][indexPath.row - 1])
                return cell
                
            }else{
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "docCell", for: indexPath) as! DoctorCell
                cell.configureDocCell(doctor: tableViewData[indexPath.section].sectionData[indexPath.row - 1])
                return cell
            }
        }
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
            
            if tableViewData[indexPath.section].opened == true{
                tableViewData[indexPath.section].opened = false
            }else{
                tableViewData[indexPath.section].opened = true
            }
            
            let sections = IndexSet.init(integer: indexPath.section)
            tableView.reloadSections(sections, with: .none)
            
        }else{
            
            let vc = (storyboard?.instantiateViewController(identifier: "PopOverDoctorDetailViewController") as? PopOverDoctorDetailViewController)!
            
            if isSearch {
                vc.doctor = filteredData[indexPath.section][indexPath.row - 1]
            }else{
                vc.doctor = tableViewData[indexPath.section].sectionData[indexPath.row-1]
            }
                        
            self.navigationController?.pushViewController(vc, animated: false)
        }
    }
    
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if ((tableView.contentOffset.y + tableView.frame.size.height) >= tableView.contentSize.height)
        {
            if !isDataLoading{
                isDataLoading = true
                self.pageNo=self.pageNo+1
                self.limit=self.limit+10
                self.offset=self.limit * self.pageNo
            }
        }
    }
}

extension DoctorsTableViewController: UISearchBarDelegate{
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
//        shouldBeOpenedSection.removeAll()
        filteredData.removeAll()
        isSearch = false
        tableView.reloadData()
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        filteredData.removeAll()
        isSearch = true
        
        let searchString = searchController.searchBar.text!
        
        for cellData in tableViewData{
            var arrayDocs = [Doctors]()
            let filteredContent = cellData.sectionData.filter {
                $0.firstName!.range(of: searchString) != nil
                || $0.lastName!.range(of: searchString) != nil
            }
            
            if !filteredContent.isEmpty{
                
//                print(filteredContent.count)
//                print(filteredContent)
                
                shouldBeOpenedSection.append(cellData.initialOfName)
                
                for doctor in filteredContent{
                    arrayDocs.append(doctor)
                }
            }
            
//            print(arrayDocs.count)
            
            filteredData.append(arrayDocs)
        }
        self.tableView.reloadData()
    }
}


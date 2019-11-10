//
//  DoctorCell.swift
//  Celo Tech Interview
//
//  Created by Ellen Zhang on 8/11/19.
//  Copyright © 2019 Ellen Zhang. All rights reserved.
//

import UIKit

class DoctorCell: UITableViewCell{
    
    @IBOutlet weak var docThumbImageView: UIImageView!
    
    @IBOutlet weak var docNameLabel: UILabel!
    
    @IBOutlet weak var docGenderLabel: UILabel!
    
    @IBOutlet weak var docDOBLabel: UILabel!
    
    func configureDocCell(doctor: Doctors)  {
        
        let imageUrl = URL(string: doctor.thumbnail!)!
        
//        DispatchQueue.global().async {
//            let data = try? Data(contentsOf: imageUrl!)
//            DispatchQueue.main.async {
//                self.docThumbImageView.image = UIImage(data: data!)
//            }
//        }
        
        ImageCacheHelper.getImage(withURL: imageUrl){
            image in
            self.docThumbImageView.image = image

        }

        self.docNameLabel.text = doctor.firstName! + " " + doctor.lastName!
        self.docGenderLabel.text = doctor.gender
        let dob = doctor.dob!
        self.docDOBLabel.text = String(dob.prefix(10))
    }
}

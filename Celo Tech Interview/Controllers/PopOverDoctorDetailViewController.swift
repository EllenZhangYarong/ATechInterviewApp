//
//  PopOverDoctorDetailViewController.swift
//  Celo Tech Interview
//
//  Created by Ellen Zhang on 8/11/19.
//  Copyright © 2019 Ellen Zhang. All rights reserved.
//

import UIKit

class PopOverDoctorDetailViewController: UIViewController {

    var doctorLargeImageName = ""
    var doctor = Doctors.init()
    
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var doctorNameLabel: UILabel!
    @IBOutlet weak var doctorLargeImageView: UIImageView!
    @IBOutlet weak var cellLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        doctorNameLabel.text = doctor.title! + " " + doctor.firstName! + " " + doctor.lastName!
        cellLabel.text = doctor.cell
        phoneLabel.text = doctor.phone
        cityLabel.text = doctor.city
        stateLabel.text = doctor.state
        countryLabel.text = doctor.country
                
        let imageUrl = URL(string: doctor.large!)!
                
        ImageCacheHelper.getImage(withURL: imageUrl){
            image in
            self.doctorLargeImageView.image = image
        }

    }

}

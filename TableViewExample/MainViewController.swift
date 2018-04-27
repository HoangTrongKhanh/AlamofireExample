//
//  MainViewController.swift
//  TableViewExample
//
//  Created by Nguyen Duc Hoang on 8/27/17.
//  Copyright © 2017 Nguyen Duc Hoang. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class MainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView?
    
    var foods: [[String: Any]] = [[String: Any]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Alamofire.request("http://hoangs-macbook-pro.local:3001/list_all_foods").responseJSON { (response) in
            if let responseValue = response.result.value as! [String: Any]? {
                if let responseFoods = responseValue["data"] as! [[String: Any]]? {
                    self.foods = responseFoods
                    self.tableView?.reloadData()
                }
            }
        }
        // Do any additional setup after loading the view.
    }
    //MARK - UITableViewDataSource & UITableViewDelegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return foods.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FoodTableViewCell") as! FoodTableViewCell
        if foods.count > 0 {
            let eachFood = foods[indexPath.row]
            cell.lblFoodName.text = (eachFood["name"] as? String) ?? ""
            cell.lblFoodDescription.text = (eachFood["foodDescription"] as? String) ?? ""
            if let imageUrl = eachFood["imageUrl"] as? String {
                Alamofire.request("http://" + imageUrl).responseImage(completionHandler: { (response) in
                    //print(response)
                    if let image = response.result.value {
//                        let size = CGSize(width: 1000.0, height: 1000.0)
//                        let scaledImage = image.af_imageScaled(to: size)
//                        let roundedImage = image.af_imageRounded(withCornerRadius: 100.0)
                        let circularImage = image.af_imageRoundedIntoCircle()
                        
                        DispatchQueue.main.async {
                            cell.imageViewFood.image = circularImage
                        }
                    }
                })
            }
        }
        return cell
    }
}

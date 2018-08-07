//
//  ViewController.swift
//  INFOSYS_TEST
//
//  Created by wasim akram on 05/08/18.
//  Copyright © 2018 Mohammad. All rights reserved.
//

import UIKit
import SDWebImage
class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    
    var countryData: Country = Country()
    lazy var activityView: UIActivityIndicatorView = {
        let  activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        activityIndicator.center = self.view.center
        activityIndicator.backgroundColor = .orange
        activityIndicator.tintColor = .yellow
        return activityIndicator
    }()
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Refreshing the Data")
        refreshControl.addTarget(self, action:
            #selector(ViewController.handleRefresh(_:)),
                                 for: UIControlEvents.valueChanged)
        refreshControl.tintColor = UIColor.red
        
        return refreshControl
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.fetchAboutCountry()
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 180
        
        self.tableView.isHidden = true
        self.tableView.addSubview(self.refreshControl)
    }
    
    // MARK: - refresh method call
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        fetchAboutCountry()
        self.tableView.reloadData()
        refreshControl.endRefreshing()
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        if(self.countryData != nil && self.countryData.rows != nil) {
            return (self.countryData.rows!.count-1)
        }
        
        return 0
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        
        return UITableViewAutomaticDimension
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CountryDetailTableViewCell", for: indexPath) as! CountryDetailTableViewCell
        
        if let detail = self.countryData.rows![indexPath.row] as? Detail {
            if let detailImageUrl = detail.imageUrl {
                cell.profileImage.sd_setImage(with: detailImageUrl, placeholderImage: UIImage(named: "No_image"))
            }
            
            if let title = detail.title {
                cell.titleLabel?.text = title
                cell.titleLabel.textColor = .random()
                cell.titleLabel.isHidden = false
                
            } else {
                cell.titleLabel.isHidden = true
            }
            
            if let description = detail.description {
                cell.descriptionLabel?.text = description
                cell.descriptionLabel?.textColor = .random()
                cell.descriptionLabel.isHidden = false
            } else {
                cell.descriptionLabel.isHidden = true
            }
        }
        
        
        return cell
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func fetchAboutCountry() {
        
        if(!(ValidationHandler.isInternetAvailable())) {
            self.showAlert(message: ValidationHandler.noInternet)
        } else {
            self.activityView.startAnimating()
            self.activityView.isHidden = false
            self.tableView.endEditing(true)
            self.tableView.isHidden = true
            
            let webserviceHandler = WebServiceHandler()
            webserviceHandler.hitApiWithGetMethod(webApicallServiceNumber: WebApiCallServiceNumber.CountryData, anyObject: nil, completionHandler: { (statusCode, receivedData, parsedData) in
                // Update UI
                
                DispatchQueue.main.async {
                    self.countryData = Country()
                    self.countryData = parsedData as! Country
                    
                    if self.countryData.title != nil {
                        self.navigationItem.title = (self.countryData.title)!
                        print("\(String(describing: self.countryData.title))")
                    } else {
                        self.navigationItem.title = "About a Country"
                    }
                    
                    self.tableView?.reloadData()
                    
                    self.activityView.stopAnimating()
                    self.activityView.isHidden = true
                    
                    self.tableView.isHidden = false
                    self.tableView.endEditing(false)
                    
                }
                
            })
            
        }
        
    }
    
    func showAlert(message: String) {
        // create the alert
        let alert = UIAlertController(title: "Country Details", message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
    
}
extension UIColor {
    static func random() -> UIColor{
        
        return UIColor(red: CGFloat(drand48()), green: CGFloat(drand48()), blue: CGFloat(drand48()), alpha: 1.0)
        
    }
}

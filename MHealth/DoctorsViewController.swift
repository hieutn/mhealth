//
//  DoctorsViewController.swift
//  MHealth
//
//  Created by Tran Ngoc Hieu on 6/17/16.
//  Copyright © 2016 MHealth. All rights reserved.
//

import UIKit
import KVOController
import SVProgressHUD
import TSMessages

final class DoctorsViewController: UITableViewController {

    var viewModel = DoctorsViewModel()
    
    private var kvoController: FBKVOController!
    
    @IBOutlet  weak var saveBarButton: UIBarButtonItem! {
        didSet {
            saveBarButton.enabled = false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.separatorInset = UIEdgeInsetsZero
        bindingModel()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        viewModel.getDoctors()
    }
    
    @IBAction func saveToLocal(sender: UIBarButtonItem) {
        if viewModel.dataManager == nil {
            viewModel.dataManager = RealmDataManager()
        }
        
        viewModel.saveDoctors()
    }
    
    private func bindingModel() {
        kvoController = FBKVOController(observer: self)
        
        kvoController.observe(viewModel, keyPath: "isLoading", options: .New) { (observer, object, change) in
            if let isLoading = change[NSKeyValueChangeNewKey] as? Bool where isLoading {
                self.saveBarButton.enabled = false
                SVProgressHUD.show()
            } else {
                SVProgressHUD.dismiss()
                self.tableView.reloadData()
            }
        }
        
        kvoController.observe(viewModel, keyPath: "error", options: .New) { (observer, object, change) in
            if let error = change[NSKeyValueChangeNewKey] as? String {
                TSMessage.showNotificationInViewController(self, title: "", subtitle: error, type: .Error)
            } else {
                self.saveBarButton.enabled = true
            }
        }
        
        kvoController.observe(viewModel, keyPath: "isSavingData", options: .New) { (observer, object, change) in
            if let isSaving = change[NSKeyValueChangeNewKey] as? Bool {
                self.saveBarButton.enabled = !isSaving
            }
        }
        
        kvoController.observe(viewModel, keyPath: "saveError", options: .New) { (observer, object, change) in
            if let saveError = change[NSKeyValueChangeNewKey] as? String {
                dispatch_async(dispatch_get_main_queue()) {
                    TSMessage.showNotificationWithTitle(saveError, subtitle: "", type: .Error)
                }
            } else {
                dispatch_async(dispatch_get_main_queue()) {
                    TSMessage.showNotificationWithTitle("Save to local successful", subtitle: "", type: .Success)
                }
            }
        }
    }
    
}


extension DoctorsViewController {
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return viewModel.numberOfSection()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfItemsInSection(section)
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("DoctorCell", forIndexPath: indexPath) as! DoctorCell
        cell.configure(withDoctor: viewModel[indexPath])
        
        return cell
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.layoutMargins = UIEdgeInsetsZero
    }
    
}

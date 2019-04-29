//
//  TextViewController.swift
//  MiaomiaoClientUI
//
//  Created by Jörn on 29.04.19.
//  Copyright © 2019 Mark Wilson. All rights reserved.
//

import UIKit

public class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1 // Create 1 row as an example
    }
    
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TextInputCell") as! TextInputTableViewCell
        
        cell.configure(text: "", placeholder: "Enter some text!")
        return cell
    }
}

//
//  ListOfNewsFromSource.swift
//  Deli News
//
//  Created by Mohammad Yunus on 09/05/19.
//  Copyright © 2019 taptap. All rights reserved.
//

import UIKit
import SafariServices

class ListOfNewsFromSource: UITableViewController {
    
    var Feed: SelectedSourceFeed?
    
    var selectedSource: String?{
        didSet{
            print(selectedSource!)
        }
    }
    
    let decoder = JSONDecoder()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(search))
        let task = URLSession.shared.dataTask(with: URL(string: selectedSource!)!) { (data, response, error) in
            if error != nil{
                print(error!)
            }else{
                do{
                    self.Feed = try self.decoder.decode(SelectedSourceFeed.self, from: data!)
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }catch{
                    print(error)
                }
                print(data!)
            }
        }
        task.resume()
    }
    
    @objc func search(){
        
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return Feed?.articles.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellID, for: indexPath)
        cell.textLabel?.text = Feed?.articles[indexPath.row].title
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let url = Feed?.articles[indexPath.row].url{
            let config = SFSafariViewController.Configuration()
            config.barCollapsingEnabled = true
            config.entersReaderIfAvailable = true
            let svc = SFSafariViewController(url: URL(string: url)!, configuration: config)
            present(svc, animated: true)
        }
    }
    
}

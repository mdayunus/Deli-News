//
//  ListOfNewsFromSource.swift
//  Deli News
//
//  Created by Mohammad Yunus on 09/05/19.
//  Copyright © 2019 taptap. All rights reserved.
//

import UIKit
import SafariServices

class ListOfNewsFromSource:UITableViewController {
    
    @IBOutlet weak var mySearchBar: UISearchBar!{
        didSet{
            mySearchBar.delegate = self
        }
    }
    
    var Feed: SelectedSourceFeed?
    
    var backupFeed: SelectedSourceFeed?
    
    var selectedSource: String?{
        didSet{
//            print(selectedSource!)
        }
    }
    
    let decoder = JSONDecoder()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let url = "https://newsapi.org/v2/top-headlines?sources=\(selectedSource!)&apiKey=d8187c253d5e471ea8f1d748a90fb437"
        getDataFrom(url: url)
    }
    
    func getDataFrom(url: String){
        let task = URLSession.shared.dataTask(with: URL(string: url)!) { (data, response, error) in
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
extension ListOfNewsFromSource: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text else{return}
        if searchBar.text?.count != 0{
            let s = "https://newsapi.org/v2/top-headlines?q=\(text)&sources=\(selectedSource!)&apiKey=d8187c253d5e471ea8f1d748a90fb437"
            backupFeed = Feed
            getDataFrom(url: s)
//            print(s)
            searchBar.resignFirstResponder()
        }else{
            Feed = backupFeed
            backupFeed = nil
            tableView.reloadData()
            searchBar.resignFirstResponder()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        Feed = backupFeed
        backupFeed = nil
        tableView.reloadData()
        searchBar.text = ""
        searchBar.resignFirstResponder()
//        print("ok")
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
    }
    
}

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
    @IBOutlet weak var refresher: UIRefreshControl!
    
    var cache = NSCache<NSURL, NSData>()
    
    lazy var session: URLSession = {
        let config = URLSessionConfiguration.default
        config.allowsCellularAccess = true
        config.waitsForConnectivity = true
        let memoryCapacity = 500 * 1024 * 1024
        let diskCapacity = 500 * 1024 * 1024
        config.urlCache = URLCache(memoryCapacity: memoryCapacity, diskCapacity: diskCapacity, diskPath: nil)
        config.requestCachePolicy = URLRequest.CachePolicy.useProtocolCachePolicy
        return URLSession(configuration: config, delegate: self, delegateQueue: nil)
    }()
    
    @IBAction func refresherAction(_ sender: UIRefreshControl) {
        let url = "https://newsapi.org/v2/top-headlines?sources=\(selectedSource!)&apiKey=d8187c253d5e471ea8f1d748a90fb437"
        getDataFrom(url: url)
    }
    @IBOutlet weak var mySearchBar: UISearchBar!{
        didSet{
            mySearchBar.delegate = self
        }
    }
    
    var Feed: SelectedSourceFeed?
    
    var selectedSource: String?
    
    let decoder = JSONDecoder()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let url = "https://newsapi.org/v2/top-headlines?sources=\(selectedSource!)&apiKey=d8187c253d5e471ea8f1d748a90fb437"
        getDataFrom(url: url)
    }
    
    func getDataFrom(url: String){
        
        let uarel = URL(string: url)
        let req = URLRequest(url: uarel!)
        session.dataTask(with: req) { (data, response, error) in
            if error != nil
            {
                print(error!)
            }else{
                do{
                    self.Feed = try self.decoder.decode(SelectedSourceFeed.self, from: data!)
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        self.refresher.endRefreshing()
                    }
                }catch{
                    print(error)
                }
            }
        }.resume()    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return Feed?.articles?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellID, for: indexPath) as! CustomCell
        cell.titleLabel.text = Feed?.articles?[indexPath.row].title
        cell.authorLabel.text = Feed?.articles?[indexPath.row].author
        DispatchQueue.global().async {
            if let urlString = self.Feed?.articles?[indexPath.row].urlToImage{
                if let url = URL(string: urlString){
                    if let data = self.cache.object(forKey: url as NSURL){
                        DispatchQueue.main.async {
                            cell.myImageView.image = UIImage(data: data as Data)
                        }
                    }else{
                        if let data = try? Data(contentsOf: url){
                            self.cache.setObject(data as NSData, forKey: url as NSURL)
                            DispatchQueue.main.async {
                                cell.myImageView.image = UIImage(data: data as Data)
                            }
                        }
                    }
                }
            }
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let url = Feed?.articles?[indexPath.row].url{
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
            let s = "https://newsapi.org/v2/top-headlines?q=\(text)&sources=\(selectedSource!)&apiKey=d8187c253d5e471ea8f1d748a90fb437"
            getDataFrom(url: s)
            searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
    }
    
}

extension ListOfNewsFromSource: URLSessionDelegate{
    
}

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
    
    var selectedSource: String?
    
    let decoder = JSONDecoder()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        let memoryCapacity = 500 * 1024 * 1024
//        let diskCapacity = 500 * 1024 * 1024
//        let articleCache = URLCache(memoryCapacity: memoryCapacity, diskCapacity: diskCapacity, diskPath: "articleDiskPath")
//        URLCache.shared = articleCache
        let url = "https://newsapi.org/v2/top-headlines?sources=\(selectedSource!)&apiKey=d8187c253d5e471ea8f1d748a90fb437"
        getDataFrom(url: url)
    }
    
    func getDataFrom(url: String){
        
        let url = URL(string: url)
        let req = URLRequest(url: url!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 60)
        let task = URLSession.shared.dataTask(with: req) { (data, response, error) in
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
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellID, for: indexPath) as! CustomCell
        cell.TitleLabel.text = Feed?.articles[indexPath.row].title
        cell.authorLabel?.text = Feed?.articles[indexPath.row].author
//        if Feed?.articles[indexPath.row].urlToImage != nil{
//            let nsstring = (Feed?.articles[indexPath.row].urlToImage)! as NSString
//            if cache.object(forKey: nsstring) != nil{
//                let data = (cache.object(forKey: nsstring))! as Data
//                cell.myImageView.image = UIImage(data: data)
//            }else{
//                let url = Feed?.articles[indexPath.row].urlToImage
//                let t = URLSession.shared.dataTask(with: URL(string: url!)!) {(data, response, error) in
//                    if error != nil{
//                        print(error!)
//                    }else{
//                        DispatchQueue.main.async {
//                            self.cache.setObject(data! as NSData, forKey: nsstring)
//                            tableView.reloadRows(at: [indexPath], with: .none)
//                        }
//                    }
//
//                }
//                t.resume()
//            }
//        }
        if Feed?.articles[indexPath.row].urlToImage != nil{
            let url = Feed?.articles[indexPath.row].urlToImage
            let req = URLRequest(url: URL(string: url!)!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 60)
            let t = URLSession.shared.dataTask(with: req) { (data, response, error) in
                if error != nil{
                    print(error!)
                }else{
                    DispatchQueue.main.async {
                        cell.myImageView.image = UIImage(data: data!)
                    }
                }
            }
            t.resume()
        }
        
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
            searchBar.resignFirstResponder()
        }else{
            Feed = backupFeed
            backupFeed = nil
            tableView.reloadData()
            searchBar.resignFirstResponder()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        if searchBar.text?.count != 0{
            Feed = backupFeed
            backupFeed = nil
            tableView.reloadData()
            searchBar.text = ""
            searchBar.resignFirstResponder()
        }else{
            tableView.reloadData()
            searchBar.text = ""
            searchBar.resignFirstResponder()
        }
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
    }
    
}

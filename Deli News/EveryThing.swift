//
//  EveryThing.swift
//  Deli News
//
//  Created by Mohammad Yunus on 10/05/19.
//  Copyright © 2019 taptap. All rights reserved.
//

import UIKit
import SafariServices

class EveryThing: UITableViewController {
    
    @IBOutlet weak var mySearchBar: UISearchBar!{
        didSet{
            mySearchBar.delegate = self
        }
    }
    
    var everyNews: SelectedSourceFeed?
    
    let decoder = JSONDecoder()

    override func viewDidLoad() {
        super.viewDidLoad()
        let sb = UserDefaults.standard.string(forKey: Constants.sortBy) ?? "popularity"
        let lang = UserDefaults.standard.string(forKey: Constants.lang) ?? "en"
        print(sb, lang)
        let lastSearch = UserDefaults.standard.string(forKey: Constants.lastSearch) ?? "news"
        print(lastSearch)
        let url = "https://newsapi.org/v2/everything?q=\(lastSearch)&sortBy=\(sb)&language=\(lang)&apiKey=d8187c253d5e471ea8f1d748a90fb437"
        getEverythingFrom(url: url)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("willappear")
        // if the language or sortby has changed then call api with that parameters
        
        if UserDefaults.standard.string(forKey: Constants.changeLang) != UserDefaults.standard.string(forKey: Constants.lang) || UserDefaults.standard.string(forKey: Constants.changeSort) != UserDefaults.standard.string(forKey: Constants.sortBy){
            let sb = UserDefaults.standard.string(forKey: Constants.sortBy) ?? "popularity"
            let lang = UserDefaults.standard.string(forKey: Constants.lang) ?? "en"
            print(sb, lang)
            let lastSearch = UserDefaults.standard.string(forKey: Constants.lastSearch) ?? "news"
            let url = "https://newsapi.org/v2/everything?q=\(lastSearch)&sortBy=\(sb)&language=\(lang)&apiKey=d8187c253d5e471ea8f1d748a90fb437"
            getEverythingFrom(url: url)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("willdisappear")
        // everytime this view controller disappears changevalue and changesort are set to language and sortby just before view controller disappears
        guard let lang = UserDefaults.standard.string(forKey: Constants.lang), let sort = UserDefaults.standard.string(forKey: Constants.sortBy) else{return}
        UserDefaults.standard.set(lang, forKey: Constants.changeLang)
        UserDefaults.standard.set(sort, forKey: Constants.changeSort)
        
    }
    
    func getEverythingFrom(url: String){
        let req = URLRequest(url: URL(string: url)!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 60)
        let task = URLSession.shared.dataTask(with: req) { (data, response, error) in
            if error != nil{
                print(error!)
            }else{
                do{
                    self.everyNews = try self.decoder.decode(SelectedSourceFeed.self, from: data!)
                    OperationQueue.main.addOperation {
                        self.tableView.reloadData()
                    }
                }catch{
                    print(error)
                }
            }
        }
        task.resume()
    }

    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return everyNews?.articles?.count ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellID, for: indexPath) as! CellCustom
        cell.titleLabel.text = everyNews?.articles?[indexPath.row].title
        cell.authorLabel.text = everyNews?.articles?[indexPath.row].author
        if everyNews?.articles?[indexPath.row].urlToImage != nil{
            let url = everyNews?.articles?[indexPath.row].urlToImage
            let req = URLRequest(url: URL(string: url!)!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 60)
            let t = URLSession.shared.dataTask(with: req) { (data, response, error) in
                if error != nil{
                    print(error!)
                }else{
                    OperationQueue.main.addOperation {
                        cell.myImageView.image = UIImage(data: data!)
                    }
                }
            }
            t.resume()
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let url = everyNews?.articles?[indexPath.row].url{
            let config = SFSafariViewController.Configuration()
            config.barCollapsingEnabled = true
            config.entersReaderIfAvailable = true
            let svc = SFSafariViewController(url: URL(string: url)!, configuration: config)
            present(svc, animated: true)
        }
    }
}
extension EveryThing: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let sb = UserDefaults.standard.string(forKey: "sortBy") ?? "popularity"
        let lang = UserDefaults.standard.string(forKey: "lang") ?? "en"
        print(sb, lang)
        if let text = searchBar.text{
            let url = "https://newsapi.org/v2/everything?q=\(text)&sortBy=\(sb)&language=\(lang)&apiKey=d8187c253d5e471ea8f1d748a90fb437"
            
            UserDefaults.standard.set(searchBar.text!, forKey: Constants.lastSearch)
            getEverythingFrom(url: url)
            searchBar.resignFirstResponder()
        }
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

//
//  SourceTableViewController.swift
//  Deli News
//
//  Created by Mohammad Yunus on 09/05/19.
//  Copyright © 2019 taptap. All rights reserved.
//

import UIKit

class SourcesTableViewController: UITableViewController {
    
    var filteredSources: [Source]?
    
    var availableSources: Sources?
    
    let decoder = JSONDecoder()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let url = URL(string: Constants.sourceURL)
        let req = URLRequest(url: url!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 60)
        
        let task = URLSession.shared.dataTask(with: req) { (data, response, error) in
            if error != nil{
                print(error!)
            }else{
                do{
                    self.availableSources = try self.decoder.decode(Sources.self, from: data!)
                    self.filteredSources = self.availableSources?.sources
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

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return availableSources?.sources?.count ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellID, for: indexPath)
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.text = availableSources?.sources?[indexPath.row].name
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let dvc = storyboard?.instantiateViewController(withIdentifier: "News") as? ListOfNewsFromSource{
            
            if let selectedSource = availableSources?.sources?[indexPath.row].id{
                dvc.selectedSource = selectedSource
                navigationController?.pushViewController(dvc, animated: true)
            }
        }
    }
    
}

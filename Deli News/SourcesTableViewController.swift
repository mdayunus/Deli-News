//
//  SourceTableViewController.swift
//  Deli News
//
//  Created by Mohammad Yunus on 09/05/19.
//  Copyright © 2019 taptap. All rights reserved.
//

import UIKit

class SourcesTableViewController: UITableViewController {
    
    var availableSources: Sources?
    
    let decoder = JSONDecoder()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let task  = URLSession.shared.dataTask(with: URL(string: Constants.sourceURL)!) { (data, response, error) in
            if error != nil{
                print(error!)
            }else{
                do{
                    self.availableSources = try self.decoder.decode(Sources.self, from: data!)
                    DispatchQueue.main.async {
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
        cell.textLabel?.text = availableSources?.sources?[indexPath.row].name

        // Configure the cell...

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let dvc = storyboard?.instantiateViewController(withIdentifier: "News") as? ListOfNewsFromSource{
            
            if let selectedSource = availableSources?.sources?[indexPath.row].id{
                dvc.selectedSource = selectedSource
                
//                "https://newsapi.org/v2/top-headlines?sources=\(selectedSource)&apiKey=d8187c253d5e471ea8f1d748a90fb437"
                navigationController?.pushViewController(dvc, animated: true)
            }
        }
    }

}

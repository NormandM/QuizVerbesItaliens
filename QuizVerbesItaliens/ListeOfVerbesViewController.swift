//
//  ListeOfVerbesViewController.swift
//  QuizVerbesItaliens
//
//  Created by Normand Martin on 16-08-19.
//  Copyright © 2016 Normand Martin. All rights reserved.
//

import UIKit
var verbeInfinitif: [String] = []
var tempsVerbes: [String] = []
var personneVerbes: [String] = []
var alphaVerbeInfinitif: [String] = []


class ListeOfVerbesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var tableView: UITableView!
    var searchActive : Bool = false
    var filtered:[String] = []


    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        
        if let plistPath = Bundle.main.path(forResource: "ItalianVerbPlist", ofType: "plist"),
            let verbeDictionary = NSDictionary(contentsOfFile: plistPath){
            
            let listeDeVerbe = ListedeVerbe(verbeDictionary: verbeDictionary as! [String : [String : AnyObject]])
            
            verbeInfinitif = listeDeVerbe.infinitif
            tempsVerbes = listeDeVerbe.tempsVerbe
            personneVerbes = listeDeVerbe.personneVerbe
            func alpha (_ s1: String, s2: String) -> Bool {
                return s1 < s2
            }
            alphaVerbeInfinitif = verbeInfinitif.sorted(by: alpha)
            
        }


    }
    
    // Setting up the searchBar active: Ttrue/False
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true;
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    //Filtering with search text
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filtered = alphaVerbeInfinitif.filter({ (text) -> Bool in
            let tmp: NSString = text as NSString
            let range = tmp.range(of: searchText, options: NSString.CompareOptions.caseInsensitive)
            return range.location != NSNotFound
        })
        if(filtered.count == 0){
            searchActive = false;
        } else {
            searchActive = true;
        }
        self.tableView.reloadData()
    }
    


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Table Source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(searchActive) {
            return filtered.count
        }
        return alphaVerbeInfinitif.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Verbe", for: indexPath)
        if(searchActive){
            cell.textLabel?.text = filtered[indexPath.row]
        } else {
            
            let verbeNonConjugue = alphaVerbeInfinitif[indexPath.row]
            cell.textLabel!.text = verbeNonConjugue
        }
        return cell
    }
    
    // MARK: - Navigation
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showTempsVerbe"{
            if let indexPath = self.tableView.indexPathForSelectedRow, let verbeChoisi = tableView.cellForRow(at: indexPath)?.textLabel?.text {
                let backItem = UIBarButtonItem()
                backItem.title = ""
                navigationItem.backBarButtonItem = backItem // This will show in the next view controller being pushed
                let controller = segue.destination as! VerbeChoisiTableViewController
                controller.detailItem = verbeChoisi
            }
            
            
        }
    }



}

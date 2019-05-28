//
//  EateriesTableViewController.swift
//  Eateries
//
//  Created by Aleksei Chudin on 29/01/2019.
//  Copyright © 2019 Aleksei Chudin. All rights reserved.
//

import UIKit
import CoreData

class EateriesTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    var fetchResultsController: NSFetchedResultsController<Restaurant>!
    var searchController: UISearchController!
    var filteredResultArray: [Restaurant] = []
    var restaurants: [Restaurant] = []
    
//        Restaurant(name: "Ogonek Grill&Bar", type: "restaurant", location: "Moscow, Leninsky Prospekt 43", image: "ogonek.jpg", isVisited: false),
//        Restaurant(name: "Elu", type: "restaurant", location: "Moscow", image: "elu.jpg", isVisited: false),
//        Restaurant(name: "Bonsai", type: "restaurant", location: "Moscow", image: "bonsai.jpg", isVisited: false),
//        Restaurant(name: "Dastarhan", type: "restaurant", location: "Moscow", image: "dastarhan.jpg", isVisited: false),
//        Restaurant(name: "Indokitay", type: "restaurant", location: "Moscow", image: "indokitay.jpg", isVisited: false),
//        Restaurant(name: "X.O.", type: "restaurant", location: "Moscow", image: "x.o.jpg", isVisited: false),
//        Restaurant(name: "Balkan", type: "restaurant", location: "Moscow", image: "balkan.jpg", isVisited: false),
//        Restaurant(name: "Respublika", type: "restaurant", location: "Moscow", image: "respublika.jpg", isVisited: false),
//        Restaurant(name: "Speakeasy", type: "restaurant", location: "Moscow", image: "speakeasy.jpg", isVisited: false),
//        Restaurant(name: "Morris", type: "restaurant", location: "Moscow", image: "morris.jpg", isVisited: false),
//        Restaurant(name: "Istorii", type: "restaurant", location: "Moscow", image: "istorii.jpg", isVisited: false),
//        Restaurant(name: "Klassik", type: "restaurant", location: "Moscow", image: "klassik.jpg", isVisited: false),
//        Restaurant(name: "Love", type: "restaurant", location: "Moscow", image: "love.jpg", isVisited: false),
//        Restaurant(name: "Shok", type: "restaurant", location: "Moscow", image: "shok.jpg", isVisited: false),
//        Restaurant(name: "Bochka", type: "restaurant", location: "Moscow", image: "bochka.jpg", isVisited: false)
//    ]
    
    @IBAction func close(segue: UIStoryboardSegue) {
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.hidesBarsOnSwipe = true
    }
    
    func filterContentFor(searchText text: String) {
        filteredResultArray = restaurants.filter { (restaurant) -> Bool in
            return ((restaurant.name?.lowercased().contains(text.lowercased()))!)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        tableView.tableHeaderView = searchController.searchBar
        searchController.searchBar.delegate = self
        searchController.searchBar.barTintColor = #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1)
        searchController.searchBar.tintColor = .white
        // Убирает searchBar при переходе с главного экрана
        definesPresentationContext = true
        
        tableView.estimatedRowHeight = 85
        tableView.rowHeight = UITableView.automaticDimension
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        // create fetch request with descriptor
        let fetchRequest: NSFetchRequest<Restaurant> = Restaurant.fetchRequest()
        let sortDesctiptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDesctiptor]
        // getting context
        if let context = (UIApplication.shared.delegate as? AppDelegate)?.coreDataStack.persistentContainer.viewContext {
            // creating fetch results controller (in fact, initialization)
            fetchResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            fetchResultsController.delegate = self
            // trying to retrieve data
            do {
                try fetchResultsController.performFetch()
                // save retrieved data into restaurants array
                restaurants = fetchResultsController.fetchedObjects!
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let userDefaults = UserDefaults.standard
        let wasIntroWatched = userDefaults.bool(forKey: "wasIntroWatched")
        
        guard !wasIntroWatched else { return }
        
        if let pageViewController = storyboard?.instantiateViewController(withIdentifier: "pageViewController") as? PageViewController {
            present(pageViewController, animated: true, completion: nil)
        }
    }
    
    // MARK: - Fetch results controller delegate
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .insert: guard let indexPath = newIndexPath else { break }
            tableView.insertRows(at: [indexPath], with: .fade)
        case .delete: guard let indexPath =  indexPath else { break }
            tableView.deleteRows(at: [indexPath], with: .fade)
        case .update: guard let indexPath =  indexPath else { break }
            tableView.reloadRows(at: [indexPath], with: .fade)
        default:
            tableView.reloadData()
        }
        restaurants = controller.fetchedObjects as! [Restaurant]
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if searchController.isActive && searchController.searchBar.text != "" {
            return filteredResultArray.count
        }
        return restaurants.count
    }
    
    func restaurantToDisplayAt(indexPath: IndexPath) -> Restaurant {
        let restaurant: Restaurant
        if searchController.isActive && searchController.searchBar.text != "" {
            restaurant = filteredResultArray[indexPath.row]
        } else {
            restaurant = restaurants[indexPath.row]
        }
        return restaurant
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! EateriesTableViewCell
        let restautant = restaurantToDisplayAt(indexPath: indexPath)
        cell.thumbnailImageView.image = UIImage(data: restautant.image! as Data)
        cell.thumbnailImageView.layer.cornerRadius = 32.5
        cell.thumbnailImageView.clipsToBounds = true
        cell.nameLabel.text = restautant.name
        cell.locationLabel.text = restautant.location
        cell.typeLabel.text = restautant.type
        
        cell.accessoryType = restautant.isVisited ? .checkmark : .none

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        // first alert controller with acrion sheet style
//        let ac = UIAlertController(title: nil, message: "Choose action", preferredStyle: .actionSheet)
//        // first alert controller action
//        let call = UIAlertAction(title: "Call: +7(901)223-211\(indexPath.row)", style: .default) {
//            (action: UIAlertAction) -> Void in
//            // second alert controller inside first action
//            let alertC = UIAlertController(title: nil, message: "Call is not possible", preferredStyle: .alert)
//            // second alert controller action
//            let ok = UIAlertAction(title: "Ok", style: .default, handler: nil)
//            // add action to second alert controller
//            alertC.addAction(ok)
//            // present second alert controller
//            self.present(alertC, animated: true, completion: nil)
//        }
//        // second action
//        let isVisitedTitle = self.restaurantIsVisited[indexPath.row] ? "I wasn`t here" : "I was here"
//        let isVisited = UIAlertAction(title: isVisitedTitle, style: .default) { (action) in
//            let cell = tableView.cellForRow(at: indexPath)
//            
//            self.restaurantIsVisited[indexPath.row] = !self.restaurantIsVisited[indexPath.row]
//            cell?.accessoryType = self.restaurantIsVisited[indexPath.row] ? .checkmark : .none
//        }
//        // third action
//        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
//        // add all actions to first alert controller
//        ac.addAction(cancel)
//        ac.addAction(isVisited)
//        ac.addAction(call)
//        // prestnt first alert controller
//        present(ac, animated: true, completion: nil)
//        // снимает выделение при нажатии
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
//    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//
//        if editingStyle == .delete {
//            self.restaurantImages.remove(at: indexPath.row)
//            self.restaurantNames.remove(at: indexPath.row)
//            self.restaurantIsVisited.remove(at: indexPath.row)
//        }
//        tableView.deleteRows(at: [indexPath], with: .fade)
//    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        // slide for share menu
        let share = UITableViewRowAction(style: .default, title: "Share") { (action, indexPath) in
            let defaultText = "I`m at " + self.restaurants[indexPath.row].name! + " now"
            if let image = UIImage(data: self.restaurants[indexPath.row].image! as Data) {
                let activityController = UIActivityViewController(activityItems: [defaultText, image], applicationActivities: nil)
                self.present(activityController, animated: true, completion: nil)
            }
        }
        // slide for delete menu
        let delete = UITableViewRowAction(style: .default, title: "Delete") { (action, indexPath) in
            self.restaurants.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            if let context = (UIApplication.shared.delegate as? AppDelegate)?.coreDataStack.persistentContainer.viewContext {
                let objectToDelete = self.fetchResultsController.object(at: indexPath)
                context.delete(objectToDelete)
                
                do {
                    try context.save()
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
        
        share.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        delete.backgroundColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
        
        return [delete, share]
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailSegue" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let dvc = segue.destination as! EateryDetailViewController
                dvc.restaurant = restaurantToDisplayAt(indexPath: indexPath)
            }
        }
    }
    
}

extension EateriesTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentFor(searchText: searchController.searchBar.text!)
        tableView.reloadData()
    }
}

extension EateriesTableViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        if searchBar.text == "" {
            navigationController?.hidesBarsOnSwipe = false
        }
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        navigationController?.hidesBarsOnSwipe = true
    }
}

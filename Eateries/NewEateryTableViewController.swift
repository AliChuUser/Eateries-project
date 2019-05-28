//
//  NewEateryTableViewController.swift
//  Eateries
//
//  Created by Aleksei Chudin on 03/02/2019.
//  Copyright © 2019 Aleksei Chudin. All rights reserved.
//

import UIKit

class NewEateryTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var typeTextField: UITextField!
    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet weak var noButton: UIButton!
    var isVisited = false
    
    
    @IBAction func toggleIsVisitedPressed(_ sender: UIButton) {
        if sender == yesButton {
            sender.backgroundColor = #colorLiteral(red: 0.449771432, green: 0.8707901554, blue: 0.5439326694, alpha: 1)
            noButton.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
            isVisited = true
        } else {
            sender.backgroundColor = #colorLiteral(red: 0.8707901554, green: 0.3710897604, blue: 0.3836879648, alpha: 1)
            yesButton.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
            isVisited = false
        }
    }
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        if nameTextField.text == "" || addressTextField.text == "" || typeTextField.text == "" {
            print("Not all fields are filled")
        } else {
            // trying to get context
            if let context = (UIApplication.shared.delegate as? AppDelegate)?.coreDataStack.persistentContainer.viewContext {
                // create entity of our resaurant class in the context
                let restaurant = Restaurant(context: context)
                // set all the ptoperties
                restaurant.name = nameTextField.text
                restaurant.location = addressTextField.text
                restaurant.type = typeTextField.text
                restaurant.isVisited = isVisited
                if let image = imageView.image {
                    // we exect to get binary data
                    restaurant.image = image.pngData()
                }
                // trying save context
                do {
                    try context.save()
                    print("Saved!")
                } catch let error as NSError {
                    print("Failed to save data \(error), \(error.userInfo)")
                }
            }
            performSegue(withIdentifier: "unwindSegueFromNewEatery", sender: self)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        yesButton.backgroundColor = #colorLiteral(red: 0.449771432, green: 0.8707901554, blue: 0.5439326694, alpha: 1)
        noButton.backgroundColor = #colorLiteral(red: 0.8707901554, green: 0.3710897604, blue: 0.3836879648, alpha: 1)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 5
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageView.image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        dismiss(animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let alertController = UIAlertController(title: "Source of foto", message: nil, preferredStyle: .actionSheet)
            let cameraAction = UIAlertAction(title: "Camera", style: .default) { (action) in
                self.chooseImagePickerAction(source: .camera)
            }
            let photoAction = UIAlertAction(title: "Photo", style: .default) { (action) in
                self.chooseImagePickerAction(source: .photoLibrary)
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            
            alertController.addAction(cameraAction)
            alertController.addAction(photoAction)
            alertController.addAction(cancelAction)
            
            self.present(alertController, animated: true, completion: nil)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func chooseImagePickerAction(source: UIImagePickerController.SourceType) {
        if UIImagePickerController.isSourceTypeAvailable(source) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = source
            self.present(imagePicker, animated: true, completion: nil)
        }
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

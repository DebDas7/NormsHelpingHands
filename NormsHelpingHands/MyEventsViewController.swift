//
//  MyEventsViewController.swift
//  NormsHelpingHands
//
//  Created by George Vargas on 3/30/20.
//  Copyright © 2020 Deb Das. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class MyEventsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var events: [String] = []
    var currentUser: UserModel!
    var postKey : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func createArray() {
        events = []
        let ref = Database.database().reference(withPath: "Posts")
        ref.observeSingleEvent(of: .value) { (snapshot) in
            for child in snapshot.children {
                let snap = child as! DataSnapshot
                let placeDict = snap.value as! [String: Any]
                let eventUID = placeDict["eventCreatorUID"] as! String
                let eventKey = placeDict["eventKey"] as! String
                if (eventUID == self.currentUser.uid) {
                    self.events.append(eventKey)
                }
            }
            self.tableView.reloadData()
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let mainTabBar = tabBarController as! MainTabBarController
        currentUser = mainTabBar.currentUser
        
        createArray()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let postPage = segue.destination as? PostPageViewController {
            postPage.postKey = self.postKey as String
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        postKey = events[indexPath.row]
        performSegue(withIdentifier: "myEventsToPost", sender: self)
    }


}

extension MyEventsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(events.count)
        return events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let event = events[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventCell") as! EventViewCell
        cell.setEventInfo(eventKey: event)
        return cell
    }
}

//
//  JoinedEventsViewController.swift
//  NormsHelpingHands
//
//  Created by George Vargas on 3/30/20.
//  Copyright © 2020 Deb Das. All rights reserved.
//

import UIKit
import Firebase

class JoinedEventsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var events: [String] = []
    var currentUser: UserModel!
    var postKey : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func createArray() {
        events = []
        
        let ref = Database.database().reference(withPath: "Users/\(currentUser.key)/joinedEvents")
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            if !snapshot.exists() {
                return
            }

            // data found
            let myData = snapshot.value as! [String: Bool]

            for (key, value) in myData {
                self.events.append(key)
            }
            self.tableView.reloadData()
        })

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
        performSegue(withIdentifier: "joinedToPost", sender: self)
    }
    
}

extension JoinedEventsViewController: UITableViewDataSource, UITableViewDelegate {
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

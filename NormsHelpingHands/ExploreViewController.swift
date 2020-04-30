//
//  ExploreViewController.swift
//  NormsHelpingHands
//
//  Created by George Vargas on 3/9/20.
//  Copyright © 2020 Deb Das. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth

class ExploreViewController: UIViewController {

    @IBOutlet weak var createEventButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    var events: [String] = []
    var postImgKey : String = ""
    var currentUser: UserModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let mainTabBar = tabBarController as! MainTabBarController
        currentUser = mainTabBar.currentUser
        
        tableView.alwaysBounceVertical = false
    }
        
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
        createArray()
    }

    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let postPage = segue.destination as? PostPageViewController {
            postPage.postKey = self.postImgKey as String
        }
    }
    
    func createArray() {
        events = []
        var i = 0
        let ref = Database.database().reference(withPath: "Posts")
        ref.observeSingleEvent(of: .value) { (snapshot) in
            for child in snapshot.children {
                if (i < 3) {
                    let snap = child as! DataSnapshot
                    let placeDict = snap.value as! [String: Any]
                    let eventKey = placeDict["eventKey"] as! String
                    self.events.append(eventKey)
                }
                i+=1
            }
            self.tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        postImgKey = events[indexPath.row]
        performSegue(withIdentifier: "exploreToPost", sender: self)
    }
    
}

extension ExploreViewController: UITableViewDataSource, UITableViewDelegate {
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

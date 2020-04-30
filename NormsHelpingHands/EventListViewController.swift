//
//  EventListViewController.swift
//  NormsHelpingHands
//
//  Created by George Vargas on 3/19/20.
//  Copyright © 2020 Deb Das. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class EventListViewController: UIViewController {

    var postImgKey : String = ""
    var events: [String] = []
    @IBOutlet weak var tableView: UITableView!
    
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
                let eventKey = placeDict["eventKey"] as! String
                self.events.append(eventKey)
            }
            self.tableView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        createArray()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let postPage = segue.destination as? PostPageViewController {
            postPage.postKey = self.postImgKey as String
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        postImgKey = events[indexPath.row]
        performSegue(withIdentifier: "listToPostPage", sender: self)
    }

}

extension EventListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let event = events[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventCell") as! EventViewCell
        cell.setEventInfo(eventKey: event)
        return cell
    }
}

//
//  LeaderBoardViewController.swift
//  NormsHelpingHands
//
//  Created by Deb Das on 4/18/20.
//  Copyright © 2020 Deb Das. All rights reserved.
//

import UIKit

class LeaderBoardViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    struct Members {
        var position: String
        var name: String
        var score: String
    }
    
    let memberArr = [
            Members(position: "1", name: "Eden Kim", score: "4000"),
            Members(position: "2", name: "Kai Havertz", score: "3500"),
            Members(position: "3", name: "John Smith", score: "3000"),
            Members(position: "4", name: "Jane Doe", score: "2500"),
            Members(position: "5", name: "Mathis Johnson", score: "2000"),
        ]
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return(memberArr.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "cell")
    
        let membr = memberArr[indexPath.row]
        cell.textLabel?.text = membr.position + "   " + membr.name + "   " + membr.score
        
        return cell

    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

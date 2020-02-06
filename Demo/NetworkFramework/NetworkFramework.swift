//
//  NetworkFramework.swift
//  Demo
//
//  Created by 黃崇漢 on 2019/11/27.
//  Copyright © 2019 Tony Huang (黃崇漢). All rights reserved.
//

import UIKit
import NetStatus 

class NetworkFramework: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var monitorButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureTableView()
        monitorButton.layer.cornerRadius = 15.0
        
        NetStatus.shared.didStartMonitoringHandler = { [unowned self] in
            self.monitorButton.setTitle("Stop Monitoring", for: .normal)
        }
        
        NetStatus.shared.didStopMonitoringHandler = { [unowned self] in
            self.monitorButton.setTitle("Start Monitoring", for: .normal)
            self.tableView.reloadData()
        }
        
        NetStatus.shared.netStatusChangeHandler = {
            self.tableView.reloadData()
        }
    }
    
    func configureTableView() {
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.isScrollEnabled = false
        tableView.alwaysBounceVertical = false
        tableView.backgroundColor = UIColor.clear
        tableView.isScrollEnabled = true
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        tableView.register(UINib(nibName: "InfoCell", bundle: nil), forCellReuseIdentifier: "infoCell")
    }
    
    @IBAction func toggleMonitoring(_ sender: Any) {
        if !NetStatus.shared.isMonitoring {
            NetStatus.shared.startMonitoring()
        }
        else {
            NetStatus.shared.stopMonitoring()
        }
    }

}

extension NetworkFramework: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section != 1 ? 1 : NetStatus.shared.availableInterfacesTypes?.count ?? 0
    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0: return "Connected"
        case 1: return "Interface Types"
        case 2: return "Is Expensive"
        default: return nil
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "infoCell", for: indexPath) as! InfoCell
        
        switch indexPath.section {
           case 0:
               cell.label?.text = NetStatus.shared.isConnected ? "Connected" : "Not Connected"
               cell.indicationImageView.image = NetStatus.shared.isConnected ? UIImage(named: "checkmark") : UIImage(named: "delete")
        
           case 1:
               if let interfaceType = NetStatus.shared.availableInterfacesTypes?[indexPath.row] {
                   cell.label?.text = "\(interfaceType)"
        
                   if let currentInterfaceType = NetStatus.shared.interfaceType {
                       cell.indicationImageView.image = (interfaceType == currentInterfaceType) ? UIImage(named: "checkmark") : nil
                   }
               }
        
           case 2:
               cell.label?.text = NetStatus.shared.isExpensive ? "Expensive" : "Not Expensive"
               cell.indicationImageView.image = NetStatus.shared.isExpensive ? UIImage(named: "warning") : nil
        
           default: ()
           }
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
}

//
//  TableViewAdvanced.swift
//  Demo
//
//  Created by 黃崇漢 on 2018/8/16.
//  Copyright © 2018年 Tony Huang (黃崇漢). All rights reserved.
//

import UIKit

class TableViewAdvanced: UIViewController {
    
    struct CellDescriptor: Codable {
        var isExpandable: Bool
        var isExpanded: Bool
        var isVisible: Bool
        var value: String
        var primaryTitle: String
        var secondaryTitle: String
        var cellIdentifier: String
        var additionalRows: Int
    }

    @IBOutlet weak var myTableView: UITableView!
    
    var cellDescriptors: [[CellDescriptor]]!
    var visibleRowsPerSection = [[Int]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.myTableView.dataSource = self
        self.myTableView.delegate = self
        
        self.myTableView.tableFooterView = UIView(frame: .zero)
        
        self.myTableView.register(UINib(nibName: "NormalCell", bundle: nil), forCellReuseIdentifier: "idCellNormal")
        self.myTableView.register(UINib(nibName: "TextfieldCell", bundle: nil), forCellReuseIdentifier: "idCellTextfield")
        self.myTableView.register(UINib(nibName: "DatePickerCell", bundle: nil), forCellReuseIdentifier: "idCellDatePicker")
        self.myTableView.register(UINib(nibName: "SwitchCell", bundle: nil), forCellReuseIdentifier: "idCellSwitch")
        self.myTableView.register(UINib(nibName: "ValuePickerCell", bundle: nil), forCellReuseIdentifier: "idCellValuePicker")
        self.myTableView.register(UINib(nibName: "SliderCell", bundle: nil), forCellReuseIdentifier: "idCellSlider")
        
        self.loadCellDescriptors()
    }

    func loadCellDescriptors() {
        if let path = Bundle.main.path(forResource: "CellDescriptor", ofType: "plist") {
            let fileUrl = URL(fileURLWithPath: path)
            
            guard let codedCellDescriptors = try? Data(contentsOf: fileUrl) else { return }
            let decoder = PropertyListDecoder()
            
            self.cellDescriptors = try? decoder.decode([[CellDescriptor]].self, from: codedCellDescriptors)

            self.getIndicesOfVisibleRows()
            self.myTableView.reloadData()
        }
    }
    
    func getIndicesOfVisibleRows() {
        self.visibleRowsPerSection.removeAll()

        for currentSectionCells in self.cellDescriptors {
            var visibleRows = [Int]()

            for row in 0...(currentSectionCells.count - 1) {
                if currentSectionCells[row].isVisible == true {
                    visibleRows.append(row)
                }
            }

            self.visibleRowsPerSection.append(visibleRows)
        }
    }
    
    func getCellDescriptorForIndexPath(indexPath: IndexPath) -> CellDescriptor {
        let indexOfVisibleRow = self.visibleRowsPerSection[indexPath.section][indexPath.row]

        let cellDescriptor = cellDescriptors[indexPath.section][indexOfVisibleRow]
        
        return cellDescriptor
    }
}

extension TableViewAdvanced: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        if self.cellDescriptors != nil {
            return self.cellDescriptors.count
        }
        else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.visibleRowsPerSection[section].count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Personal"
     
        case 1:
            return "Preferences"
     
        default:
            return "Work Experience"
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let currentCellDescriptor = getCellDescriptorForIndexPath(indexPath: indexPath)

        switch currentCellDescriptor.cellIdentifier {
        case "idCellNormal":
            return 60.0
        case "idCellDatePicker":
            return 270.0
        default:
            return 44.0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let currentCellDescriptor = getCellDescriptorForIndexPath(indexPath: indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: currentCellDescriptor.cellIdentifier, for: indexPath) as! CustomCell

        if currentCellDescriptor.cellIdentifier == "idCellNormal" {
            cell.textLabel?.text = currentCellDescriptor.primaryTitle
            cell.detailTextLabel?.text = currentCellDescriptor.secondaryTitle
        }
        else if currentCellDescriptor.cellIdentifier == "idCellTextfield" {
            cell.textField.placeholder = currentCellDescriptor.primaryTitle
        }
        else if currentCellDescriptor.cellIdentifier == "idCellSwitch" {
            cell.lblSwitchLabel.text = currentCellDescriptor.primaryTitle

            let value = currentCellDescriptor.value
            cell.swMaritalStatus.isOn = (value == "true") ? true : false
        }
        else if currentCellDescriptor.cellIdentifier == "idCellValuePicker" {
            cell.textLabel?.text = currentCellDescriptor.primaryTitle
        }
        else if currentCellDescriptor.cellIdentifier == "idCellSlider" {
            let value = currentCellDescriptor.value
            if let value = Float(value) {
                cell.slExperienceLevel.value = value
            }
        }

        cell.delegate = self

        return cell
    }
}

extension TableViewAdvanced: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let indexOfTappedRow = visibleRowsPerSection[indexPath.section][indexPath.row]
        
        if cellDescriptors[indexPath.section][indexOfTappedRow].isExpandable == true {
            var shouldExpandAndShowSubRows = false
            if cellDescriptors[indexPath.section][indexOfTappedRow].isExpanded == false {
                shouldExpandAndShowSubRows = true
            }
            
            cellDescriptors[indexPath.section][indexOfTappedRow].isExpanded = shouldExpandAndShowSubRows
            
            for i in (indexOfTappedRow + 1)...(indexOfTappedRow + (cellDescriptors[indexPath.section][indexOfTappedRow].additionalRows)) {
                cellDescriptors[indexPath.section][i].isVisible = shouldExpandAndShowSubRows
            }
        }
        else {
            if cellDescriptors[indexPath.section][indexOfTappedRow].cellIdentifier == "idCellValuePicker" {
                var indexOfParentCell: Int!
                
                for i in (0...indexOfTappedRow - 1).reversed() {
                    if cellDescriptors[indexPath.section][i].isExpanded == true {
                        indexOfParentCell = i
                        break
                    }
                }
                cellDescriptors[indexPath.section][indexOfParentCell].primaryTitle =  (myTableView.cellForRow(at: indexPath) as! CustomCell).textLabel?.text ?? ""
                cellDescriptors[indexPath.section][indexOfParentCell].isExpanded = false
                
                for i in (indexOfParentCell + 1)...(indexOfParentCell + (cellDescriptors[indexPath.section][indexOfParentCell].additionalRows)) {
                    cellDescriptors[indexPath.section][i].isVisible = false
                }
            }
        }
        
        getIndicesOfVisibleRows()
        myTableView.reloadSections(IndexSet(integer: indexPath.section), with: UITableView.RowAnimation.fade)
    }
}

extension TableViewAdvanced: CustomCellDelegate {
    func dateWasSelected(selectedDateString: String) {
        let dateCellSection = 0
        let dateCellRow = 3

        cellDescriptors[dateCellSection][dateCellRow].primaryTitle = selectedDateString
        myTableView.reloadData()
    }
    
    func maritalStatusSwitchChangedState(isOn: Bool) {
        let maritalSwitchCellSection = 0
        let maritalSwitchCellRow = 6

        let valueToStore = (isOn) ? "true" : "false"
        let valueToDisplay = (isOn) ? "Married" : "Single"

        cellDescriptors[maritalSwitchCellSection][maritalSwitchCellRow].value = valueToStore
        cellDescriptors[maritalSwitchCellSection][maritalSwitchCellRow - 1].primaryTitle = valueToDisplay
        myTableView.reloadData()
    }
    
    func textfieldTextWasChanged(newText: String, parentCell: CustomCell) {
        let parentCellIndexPath = myTableView.indexPath(for: parentCell)

        let currentFullname = cellDescriptors[0][0].primaryTitle
        let fullnameParts = currentFullname.components(separatedBy: " ")

        var newFullname = ""

        if parentCellIndexPath?.row == 1 {
            if fullnameParts.count == 2 {
                newFullname = "\(newText) \(fullnameParts[1])"
            }
            else {
                newFullname = newText
            }
        }
        else {
            newFullname = "\(fullnameParts[0]) \(newText)"
        }

        cellDescriptors[0][0].primaryTitle = newFullname
        myTableView.reloadData()
    }
    
    func sliderDidChangeValue(newSliderValue: String) {
        cellDescriptors[2][0].primaryTitle = newSliderValue
        cellDescriptors[2][1].value = newSliderValue

        myTableView.reloadSections(IndexSet(integer: 2), with: UITableView.RowAnimation.none)
    }
}

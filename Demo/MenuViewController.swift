//
//  MenuViewController.swift
//  Demo
//
//  Created by Tony Huang (黃崇漢) on 2018/5/21.
//  Copyright © 2018年 Tony Huang (黃崇漢). All rights reserved.
//

import UIKit

enum MenuData: String, CaseIterable {
    case PageAnimation
    case Formfeed
    case PullRefresh
    case SearchController
    case ViewAnimate
    case AutolayoutEqualWidth
    case AlertControllerShowImage
//    case CollectionViewAutosizing
    case InformationSecurity
    case DataProtection
    case DataSecurity
    case NumberLock
    case PrimeNumber
    case ColorFinder
    case UserDefaultsSaveObject
    case PlayAudio
    case MKMap
    case ToDoList
    case GCD
    case Operation
    case Session
    case RandomUser
    case RSSReader
    case eBook
    case eBook2
    case ThreeDTouch
    case Calculator
    case DrawSomething
    case MyCalendar
    case DropDownMenu
    case UnwindSegue
    case Gif
    case AttributedString
    case TableViewAdvanced
    case Banners
    case MAVPlayer
    case HeaderAnimation
    case Localization
    case WebView
    case Rainbow
    case SideMenu
    case Draw
    case Popover
    case QRCode
    case CoreImage
    case CoreSpotlight
    case Health
    case Layer
    case FaceDetection
    case ProtocolOrientedProgramming
    case ShapeFactory
    case ObserverDesignPattern
    case MementoDesignPattern
    case FacadeDesignPattern
    case AdapterDesignPattern
    case NetworkFramework
    case CompositionalLayout
    case StateMachine
    case DragAndDrop
    case CoreBluetooth
    case Lottie
    case SwiftUIVC
    case SpeechSynthesizer
    case Graphics
    case TransparentNavigation
    case LocalNotification
    case GesturePassword
    case iBeacon
    case AssistiveTouch
    case DiffableDataSource
    case SignIn
    case SoftwareArchitecture
    case StarTrail
    case SVG
    case ScrollView
    case IAP
    case Stopwatch
    case RippleEffect
}

private let reuseIdentifier = "reuseCell"

class MenuViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        APIManager.shared.navigationController = self.navigationController
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MenuData.allCases.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        
        cell.textLabel?.text = MenuData.allCases[indexPath.row].rawValue
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = MenuData.allCases[indexPath.row]
        let story = UIStoryboard.init(name: "Main", bundle: nil)
        let vc = story.instantiateViewController(withIdentifier: data.rawValue)
        if ((vc as? UINavigationController) != nil) || data == MenuData.Formfeed {
            self.present(vc, animated: true, completion: nil)
        }
        else {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

class CallStack {
    static let shared = CallStack()
    
    func print() {
        for symbol in Thread.callStackSymbols {
            Swift.print(symbol)
        }
    }
}

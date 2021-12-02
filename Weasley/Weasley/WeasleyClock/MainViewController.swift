//
//  ViewController.swift
//  Weasley
//
//  Created by Doyoung on 2021/10/25.
//

import UIKit
import CoreLocation
import SnapKit

class MainViewController: UIViewController {

    //MARK: Sample Property
    var latitude = ""
    var longitude = ""
    
    let locationManager = CLLocationManager()
    //let viewModel = CurrentLocations.share
    /**
        [Sub : Needle View]
     */
    var needles = [String : Needle]()
    
    override func loadView() {
        super.loadView()
        view.backgroundColor = .systemBackground
        self.view.addSubview(menuButton)
        menuButton.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.trailing.equalToSuperview().offset(-20)
        }
        self.view.addSubview(clockView)
        clockView.snp.makeConstraints { make in
            make.height.equalTo(self.view.frame.width)
            make.width.equalToSuperview()
            make.top.equalTo(menuButton.snp.bottom)
        }
        self.view.addSubview(arcLocationLabel)
        arcLocationLabel.snp.makeConstraints { make in
            make.top.equalTo(clockView.snp.top)
            make.bottom.equalTo(clockView.snp.bottom)
            make.leading.equalTo(clockView.snp.leading)
            make.trailing.equalTo(clockView.snp.trailing)
        }
       self.view.addSubview(relocateButton)
        relocateButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.width.equalTo(50)
            make.centerX.equalTo(arcLocationLabel.snp.centerX)
            make.centerY.equalTo(arcLocationLabel.snp.centerY)
        }
        //MARK: Sample UI
        self.view.addSubview(groupCollectionView)
        groupCollectionView.snp.makeConstraints { make in
            make.top.equalTo(clockView.snp.bottom)
            make.leading.equalToSuperview()
            make.trailing.equalTo(menuButton.snp.leading)
            make.height.equalTo(50)
        }
        self.view.addSubview(membersTableView)
        membersTableView.snp.makeConstraints { make in
            make.top.equalTo(groupCollectionView.snp.bottom)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization() // 위치 서비스를 사용하기 위한 사용자 권한 요청
        locationManager.requestLocation() // 사용자의 현재 위치에 대한 일회성 전달을 요청
        if #available(iOS 14.0, *) {
            menuButton.showsMenuAsPrimaryAction = true
            menuButton.menu = menu
        } else {
            showActionSheet()
        }
    }
    
//    func loadNeedles(area: Location) {
//        let needle = Needle()
//        needle.text = viewModel.currentUser
//        needle.value = area.location
//        self.view.addSubview(needle)
//        needle.snp.makeConstraints { make in
//            make.centerX.equalTo(arcLocationLabel.snp.centerX)
//            make.centerY.equalTo(arcLocationLabel.snp.centerY)
//        }
//        needles.updateValue(needle, forKey: viewModel.currentUser)
//    }

    //MARK: Sample load view
    func moveNeedle(_ member: Member) {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 1) {
                self.needles[member.user.sub]?.value = member.currentLoction.location
            }
        }
    }
    
    //MARK: UIView
    private lazy var arcLocationLabel: LocationLabel = {
        let label = LocationLabel()
        label.backgroundColor = .clear
        return label
    }()
    private lazy var clockView: Clock = {
        let view = Clock(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        view.backgroundColor = .clear
        return view
    }()
    private lazy var relocateButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "safari.fill"), for: .normal)
        button.tintColor = .systemRed
        button.addTarget(self, action: #selector(reLocate), for: .touchUpInside)
        return button
    }()
    private lazy var menuButton: UIButton = {
        let button = UIButton()
        let config = UIImage.SymbolConfiguration(pointSize: 30)
        button.setImage(UIImage(systemName: "ellipsis.circle.fill", withConfiguration: config), for: .normal)
        return button
    }()
    private lazy var groupCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 120, height: 120)
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.register(GroupCell.self, forCellWithReuseIdentifier: "groupCell")
        return collectionView
    }()
    private lazy var membersTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .systemIndigo
        return tableView
    }()
    private lazy var menu: UIMenu = {
        return UIMenu(title: "", options: [], children: menuItems)
    }()
    private lazy var menuItems: [UIAction] = {
        return [
            UIAction(title: "Invite member", image: UIImage(systemName: "paperplane.fill"), handler: { _ in
                self.inviteMember()
            }),
            UIAction(title: "Setting", image: UIImage(systemName: "gearshape.fill"), handler: { _ in
                //TODO: Implement Setting View
            }),
            UIAction(title: "Mark", image: UIImage(systemName: "gearshape.fill"), handler: { _ in
                self.goEdit()
            }),
            UIAction(title: "Sign Out", image: UIImage(systemName: "rectangle.portrait.and.arrow.right"), handler: { _ in
                self.signOut()
            })
        ]
    }()
    
    private func showActionSheet() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        for action in alertActions {
            alert.addAction(action)
        }
    }
    
    private lazy var alertActions: [UIAlertAction] = {
        return [
            UIAlertAction(title: "Invite", style: .default, handler: { _ in
                self.inviteMember()
            }),
            UIAlertAction(title: "Edit Mark", style: .default, handler: { _ in
                self.goEdit()
            }),
            UIAlertAction(title: "Setting", style: .default, handler: { _ in
                //TODO: Implement Setting View
            }),
            UIAlertAction(title: "Sign Out", style: .default, handler: { _ in
                self.signOut()
            }),
            UIAlertAction(title: "Cancel", style: .cancel)
        ]
    }()
}

extension MainViewController {
    
    func signOut() {
        Login().signOut()
        dismiss(animated: true, completion: nil)
    }
    
    @objc func reLocate() {
        locationManager.requestLocation()
    }
    
    func goEdit() {
        let destinationVC = MapPinViewController()
        destinationVC.lat = latitude
        destinationVC.long = longitude
        destinationVC.modalPresentationStyle = .overFullScreen
        present(destinationVC, animated: true, completion: nil)
    }
    
    func inviteMember() {
        let message = ["Message and link.."] // TODO: Link message
        let activityVC = UIActivityViewController(activityItems: message, applicationActivities: nil)
        if UIDevice.current.userInterfaceIdiom == .pad {
            if let popup = activityVC.popoverPresentationController {
                popup.sourceView = self.view
                popup.sourceRect = CGRect(x: self.view.frame.size.width / 2, y: self.view.frame.size.height, width: 0, height: 0)
            }
        }
        self.present(activityVC, animated: true, completion: nil)
    }
}

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "groupCell", for: indexPath) as? GroupCell else {
            return UICollectionViewCell()
        }
        cell.groupNameLabel.text = ""
        return cell
    }
}
extension MainViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let digit: Double = pow(10, 3)
            let lat = String(round(location.coordinate.latitude * digit) / digit)
            let long = String(round(location.coordinate.longitude * digit) / digit)
            self.latitude = lat
            self.longitude = long
            print("\(lat) & \(long)")
//            viewModel.postLocation(latitude: lat, longitude: long) { [weak self] area in
//                self?.loadNeedles(area: area.area)
//            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Cancel Location")
        print("Error: \(error.localizedDescription)")
    }
    
}

//
//  ViewController.swift
//  Weasley
//
//  Created by Doyoung on 2021/10/25.
//

import UIKit
import CoreLocation
import SnapKit
import MapKit

var sampleUser = [UserArea(area: .lost)]
var sampleGroup = ["Hello", "World"]

class MainViewController: UIViewController {

    let locationManager = CLLocationManager()
    let viewModel = CurrentLocations.share
    /**
        [Email : Needle View]
     */
    var needles = [String : Needle]()
    
    override func loadView() {
        super.loadView()
        view.backgroundColor = .secondarySystemBackground
        self.view.addSubview(clockView)
        self.view.addSubview(arcLocationLabel)
        self.view.addSubview(menuButton)
        self.view.addSubview(relocateButton)
        self.view.addSubview(addGroupButton)
        self.view.addSubview(membersTableView)
        self.view.addSubview(groupsScrollView)
        self.clockView.addSubview(userLocationMapView)
        menuButton.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeArea.top).offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }
        clockView.snp.makeConstraints { make in
            make.height.equalTo(self.view.frame.width)
            make.width.equalToSuperview()
            make.top.equalTo(self.view.safeArea.top)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        arcLocationLabel.snp.makeConstraints { make in
            make.top.equalTo(clockView.snp.top)
            make.bottom.equalTo(clockView.snp.bottom)
            make.leading.equalTo(clockView.snp.leading)
            make.trailing.equalTo(clockView.snp.trailing)
        }
        userLocationMapView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.bottom.equalToSuperview().offset(-20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
        relocateButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.width.equalTo(50)
            make.centerX.equalTo(arcLocationLabel.snp.centerX)
            make.centerY.equalTo(arcLocationLabel.snp.centerY)
        }
        membersTableView.snp.makeConstraints { make in
            make.top.equalTo(clockView.snp.bottom)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalTo(groupsScrollView.snp.top)
        }
        groupsScrollView.snp.makeConstraints { make in
            make.height.equalTo(80)
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        groupsScrollView.delegate = self
        membersTableView.delegate = self
        membersTableView.dataSource = self
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization() // 위치 서비스를 사용하기 위한 사용자 권한 요청
        locationManager.requestLocation() // 사용자의 현재 위치에 대한 일회성 전달을 요청
        if #available(iOS 14.0, *) {
            menuButton.showsMenuAsPrimaryAction = true
            menuButton.menu = menu
        } else {
            showActionSheet()
        }
        self.userLocationMapView.delegate = self
        self.userLocationMapView.alpha = 0
        loadGroupLabels()
        loadNeedles()
        self.hero.isEnabled = true
        self.view.hero.id = "main"
    }
    
    func loadNeedles() {
        for user in sampleUser {
            let needle = Needle()
            needle.text = viewModel.currentUser
            needle.value = user.area.location
            self.view.addSubview(needle)
            needle.snp.makeConstraints { make in
                make.centerX.equalTo(arcLocationLabel.snp.centerX)
                make.centerY.equalTo(arcLocationLabel.snp.centerY)
            }
            needles.updateValue(needle, forKey: viewModel.currentUser)
        }
    }

    //MARK: Sample load view
    func moveNeedle() {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 3) {
                self.needles[self.viewModel.currentUser]?.value = Location.move.location
                //member.currentLoction.location
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
    
    private lazy var userLocationMapView: MKMapView = {
        let mapView = MKMapView()
        mapView.rounded((UIScreen.main.bounds.width - 40) / 2)
        return mapView
    }()
    
    private lazy var addGroupButton: UIButton = {
        let button = UIButton()
        let config = UIImage.SymbolConfiguration(pointSize: 30)
        button.setImage(UIImage(systemName: "plus.circle.fill", withConfiguration: config), for: .normal)
        button.addTarget(self, action: #selector(addGroup), for: .touchUpInside)
        return button
    }()
    
    private lazy var menuButton: UIButton = {
        let button = UIButton()
        let config = UIImage.SymbolConfiguration(pointSize: 24)
        button.setImage(UIImage(systemName: "ellipsis.circle", withConfiguration: config), for: .normal)
        return button
    }()
    
    private lazy var groupsScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width * 4, height: scrollView.contentSize.height)
        scrollView.backgroundColor = .systemGray
        scrollView.isPagingEnabled = true
        return scrollView
    }()
    
    private lazy var sampleGroupName: UILabel = {
        let label = UILabel()
        print(UIScreen.main.bounds.height)
        print(self.view.frame.maxY)
        label.frame = CGRect(x: UIScreen.main.bounds.width * 0, y: 0, width: self.view.frame.width, height: 80)
        label.font = UIFont.systemFont(ofSize: 60, weight: .black)
        label.backgroundColor = .systemBackground
        label.text = "Hello World!"
        let gradientLayer = CAGradientLayer()
        gradientLayer.getGradientLayer(
            colors: UIColor().themeColors,
            alpha: 1,
            frame: label.bounds,
            startPoint: CGPoint(x: 0.0, y: 0.5),
            endPoint: CGPoint(x: 1.0, y: 0.5)
        )
        label.textColor = .gradientColor(bounds: label.bounds, gradientLayer: gradientLayer)
        label.textAlignment = .center
        return label
    }()
    
    func loadGroupLabels() {
        self.groupsScrollView.addSubview(sampleGroupName)
    }
    
    private lazy var membersTableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .insetGrouped)
        tableView.register(MemberCell.self, forCellReuseIdentifier: "memberCell")
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
                self.goSetting()
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
            UIAlertAction(title: "Setting", style: .default, handler: { _ in
                self.goSetting()
            }),
            UIAlertAction(title: "Sign Out", style: .default, handler: { _ in
                self.signOut()
            }),
            UIAlertAction(title: "Cancel", style: .cancel)
        ]
    }()
    
    private func setMemberMenu(index member: Int) -> UIMenu {
        let items = [
            UIAction(title: "Request Location", image: UIImage(systemName: "exclamationmark.bubble"), handler: { _ in
                //TODO: Send Push
            }),
            UIAction(title: "Show Location", image: UIImage(systemName: "binoculars.fill"), handler: { _ in
                //TODO: Show Map
                let mapView = self.userLocationMapView
                mapView.removeOverlays(mapView.overlays)
                let loc = CLLocationCoordinate2D(latitude: 37.365, longitude: 127.107)
                //MARK: SET MEMBER INDEX
                //let loc = CLLocationCoordinate2D(latitude: <#T##CLLocationDegrees#>, longitude: <#T##CLLocationDegrees#>)
                let circle = MKCircle(center: loc, radius: 200)
                let span = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
                mapView.setRegion(MKCoordinateRegion(center: loc, span: span), animated: true)
                mapView.addOverlay(circle)
                mapView.animateToHide()
            })
        ]
        return UIMenu(title: "", options: [], children: items)
    }
}

extension MainViewController {
    
    func signOut() {
        Login().signOut()
        dismiss(animated: true, completion: nil)
    }
    
    @objc func reLocate() {
        locationManager.requestLocation()
    }
    
    func goSetting() {
        let rootVC = SettingTableViewController()
        let destinationVC = UINavigationController(rootViewController: rootVC)
        destinationVC.modalPresentationStyle = .fullScreen
        present(destinationVC, animated: true, completion: nil)
    }
    
    //MARK: To Do add Action Method
    @objc func addGroup() {
       print("")
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

//MARK: TABLE VIEW DELEGATE
extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "memberCell", for: indexPath) as? MemberCell else {
           return UITableViewCell()
        }
        cell.textLabel?.text = "Test"
        return cell
    }
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(identifier: nil,
                                          previewProvider: nil,
                                          actionProvider: {_ in
            return self.setMemberMenu(index: 0)
        })
    }
}

//MARK: CORE LOCATION MANGER DELEGATE
extension MainViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            let digit: Double = pow(10, 3)
            let lat = String(round(location.coordinate.latitude * digit) / digit)
            let long = String(round(location.coordinate.longitude * digit) / digit)
            if lat != viewModel.userLatitude || long != viewModel.userLongitude {
                viewModel.userLatitude = lat
                viewModel.userLongitude = long
                print("Lat: \(viewModel.userLatitude!), Long:  \(viewModel.userLongitude!)")
                self.moveNeedle()
                viewModel.postLocation() { [weak self] area in
                    //self?.loadNeedles(area: area.area)
                    self?.moveNeedle()
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Cancel Location")
        print("Error: \(error.localizedDescription)")
    }
    
}

extension MainViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        guard let circleOverlay = overlay as? MKCircle else {
            return MKOverlayRenderer()
        }
        let circleRenderer = MKCircleRenderer(overlay: circleOverlay)
        circleRenderer.fillColor = .systemBlue
        circleRenderer.alpha = 0.7
        return circleRenderer
    }
}

//
//  ViewController.swift
//  Weasley
//
//  Created by Doyoung on 2021/10/25.
//

import UIKit
import SnapKit
import MapKit

class MainViewController: UIViewController {

    /**
        [Email : Needle View]
     */
    var needles = [String : Needle]()
    
    override func loadView() {
        super.loadView()
        view.backgroundColor = .secondarySystemBackground
        self.view.addSubview(clockView)
        self.view.addSubview(arcLocationLabel)
        self.view.addSubview(membersTableView)
        self.view.addSubview(groupsScrollView)
        self.clockView.addSubview(userLocationMapView)
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
        self.userLocationMapView.delegate = self
        self.userLocationMapView.alpha = 0
        loadGroupLabels()
//        loadNeedles()
        self.hero.isEnabled = true
        self.view.hero.id = "main"
    }
    
    func loadNeedles() {
        for user in sampleUser {
            let needle = Needle()
            //needle.text = viewModel.currentUser
            needle.value = user.area.location
            self.view.addSubview(needle)
            needle.snp.makeConstraints { make in
                make.centerX.equalTo(arcLocationLabel.snp.centerX)
                make.centerY.equalTo(arcLocationLabel.snp.centerY)
            }
            //needles.updateValue(needle, forKey: viewModel.currentUser)
        }
    }

    //MARK: Sample load view
    func moveNeedle() {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 3) {
                //self.needles[self.viewModel.currentUser]?.value = Location.move.location
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
    
    private lazy var userLocationMapView: MKMapView = {
        let mapView = MKMapView()
        mapView.rounded((UIScreen.main.bounds.width - 40) / 2)
        return mapView
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

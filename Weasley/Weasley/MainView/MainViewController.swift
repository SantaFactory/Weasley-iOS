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
        self.view.addSubview(groupNameLabel)
        self.clockView.addSubview(userLocationMapView)
        self.view.addSubview(backButton)
        groupNameLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.top.equalTo(self.view.safeArea.top)
        }
        clockView.snp.makeConstraints { make in
            make.height.equalTo(self.view.frame.width)
            make.width.equalToSuperview()
            make.top.equalTo(groupNameLabel.snp.bottom)
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
            make.bottom.equalTo(backButton.snp.bottom)
        }
        backButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.bottom.equalTo(self.view.safeArea.bottom).offset(-20)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        membersTableView.delegate = self
        membersTableView.dataSource = self
        self.userLocationMapView.delegate = self
        self.userLocationMapView.alpha = 0
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
    
    private lazy var groupNameLabel: UILabel = {
        let label = UILabel()
        let gradientLayer = CAGradientLayer()
        gradientLayer.getGradientLayer(
            colors: UIColor().themeColors,
            alpha: 0.6,
            frame: self.view.bounds,
            startPoint: CGPoint(x: 0.0, y: 0.5),
            endPoint: CGPoint(x: 1.0, y: 0.5)
        )
        let color = UIColor.gradientColor(bounds: self.view.bounds, gradientLayer: gradientLayer)
        label.frame = CGRect(x: UIScreen.main.bounds.width * 0, y: 0, width: self.view.frame.width, height: 40)
        label.font = UIFont.systemFont(ofSize: 30, weight: .black)
        label.backgroundColor = .clear
        label.text = "Hello World!"
        label.textColor = color
        label.textAlignment = .center
        return label
    }()
    
    
    private lazy var membersTableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .insetGrouped)
        tableView.register(MemberCell.self, forCellReuseIdentifier: "memberCell")
        return tableView
    }()
    
    private lazy var backButton: UIButton = {
        let button = UIButton(type: .system)
        button.addTarget(self, action: #selector(back), for: .touchUpInside)
        let configuration = UIImage.SymbolConfiguration(pointSize: 30)
        button.setImage(UIImage(systemName: "chevron.backward.circle.fill", withConfiguration: configuration), for: .normal)
        button.tintColor = .white
        return button
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
    
    @objc private func back() {
        self.dismiss(animated: true, completion: nil)
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

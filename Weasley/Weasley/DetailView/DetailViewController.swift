//
//  ViewController.swift
//  Weasley
//
//  Created by Doyoung on 2021/10/25.
//

import UIKit
import SnapKit
import MapKit

class DetailViewController: UIViewController {
    
    var viewModel: Detail
    
    init(viewModel: Detail) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        view.backgroundColor = .secondarySystemBackground
        self.view.addSubview(clockView)
        self.view.addSubview(arcLocationLabel)
        self.view.addSubview(membersTableView)
        self.view.addSubview(groupNameLabel)
        self.arcLocationLabel.addSubview(userLocationMapView)
        self.view.addSubview(backButton)
        self.view.addSubview(inviteButton)
        groupNameLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.top.equalTo(self.view.safeArea.top).offset(20)
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
            make.top.equalToSuperview().offset(60)
            make.bottom.equalToSuperview().offset(-60)
            make.leading.equalToSuperview().offset(60)
            make.trailing.equalToSuperview().offset(-60)
        }
        membersTableView.snp.makeConstraints { make in
            make.top.equalTo(clockView.snp.bottom)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalTo(backButton.snp.top)
        }
        backButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.bottom.equalTo(self.view.safeArea.bottom).offset(-20)
        }
        inviteButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-20)
            make.centerY.equalTo(backButton.snp.centerY)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        groupNameLabel.text = viewModel.groupName
        membersTableView.delegate = self
        membersTableView.dataSource = self
        self.userLocationMapView.delegate = self
        self.userLocationMapView.alpha = 0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        viewModel.loadGroupDetail {
//            self.membersTableView.reloadData()
//        }
//        viewModel.loadMembers()
        loadNeedles()
    }
    
    var needles = [Int : Needle]()
    
    func loadNeedles() {
        for member in viewModel.members! {
            let needle = Needle()
            let shadow = NSShadow()
            shadow.shadowColor = UIColor.green
            shadow.shadowBlurRadius = 5
            let attributes: [NSAttributedString.Key: Any] = [
                .shadow: shadow
            ]
            needle.attributedText  = NSAttributedString(string: member.name, attributes: attributes)
            needle.textAlignment = .right
            needle.font = UIFont.systemFont(ofSize: 20, weight: .light)
            //TODO: Set needle.value
            needle.value = member.currentPlace.location
            self.view.addSubview(needle)
            needle.snp.makeConstraints { make in
                make.width.equalTo((arcLocationLabel.bounds.width / 2) - 40)
                make.centerX.equalTo(arcLocationLabel.snp.centerX)
                make.centerY.equalTo(arcLocationLabel.snp.centerY)
            }
            //TODO: Set needles Key
            needles.updateValue(needle, forKey: member.id)
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
        mapView.rounded((UIScreen.main.bounds.width - 120) / 2)
        return mapView
    }()
    
    private lazy var groupNameLabel: UILabel = {
        let label = UILabel()
        let gradientLayer = CAGradientLayer()
        label.frame = CGRect(x: UIScreen.main.bounds.width * 0, y: 0, width: self.view.frame.width, height: 40)
        label.font = UIFont.systemFont(ofSize: 30, weight: .light)
        label.backgroundColor = .clear
        label.textAlignment = .center
        return label
    }()
    
    
    private lazy var membersTableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .insetGrouped)
        tableView.backgroundColor = .clear
        tableView.register(MemberCell.self, forCellReuseIdentifier: MemberCell.reuseID)
        return tableView
    }()
    
    private lazy var backButton: UIButton = {
        let button = UIButton(type: .system)
        button.addTarget(self, action: #selector(back), for: .touchUpInside)
        let configuration = UIImage.SymbolConfiguration(pointSize: 20)
        button.setImage(UIImage(systemName: SystemImage.backFill.name, withConfiguration: configuration), for: .normal)
        button.tintColor = .themeGreen
        return button
    }()
    
    private lazy var inviteButton: UIButton = {
        let button = UIButton(type: .system)
        button.addTarget(self, action: #selector(inviteMember), for: .touchUpInside)
        if #available(iOS 15.0, *) {
            button.configuration = .filled()
        }
        button.setTitle("Invite friends", for: .normal)
        button.setImage(UIImage(systemName: SystemImage.invite.name), for: .normal)
        button.tintColor = .themeGreen
        return button
    }()
    
    private func setMemberMenu(index: Int) -> UIMenu {
        let items = [
            UIAction(title: "Request Location", image: UIImage(systemName: SystemImage.requestMessage.name), handler: { _ in
                //TODO: Send Push
            }),
            UIAction(title: "Show Current Location", image: UIImage(systemName: SystemImage.show.name), handler: { _ in
                let mapView = self.userLocationMapView
                mapView.removeOverlays(mapView.overlays)
                let member = self.viewModel.members![index]
                let loc = CLLocationCoordinate2D(latitude: member.latitude, longitude: member.longitude)
                let circle = MKCircle(center: loc, radius: 200)
                let span = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
                mapView.setRegion(MKCoordinateRegion(center: loc, span: span), animated: true)
                mapView.addOverlay(circle)
                mapView.animateToHide(showAlpha: 0.3)
            })
        ]
        return UIMenu(title: "", options: [], children: items)
    }
}

extension DetailViewController {
    
    @objc private func back() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc private func inviteMember() {
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
extension DetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.members?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MemberCell.reuseID, for: indexPath) as? MemberCell else {
           return UITableViewCell()
        }
        cell.selectionStyle = .none
        cell.nameLabel.text = viewModel.members?[indexPath.row].name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let member = viewModel.members?[indexPath.row] else {
            return
        }
        DispatchQueue.main.async {
            UIView.animate(withDuration: 2) {
                self.needles[member.id]!.value = member.currentPlace.location
            }
        }
    }
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(identifier: nil,
                                          previewProvider: nil,
                                          actionProvider: {_ in
            return self.setMemberMenu(index: indexPath.row)
        })
    }
}

extension DetailViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        guard let circleOverlay = overlay as? MKCircle else {
            return MKOverlayRenderer()
        }
        let circleRenderer = MKCircleRenderer(overlay: circleOverlay)
        circleRenderer.fillColor = .systemRed
        circleRenderer.alpha = 0.4
        return circleRenderer
    }
}
//MARK: Table View Cell
class MemberCell: UITableViewCell {
    
    fileprivate static let reuseID = "MemberTableViewCellReuseID"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.centerY.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        return label
    }()
}

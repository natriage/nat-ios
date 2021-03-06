//
//  RespondersViewController.swift
//  Triage
//
//  Created by Francis Li on 9/29/20.
//  Copyright © 2020 Francis Li. All rights reserved.
//

import RealmSwift
import UIKit

class RespondersViewController: UIViewController, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate,
                                SortBarDelegate {
    @IBOutlet weak var searchBar: SearchBar!
    @IBOutlet weak var sortBar: SortBar!
    @IBOutlet weak var tableView: UITableView!

    var searchBarShouldBeginEditing = true
    var sort: ResponderSort = .az
    var results: Results<Responder>?
    var notificationToken: NotificationToken?

    var scene: Scene!
    var sceneNotificationToken: NotificationToken?

    deinit {
        notificationToken?.invalidate()
        sceneNotificationToken?.invalidate()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // set initial sort
        sortBar.dropdownButton.setTitle(sort.description, for: .normal)
        // hide until sorts implemented
        sortBar.isHidden = true

        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        tableView.refreshControl = refreshControl

        tableView.register(UserTableViewCell.self, forCellReuseIdentifier: "User")

        guard let sceneId = AppSettings.sceneId else { return }
        scene = AppRealm.open().object(ofType: Scene.self, forPrimaryKey: sceneId)
        sceneNotificationToken = scene.observe { [weak self] (change) in
            self?.didObserveSceneChange(change)
        }

        performQuery()
        refresh()
    }

    private func performQuery() {
        notificationToken?.invalidate()

        var predicates: [NSPredicate] = []
        predicates.append(NSPredicate(format: "scene.id=%@", scene.id))
        if let text = searchBar.text, !text.isEmpty {
            predicates.append(NSPredicate(format: "user.firstName CONTAINS[cd] %@ OR user.lastName CONTAINS[cd] %@", text, text))
        }

        var sorts: [SortDescriptor] = []
        switch sort {
        case .az:
            sorts.append(SortDescriptor(keyPath: "user.firstName", ascending: true))
            sorts.append(SortDescriptor(keyPath: "user.lastName", ascending: true))
        }
        sorts.append(SortDescriptor(keyPath: "arrivedAt", ascending: false))

        let realm = AppRealm.open()
        results = realm.objects(Responder.self)
            .filter(predicates.count == 1 ? predicates[0] : NSCompoundPredicate(andPredicateWithSubpredicates: predicates))
            .sorted(by: sorts)
            .distinct(by: ["user.id"])
        notificationToken = results?.observe { [weak self] (changes) in
            self?.didObserveResultsChanges(changes)
        }
    }

    private func didObserveResultsChanges(_ changes: RealmCollectionChange<Results<Responder>>) {
        switch changes {
        case .initial:
            tableView.reloadData()
        case .update(_, let deletions, let insertions, let modifications):
            tableView.performBatchUpdates({ [weak self] in
                self?.tableView.insertRows(at: insertions.map { IndexPath(row: $0, section: 0) }, with: .automatic)
                self?.tableView.deleteRows(at: deletions.map { IndexPath(row: $0, section: 0) }, with: .automatic)
                self?.tableView.reloadRows(at: modifications.map { IndexPath(row: $0, section: 0) }, with: .automatic)
            }, completion: nil)
        case .error(let error):
            presentAlert(error: error)
        }
    }

    func didObserveSceneChange(_ change: ObjectChange<Scene>) {
        switch change {
        case .change:
            tableView.reloadData()
        case .error(let error):
            presentAlert(error: error)
        case .deleted:
            break
        }
    }

    @objc func refresh() {
        tableView.refreshControl?.beginRefreshing()
        AppRealm.getResponders(sceneId: scene.id) { [weak self] (error) in
            DispatchQueue.main.async { [weak self] in
                self?.tableView.refreshControl?.endRefreshing()
                if let error = error {
                    self?.presentAlert(error: error)
                }
            }
        }
    }

    // MARK: - SortBarDelegate

    func sortBar(_ sortBar: SortBar, willShow selectorView: SelectorView) {
        for sort in ResponderSort.allCases {
            selectorView.addButton(title: sort.description)
        }
    }

    func sortBar(_ sortBar: SortBar, selectorView: SelectorView, didSelectButtonAtIndex index: Int) {
        if sort != ResponderSort.allCases[index] {
            sort = ResponderSort.allCases[index]
            performQuery()
        }
    }

    // MARK: - UISearchBarDelegate

    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return .topAttached
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if !searchBar.isFirstResponder {
            searchBarShouldBeginEditing = false
        }
        performQuery()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }

    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        let result = searchBarShouldBeginEditing
        searchBarShouldBeginEditing = true
        return result
    }

    // MARK: - UITableViewDataSource

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "User", for: indexPath)
        if let cell = cell as? UserTableViewCell, let responder = results?[indexPath.row] {
            cell.configure(from: responder, isMGS: responder.user?.id == scene.incidentCommanderId)
        }
        return cell
    }

    // MARK: - UITableViewDelegate

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = UIStoryboard(name: "Users", bundle: nil).instantiateViewController(withIdentifier: "Responder")
        if let vc = vc as? ResponderViewController, let responder = results?[indexPath.row] {
            vc.responder = responder
            presentAnimated(vc)
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
}

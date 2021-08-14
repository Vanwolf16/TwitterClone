//
//  ExploreController.swift
//  TwitterClone
//
//  Created by David Murillo on 6/14/21.
//

import UIKit

class ExploreController: UITableViewController {
    
    //MARK:Properties
    private var users = [User](){
        didSet{tableView.reloadData()}
    }
    //Search Bars
    private var filteredUsers = [User](){
        didSet{tableView.reloadData()}
    }
    
    private var inSearchMode:Bool{
        return searchController.isActive && !searchController.searchBar.text!.isEmpty
    }
    
    private let searchController = UISearchController(searchResultsController: nil)
    
    //MARK:LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        fetchUsers()
        configureSearchController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.navigationBar.barStyle = .default
    }
    
    //MARK:Helper
    func configureUI(){
        view.backgroundColor = .white
        navigationItem.title = "Explore"
        
        tableView.register(UserCell.self, forCellReuseIdentifier: UserCell.reuseIdentifer)
        tableView.rowHeight = 60
        tableView.separatorStyle = .none
    }
    
    func fetchUsers(){
        UserService.shared.fetchUsers {[weak self] users in
            self?.users = users
        }
    }
    
    func configureSearchController(){
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = "Search for User..."
        navigationItem.searchController = searchController
        definesPresentationContext = false
    }

}
//MARK: Datasource and Delegate
extension ExploreController{
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return inSearchMode ? filteredUsers.count : users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UserCell.reuseIdentifer, for: indexPath) as! UserCell
        let user = inSearchMode ? filteredUsers[indexPath.row] : users[indexPath.row]
        cell.user = user
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

extension ExploreController:UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else {return}
        filteredUsers = users.filter({$0.username.contains(searchText)
            || $0.fullname.contains(searchText)
        })
    }
}

//
//  AccountSummaryViewController.swift
//  Bankey
//
//  Created by Mpilo Pillz on 2022/11/06.
//

import UIKit

class AccountSummaryViewController: UIViewController {
    
    // Request Models
    var profile: Profile?
    var accounts: [Account] = []
    
    // View Models
    var headerViewModel = AccountSummaryHeaderView.ViewModel(welcomeMessage: "Welcome", name: "", date: Date())
    
    var accountCellViewModels: [AccountSummaryCell.ViewModel] = []
    
    // Compoents
    var tableView = UITableView()
    var headerView = AccountSummaryHeaderView(frame: .zero)
    let refreshControl = UIRefreshControl()
    
    // Networking
    var profileManager: ProfileManageble = ProfileManager()
    var isLoaded = false
    
    // Error alert
    lazy var errorAlert: UIAlertController = {
        let alert = UIAlertController(title: "", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        return alert
    }()
    
    
    // Instantiated only when needed
    lazy var logoutBarButtonItem: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logoutTapped))
        barButtonItem.tintColor = .label
        return barButtonItem
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        
    }
    
    
}

extension AccountSummaryViewController {
    private func setup() {
        setupNavigationBar()
        setupTableView()
        setupTableHeaderView()
        setupRefreshControl()
        setupSkeletons()
        fetchData()
    }
    
    private func setupTableView() {
        tableView.backgroundColor = appColor
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(AccountSummaryCell.self, forCellReuseIdentifier: AccountSummaryCell.reuseID)
        tableView.register(SkeletonCell.self, forCellReuseIdentifier: SkeletonCell.reuseID)
        tableView.rowHeight = AccountSummaryCell.rowHeight
        tableView.tableFooterView = UIView()
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func setupTableHeaderView() {
        
        var size = headerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        size.width = UIScreen.main.bounds.width
        headerView.frame.size = size
        
        tableView.tableHeaderView = headerView
    }
    
    func setupNavigationBar() {
        navigationItem.rightBarButtonItem = logoutBarButtonItem
    }
    
    private func setupRefreshControl() {
        refreshControl.tintColor = appColor
        refreshControl.addTarget(self, action: #selector(refreshContent), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
    
    private func setupSkeletons() {
        let row = Account.makeSkeleton()
        accounts = Array(repeating: row, count: 10)
        
        configureTableCells(with: accounts)
    }
}

extension AccountSummaryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard !accountCellViewModels.isEmpty else {return UITableViewCell()}
        let account = accountCellViewModels[indexPath.row]
        if isLoaded {
            let cell = tableView.dequeueReusableCell(withIdentifier: AccountSummaryCell.reuseID, for: indexPath) as! AccountSummaryCell
            
            cell.configure(with: account)
            
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: SkeletonCell.reuseID, for: indexPath) as! SkeletonCell
                return cell
        
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return accountCellViewModels.count
    }
    // delete it crashes app
//    let cell = tableView.dequeueReusableCell(withIdentifier: SkeletonCell.reuseID, for: indexPath) as! SkeletonCell
}

extension AccountSummaryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("todo")
    }
}

extension AccountSummaryViewController {
    private func fetchAccountsHArdCode() {
        let savings = AccountSummaryCell.ViewModel(accountType: .Banking, accountName: "Basic Savings", balance: 929466.23)
        let chequing = AccountSummaryCell.ViewModel(accountType: .Banking, accountName: "No-fee All-In Chequing", balance: 17562.44)
        let visa = AccountSummaryCell.ViewModel(accountType: .CreditCard, accountName: "Master Credit Card", balance: 412.83)
        let investment1 = AccountSummaryCell.ViewModel(accountType: .Investment, accountName: "Tax-Free Savings", balance: 2000.00)
        let investment2 = AccountSummaryCell.ViewModel(accountType: .Investment, accountName: "Growth Fund", balance: 15000.00)
        
        accountCellViewModels.append(savings)
        accountCellViewModels.append(chequing)
        accountCellViewModels.append(visa)
        accountCellViewModels.append(investment1)
        accountCellViewModels.append(investment2)
    }
}

// MARK: - Networking
extension AccountSummaryViewController {
    private func fetchData() {
        let group = DispatchGroup()
        
        // Testing - random number selection
        let userId = String(Int.random(in: 1..<4))
        
        fetchProfile(group: group, userId: userId)
        fetchAccounts(group: group, userId: userId)
        
        group.notify(queue: .main) {
            self.reloadView()
        }
    }
    
    private func fetchProfile(group: DispatchGroup, userId: String) {
    group.enter()
    profileManager.fetchProfile(forUserId: userId) { result in
        switch result {
        case .success(let profile):
            self.profile = profile
        case .failure(let error):
            self.displayError(error)
        }
        group.leave()
    }
}
    
private func fetchAccounts(group: DispatchGroup, userId: String) {
    group.enter()
    fetchAccounts(forUserId: userId) { result in
        switch result {
        case .success(let accounts):
            self.accounts = accounts
        case .failure(let error):
            self.displayError(error)
        }
        group.leave()
    }
}
    
private func reloadView() {
    self.tableView.refreshControl?.endRefreshing()
    
    guard let profile = self.profile else { return }
    
    self.isLoaded = true
    self.configureTableHeaderView(with: profile)
    self.configureTableCells(with: self.accounts)
    self.tableView.reloadData()
}


    
    private func configureTableCells(with accounts: [Account]) {
        accountCellViewModels = accounts.map {
            AccountSummaryCell.ViewModel(accountType: $0.type,
                                         accountName: $0.name,
                                         balance: $0.amount)
        }
    }
    
   
//    private func displayError(_ error: NetworkError) {
//        print(error.localizedDescription)
//        let title: String
//        let message: String
//        switch error {
//
//        case .serverError:
//            title = "Server Error"
//            message = "Ensure you are connected to the internet. Please try again"
//        case .decodingError:
//            title = "Decoding Error"
//            message = "We could not process your request. Please try again."
//        }
//        self.showErrorAlert(title: title, message: message)
//    }
    
    private func displayError(_ error: NetworkError) {
        let titleAndMessage = titleAndMessage(for: error)
        self.showErrorAlert(title: titleAndMessage.0, message: titleAndMessage.1)
    }
    
    private func titleAndMessage(for error: NetworkError) -> (String, String) {
        let title: String
            let message: String
            switch error {
            case .serverError:
                title = "Server Error"
                message = "We could not process your request. Please try again."
            case .decodingError:
                title = "Network Error"
                message = "Ensure you are connected to the internet. Please try again."
            }
            return (title, message)
    }
    private func showErrorAlert(title: String, message: String) {
//        let alert = UIAlertController(title: title,
//                                      message: message,
//                                      preferredStyle: .alert)
//
//        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//        present(alert, animated: true, completion: nil)
        
        errorAlert.title = title
        errorAlert.message = message
        
        present(errorAlert, animated: true, completion: nil)
    }
    
    private func configureTableHeaderView(with profile: Profile) {
        let vm = AccountSummaryHeaderView.ViewModel(welcomeMessage: "Good morning,",
                                                    name: profile.firstName,
                                                    date: Date())
        headerView.configure(viewModel: vm)
    }
}

// MARK: Actions
extension AccountSummaryViewController {
    @objc func logoutTapped(sender: UIButton) {
        // this is like a dispatch
        NotificationCenter.default.post(name: .logout, object: nil)
    }
    
    @objc func refreshContent() {
            reset()
            setupSkeletons()
            tableView.reloadData()
            fetchData()
        }
        
        private func reset() {
            profile = nil
            accounts = []
            isLoaded = false
        }}

// MARK: Unit testing
// MARK: Unit testing
extension AccountSummaryViewController {
    func titleAndMessageForTesting(for error: NetworkError) -> (String, String) {
            return titleAndMessage(for: error)
    }
    
    func forceFetchPRofile() {
        fetchProfile(group: DispatchGroup(), userId: "1")
    }
} 

// MARK: REFERENCE

// MARK: - Networking
//extension AccountSummaryViewController {
//    private func fetchData() {
//        let group = DispatchGroup()
//
////        Testing - random number selection
//        let userId = String(Int.random(in: 1..<4))
//
//        group.enter()
//        profileManager.fetchProfile(forUserId: userId) { result in
//            switch result {
//            case .success(let profile):
//                self.profile = profile
////                self.configureTableHeaderView(with: profile)
////                self.tableView.reloadData()
//            case .failure(let error):
//                self.displayError(error)
//            }
//            group.leave()
//        }
//
//        group.enter()
//        fetchAccounts(forUserId: userId) { result in
//            switch result {
//            case .success(let accounts):
//                self.accounts = accounts
////                self.configureTableCells(with: accounts)
////                self.tableView.reloadData()
//            case .failure(let error):
//                print(error.localizedDescription)
//                self.displayError(error)
//            }
//            group.leave()
//        }
//        group.notify(queue: .main) {
//            // reloading the data on the table view only after both complete
//            self.tableView.refreshControl?.endRefreshing()
//            guard let profile = self.profile else { return }
//
//            self.isLoaded = true
//            self.configureTableHeaderView(with: profile)
//            self.configureTableCells(with: self.accounts)
//            self.tableView.reloadData()
//
//        }
//    }

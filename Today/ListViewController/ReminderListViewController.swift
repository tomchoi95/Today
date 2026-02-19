//
//  ReminderListViewController.swift
//  Today
//
//  Created by Tom Choi on 2/18/26.
//

import UIKit

final class ReminderListViewController: UICollectionViewController {

    var dataSource: DataSource?

    override func viewDidLoad() {
        super.viewDidLoad()

        let listLayout = listLayout()
        collectionView.collectionViewLayout = listLayout

        let cellRegistration = UICollectionView.CellRegistration(handler: cellRegistrationHandler)

        dataSource = DataSource(
            collectionView: collectionView,
            cellProvider: {
                $0.dequeueConfiguredReusableCell(using: cellRegistration, for: $1, item: $2)
            }
        )

        var snapshot = SnapShot()
        snapshot.appendSections([0])
        snapshot.appendItems(Reminder.sampleData.map(\.title))
        dataSource?.apply(snapshot)

        collectionView.dataSource = dataSource
    }

    private func listLayout() -> UICollectionViewCompositionalLayout {
        var listConfiguration = UICollectionLayoutListConfiguration(appearance: .grouped)
        listConfiguration.showsSeparators = false
        listConfiguration.backgroundColor = .clear
        return UICollectionViewCompositionalLayout.list(using: listConfiguration)
    }
}

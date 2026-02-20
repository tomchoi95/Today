//
//  ReminderListViewController.swift
//  Today
//
//  Created by Tom Choi on 2/18/26.
//

import UIKit

final class ReminderListViewController: UICollectionViewController {

    var dataSource: DataSource?
    var reminders: [Reminder] = Reminder.sampleData
    var listStyle: ReminderListStyle = .today
    var filteredReminders: [Reminder] {
        return reminders.filter { listStyle.shouldInclude(date: $0.dueDate) }
            .sorted { $0.dueDate < $1.dueDate }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let listLayout = listLayout()
        collectionView.collectionViewLayout = listLayout

        let cellRegistration = UICollectionView.CellRegistration(handler: cellRegistrationHandler)

        dataSource = DataSource(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, itemIdentifier: Reminder.ID) in
            return collectionView.dequeueConfiguredReusableCell(
                using: cellRegistration,
                for: indexPath,
                item: itemIdentifier
            )
        }

        let addButton = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(didPressAddButton(_:))
        )
        addButton.accessibilityLabel = NSLocalizedString(
            "Add reminder",
            comment: "Add button accessibility label"
        )
        navigationItem.rightBarButtonItem = addButton
        navigationItem.style = .navigator

        var snapshot = SnapShot()
        snapshot.appendSections([0])
        snapshot.appendItems(Reminder.sampleData.map(\.id))
        dataSource?.apply(snapshot)

        updateSnapShot()

        collectionView.dataSource = dataSource
    }

    override func collectionView(
        _ collectionView: UICollectionView,
        shouldSelectItemAt indexPath: IndexPath
    ) -> Bool {
        let id = filteredReminders[indexPath.item].id
        pushDetailViewForReminder(withID: id)
        return false
    }

    func pushDetailViewForReminder(withID id: Reminder.ID) {
        let reminder = reminder(withID: id)
        let viewController = ReminderViewController(reminder: reminder) { [weak self] reminder in
            self?.updateReminder(reminder)
            self?.updateSnapShot(reloading: [reminder.id])
        }
        navigationController?.pushViewController(viewController, animated: true)
    }

    private func listLayout() -> UICollectionViewCompositionalLayout {
        var listConfiguration = UICollectionLayoutListConfiguration(appearance: .grouped)
        listConfiguration.showsSeparators = false
        listConfiguration.trailingSwipeActionsConfigurationProvider = makeSwipeActions
        listConfiguration.backgroundColor = .clear
        return UICollectionViewCompositionalLayout.list(using: listConfiguration)
    }

    private func makeSwipeActions(for indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard let id = dataSource?.itemIdentifier(for: indexPath) else { return nil }
        let deleteActionTitle = NSLocalizedString("Delete", comment: "Delete action title")
        let deleteAction = UIContextualAction(
            style: .destructive,
            title: deleteActionTitle
        ) { [weak self] _, _, completion in
            self?.deleteReminder(with: id)
            self?.updateSnapShot()
            completion(false)  // 여기 왜 false 인겨?
        }
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}

#Preview(traits: .defaultLayout) {
    let listLayout: UICollectionViewCompositionalLayout = {
        var listConfiguration = UICollectionLayoutListConfiguration(appearance: .grouped)
        listConfiguration.showsSeparators = false
        listConfiguration.backgroundColor = .clear
        return UICollectionViewCompositionalLayout.list(using: listConfiguration)
    }()

    UINavigationController(
        rootViewController: ReminderListViewController(collectionViewLayout: listLayout)
    )

}

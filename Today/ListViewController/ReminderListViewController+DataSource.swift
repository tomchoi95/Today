//
//  ReminderListViewController+DataSource.swift
//  Today
//
//  Created by Tom Choi on 2/19/26.
//

import UIKit

extension ReminderListViewController {
    typealias DataSource = UICollectionViewDiffableDataSource<Int, Reminder.ID>
    typealias SnapShot = NSDiffableDataSourceSnapshot<Int, Reminder.ID>

    var reminderCompletedValue: String {
        NSLocalizedString("Completed", comment: "Reminder completed value")
    }

    var reminderNotCompletedValue: String {
        NSLocalizedString("Not completed", comment: "Reminder not completed value")
    }

    func updateSnapShot(reloading idsThatChanged: [Reminder.ID] = []) {
        let ids = idsThatChanged.filter { id in filteredReminders.contains { $0.id == id } }
        var snapshot = SnapShot()
        snapshot.appendSections([0])
        snapshot.appendItems(reminders.map(\.id))
        if !ids.isEmpty {
            snapshot.reloadItems(ids)
        }
        dataSource?.apply(snapshot)
    }

    func cellRegistrationHandler(
        cell: UICollectionViewListCell,
        indexPath: IndexPath,
        id: Reminder.ID
    ) {
        let reminder = reminder(withID: id)
        var contentConfiguration = cell.defaultContentConfiguration()
        contentConfiguration.text = reminder.title
        contentConfiguration.secondaryText = reminder.dueDate.dayAndTimeText
        contentConfiguration.secondaryTextProperties.font = UIFont.preferredFont(
            forTextStyle: .caption1
        )
        cell.contentConfiguration = contentConfiguration

        var doneButtonConfiguration = doneButtonConfiguration(for: reminder)
        doneButtonConfiguration.tintColor = .todayListCellDoneButtonTint
        cell.accessibilityCustomActions = [doneButtonAccessibilityAction(for: reminder)]
        cell.accessibilityValue =
            reminder.isComplete ? reminderCompletedValue : reminderNotCompletedValue
        cell.accessories = [
            .customView(configuration: doneButtonConfiguration),
            .disclosureIndicator(displayed: .always),
        ]

        var backgroundConfiguration = UIBackgroundConfiguration.listCell()
        backgroundConfiguration.backgroundColor = .todayListCellBackground
        cell.backgroundConfiguration = backgroundConfiguration
    }

    func reminder(withID id: Reminder.ID) -> Reminder {
        let index = reminders.indexOfReminder(withID: id)
        return reminders[index]
    }

    func updateReminder(_ reminder: Reminder) {
        let index = reminders.indexOfReminder(withID: reminder.id)
        reminders[index] = reminder
    }

    func completeReminder(withID id: Reminder.ID) {
        var reminder = reminder(withID: id)
        reminder.isComplete.toggle()
        updateReminder(reminder)
        updateSnapShot(reloading: [id])
    }

    func addReminder(_ reminder: Reminder) {
        reminders.append(reminder)
    }

    func deleteReminder(with id: Reminder.ID) {
        let index = reminders.indexOfReminder(withID: id)
        reminders.remove(at: index)
    }

    private func doneButtonAccessibilityAction(for reminder: Reminder)
        -> UIAccessibilityCustomAction
    {
        let name = NSLocalizedString(
            "Toggle completion",
            comment: "Reminderdone button accessibility label"
        )
        let action = UIAccessibilityCustomAction(name: name) { [weak self] action in
            self?.completeReminder(withID: reminder.id)
            return true
        }
        return action
    }

    private func doneButtonConfiguration(for reminder: Reminder)
        -> UICellAccessory.CustomViewConfiguration
    {
        let symbolName = reminder.isComplete ? "circle.fill" : "circle"
        let symbolConfiguration = UIImage.SymbolConfiguration(textStyle: .title1)
        let image = UIImage(systemName: symbolName, withConfiguration: symbolConfiguration)
        let button = ReminderDoneButton()
        button.addTarget(self, action: #selector(didPressDoneButton(_:)), for: .touchUpInside)
        button.id = reminder.id
        button.setImage(image, for: .normal)
        return UICellAccessory.CustomViewConfiguration(
            customView: button,
            placement: .leading(displayed: .always)
        )
    }
}

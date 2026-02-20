//
//  ReminderListViewController+Actions.swift
//  Today
//
//  Created by Tom Choi on 2/19/26.
//

import UIKit

extension ReminderListViewController {
    @objc func didPressDoneButton(_ sender: ReminderDoneButton) {
        guard let id = sender.id else { return }
        completeReminder(withID: id)
    }

    @objc func didPressAddButton(_ sender: UIBarButtonItem) {
        let reminder = Reminder(title: "", dueDate: Date.now)
        let viewController = ReminderViewController(reminder: reminder) { [weak self] reminder in

        }
        viewController.isAddingNewReminder = true
        viewController.setEditing(true, animated: true)
        viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .cancel,
            target: self,
            action: #selector(didCancelAdd(_:))
        )
        viewController.navigationItem.title = NSLocalizedString(
            "Add Reminder",
            comment: "Add Reminder view controller title"
        )
        let navigationController = UINavigationController(rootViewController: viewController)
        present(navigationController, animated: true)
    }

    @objc func didCancelAdd(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
}

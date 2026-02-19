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
}

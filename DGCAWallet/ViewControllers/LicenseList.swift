//
/*-
 * ---license-start
 * eu-digital-green-certificates / dgca-wallet-app-ios
 * ---
 * Copyright (C) 2021 T-Systems International GmbH and all other contributors
 * ---
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * ---license-end
 */
//  
//  Licenses.swift
//  DGCAWallet
//  
//  Created by Paul Ballmann on 19.05.21.
//

import Foundation
import UIKit
import FloatingPanel
import SwiftDGC
import SwiftyJSON

class LicenseList: UINavigationController {

  override func viewDidLoad() {
    super.viewDidLoad()
  }

  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
  }

}

class LicenseTableVC: UITableViewController {
  public var licenses: [JSON] = []
  private var selectedLicense: JSON = []

  override func viewDidLoad() {
    super.viewDidLoad()
    self.loadLicenses()
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.destination is LicenseVC {
      if let destVC = segue.destination as? LicenseVC {
        destVC.licenseObject = self.selectedLicense
      }
    }
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "LicenseCell", for: indexPath) as? LicenseCell
    else {
      return UITableViewCell()
    }
    let index = indexPath.row
    cell.drawLabel(self.licenses[index])
    return cell
  }

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if let cell = tableView.cellForRow(at: indexPath) as? LicenseCell {
      self.selectedLicense = cell.licenseObject
    }
    // segue to the vc
    performSegue(withIdentifier: "licenseSegue", sender: nil)
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.licenses.count
  }

  private func loadLicenses() {
    do {
      guard let licenseFileLocation = Bundle.main.path(forResource: "OpenSourceNotices", ofType: "json")
      else {
        return
      }
      guard let jsonData = try String(contentsOfFile: licenseFileLocation).data(using: .utf8)
      else {
        return
      }
      let jsonDoc = try JSON(data: jsonData)
      self.licenses = jsonDoc["licenses"].array ?? []
    } catch {
      print(error)
      return
    }

    print(self.licenses)
  }
}

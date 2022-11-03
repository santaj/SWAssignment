//
//  NiblessViewController.swift
//  SWAssignment
//
//  Created by Josef Santamaria on 2022-10-30.
//

import UIKit

open class NiblessViewController: UIViewController {
    init() {
      super.init(nibName: nil, bundle: nil)
    }
    @available(*, unavailable,
      message: "Loading this view controller from a nib is unsupported in favor of initializer dependency injection."
    )
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
      super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    @available(*, unavailable,
      message: "Loading this view controller from a nib is unsupported in favor of initializer dependency injection."
    )
    public required init?(coder aDecoder: NSCoder) {
      fatalError("Loading this view controller from a nib is unsupported in favor of initializer dependency injection.")
    }
}

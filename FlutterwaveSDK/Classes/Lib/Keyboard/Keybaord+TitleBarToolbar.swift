//
//  Keybaord+TitleBarToolbar.swift
//  FlutterwaveSDK
//
//  Created by Rotimi Joshua on 23/09/2020.
//  Copyright © 2020 Flutterwave. All rights reserved.
//

import Foundation
import UIKit
open class FLTitleBarButtonItem: FLBarButtonItem {

    @objc open var titleFont: UIFont? {

        didSet {
            if let unwrappedFont = titleFont {
                titleButton?.titleLabel?.font = unwrappedFont
            } else {
                titleButton?.titleLabel?.font = UIFont.systemFont(ofSize: 13)
            }
        }
    }

    @objc override open var title: String? {
        didSet {
                titleButton?.setTitle(title, for: .normal)
        }
    }

    /**
     titleColor to be used for displaying button text when displaying title (disabled state).
     */
    @objc open var titleColor: UIColor? {

        didSet {

            if let color = titleColor {
                titleButton?.setTitleColor(color, for: .disabled)
            } else {
                titleButton?.setTitleColor(UIColor.lightGray, for: .disabled)
            }
        }
    }

    /**
     selectableTitleColor to be used for displaying button text when button is enabled.
     */
    @objc open var selectableTitleColor: UIColor? {

        didSet {

            if let color = selectableTitleColor {
                titleButton?.setTitleColor(color, for: .normal)
            } else {
                #if swift(>=5.1)
                titleButton?.setTitleColor(UIColor.systemBlue, for: .normal)
                #else
                titleButton?.setTitleColor(UIColor(red: 0.0, green: 0.5, blue: 1.0, alpha: 1), for: .normal)
                #endif
            }
        }
    }

    /**
     Customized Invocation to be called on title button action. titleInvocation is internally created using setTitleTarget:action: method.
     */
    @objc override open var invocation: FLInvocation? {

        didSet {

            if let target = invocation?.target, let action = invocation?.action {
                self.isEnabled = true
                titleButton?.isEnabled = true
                titleButton?.addTarget(target, action: action, for: .touchUpInside)
            } else {
                self.isEnabled = false
                titleButton?.isEnabled = false
                titleButton?.removeTarget(nil, action: nil, for: .touchUpInside)
            }
        }
    }

    internal var titleButton: UIButton?
    private var _titleView: UIView?

    override init() {
        super.init()
    }

    @objc public convenience init(title: String?) {

        self.init(title: nil, style: .plain, target: nil, action: nil)

        _titleView = UIView()
        _titleView?.backgroundColor = UIColor.clear

        titleButton = UIButton(type: .system)
        titleButton?.isEnabled = false
        titleButton?.titleLabel?.numberOfLines = 3
        titleButton?.setTitleColor(UIColor.lightGray, for: .disabled)
        #if swift(>=5.1)
        titleButton?.setTitleColor(UIColor.systemBlue, for: .normal)
        #else
        titleButton?.setTitleColor(UIColor(red: 0.0, green: 0.5, blue: 1.0, alpha: 1), for: .normal)
        #endif
        titleButton?.backgroundColor = UIColor.clear
        titleButton?.titleLabel?.textAlignment = .center
        titleButton?.setTitle(title, for: .normal)
        titleFont = UIFont.systemFont(ofSize: 13.0)
        titleButton?.titleLabel?.font = self.titleFont
        _titleView?.addSubview(titleButton!)

        if #available(iOS 11, *) {

            #if swift(>=4.0)
                let layoutDefaultLowPriority = UILayoutPriority(rawValue: UILayoutPriority.defaultLow.rawValue-1)
                let layoutDefaultHighPriority = UILayoutPriority(rawValue: UILayoutPriority.defaultHigh.rawValue-1)
            #else
                let layoutDefaultLowPriority = UILayoutPriorityDefaultLow-1
                let layoutDefaultHighPriority = UILayoutPriorityDefaultHigh-1
            #endif

            _titleView?.translatesAutoresizingMaskIntoConstraints = false
            _titleView?.setContentHuggingPriority(layoutDefaultLowPriority, for: .vertical)
            _titleView?.setContentHuggingPriority(layoutDefaultLowPriority, for: .horizontal)
            _titleView?.setContentCompressionResistancePriority(layoutDefaultHighPriority, for: .vertical)
            _titleView?.setContentCompressionResistancePriority(layoutDefaultHighPriority, for: .horizontal)

            titleButton?.translatesAutoresizingMaskIntoConstraints = false
            titleButton?.setContentHuggingPriority(layoutDefaultLowPriority, for: .vertical)
            titleButton?.setContentHuggingPriority(layoutDefaultLowPriority, for: .horizontal)
            titleButton?.setContentCompressionResistancePriority(layoutDefaultHighPriority, for: .vertical)
            titleButton?.setContentCompressionResistancePriority(layoutDefaultHighPriority, for: .horizontal)

            let top = NSLayoutConstraint.init(item: titleButton!, attribute: .top, relatedBy: .equal, toItem: _titleView, attribute: .top, multiplier: 1, constant: 0)
            let bottom = NSLayoutConstraint.init(item: titleButton!, attribute: .bottom, relatedBy: .equal, toItem: _titleView, attribute: .bottom, multiplier: 1, constant: 0)
            let leading = NSLayoutConstraint.init(item: titleButton!, attribute: .leading, relatedBy: .equal, toItem: _titleView, attribute: .leading, multiplier: 1, constant: 0)
            let trailing = NSLayoutConstraint.init(item: titleButton!, attribute: .trailing, relatedBy: .equal, toItem: _titleView, attribute: .trailing, multiplier: 1, constant: 0)

            _titleView?.addConstraints([top, bottom, leading, trailing])
        } else {
            _titleView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            titleButton?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        }

        customView = _titleView
    }

    @objc required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    deinit {
        customView = nil
        titleButton?.removeTarget(nil, action: nil, for: .touchUpInside)
        _titleView = nil
        titleButton = nil
    }
}

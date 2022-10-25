//
//  UIKit+Theme.swift
//  Handy
//
//  Created by leetangsong on 2022/10/21.
//

import UIKit


extension ThemeExtension where Base: UIView{
    public var alpha: ThemeCGFloatPicker? {
        get { return getThemePicker(base, "setAlpha:") as? ThemeCGFloatPicker }
        set { setThemePicker(base, "setAlpha:", newValue) }
    }
    
    public var backgroundColor: ThemeColorPicker? {
        get { return getThemePicker(base, "setBackgroundColor:") as? ThemeColorPicker }
        set { setThemePicker(base, "setBackgroundColor:", newValue) }
    }
    
    public var tintColor: ThemeColorPicker? {
        get { return getThemePicker(base, "setTintColor:") as? ThemeColorPicker }
        set { setThemePicker(base, "setTintColor:", newValue) }
    }
}

extension ThemeExtension where Base: UIApplication
{
    #if os(iOS)
    public func setStatusBarStyle(_ picker: ThemeStatusBarStylePicker, animated: Bool) {
        picker.animated = animated
        setThemePicker(base, "setStatusBarStyle:animated:", picker)
    }
    #endif
}

extension ThemeExtension where Base: UIBarItem
{
    public var image: ThemeImagePicker? {
        get { return getThemePicker(base, "setImage:") as? ThemeImagePicker }
        set { setThemePicker(base, "setImage:", newValue) }
    }
    public func setTitleTextAttributes(_ picker: ThemeStringAttributesPicker?, forState state: UIControl.State) {
        let statePicker = makeStatePicker(base, "setTitleTextAttributes:forState:", picker, state)
        setThemePicker(base, "setTitleTextAttributes:forState:", statePicker)
    }
    
}


extension ThemeExtension where Base: UIBarButtonItem
{
    public var tintColor: ThemeColorPicker? {
        get { return getThemePicker(base, "setTintColor:") as? ThemeColorPicker }
        set { setThemePicker(base, "setTintColor:", newValue) }
    }
}
extension ThemeExtension where Base: UILabel
{
    public var font: ThemeFontPicker? {
        get { return getThemePicker(base, "setFont:") as? ThemeFontPicker }
        set { setThemePicker(base, "setFont:", newValue) }
    }
    public var textColor: ThemeColorPicker? {
        get { return getThemePicker(base, "setTextColor:") as? ThemeColorPicker }
        set { setThemePicker(base, "setTextColor:", newValue) }
    }
    public var highlightedTextColor: ThemeColorPicker? {
        get { return getThemePicker(base, "setHighlightedTextColor:") as? ThemeColorPicker }
        set { setThemePicker(base, "setHighlightedTextColor:", newValue) }
    }
    public var shadowColor: ThemeColorPicker? {
        get { return getThemePicker(base, "setShadowColor:") as? ThemeColorPicker }
        set { setThemePicker(base, "setShadowColor:", newValue) }
    }
    public var textAttributes: ThemeStringAttributesPicker? {
        get { return getThemePicker(base, "updateTextAttributes:") as? ThemeStringAttributesPicker }
        set { setThemePicker(base, "updateTextAttributes:", newValue) }
    }
    public var attributedText: ThemeAttributedStringPicker? {
        get { return getThemePicker(base, "setAttributedText:") as? ThemeAttributedStringPicker }
        set { setThemePicker(base, "setAttributedText:", newValue) }
    }
}


extension ThemeExtension where Base: UINavigationBar
{
    #if os(iOS)
    public var barStyle: ThemeBarStylePicker? {
        get { return getThemePicker(base, "setBarStyle:") as? ThemeBarStylePicker }
        set { setThemePicker(base, "setBarStyle:", newValue) }
    }
    #endif
    public var barTintColor: ThemeColorPicker? {
        get { return getThemePicker(base, "setBarTintColor:") as? ThemeColorPicker }
        set { setThemePicker(base, "setBarTintColor:", newValue) }
    }
    public var titleTextAttributes: ThemeStringAttributesPicker? {
        get { return getThemePicker(base, "setTitleTextAttributes:") as? ThemeStringAttributesPicker }
        set { setThemePicker(base, "setTitleTextAttributes:", newValue) }
    }
    public var largeTitleTextAttributes: ThemeStringAttributesPicker? {
        get { return getThemePicker(base, "setLargeTitleTextAttributes:") as? ThemeStringAttributesPicker }
        set { setThemePicker(base, "setLargeTitleTextAttributes:", newValue) }
    }
    @available(iOS 13.0, tvOS 13.0, *)
    public var standardAppearance: ThemeNavigationBarAppearancePicker? {
        get { return getThemePicker(base, "setStandardAppearance:") as? ThemeNavigationBarAppearancePicker }
        set { setThemePicker(base, "setStandardAppearance:", newValue) }
    }
    @available(iOS 13.0, tvOS 13.0, *)
    public var compactAppearance: ThemeNavigationBarAppearancePicker? {
        get { return getThemePicker(base, "setCompactAppearance:") as? ThemeNavigationBarAppearancePicker }
        set { setThemePicker(base, "setCompactAppearance:", newValue) }
    }
    @available(iOS 13.0, tvOS 13.0, *)
    public var scrollEdgeAppearance: ThemeNavigationBarAppearancePicker? {
        get { return getThemePicker(base, "setScrollEdgeAppearance:") as? ThemeNavigationBarAppearancePicker }
        set { setThemePicker(base, "setScrollEdgeAppearance:", newValue) }
    }
}
extension ThemeExtension where Base: UITabBar
{
    #if os(iOS)
    public var barStyle: ThemeBarStylePicker? {
        get { return getThemePicker(base, "setBarStyle:") as? ThemeBarStylePicker }
        set { setThemePicker(base, "setBarStyle:", newValue) }
    }
    #endif
    public var unselectedItemTintColor: ThemeColorPicker? {
        get { return getThemePicker(base, "setUnselectedItemTintColor:") as? ThemeColorPicker }
        set { setThemePicker(base, "setUnselectedItemTintColor:", newValue) }
    }
    public var barTintColor: ThemeColorPicker? {
        get { return getThemePicker(base, "setBarTintColor:") as? ThemeColorPicker }
        set { setThemePicker(base, "setBarTintColor:", newValue) }
    }

    @available(iOS 13.0, tvOS 13.0, *)
    public var standardAppearance: ThemeTabBarAppearancePicker? {
        get { return getThemePicker(base, "setStandardAppearance:") as? ThemeTabBarAppearancePicker }
        set { setThemePicker(base, "setStandardAppearance:", newValue) }
    }
    @available(iOS 13.0, tvOS 13.0, *)
    public var compactAppearance: ThemeTabBarAppearancePicker? {
        get { return getThemePicker(base, "setCompactAppearance:") as? ThemeTabBarAppearancePicker }
        set { setThemePicker(base, "setCompactAppearance:", newValue) }
    }
    @available(iOS 13.0, tvOS 13.0, *)
    public var scrollEdgeAppearance: ThemeTabBarAppearancePicker? {
        get { return getThemePicker(base, "setScrollEdgeAppearance:") as? ThemeTabBarAppearancePicker }
        set { setThemePicker(base, "setScrollEdgeAppearance:", newValue) }
    }
}
extension ThemeExtension where Base: UITabBarItem
{
    public var selectedImage: ThemeImagePicker? {
        get { return getThemePicker(base, "setSelectedImage:") as? ThemeImagePicker }
        set { setThemePicker(base, "setSelectedImage:", newValue) }
    }
}
extension ThemeExtension where Base: UITableView
{
    public var separatorColor: ThemeColorPicker? {
        get { return getThemePicker(base, "setSeparatorColor:") as? ThemeColorPicker }
        set { setThemePicker(base, "setSeparatorColor:", newValue) }
    }
    public var sectionIndexColor: ThemeColorPicker? {
        get { return getThemePicker(base, "setSectionIndexColor:") as? ThemeColorPicker }
        set { setThemePicker(base, "setSectionIndexColor:", newValue) }
    }
    public var sectionIndexBackgroundColor: ThemeColorPicker? {
        get { return getThemePicker(base, "setSectionIndexBackgroundColor:") as? ThemeColorPicker }
        set { setThemePicker(base, "setSectionIndexBackgroundColor:", newValue) }
    }
}
extension ThemeExtension where Base: UITextField
{
    public var font: ThemeFontPicker? {
        get { return getThemePicker(base, "setFont:") as? ThemeFontPicker }
        set { setThemePicker(base, "setFont:", newValue) }
    }
    public var keyboardAppearance: ThemeKeyboardAppearancePicker? {
        get { return getThemePicker(base, "setKeyboardAppearance:") as? ThemeKeyboardAppearancePicker }
        set { setThemePicker(base, "setKeyboardAppearance:", newValue) }
    }
    public var textColor: ThemeColorPicker? {
        get { return getThemePicker(base, "setTextColor:") as? ThemeColorPicker }
        set { setThemePicker(base, "setTextColor:", newValue) }
    }
    public var placeholderAttributes: ThemeStringAttributesPicker? {
        get { return getThemePicker(base, "updatePlaceholderAttributes:") as? ThemeStringAttributesPicker }
        set { setThemePicker(base, "updatePlaceholderAttributes:", newValue) }
    }
}
extension ThemeExtension where Base: UITextView
{
    public var font: ThemeFontPicker? {
        get { return getThemePicker(base, "setFont:") as? ThemeFontPicker }
        set { setThemePicker(base, "setFont:", newValue) }
    }
    public var keyboardAppearance: ThemeKeyboardAppearancePicker? {
        get { return getThemePicker(base, "setKeyboardAppearance:") as? ThemeKeyboardAppearancePicker }
        set { setThemePicker(base, "setKeyboardAppearance:", newValue) }
    }
    public var textColor: ThemeColorPicker? {
        get { return getThemePicker(base, "setTextColor:") as? ThemeColorPicker }
        set { setThemePicker(base, "setTextColor:", newValue) }
    }
}
extension ThemeExtension where Base: UISearchBar
{
    #if os(iOS)
    public var barStyle: ThemeBarStylePicker? {
        get { return getThemePicker(base, "setBarStyle:") as? ThemeBarStylePicker }
        set { setThemePicker(base, "setBarStyle:", newValue) }
    }
    #endif
    public var keyboardAppearance: ThemeKeyboardAppearancePicker? {
        get { return getThemePicker(base, "setKeyboardAppearance:") as? ThemeKeyboardAppearancePicker }
        set { setThemePicker(base, "setKeyboardAppearance:", newValue) }
    }
    public var barTintColor: ThemeColorPicker? {
        get { return getThemePicker(base, "setBarTintColor:") as? ThemeColorPicker }
        set { setThemePicker(base, "setBarTintColor:", newValue) }
    }
}
extension ThemeExtension where Base: UIProgressView
{
    public var progressTintColor: ThemeColorPicker? {
        get { return getThemePicker(base, "setProgressTintColor:") as? ThemeColorPicker }
        set { setThemePicker(base, "setProgressTintColor:", newValue) }
    }
    public var trackTintColor: ThemeColorPicker? {
        get { return getThemePicker(base, "setTrackTintColor:") as? ThemeColorPicker }
        set { setThemePicker(base, "setTrackTintColor:", newValue) }
    }
}
extension ThemeExtension where Base: UIPageControl
{
    public var pageIndicatorTintColor: ThemeColorPicker? {
        get { return getThemePicker(base, "setPageIndicatorTintColor:") as? ThemeColorPicker }
        set { setThemePicker(base, "setPageIndicatorTintColor:", newValue) }
    }
    public var currentPageIndicatorTintColor: ThemeColorPicker? {
        get { return getThemePicker(base, "setCurrentPageIndicatorTintColor:") as? ThemeColorPicker }
        set { setThemePicker(base, "setCurrentPageIndicatorTintColor:", newValue) }
    }
}
extension ThemeExtension where Base: UIImageView
{
    public var image: ThemeImagePicker? {
        get { return getThemePicker(base, "setImage:") as? ThemeImagePicker }
        set { setThemePicker(base, "setImage:", newValue) }
    }
}
extension ThemeExtension where Base: UIActivityIndicatorView
{
    public var color: ThemeColorPicker? {
        get { return getThemePicker(base, "setColor:") as? ThemeColorPicker }
        set { setThemePicker(base, "setColor:", newValue) }
    }
    public var activityIndicatorViewStyle: ThemeActivityIndicatorViewStylePicker? {
        get { return getThemePicker(base, "setActivityIndicatorViewStyle:") as? ThemeActivityIndicatorViewStylePicker }
        set { setThemePicker(base, "setActivityIndicatorViewStyle:", newValue) }
    }
}
extension ThemeExtension where Base: UIScrollView
{
    public var indicatorStyle: ThemeScrollViewIndicatorStylePicker? {
        get { return getThemePicker(base, "setIndicatorStyle:") as? ThemeScrollViewIndicatorStylePicker }
        set { setThemePicker(base, "setIndicatorStyle:", newValue) }
    }
}
extension ThemeExtension where Base: UIButton
{
    public func setImage(_ picker: ThemeImagePicker?, forState state: UIControl.State) {
        let statePicker = makeStatePicker(base, "setImage:forState:", picker, state)
        setThemePicker(base, "setImage:forState:", statePicker)
    }
    public func setBackgroundImage(_ picker: ThemeImagePicker?, forState state: UIControl.State) {
        let statePicker = makeStatePicker(base, "setBackgroundImage:forState:", picker, state)
        setThemePicker(base, "setBackgroundImage:forState:", statePicker)
    }
    public func setTitleColor(_ picker: ThemeColorPicker?, forState state: UIControl.State) {
        let statePicker = makeStatePicker(base, "setTitleColor:forState:", picker, state)
        setThemePicker(base, "setTitleColor:forState:", statePicker)
    }
    public func setAttributedTitle(_ picker: ThemeAttributedStringPicker?, forState state: UIControl.State) {
        let statePicker = makeStatePicker(base, "setAttributedTitle:forState:", picker, state)
        setThemePicker(base, "setAttributedTitle:forState:", statePicker)
    }
}
extension ThemeExtension where Base: CALayer
{
    public var backgroundColor: ThemeCGColorPicker? {
        get { return getThemePicker(base, "setBackgroundColor:") as? ThemeCGColorPicker}
        set { setThemePicker(base, "setBackgroundColor:", newValue) }
    }
    public var borderWidth: ThemeCGFloatPicker? {
        get { return getThemePicker(base, "setBorderWidth:") as? ThemeCGFloatPicker }
        set { setThemePicker(base, "setBorderWidth:", newValue) }
    }
    public var borderColor: ThemeCGColorPicker? {
        get { return getThemePicker(base, "setBorderColor:") as? ThemeCGColorPicker }
        set { setThemePicker(base, "setBorderColor:", newValue) }
    }
    public var shadowColor: ThemeCGColorPicker? {
        get { return getThemePicker(base, "setShadowColor:") as? ThemeCGColorPicker }
        set { setThemePicker(base, "setShadowColor:", newValue) }
    }
    public var strokeColor: ThemeCGColorPicker? {
        get { return getThemePicker(base, "setStrokeColor:") as? ThemeCGColorPicker }
        set { setThemePicker(base, "setStrokeColor:", newValue) }
    }
    public var fillColor: ThemeCGColorPicker?{
        get { return getThemePicker(base, "setFillColor:") as? ThemeCGColorPicker }
        set { setThemePicker(base, "setFillColor:", newValue) }
    }
}
extension ThemeExtension where Base: CATextLayer
{
    public var foregroundColor: ThemeCGColorPicker? {
        get { return getThemePicker(base, "setForegroundColor:") as? ThemeCGColorPicker}
        set { setThemePicker(base, "setForegroundColor:", newValue) }
    }
}
extension ThemeExtension where Base: CAGradientLayer
{
    public var colors: ThemeAnyPicker? {
        get { return getThemePicker(base, "setColors:") as? ThemeAnyPicker }
        set { setThemePicker(base, "setColors:", newValue) }
    }
}

#if os(iOS)
extension ThemeExtension where Base: UIToolbar
{
    public var barStyle: ThemeBarStylePicker? {
        get { return getThemePicker(base, "setBarStyle:") as? ThemeBarStylePicker }
        set { setThemePicker(base, "setBarStyle:", newValue) }
    }
    public var barTintColor: ThemeColorPicker? {
        get { return getThemePicker(base, "setBarTintColor:") as? ThemeColorPicker }
        set { setThemePicker(base, "setBarTintColor:", newValue) }
    }
}
extension ThemeExtension where Base: UISegmentedControl
{
    public var selectedSegmentTintColor: ThemeColorPicker? {
        get { return getThemePicker(base, "setSelectedSegmentTintColor:") as? ThemeColorPicker }
        set { setThemePicker(base, "setSelectedSegmentTintColor:", newValue) }
    }
    public func setTitleTextAttributes(_ picker: ThemeStringAttributesPicker?, forState state: UIControl.State) {
        let statePicker = makeStatePicker(base, "setTitleTextAttributes:forState:", picker, state)
        setThemePicker(base, "setTitleTextAttributes:forState:", statePicker)
    }
}
extension ThemeExtension where Base: UISwitch
{
    public var onTintColor: ThemeColorPicker? {
        get { return getThemePicker(base, "setOnTintColor:") as? ThemeColorPicker }
        set { setThemePicker(base, "setOnTintColor:", newValue) }
    }
    public var thumbTintColor: ThemeColorPicker? {
        get { return getThemePicker(base, "setThumbTintColor:") as? ThemeColorPicker }
        set { setThemePicker(base, "setThumbTintColor:", newValue) }
    }
}
extension ThemeExtension where Base: UISlider
{
    public var thumbTintColor: ThemeColorPicker? {
        get { return getThemePicker(base, "setThumbTintColor:") as? ThemeColorPicker }
        set { setThemePicker(base, "setThumbTintColor:", newValue) }
    }
    public var minimumTrackTintColor: ThemeColorPicker? {
        get { return getThemePicker(base, "setMinimumTrackTintColor:") as? ThemeColorPicker }
        set { setThemePicker(base, "setMinimumTrackTintColor:", newValue) }
    }
    public var maximumTrackTintColor: ThemeColorPicker? {
        get { return getThemePicker(base, "setMaximumTrackTintColor:") as? ThemeColorPicker }
        set { setThemePicker(base, "setMaximumTrackTintColor:", newValue) }
    }
}
extension ThemeExtension where Base: UIPopoverPresentationController
{
    public var backgroundColor: ThemeColorPicker? {
        get { return getThemePicker(base, "setBackgroundColor:") as? ThemeColorPicker }
        set { setThemePicker(base, "setBackgroundColor:", newValue) }
    }
}
extension ThemeExtension where Base: UIRefreshControl
{
    public var titleAttributes: ThemeStringAttributesPicker? {
        get { return getThemePicker(base, "updateTitleAttributes:") as? ThemeStringAttributesPicker }
        set { setThemePicker(base, "updateTitleAttributes:", newValue) }
    }
}
extension ThemeExtension where Base: UIVisualEffectView
{
    public var effect: ThemeVisualEffectPicker? {
        get { return getThemePicker(base, "setEffect:") as? ThemeVisualEffectPicker }
        set { setThemePicker(base, "setEffect:", newValue) }
    }
}
@available(iOS 13.0, *)
extension ThemeExtension where Base: UINavigationBarAppearance
{
    public var titleTextAttributes: ThemeStringAttributesPicker? {
        get { return getThemePicker(base, "setTitleTextAttributes:") as? ThemeStringAttributesPicker }
        set { setThemePicker(base, "setTitleTextAttributes:", newValue) }
    }
    public var largeTitleTextAttributes: ThemeStringAttributesPicker? {
        get { return getThemePicker(base, "setLargeTitleTextAttributes:") as? ThemeStringAttributesPicker }
        set { setThemePicker(base, "setLargeTitleTextAttributes:", newValue) }
    }
    public var backIndicatorImage: ThemeImagePicker? {
        get { return getThemePicker(base, "setBackIndicatorImage:") as? ThemeImagePicker }
        set { setThemePicker(base, "setBackIndicatorImage:", newValue) }
    }
}
@available(iOS 13.0, *)
extension ThemeExtension where Base: UIBarAppearance
{
    public var backgroundColor: ThemeColorPicker? {
        get { return getThemePicker(base, "setBackgroundColor:") as? ThemeColorPicker }
        set { setThemePicker(base, "setBackgroundColor:", newValue) }
    }
    public var backgroundImage: ThemeImagePicker? {
        get { return getThemePicker(base, "setBackgroundImage:") as? ThemeImagePicker }
        set { setThemePicker(base, "setBackgroundImage:", newValue) }
    }
    public var backgroundEffect: ThemeBlurEffectPicker? {
        get { return getThemePicker(base, "setBackgroundEffect:") as? ThemeBlurEffectPicker }
        set { setThemePicker(base, "setBackgroundEffect:", newValue) }
    }
    public var shadowColor: ThemeColorPicker? {
        get { return getThemePicker(base, "setShadowColor:") as? ThemeColorPicker }
        set { setThemePicker(base, "setShadowColor:", newValue) }
    }
    public var shadowImage: ThemeImagePicker? {
        get { return getThemePicker(base, "setShadowImage:") as? ThemeImagePicker }
        set { setThemePicker(base, "setShadowImage:", newValue) }
    }
}


extension ThemeExtension where Base: UIViewController{
    public var statusBarStyle: ThemeStatusBarStylePicker? {
        get {
            return getThemePicker(base, "statusBarStyle") as? ThemeStatusBarStylePicker
        }
        set {
            setThemePicker(base, "statusBarStyle", newValue)
        }
    }
   
    
    public var naviBarStyle: ThemeBarStylePicker? {
        get {
            return getThemePicker(base, "naviBarStyle") as? ThemeBarStylePicker
        }
        set {
            setThemePicker(base, "naviBarStyle", newValue)
        }
    }

    public var naviTintColor: ThemeColorPicker? {
        get {
            return getThemePicker(base, "naviTintColor") as? ThemeColorPicker
        }
        set {
            setThemePicker(base, "naviTintColor", newValue)
        }
    }
    public var naviTitleColor: ThemeColorPicker? {
        get {
            return getThemePicker(base, "naviTitleColor") as? ThemeColorPicker
        }
        set {
            setThemePicker(base, "naviTitleColor", newValue)
        }
    }
//
    public var naviTitleFont: ThemeFontPicker? {
        get {
            return getThemePicker(base, "naviTitleFont") as? ThemeFontPicker
        }
        set {
            setThemePicker(base, "naviTitleFont", newValue)
        }
    }
//
//
//    /// 导航栏背景色，默认白色
    public var naviBackgroundColor: ThemeColorPicker? {
        get {
            return getThemePicker(base, "naviBackgroundColor") as? ThemeColorPicker
        }
        set {
            setThemePicker(base, "naviBackgroundColor", newValue)
        }
    }
//    /// 导航栏背景图片
    public var naviBackgroundImage: ThemeImagePicker? {
        get {
            return getThemePicker(base, "naviBackgroundImage") as? ThemeImagePicker
        }
        set {
            setThemePicker(base, "naviBackgroundImage", newValue)
        }
    }
//
//    /// 导航栏底部分割线颜色
    public var naviShadowColor: ThemeColorPicker? {
        get {
            return getThemePicker(base, "naviShadowColor") as? ThemeColorPicker
        }
        set {
            setThemePicker(base, "naviShadowColor", newValue)
        }
    }
    
    
}

#endif


private func getThemePicker(
    _ object : NSObject,
    _ selector : String
) -> ThemePicker? {
    return ThemePicker.getThemePicker(object, selector)
}

private func setThemePicker(
    _ object : NSObject,
    _ selector : String,
    _ picker : ThemePicker?
) {
    return ThemePicker.setThemePicker(object, selector, picker)
}

private func makeStatePicker(
    _ object : NSObject,
    _ selector : String,
    _ picker : ThemePicker?,
    _ state : UIControl.State
) -> ThemePicker? {
    return ThemePicker.makeStatePicker(object, selector, picker, state)
}


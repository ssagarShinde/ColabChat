//
//  ScrollViewsExtension.swift
//  ChatLib
//
//  Created by Sagar on 25/09/21.
//

import UIKit

internal class CustomeScrollView: UIScrollView, UITextFieldDelegate, UITextViewDelegate {
    override public var contentSize: CGSize {
        didSet {
            self.UpdateFromContentSizeChange()
        }
    }
    
    override public var frame: CGRect {
        didSet {
            self.UpdateContentInset()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    override public func awakeFromNib() {
        setup()
    }
    
    func contentSizeToFit() {
        self.contentSize = self.CalculatedContentSizeFromSubviewFrames()
    }
    
    func focusNextTextField() -> Bool {
        return self.FocusNextTextField()
    }
    
    @objc func scrollToActiveTextField() {
        return self.ScrollToActiveTextField()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override public func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        
        guard newSuperview != nil else { return }
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(AssignTextDelegateForViewsBeneathView(_:)), object: self)
    }
    
    override public func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.FindFirstResponderBeneathView(self)?.resignFirstResponder()
        super.touchesEnded(touches, with: event)
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if !self.focusNextTextField() {
            textField.resignFirstResponder()
        }
        return true
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(AssignTextDelegateForViewsBeneathView(_:)), object: self)
        
        Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(AssignTextDelegateForViewsBeneathView(_:)), userInfo: nil, repeats: false)
    }
}

private extension CustomeScrollView {
    func setup() {
        NotificationCenter.default.addObserver(self, selector: #selector(KeyboardWillShow(_:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(KeyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(scrollToActiveTextField), name: UITextView.textDidBeginEditingNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(scrollToActiveTextField), name: UITextField.textDidBeginEditingNotification, object: nil)
    }
}

let kContentPadding: CGFloat = 10
let kMinimumScrollOffsetPadding: CGFloat = 20

extension UIScrollView {
    @objc func KeyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo else { return }
        guard let rectNotification = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
            return
        }
        
        let keyboardRect = self.convert(rectNotification.cgRectValue, from: nil)
        guard !keyboardRect.isEmpty else { return }
        
        let state = self.keyboardAvoidingState()
        
        guard let firstResponder = self.FindFirstResponderBeneathView(self) else { return }
        
        state.keyboardRect = keyboardRect
        if !state.keyboardVisible {
            state.priorInset = self.contentInset
            state.priorScrollIndicatorInsets = self.scrollIndicatorInsets
            state.priorPagingEnabled = self.isPagingEnabled
        }
        
        state.keyboardVisible = true
        self.isPagingEnabled = false
        
        if self is CustomeScrollView {
            state.priorContentSize = self.contentSize
            if self.contentSize.equalTo(CGSize.zero) {
                self.contentSize = self.CalculatedContentSizeFromSubviewFrames()
            }
        }
        
        let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Float ?? 0.0
        let curve = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? Int ?? 0
        let options = UIView.AnimationOptions(rawValue: UInt(curve))
        
        UIView.animate(withDuration: TimeInterval(duration), delay: 0, options: options, animations: { [weak self] in
            guard let self = self else { return }
            
            self.contentInset = self.ContentInsetForKeyboard()
            let viewableHeight = self.bounds.size.height - self.contentInset.top - self.contentInset.bottom
            let point = CGPoint(x: self.contentOffset.x, y: self.IdealOffsetForView(firstResponder, viewAreaHeight: viewableHeight))
            self.setContentOffset(point, animated: false)
            
            self.scrollIndicatorInsets = self.contentInset
            self.layoutIfNeeded()
        })
    }
    
    @objc func KeyboardWillHide(_ notification: Notification) {
        guard let userInfo = notification.userInfo else { return }
        
        guard let rectNotification = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardRect = self.convert(rectNotification.cgRectValue, from: nil)
        guard !keyboardRect.isEmpty else { return }
        
        let state = self.keyboardAvoidingState()
        guard state.keyboardVisible else { return }
        state.keyboardRect = CGRect.zero
        state.keyboardVisible = false
        
        let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Float ?? 0.0
        let curve = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? Int ?? 0
        let options = UIView.AnimationOptions(rawValue: UInt(curve))
        
        UIView.animate(withDuration: TimeInterval(duration), delay: 0, options: options, animations: { [weak self] in
            guard let self = self, self is CustomeScrollView else { return }
            
            self.contentSize =  CGSize(width: state.priorContentSize.width, height: state.priorContentSize.height + Constraints.bottom) 
            self.contentInset = state.priorInset
            self.scrollIndicatorInsets = state.priorScrollIndicatorInsets
            self.isPagingEnabled = state.priorPagingEnabled
            self.layoutIfNeeded()
        })
    }
    
    func UpdateFromContentSizeChange() {
        let state = self.keyboardAvoidingState()
        if state.keyboardVisible {
            state.priorContentSize = self.contentSize
        }
    }
    
    func FocusNextTextField() -> Bool {
        guard let firstResponder = self.FindFirstResponderBeneathView(self) else { return false }
        guard let view = self.FindNextInputViewAfterView(firstResponder, beneathView: self) else { return false }
        
        Timer.scheduledTimer(timeInterval: 0.1, target: view, selector: #selector(becomeFirstResponder), userInfo: nil, repeats: false)
        
        return true
    }
    
    func ScrollToActiveTextField() {
        let state = self.keyboardAvoidingState()
        guard state.keyboardVisible else { return }
        
        let visibleSpace = self.bounds.size.height - self.contentInset.top - self.contentInset.bottom
        let idealOffset = CGPoint(x: 0, y: self.IdealOffsetForView(self.FindFirstResponderBeneathView(self), viewAreaHeight: visibleSpace))
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double((Int64)(0 * NSEC_PER_SEC)) / Double(NSEC_PER_SEC)) { [weak self] in
            self?.setContentOffset(idealOffset, animated: true)
        }
    }
    
    func FindFirstResponderBeneathView(_ view: UIView) -> UIView? {
        for childView in view.subviews {
            if childView.responds(to: #selector(getter: isFirstResponder)) && childView.isFirstResponder {
                return childView
            }
            let result = FindFirstResponderBeneathView(childView)
            if result != nil {
                return result
            }
        }
        return nil
    }
    
    func UpdateContentInset() {
        let state = self.keyboardAvoidingState()
        if state.keyboardVisible {
            self.contentInset = self.ContentInsetForKeyboard()
        }
    }
    
    func CalculatedContentSizeFromSubviewFrames() -> CGSize {
        let wasShowingVerticalScrollIndicator = self.showsVerticalScrollIndicator
        let wasShowingHorizontalScrollIndicator = self.showsHorizontalScrollIndicator
        
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false
        
        var rect = CGRect.zero
        
        self.subviews.forEach {
            rect = rect.union($0.frame)
        }
        
        for view in self.subviews {
            rect = rect.union(view.frame)
        }
        
        rect.size.height += kContentPadding
        self.showsVerticalScrollIndicator = wasShowingVerticalScrollIndicator
        self.showsHorizontalScrollIndicator = wasShowingHorizontalScrollIndicator
        
        return rect.size
    }
    
    func IdealOffsetForView(_ view: UIView?, viewAreaHeight: CGFloat) -> CGFloat {
        let contentSize = self.contentSize
        
        var offset: CGFloat = 0.0
        let subviewRect = view != nil ? view!.convert(view!.bounds, to: self) : CGRect.zero
        
        var padding = (viewAreaHeight - subviewRect.height) / 2
        if padding < kMinimumScrollOffsetPadding {
            padding = kMinimumScrollOffsetPadding
        }
        
        offset = subviewRect.origin.y - padding - self.contentInset.top
        
        if offset > (contentSize.height - viewAreaHeight) {
            offset = contentSize.height - viewAreaHeight
        }
        
        if offset < -self.contentInset.top {
            offset = -self.contentInset.top
        }
        
        return offset
    }
    
    func ContentInsetForKeyboard() -> UIEdgeInsets {
        let state = self.keyboardAvoidingState()
        var newInset = self.contentInset
        
        let keyboardRect = state.keyboardRect
        newInset.bottom = keyboardRect.size.height - max(keyboardRect.maxY - self.bounds.maxY, 0)
        
        return newInset
    }
    
    func ViewIsValidKeyViewCandidate(_ view: UIView) -> Bool {
        if view.isHidden || !view.isUserInteractionEnabled { return false}
        
        if let textField = view as? UITextField, textField.isEnabled {
            return true
        }
        
        if let textView = view as? UITextView, textView.isEditable {
            return true
        }
        
        return false
    }
    
    func FindNextInputViewAfterView(_ priorView: UIView, beneathView view: UIView, candidateView bestCandidate: inout UIView?) {
        let priorFrame = self.convert(priorView.frame, to: priorView.superview)
        let candidateFrame = bestCandidate == nil ? CGRect.zero : self.convert(bestCandidate!.frame, to: bestCandidate!.superview)
        
        var bestCandidateHeuristic = -sqrt(candidateFrame.origin.x * candidateFrame.origin.x + candidateFrame.origin.y * candidateFrame.origin.y) + ( Float(abs(candidateFrame.minY - priorFrame.minY)) < Float.ulpOfOne ? 1e6 : 0)
        
        for childView in view.subviews {
            if ViewIsValidKeyViewCandidate(childView) {
                let frame = self.convert(childView.frame, to: view)
                let heuristic = -sqrt(frame.origin.x * frame.origin.x + frame.origin.y * frame.origin.y)
                    + (Float(abs(frame.minY - priorFrame.minY)) < Float.ulpOfOne ? 1e6 : 0)
                
                if childView != priorView && (Float(abs(frame.minY - priorFrame.minY)) < Float.ulpOfOne
                    && frame.minX > priorFrame.minX
                    || frame.minY > priorFrame.minY)
                    && (bestCandidate == nil || heuristic > bestCandidateHeuristic) {
                    bestCandidate = childView
                    bestCandidateHeuristic = heuristic
                }
            } else {
                self.FindNextInputViewAfterView(priorView, beneathView: view, candidateView: &bestCandidate)
            }
        }
    }
    
    func FindNextInputViewAfterView(_ priorView: UIView, beneathView view: UIView) -> UIView? {
        var candidate: UIView?
        self.FindNextInputViewAfterView(priorView, beneathView: view, candidateView: &candidate)
        return candidate
    }
    
    @objc func AssignTextDelegateForViewsBeneathView(_ obj: AnyObject) {
        func processWithView(_ view: UIView) {
            for childView in view.subviews {
                if childView is UITextField || childView is UITextView {
                    self.initView(childView)
                } else {
                    self.AssignTextDelegateForViewsBeneathView(childView)
                }
            }
        }
        
        if let timer = obj as? Timer, let view = timer.userInfo as? UIView {
            processWithView(view)
        } else if let view = obj as? UIView {
            processWithView(view)
        }
    }
    
    func initView(_ view: UIView) {
        if let textField = view as? UITextField,
            let delegate = self as? UITextFieldDelegate, textField.returnKeyType == UIReturnKeyType.default &&
            textField.delegate !== delegate {
            textField.delegate = delegate
            let otherView = self.FindNextInputViewAfterView(view, beneathView: self)
            textField.returnKeyType = otherView != nil ? .next : .done
        }
    }
    
    func keyboardAvoidingState() -> AvoidState {
        var state = objc_getAssociatedObject(self, &KeyboardKeysPrefrences.DescriptiveName) as? AvoidState
        if state == nil {
            state = AvoidState()
            self.state = state
        }
        
        return self.state!
    }
}

internal class AvoidState: NSObject {
    var priorInset = UIEdgeInsets.zero
    var priorScrollIndicatorInsets = UIEdgeInsets.zero
    
    var keyboardVisible = false
    var keyboardRect = CGRect.zero
    var priorContentSize = CGSize.zero
    
    var priorPagingEnabled = false
}

internal extension UIScrollView {
    fileprivate struct KeyboardKeysPrefrences {
        static var DescriptiveName = "KeyBoard_DescriptiveName"
    }
    
    var state: AvoidState? {
        get {
            let optionalObject: AnyObject? = objc_getAssociatedObject(self, &KeyboardKeysPrefrences.DescriptiveName) as AnyObject?
            if let object: AnyObject = optionalObject {
                return object as? AvoidState
            } else {
                return nil
            }
        }
        set {
            objc_setAssociatedObject(self, &KeyboardKeysPrefrences.DescriptiveName, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}

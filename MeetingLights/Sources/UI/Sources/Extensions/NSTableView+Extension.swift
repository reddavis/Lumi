import Cocoa

extension NSTableView {
    open override func viewDidMoveToWindow() {
        super.viewDidMoveToWindow()
        self.backgroundColor = NSColor.clear
        self.enclosingScrollView!.drawsBackground = false
    }
}

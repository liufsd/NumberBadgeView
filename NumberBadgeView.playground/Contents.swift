//: Playground - noun: a place where people can play
import Foundation
import Cocoa

extension NSColor {
    
    
    /**
    HexColor
    eg. NSColor(0x222222)
    
    :param: value 0xFFFFF
    
    :returns: NSColor
    */
    public convenience init(_ value: Int) {
        let components = colorComponents(value)
        self.init(red: components.red, green: components.green, blue: components.blue, alpha: 1.0)
    }
}

private func colorComponents(value: Int) -> (red: CGFloat, green: CGFloat, blue : CGFloat){
    let r = CGFloat(value >> 16 & 0xFF) / 255.0
    let g = CGFloat(value >> 8 & 0xFF) / 255.0
    let b = CGFloat(value & 0xFF) / 255.0
    
    return (r, g, b)
}


import Cocoa
class NumberBadgeView: NSView {
    private let backgroundRadius = 10
    private let backgroundOffsetRight = 6
    private var drawMaxCount: UInt = 99
    private var drawTextContent: NSString = ""
    private var contentTextSize: NSSize?
    
    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)
        // Drawing code here.
        self.drawUnreadCount()
    }
    
    func showUnReaderCount(count: UInt) {
        //        self.hidden == (count <= 0)//not working?
        self.drawText(count>=drawMaxCount ? "99+" : String(count))
    }
    
    func setDrawMaxCount(maxCount: UInt) {
        self.drawMaxCount = maxCount
    }
    
    func drawText(drawText: String) {
        self.drawTextContent = drawText
        self.needsDisplay = true
    }
    
    func drawUnreadCount() {
        let offsetY = 6
        
        let font = NSFont(name: "HelveticaNeue-Bold", size: CGFloat(10))
        let attrs = [
            NSForegroundColorAttributeName: NSColor.whiteColor(),
            NSFontAttributeName: font!]
        
        var size = self.drawTextContent.sizeWithAttributes(attrs)
        size.width = ceil(size.width)
        size.height = ceil(size.height)
        self.contentTextSize = size
        
        let sizeWidth = max(Int(self.contentTextSize!.width + 12), backgroundRadius * 2)
        
        let offset2 = Int(self.bounds.size.width) - backgroundOffsetRight - backgroundRadius
        let offset1 = offset2 - (sizeWidth - backgroundRadius * 2)
        
        let path: NSBezierPath = NSBezierPath()
        
        let center1:NSPoint = NSPoint(x:offset1, y: offsetY + backgroundRadius)
        path.moveToPoint(center1)
        path.appendBezierPathWithArcWithCenter(center1, radius: CGFloat(backgroundRadius), startAngle: CGFloat(90), endAngle: CGFloat(-90))
        
        let center2:NSPoint = NSPoint(x:offset2, y: offsetY + backgroundRadius)
        path.moveToPoint(center2)
        path.appendBezierPathWithArcWithCenter(center2, radius: CGFloat(backgroundRadius), startAngle: CGFloat(-90), endAngle: CGFloat(90))
        
        path.appendBezierPathWithRect(NSMakeRect(center1.x, CGFloat(Int(center1.y)-backgroundRadius), center2.x-center1.x, CGFloat(backgroundRadius*2)))
        NSColor(0x4F65B4F).set()
        path.fill()
        path.closePath()
        
        let offsetX = (sizeWidth - Int(self.contentTextSize!.width))/2
        
        self.drawTextContent.drawAtPoint(CGPointMake(CGFloat(offset1 - backgroundRadius + offsetX),CGFloat(offsetY + 3)), withAttributes: attrs)
    }
}

let numberView = NumberBadgeView(frame: CGRectMake(0, 0, 100, 100))
numberView.showUnReaderCount(15)


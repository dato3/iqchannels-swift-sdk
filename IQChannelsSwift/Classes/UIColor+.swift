import UIKit

extension UIColor {
    
    // MARK: - Message bubble colors
    class func jsq_messageBubbleGreen() -> UIColor {
        return UIColor(hue: 130.0 / 360.0, saturation: 0.68, brightness: 0.84, alpha: 1.0)
    }

    class func jsq_messageBubbleBlue() -> UIColor {
        return UIColor(hue: 210.0 / 360.0, saturation: 0.94, brightness: 1.0, alpha: 1.0)
    }

    class func jsq_messageBubbleRed() -> UIColor {
        return UIColor(hue: 0.0, saturation: 0.79, brightness: 1.0, alpha: 1.0)
    }

    class func jsq_messageBubbleLightGray() -> UIColor {
        return UIColor(hue: 240.0 / 360.0, saturation: 0.02, brightness: 0.92, alpha: 1.0)
    }

    // MARK: - Utilities
    func jsq_colorByDarkeningColorWithValue(value: CGFloat) -> UIColor {
        let totalComponents = self.cgColor.numberOfComponents
        let isGreyscale = totalComponents == 2

        let oldComponents = self.cgColor.components
        var newComponents: [CGFloat] = .init(repeating: 0.0, count: 4)

        if isGreyscale {
            newComponents[0] = max((oldComponents?[0] ?? 0.0) - value, 0.0)
            newComponents[1] = max((oldComponents?[0] ?? 0.0) - value, 0.0)
            newComponents[2] = max((oldComponents?[0] ?? 0.0) - value, 0.0)
            newComponents[3] = oldComponents?[1] ?? 0.0
        } else {
            newComponents[0] = max((oldComponents?[0] ?? 0.0) - value, 0.0)
            newComponents[1] = max((oldComponents?[1] ?? 0.0) - value, 0.0)
            newComponents[2] = max((oldComponents?[2] ?? 0.0) - value, 0.0)
            newComponents[3] = oldComponents?[3] ?? 0.0
        }

        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let newColor = CGColor(colorSpace: colorSpace, components: newComponents)
        let retColor = UIColor(cgColor: newColor!)

        return retColor
    }
}

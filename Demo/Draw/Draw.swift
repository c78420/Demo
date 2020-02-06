//
//  Draw.swift
//  Demo
//
//  Created by 黃崇漢 on 2019/9/17.
//  Copyright © 2019 Tony Huang (黃崇漢). All rights reserved.
//

import UIKit

class Draw: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let cgView = CGView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 110))
        cgView.backgroundColor = UIColor.white
        self.scrollView.addSubview(cgView)
        
        let cgView3 = CGView3(frame:CGRect(x: 0, y: 120, width: self.view.frame.size.width, height: self.view.frame.size.height - 110))
        cgView3.backgroundColor = UIColor.white
        self.scrollView.addSubview(cgView3)
        
        let ctView5 = CGView5(frame:CGRect(x: 0, y: self.view.frame.size.height + 20, width: self.view.frame.width, height: 100))
        ctView5.backgroundColor = UIColor.white
        self.scrollView.addSubview(ctView5)
        
        let ctView6 = CGView6(frame:CGRect(x: 0, y: self.view.frame.size.height + 130, width: self.view.frame.width, height: 500))
        ctView6.backgroundColor = UIColor.white
        self.scrollView.addSubview(ctView6)
        
        let ctView7 = CGView7(frame:CGRect(x: 0, y: self.view.frame.size.height + 640, width: self.view.frame.width, height: self.view.frame.size.height))
        ctView7.backgroundColor = UIColor.white
        self.scrollView.addSubview(ctView7)
        
        self.scrollView.contentSize = CGSize(width: self.view.frame.size.width, height: ctView7.frame.origin.y + ctView7.frame.size.height + 10)
    }

}

class CGView: UIView {
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        // 1、 獲取上下文對象
        let context = UIGraphicsGetCurrentContext()
        
        // 2、 創建路徑對象
        let path = CGMutablePath()
        path.move(to: CGPoint(x: 10, y: 30))
        path.addLine(to: CGPoint(x: 10, y: 100))
        path.addLine(to: CGPoint(x: 150, y: 100))
        
        // 3、 添加路徑到圖形上下文
        context?.addPath(path)
        
        // 4、 設置圖形上下文狀態屬性
        context?.setStrokeColor(red: 1, green: 0, blue: 1, alpha: 1)
        context?.setFillColor(red: 1, green: 1, blue: 0, alpha: 1)
        
        context?.setLineWidth(5)
        context?.setLineCap(CGLineCap.round)
        context?.setLineJoin(CGLineJoin.round)
        
        let lengths: [CGFloat] = [5, 7]
        context?.setLineDash(phase: 0, lengths: lengths)
        
        let color = UIColor.gray.cgColor
        context?.setShadow(offset: CGSize(width: 2, height: 2), blur: 0.8, color: color)
        
        // 5、 繪製圖像到指定圖形上下文
        /*
         Fill:只有填充（非零纏繞數填充），不繪製邊框
         EOFill:奇偶規則填充（多條路徑交叉時，奇數交叉填充，偶交叉不填充）
         Stroke:只有邊框
         FillStroke：既有邊框又有填充
         EOFillStroke：奇偶填充並繪製邊框
         */
        context?.drawPath(using: .fillStroke)
    }
}

class CGView3: UIView {
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        // 1、 獲取上下文對象
        let context = UIGraphicsGetCurrentContext()
        
        // 畫矩形
        self.drawRectWithContext(context: context!)
        
        self.drawRectByUIKitWithContext(context: context!)
        
        // 畫橢圓
        self.drawEllipse(context: context!)
        
        // 創建弧形
        self.drawArc(context: context!)
        
        // 貝茲曲線
        self.drawCurve(context: context!)
    }
    
    // 畫矩形
    func drawRectWithContext(context: CGContext){
        let rect = CGRect(x: 20, y: 0, width: 280, height: 50)
        context.addRect(rect)
        UIColor.blue.set()
        context.drawPath(using: .fillStroke)
    }
    
    func drawRectByUIKitWithContext(context: CGContext){
        let rect = CGRect(x: 20, y: 60, width: 280.0, height: 50.0)
        let rect2 = CGRect(x: 20, y: 120, width: 280.0, height: 50.0)
        
        UIColor.yellow.set()
        UIRectFill(rect)
        
        UIColor.red.setFill()
        UIRectFill(rect2)
    }
    
    // 畫橢圓
    func drawEllipse(context: CGContext){
        let rect = CGRect(x: 20, y: 180 ,width: 100,height: 120)
        
        context.addEllipse(in: rect)
        UIColor.purple.set()
        context.drawPath(using: .fill)
    }
    
    // 創建弧形
    func drawArc(context: CGContext) {
        /*
         x:中心點x坐標
         y:中心點y坐標
         radius:半徑
         startAngle:起始弧度
         endAngle:終止弧度
         closewise:是否逆時針繪製，0則順時針繪製
         */
        context.addArc(center: CGPoint(x: 200, y: 250), radius: 50, startAngle: 0, endAngle: .pi, clockwise: false)
        UIColor.green.set()
        context.drawPath(using: .fill)
    }
    
    // 貝茲曲線
    func drawCurve(context: CGContext) {
        context.move(to: CGPoint(x: 20, y: 310))
        
        /*
         繪製二次貝茲曲線
         control:控制點坐標
         to:結束點坐標
         */
        context.addQuadCurve(to: CGPoint(x: 100, y: 400), control: CGPoint(x: 220, y: 310))
        
        context.move(to: CGPoint(x: 230, y: 310))
        
        /*
         繪製三次貝茲曲線
         to:結束點坐標
         control1:第一控制點坐標
         control2:第二控制點坐標
         */
        context.addCurve(to: CGPoint(x: 300, y: 500), control1: CGPoint(x: 100, y: 330), control2: CGPoint(x: 400, y: 410))
        
        UIColor.yellow.setFill()
        UIColor.red.setStroke()
        context.drawPath(using: .fillStroke)
    }
}

class CGView5: UIView {
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let context = UIGraphicsGetCurrentContext()
        
        // 線性漸層
        self.drawLinearGradient(context: context!)
    }
    
    func drawLinearGradient(context: CGContext) {
        // 使用rgb顏色空間
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        
        /*
         指定漸層色
         space:顏色空間
         components:顏色數組,注意由於指定了RGB顏色空間，那麼四個數組元素表示一個顏色（red、green、blue、alpha），
                    如果有三個顏色則這個數組有4*3個元素
         locations:顏色所在位置（範圍0~1），這個數組的個數不小於components中存放顏色的個數
         count:漸層個數，等於locations的個數
         */
        let compoents:[CGFloat] = [ 248.0/255.0, 86.0/255.0, 86.0/255.0, 1,
                                    249.0/255.0, 127.0/255.0, 127.0/255.0, 1,
                                    1.0, 1.0, 1.0, 1.0]
        let locations:[CGFloat] = [0, 0.4, 1]
        guard let gradient = CGGradient(colorSpace: colorSpace, colorComponents: compoents, locations: locations, count: locations.count) else { return }
        
        /*
         startPoint:起始位置
         endPoint:終止位置
         options:繪製方式，DrawsBeforeStartLocation 開始位置之前就進行繪製，到結束位置之後不再繪製，
                 DrawsAfterEndLocation 開始位置之前不進行繪製，到結束點之後繼續填充
         */
        context.drawLinearGradient(gradient, start: .zero, end: CGPoint(x: UIScreen.main.bounds.size.width, y: 100), options: .drawsAfterEndLocation)
    }
    
}

class CGView6: UIView {
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let context = UIGraphicsGetCurrentContext()
        
        // 徑向漸層
        self.drawRadialGradient(context: context!)
        
        self.drawRectWithLinearGradientFill(context: context!)
    }
    
    func drawRadialGradient(context: CGContext) {
        // 使用rgb顏色空間
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        
        /*
         指定漸層色
         space:顏色空間
         components:顏色數組,注意由於指定了RGB顏色空間，那麼四個數組元素表示一個顏色（red、green、blue、alpha），
                    如果有三個顏色則這個數組有4*3個元素
         locations:顏色所在位置（範圍0~1），這個數組的個數不小於components中存放顏色的個數
         count:漸層個數，等於locations的個數
         */
        let compoents:[CGFloat] = [ 248.0/255.0, 86.0/255.0, 86.0/255.0, 1,
                                    249.0/255.0, 127.0/255.0, 127.0/255.0, 1,
                                    1.0, 1.0, 1.0, 1.0]
        let locations:[CGFloat] = [0, 0.4, 1]
        guard let gradient = CGGradient(colorSpace: colorSpace, colorComponents: compoents, locations: locations, count: locations.count) else { return }
        
        /*
         startCenter:起始位置
         startRadius:起始半徑（通常為0，否則在此半徑範圍內容無任何填充）
         endCenter:終點位置（通常和起始點相同，否則會有偏移）
         endRadius:終點半徑（也就是漸變的擴散長度）
         options:繪製方式，DrawsBeforeStartLocation 開始位置之前就進行繪製，到結束位置之後不再繪製，
                 DrawsAfterEndLocation 開始位置之前不進行繪製，到結束點之後繼續填充
         */
        context.drawRadialGradient(gradient, startCenter: CGPoint(x: 100,y: 100), startRadius: 0, endCenter: CGPoint(x: 105, y: 105), endRadius: 80, options: .drawsAfterEndLocation)
    }
    
    func drawRectWithLinearGradientFill(context: CGContext) {
        // 使用rgb顏色空間
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        
        // 裁切處一塊矩形用於顯示，注意必須先裁切再調用漸層
//        context.clip(to: CGRect(x: 20, y: 250, width: 300, height: 300))
        // 裁切還可以使用UIKit中對應的方法
        UIRectClip(CGRect(x: 20, y: 250, width: 300, height: 300))

        let compoents:[CGFloat] = [ 248.0/255.0, 86.0/255.0, 86.0/255.0, 1,
                                    249.0/255.0, 127.0/255.0, 127.0/255.0, 1,
                                    1.0, 1.0, 1.0, 1.0]
        
        let locations:[CGFloat] = [0, 0.4, 1]
        guard let gradient = CGGradient(colorSpace: colorSpace, colorComponents: compoents, locations: locations, count: locations.count) else { return }
        
        context.drawLinearGradient(gradient, start: CGPoint(x: 20, y: 250), end: CGPoint(x: 320, y: 300), options: .drawsAfterEndLocation);
    }
}

class CGView7: UIView {
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let rect0 = CGRect(x: 0, y: 130.0, width: 320.0, height: 50.0)
        let rect1 = CGRect(x: 0, y: 390.0, width: 320.0, height: 50.0)
        
        let rect2 = CGRect(x: 20, y: 50.0, width: 10.0, height: 250.0)
        let rect3 = CGRect(x: 40.0, y: 50.0, width: 10.0, height: 250.0)
        let rect4 = CGRect(x: 60.0, y: 50.0, width: 10.0, height: 250.0)
        let rect5 = CGRect(x: 80.0, y: 50.0, width: 10.0, height: 250.0)
        let rect6 = CGRect(x: 100.0, y: 50.0, width: 10.0, height: 250.0)
        let rect7 = CGRect(x: 120.0, y: 50.0, width: 10.0, height: 250.0)
        let rect8 = CGRect(x: 140.0, y: 50.0, width: 10.0, height: 250.0)
        let rect9 = CGRect(x: 160.0, y: 50.0, width: 10.0, height: 250.0)
        let rect10 = CGRect(x: 180.0, y: 50.0, width: 10.0, height: 250.0)
        let rect11 = CGRect(x: 200.0, y: 50.0, width: 10.0, height: 250.0)
        let rect12 = CGRect(x: 220.0, y: 50.0, width: 10.0, height: 250.0)
        let rect13 = CGRect(x: 240.0, y: 50.0, width: 10.0, height: 250.0)
        let rect14 = CGRect(x: 260.0, y: 50.0, width: 10.0, height: 250.0)
        let rect15 = CGRect(x: 280.0, y: 50.0, width: 10.0, height: 250.0)
        
        let rect16 = CGRect(x: 30.0, y: 310.0, width: 10.0, height: 250.0)
        let rect17 = CGRect(x: 50.0, y: 310.0, width: 10.0, height: 250.0)
        let rect18 = CGRect(x: 70.0, y: 310.0, width: 10.0, height: 250.0)
        let rect19 = CGRect(x: 90.0, y: 310.0, width: 10.0, height: 250.0)
        let rect20 = CGRect(x: 110.0, y: 310.0, width: 10.0, height: 250.0)
        let rect21 = CGRect(x: 130.0, y: 310.0, width: 10.0, height: 250.0)
        let rect22 = CGRect(x: 150.0, y: 310.0, width: 10.0, height: 250.0)
        let rect23 = CGRect(x: 170.0, y: 310.0, width: 10.0, height: 250.0)
        let rect24 = CGRect(x: 190.0, y: 310.0, width: 10.0, height: 250.0)
        let rect25 = CGRect(x: 210.0, y: 310.0, width: 10.0, height: 250.0)
        let rect26 = CGRect(x: 230.0, y: 310.0, width: 10.0, height: 250.0)
        let rect27 = CGRect(x: 250.0, y: 310.0, width: 10.0, height: 250.0)
        let rect28 = CGRect(x: 270.0, y: 310.0, width: 10.0, height: 250.0)
        let rect29 = CGRect(x: 290.0, y: 310.0, width: 10.0, height: 250.0)
        
        UIColor.yellow.set()
        UIRectFill(rect0)
        UIColor.green.set()
        UIRectFill(rect1)
        UIColor.red.set()
        
        UIRectFillUsingBlendMode(rect2, CGBlendMode.clear )
        UIRectFillUsingBlendMode(rect3, CGBlendMode.color )
        UIRectFillUsingBlendMode(rect4, CGBlendMode.colorBurn)
        UIRectFillUsingBlendMode(rect5, CGBlendMode.colorDodge)
        UIRectFillUsingBlendMode(rect6, CGBlendMode.copy)
        UIRectFillUsingBlendMode(rect7, CGBlendMode.darken)
        UIRectFillUsingBlendMode(rect8, CGBlendMode.destinationAtop)
        UIRectFillUsingBlendMode(rect9, CGBlendMode.destinationIn)
        UIRectFillUsingBlendMode(rect10, CGBlendMode.destinationOut)
        UIRectFillUsingBlendMode(rect11, CGBlendMode.destinationOver)
        UIRectFillUsingBlendMode(rect12, CGBlendMode.difference)
        UIRectFillUsingBlendMode(rect13, CGBlendMode.exclusion)
        UIRectFillUsingBlendMode(rect14, CGBlendMode.hardLight)
        UIRectFillUsingBlendMode(rect15, CGBlendMode.hue)
        UIRectFillUsingBlendMode(rect16, CGBlendMode.lighten)
        
        UIRectFillUsingBlendMode(rect17, CGBlendMode.luminosity)
        UIRectFillUsingBlendMode(rect18, CGBlendMode.multiply)
        UIRectFillUsingBlendMode(rect19, CGBlendMode.normal)
        UIRectFillUsingBlendMode(rect20, CGBlendMode.overlay)
        UIRectFillUsingBlendMode(rect21, CGBlendMode.plusDarker)
        UIRectFillUsingBlendMode(rect22, CGBlendMode.plusLighter)
        UIRectFillUsingBlendMode(rect23, CGBlendMode.saturation)
        UIRectFillUsingBlendMode(rect24, CGBlendMode.screen)
        UIRectFillUsingBlendMode(rect25, CGBlendMode.softLight)
        UIRectFillUsingBlendMode(rect26, CGBlendMode.sourceAtop)
        UIRectFillUsingBlendMode(rect27, CGBlendMode.sourceIn)
        UIRectFillUsingBlendMode(rect28, CGBlendMode.sourceOut)
        UIRectFillUsingBlendMode(rect29, CGBlendMode.xor)
    }
}

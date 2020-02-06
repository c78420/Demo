//
//  AttributedString.swift
//  Demo
//
//  Created by 黃崇漢 on 2018/8/15.
//  Copyright © 2018年 Tony Huang (黃崇漢). All rights reserved.
//

import UIKit

class AttributedString: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // ============================================================================================================
        let str = "人生若只如初见，何事悲风秋画扇。\n等闲变却故人心，却道故人心易变。\n骊山语罢清宵半，泪雨霖铃终不怨。\n何如薄幸锦衣郎，比翼连枝当日愿。"
        //创建NSMutableAttributedString
        let attrStr = NSMutableAttributedString(string: str)
        
        //设置字体和设置字体的范围
        attrStr.addAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 30.0)], range: NSRange(location: 0, length: 3))
        //添加文字颜色
        attrStr.addAttributes([NSAttributedString.Key.foregroundColor: UIColor.red], range: NSRange(location: 17, length: 7))
        //添加文字背景颜色
        attrStr.addAttributes([NSAttributedString.Key.backgroundColor: UIColor.orange], range: NSRange(location: 17, length: 7))
        //添加下划线
        attrStr.addAttributes([NSAttributedString.Key.underlineStyle: NSNumber(value: Int8(NSUnderlineStyle.single.rawValue))], range: NSRange(location: 8, length: 7))
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 0))
        label.backgroundColor = UIColor.green
        //自动换行
        label.numberOfLines = 0;
        //设置label的富文本
        label.attributedText = attrStr;
        //label高度自适应
        label.sizeToFit()
        self.scrollView.addSubview(label)
        // ============================================================================================================
        
        //初始化NSMutableAttributedString
        let attributedString = NSMutableAttributedString()
        
        //设置字体格式和大小
        let str0 = "设置字体格式和大小"
        let dictAttr0 = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14.0)]
        let attr0 = NSAttributedString(string: str0, attributes: dictAttr0)
        attributedString.append(attr0)
        
        //设置字体颜色
        let str1 = "\n设置字体颜色\n"
        let dictAttr1 = [NSAttributedString.Key.foregroundColor: UIColor.purple]
        let attr1 = NSAttributedString(string: str1, attributes: dictAttr1)
        attributedString.append(attr1)
        
        //设置字体背景颜色
        let str2 = "设置字体背景颜色\n"
        let dictAttr2 = [NSAttributedString.Key.backgroundColor: UIColor.cyan]
        let attr2 = NSAttributedString(string: str2, attributes: dictAttr2)
        attributedString.append(attr2)
        
        /*
         注：NSLigatureAttributeName设置连体属性，取值为NSNumber对象（整数），1表示使用默认的连体字符，0表示不使用，2表示使用所有连体符号（iOS不支持2）。而且并非所有的字符之间都有组合符合。如 fly ，f和l会连起来。
         */
        //设置连体属性
        let str3 = "fly"
        let dictAttr3 = [NSAttributedString.Key.font: UIFont(name: "futura", size: 14.0)!, NSAttributedString.Key.ligature: 1] as [NSAttributedString.Key : Any]
        let attr3 = NSAttributedString(string: str3, attributes: dictAttr3)
        attributedString.append(attr3)
        
        /*!
         注：NSKernAttributeName用来设置字符之间的间距，取值为NSNumber对象（整数），负值间距变窄，正值间距变宽
         */
        
        let str4 = "\n设置字符间距"
        let dictAttr4 = [NSAttributedString.Key.kern: 4]
        let attr4 = NSAttributedString(string: str4, attributes: dictAttr4)
        attributedString.append(attr4)
        
        /*!
         注：NSStrikethroughStyleAttributeName设置删除线，取值为NSNumber对象，枚举NSUnderlineStyle中的值。NSStrikethroughColorAttributeName设置删除线的颜色。并可以将Style和Pattern相互 取与 获取不同的效果
         */
        
        let str51 = "\n设置删除线为细单实线,颜色为红色"
        let dictAttr51 = [NSAttributedString.Key.strikethroughStyle: NSNumber(value: Int8(NSUnderlineStyle.single.rawValue)), NSAttributedString.Key.strikethroughColor: UIColor.red] as [NSAttributedString.Key : Any]
        let attr51 = NSAttributedString(string: str51, attributes: dictAttr51)
        attributedString.append(attr51)


        let str52 = "\n设置删除线为粗单实线,颜色为红色"
        let dictAttr52 = [NSAttributedString.Key.strikethroughStyle: NSNumber(value: Int8(NSUnderlineStyle.thick.rawValue)), NSAttributedString.Key.strikethroughColor: UIColor.red] as [NSAttributedString.Key : Any]
        let attr52 = NSAttributedString(string: str52, attributes: dictAttr52)
        attributedString.append(attr52)

        let str53 = "\n设置删除线为细单实线,颜色为红色"
        let dictAttr53 = [NSAttributedString.Key.strikethroughStyle: NSNumber(value: Int8(NSUnderlineStyle.double.rawValue)), NSAttributedString.Key.strikethroughColor: UIColor.red] as [NSAttributedString.Key : Any]
        let attr53 = NSAttributedString(string: str53, attributes: dictAttr53)
        attributedString.append(attr53)
        
        
//        let str54 = "\n设置删除线为细单虚线,颜色为红色"
//        let dictAttr54 = [NSAttributedStringKey.strikethroughStyle: NSNumber(value: UInt8(NSUnderlineStyle.styleSingle.rawValue | NSUnderlineStyle.patternDot.rawValue)), NSAttributedStringKey.strikethroughColor: UIColor.red] as [NSAttributedStringKey : Any]
//        let attr54 = NSAttributedString(string: str54, attributes: dictAttr54)
//        attributedString.append(attr54)
        
        /*!
         NSStrokeWidthAttributeName 设置笔画的宽度，取值为NSNumber对象（整数），负值填充效果，正值是中空效果。NSStrokeColorAttributeName  设置填充部分颜色，取值为UIColor对象。
         设置中间部分颜色可以使用 NSForegroundColorAttributeName 属性来进行
         */
        //设置笔画宽度和填充部分颜色
        let str6 = "设置笔画宽度和填充颜色\n"
        let dictAttr6 = [NSAttributedString.Key.strokeWidth: 2, NSAttributedString.Key.strokeColor: UIColor.blue] as [NSAttributedString.Key : Any]
        let attr6 = NSAttributedString(string: str6, attributes: dictAttr6)
        attributedString.append(attr6)
        
        //设置阴影属性，取值为NSShadow对象
        let str7 = "设置阴影属性\n"
        let shadow = NSShadow()
        shadow.shadowColor = UIColor.red
        shadow.shadowBlurRadius = 1.0
        shadow.shadowOffset = CGSize(width: 1, height: 1)
        let dictAttr7 = [NSAttributedString.Key.shadow: shadow]
        let attr7 = NSAttributedString(string: str7, attributes: dictAttr7)
        attributedString.append(attr7)
        
        //设置文本特殊效果，取值为NSString类型，目前只有一个可用效果  NSTextEffectLetterpressStyle（凸版印刷效果）
//        let str8 = "设置特殊效果\n"
//        let dictAttr8 = [NSAttributedStringKey.textEffect: NSAttributedString.TextEffectStyle.letterpressStyle]
//        let attr8 = NSAttributedString(string: str8, attributes: dictAttr8)
//        attributedString.append(attr8)
        
        //设置文本附件，取值为NSTextAttachment对象，常用于文字的图文混排
//        let str9 = "文字的图文混排\n"
//        let textAttachment = NSTextAttachment()
//        textAttachment.image = UIImage(named: "Add")
//        textAttachment.bounds = CGRect(x: 0, y: 0, width: 30, height: 30)
//        let dictAttr9 = [NSAttributedStringKey.attachment: textAttachment]
//        let attr9 = NSAttributedString(string: str9, attributes: dictAttr9)
//        attributedString.append(attr9)
        
        /*!
         添加下划线 NSUnderlineStyleAttributeName。设置下划线的颜色 NSUnderlineColorAttributeName，对象为 UIColor。使用方式同删除线一样。
         */
        //添加下划线
        let str10 = "添加下划线\n"
        let dictAttr10 = [NSAttributedString.Key.underlineStyle: NSNumber(value: Int8(NSUnderlineStyle.single.rawValue)), NSAttributedString.Key.underlineColor: UIColor.red] as [NSAttributedString.Key : Any]
        let attr10 = NSAttributedString(string: str10, attributes: dictAttr10)
        attributedString.append(attr10)
        
        /*!
         NSBaselineOffsetAttributeName 设置基线偏移值。取值为NSNumber （float），正值上偏，负值下偏
         */
        //设置基线偏移值 NSBaselineOffsetAttributeName
        let str11 = "添加基线偏移值\n"
        let dictAttr11 = [NSAttributedString.Key.baselineOffset: -10]
        let attr11 = NSAttributedString(string: str11, attributes: dictAttr11)
        attributedString.append(attr11)
        
        /*!
         NSObliquenessAttributeName 设置字体倾斜度，取值为 NSNumber（float），正值右倾，负值左倾
         */
        //设置字体倾斜度 NSObliquenessAttributeName
        let str12 = "设置字体倾斜度\n"
        let dictAttr12 = [NSAttributedString.Key.obliqueness: 0.5]
        let attr12 = NSAttributedString(string: str12, attributes: dictAttr12)
        attributedString.append(attr12)
        
        /*!
         NSExpansionAttributeName 设置字体的横向拉伸，取值为NSNumber （float），正值拉伸 ，负值压缩
         */
        //设置字体的横向拉伸 NSExpansionAttributeName
        let str13 = "设置字体横向拉伸\n"
        let dictAttr13 = [NSAttributedString.Key.expansion: 0.5]
        let attr13 = NSAttributedString(string: str13, attributes: dictAttr13)
        attributedString.append(attr13)
        
        /*!
         NSWritingDirectionAttributeName 设置文字的书写方向，取值为以下组合
         @[@(NSWritingDirectionLeftToRight | NSWritingDirectionEmbedding)]
         @[@(NSWritingDirectionLeftToRight | NSWritingDirectionOverride)]
         @[@(NSWritingDirectionRightToLeft | NSWritingDirectionEmbedding)]
         @[@(NSWritingDirectionRightToLeft | NSWritingDirectionOverride)]
         
         ???NSWritingDirectionEmbedding和NSWritingDirectionOverride有什么不同
         */
        //设置文字的书写方向 NSWritingDirectionAttributeName
        let str14 = "设置文字书写方向\n"
        let dictAttr14 = [NSAttributedString.Key.writingDirection: NSWritingDirection.rightToLeft]
        let attr14 = NSAttributedString(string: str14, attributes: dictAttr14)
        attributedString.append(attr14)
        
        /*!
         NSVerticalGlyphFormAttributeName 设置文字排版方向，取值为NSNumber对象（整数），0表示横排文本，1表示竖排文本  在iOS中只支持0
         */
        //设置文字排版方向 NSVerticalGlyphFormAttributeName
        let str15 = "设置文字排版方向\n"
        let dictAttr15 = [NSAttributedString.Key.verticalGlyphForm: 0]
        let attr15 = NSAttributedString(string: str15, attributes: dictAttr15)
        attributedString.append(attr15)
        
        //段落样式
        let paragraph = NSMutableParagraphStyle()
        //行间距
        paragraph.lineSpacing = 10
        //段落间距
        paragraph.paragraphSpacing = 20
        //对齐方式
        paragraph.alignment = NSTextAlignment.left
        //指定段落开始的缩进像素
        paragraph.firstLineHeadIndent = 30
        //调整全部文字的缩进像素
        paragraph.headIndent = 10
        
        //添加段落设置
        attributedString.addAttributes([NSAttributedString.Key.paragraphStyle: paragraph], range: NSRange(location: 0, length: attributedString.length))
        
        let label2 = UILabel(frame: CGRect(x: 0, y: 100, width: self.view.frame.size.width, height: 0))
        label2.backgroundColor = UIColor.lightGray
        //自动换行
        label2.numberOfLines = 0
        //设置label的富文本
        label2.attributedText = attributedString
        //label高度自适应
        label2.sizeToFit()
        self.scrollView.addSubview(label2)
        
        self.scrollView.contentSize = CGSize(width: self.view.frame.size.width, height: label.frame.size.height + label2.frame.size.height)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

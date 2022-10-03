//
//  AboutUs.swift
//  LVS
//
//  Created by Jalal on 12/13/16.
//  Copyright © 2016 Abd Al Majed. All rights reserved.
//

import UIKit

class AboutUs: UIViewController, UITextViewDelegate {

    @IBOutlet weak var showMenu: UIButton!

    @IBOutlet weak var label1: UILabel!
    
    @IBOutlet weak var label: UILabel!
    
    @IBOutlet weak var label2: UILabel!
    
    @IBOutlet weak var ourSchool: UILabel!
    
    @IBOutlet weak var LVS_Story: UITextView!
    
    @IBOutlet weak var imageHeight: NSLayoutConstraint!
    
    @IBOutlet weak var label1Width: NSLayoutConstraint!
    
    @IBOutlet weak var labelWidth: NSLayoutConstraint!
    
    @IBOutlet weak var label2Width: NSLayoutConstraint!
    
    @IBOutlet weak var totalWidth: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.isTranslucent = false
        
        self.navigationItem.title = NSLocalizedString("about_us", comment: "")
                
        if (Locale.current as NSLocale).object(forKey: NSLocale.Key.languageCode) as! String == "ar"
        {
            showMenu.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.rightRevealToggle(_:)), for: .touchUpInside)
            self.revealViewController().rearViewController = nil
        }
        else
        {
            showMenu.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
            self.revealViewController().rightViewController = nil
        }
        
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        // Do any additional setup after loading the view.
        
        self.totalWidth.constant = (341.0 / 375.0) * self.view.frame.width
        
        self.labelWidth.constant = (144.0 / 341.0) * self.totalWidth.constant
        
        self.label1Width.constant = (144.0 / 341.0) * self.totalWidth.constant
        
        self.label2Width.constant = (53.0 / 341.0) * self.totalWidth.constant
        
        self.imageHeight.constant = self.view.frame.width / 2
        
        self.view.backgroundColor = Colors.getInstance().colorBackground
        
        self.ourSchool.textColor = Colors.getInstance().colorPrimary
        
        self.label1.textColor = Colors.getInstance().colorPrimary
        
        self.label1.adjustsFontSizeToFitWidth = true
        
        self.label.textColor = Colors.getInstance().colorAccent
        
        self.label.adjustsFontSizeToFitWidth = true
        
        self.label2.textColor = Colors.getInstance().colorPrimary
        
        self.label2.adjustsFontSizeToFitWidth = true
        
        let phoneTap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.webPage(_:)))
        
        self.label.addGestureRecognizer(phoneTap)
        
        self.LVS_Story.delegate = self
        
        self.LVS_Story.text = "من القرية الصغيرة إلى العالم الكبير تبدأُ رحلة النجاح.\nالفكرة التي راودتنا مطلع عام 1999،هي إنشاء مؤسسةٍ تعليمية تربوية تنهل من إيجابيات منهجٍ رسميٍ رصين عالي المستوى يتم رفده و إثرائه بمواد داعمة تغني ثقافة الطلاب و تمكنهم من الأدوات اللازمة لخوض غمار المستقبل من لغة أجنبية و أسلوب تفكير و حب الاطلاع و البحث.\nمن أجل تحقيق تلك الغايات وفق أعلى المعايير تم افتتاح مدرسة القرية الصغيرة عام 1999 إذ تم التدرج بافتتاح المراحل بدءاً من المرحلة التحضيرية والصفوف الأولى وأخذت المدرسة تكبر مع أبنائها حتى اكتملت المراحل الدراسية كاملةً.\nنمت المدرسة من مبنى بمساحة 800م2 على أرض مساحتها 4000م2 إلى أن أصبحت تضم أربعة مبانيّ ومسرحاً وصالة رياضية مغلقة ومجموعةً من ملاعب كرة السلة وكرة القدم ومسبحاً وأبنية خدمية من مطاعم ومبانيّ ترفيهية ومبانيّ للأنشطة بحيث بلغت مساحة الأبنية ما يقارب الـ20000م2 على أرضٍ مساحتها حوالي الـ 40000م2.\nوازداد عدد الطلاب من 190طالباً عند الافتتاح لعام 1999 ليبلغ حوالي الـ 3000 طالب بعد عشر سنوات ولم يُخيب أبناء مدرسة القرية الصغيرة أمل الإدارة بهم.\nفعلى الصعيد العلمي تفخر إدارة المدرسة بتفوق أبنائها وليس أدل على ذلك من نسب النجاح في الشهادتين الإعدادية والثانوية التي حافظت على نسبة 100% نجاح وحصولهم على المراتب الأولى على المحافظة في كل دورة.\nكذلك تفوق أولئك الطلاب عند تقدمهم لفحوص عالمية مثل IGCSE بحصولهم على معدلات ممتازة أعلى من تلك التي يحصل عليها عادة قرناؤهم في المدارس التي تعتمد ذلك المنهاج فقط. ولم يقتصر تفوق طلاب المدرسة على المجال العلمي بل امتد ليشمل التفوق الرياضي فقد حازوا وباستمرار على المراتب الأولى في جميع البطولات الرياضية المدرسية التي شاركوا بها.\nشارك طلاب المدرسة في مهرجانات ومناسبات عالمية مثلوا عامين محدديين من فيها بلدهم أفضل تمثيل.\nعلى الصعيد الفني عُرفت مدرسة القرية الصغيرة بضخامة أعمالها الفنية التي تهدف لرعاية مواهب أبنائها وتنمية شخصياتهم إذ قدمت احتفاليات وعروض يشارك فيها المئات من أبنائها إلى جانب نخبةً من فناني ونجوم سورية.\nوتتابع إدارة المدرسة إنجازات الخريجين من أبنائها وتفوقهم الدراسي وحياتهم العملية بكثيرٍ من الفخر والتقدير والمحبة.\nخطواتنا تلك على طريق حلمنا الكبير ستستمر على الرُغم من الصعاب والظروف التي حالت دون تحقيق طموحاتٍ ورؤىً وأهداف في مواعيدها، لكنّ الإصرار والإرادة والأمل أسلحةٌ لن نتخلى عنها إيماناً منا بأن عملية بناء إنسانِ الغد تبدأ بقرار جريءٍ ينطلق في طريقٍ صحيحٍ نحو هدفٍ كبير.\n"
        
        //self.LVS_Story.contentInset = UIEdgeInsetsMake(0.0, 0.0, 0.0, 5.0)
        
        //self.powering.text = String(htmlEncodedString: desc)
    }
    
    override func viewDidLayoutSubviews() {
        self.LVS_Story.scrollRangeToVisible(NSMakeRange(0, 0))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func webPage(_ sender: AnyObject)
    {
        print("test")
        UIApplication.shared.open(URL(string : "http://www.littlevillageschool.com")! )
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let verticalIndicator: UIView = (scrollView.subviews[(scrollView.subviews.count - 1)] )
        verticalIndicator.backgroundColor = Colors.getInstance().colorAccent
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

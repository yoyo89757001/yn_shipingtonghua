//
//  ViewController.swift
//  yn_shipingtonghua
//
//  Created by 陈军 on 2021/1/25.
//

import UIKit
import SwiftyUserDefaults
import SnapKit
import QMUIKit
import ESPullToRefresh
import Alamofire


//主界面
class ViewController: UIViewController,UICollectionViewDelegate, UICollectionViewDataSource, UIGestureRecognizerDelegate {
    lazy var topBox = UIButton()
    var butt:UIButton?
    var popview :QMUIPopupMenuView?
    // 当前statusBar使用的样式
    var style: UIStatusBarStyle = .lightContent
    var collectionView : UICollectionView?
    var dataSource : [BBModel] = []
    var qmuiTip : QMUITips? =  nil
    let kongBox = UIView()
    let kongLabel = UILabel()
    let kongImg = UIImageView()
    let ref = UIRefreshControl()
    
     
    // 重现statusBar相关方法
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return self.style
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor=UIColor.init(hexString: "ffffff")
        print(Defaults.topbarHeight,"状态栏高度")
        
        if Defaults.password == "" {//跳转到登录界面
            let logvc = Logging()
            self.navigationController?.pushViewController(logvc, animated: true)
        }
        
        let tgp = UITapGestureRecognizer.init() //手势监听事件
        tgp.delegate=self; //手势监听事件
        self.view.addGestureRecognizer(tgp) //手势监听事件
             
        NotificationCenter.default.addObserver(self, selector: #selector(becomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(becomeDeath), name: UIApplication.willResignActiveNotification, object: nil)
        
        initview();
       
    }
    
    @objc
    func becomeDeath(){
        print("前台到后台")
        
    }
    
    @objc
    func becomeActive(){
        print("后台到前台")
        qmuiTip = QMUITips.showLoading("登录中...", in: self.view)
        get_link()
    }

    //手势监听事件
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if (touch.view!.isDescendant(of: self.collectionView!)) {
            if popview!.isHidden {//如果popview是隐藏的，不拦截点击事件,否则相反
                return false;
            }else{
                popview?.hideWith(animated: true)
                return true;
            }
        }
        return true;
    }
    
    
    func initview(){
        view.addSubview(topBox)
        topBox.backgroundColor=UIColor.init(hexString: "E6481D")
        
        setupUICollection()

        let title = VUtils.Label(view: topBox, text: "远程探视", color: "FFFFFF", size: 18)
        butt = VUtils.Button(view: topBox, name: "san2", top: 10, left: 10, bottom: 10, right: 10)
        butt!.addTarget(self, action: #selector(touchUpInsideFn), for: UIControl.Event.touchUpInside)
       
        topBox.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(Defaults.topbarHeight+44)
         }
        title.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(Defaults.topbarHeight+6)
         }
        butt!.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-9)
            make.centerY.equalTo(title.snp.centerY)
            make.width.equalTo(40)
            make.height.equalTo(40)
         }
        
        popview =  QMUIPopupMenuView.init()
        popview!.automaticallyHidesWhenUserTap = true;
        popview!.contentMode = .bottom
        popview!.shouldShowItemSeparator=true
        let item1 = QMUIPopupMenuButtonItem.init()
        let item1tap = UITapGestureRecognizer.init(target: self, action: #selector(tc_tapView))
        item1.button.addGestureRecognizer(item1tap)
        item1.title="退出登录"
        item1.image=UIImage.init(named: "tuichu")?.reSizeImage(reSize: CGSize(width: 22, height: 22))
        popview!.items=[item1]
        popview!.sourceView=butt
//         popview!.didHideBlock = {(hidesByUserTap:Bool)->Void in
//            print(hidesByUserTap)
//        }
        view.addSubview(popview!)
        kongBox.addSubview(kongImg)
        kongBox.addSubview(kongLabel)
        view.addSubview(kongBox)
        kongBox.isHidden = false
        kongImg.image=UIImage.init(named: "zwsjbg")
        kongLabel.text="暂无数据";kongLabel.textColor=UIColor.init(hexString: "dddddd")
        kongBox.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
         }
        kongImg.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.width.equalTo(100)
            make.height.equalTo(100)
         }
        kongLabel.snp.makeConstraints { (make) in
            make.top.equalTo(kongImg.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        kongBox.isHidden=true
        ref.tintColor=UIColor.init(hexString: "ff3e2b")
        
//        let tap = UITapGestureRecognizer.init(target: self, action: #selector(tapView))
//        view.addGestureRecognizer(tap)

      
    }
    
    
    func setupUICollection(){
          let layout = UICollectionViewFlowLayout()
          layout.itemSize = CGSize(width: (self.view.bounds.size.width - 12), height: 270)
          collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
          collectionView!.register(CollectionViewCell.self, forCellWithReuseIdentifier: "CollectionViewCell")
          collectionView!.delegate = self
          collectionView!.dataSource = self
          collectionView!.bounces = true
          collectionView!.showsVerticalScrollIndicator = false
          collectionView!.bouncesZoom = true
          
        
          collectionView!.refreshControl = ref
          collectionView!.backgroundColor = UIColor.init(hexString: "ffffff")
          view.addSubview(collectionView!)
          collectionView!.snp.makeConstraints { (make) in
                make.top.equalTo(topBox.snp.bottom).offset(8)
                make.left.equalToSuperview()
                make.right.equalToSuperview()
                make.bottom.equalToSuperview()
            }
        
//        self.collectionView!.es.addPullToRefresh {
//            [unowned self] in
//            /// 在这里做刷新相关事件
//            print("刷新了")
//            get_link()
//            /// 如果你的刷新事件成功，设置completion自动重置footer的状态
//            //   self.collectionView!.es.stopPullToRefresh()
//            /// 设置ignoreFooter来处理不需要显示footer的情况
//            //self.collectionView!.es.stopPullToRefresh(completion: true, ignoreFooter: false)
//        }
        ref.addTarget(self, action: #selector(shuaxin), for: UIControl.Event.valueChanged)
       
    }
    
    
    @objc
    func shuaxin() {
        print("刷新")
        get_link()
    }
    
    
    @objc func touchUpInsideFn() {
        print("你点击了菜单按钮")
        if popview!.isHidden {
            popview?.showWith(animated: true)
        }else{
            popview?.hideWith(animated: true)
        }
     }
    
    @objc func tc_tapView() {
        print("你点击了退出按钮")
        popview?.hideWith(animated: true)
        let loggingvc = Logging()
        navigationController?.pushViewController(loggingvc, animated: true)
        
     }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
           return dataSource.count
       }

       func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
           let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
           let data = dataSource[indexPath.row]
        cell.imageView.image = UIImage(named: "a11");
        cell.name.text=(data.elderName ?? "") + " " + (data.roomName ?? "")
        let ttm=data.visitTime?.split(separator: " ")[0]
        let sss = "探视时间:\(ttm ?? "")\n" + "\(data.startTime ?? "")至\(data.endTime ?? "")"
        cell.times.text = sss
        cell.kaishi.tag=indexPath.row
        cell.kaishi.addTarget(self, action: #selector(touchUpTanShi(sender:)),for: UIControl.Event.touchUpInside)
        return cell
       }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("item被点击")
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
           self.navigationController?.setNavigationBarHidden(true, animated: false)
           super.viewWillAppear(animated)
               // 隐藏导航栏 true 有动画
        popview?.hideWith(animated: false)
        print("视图将要显示")
        qmuiTip = QMUITips.showLoading("加载中...", in: self.view)
        get_link()
        
       }
    
    
    
    @objc
    func touchUpTanShi(sender:UIButton) {
        print("点击了探视",sender.tag)
        print(Defaults.phone?.suffix(10).description ?? "")
        let vc = PlayAudio()
        vc.roomId=UInt32(dataSource[sender.tag].userCode ?? "0") ?? 0
        vc.userId=Defaults.phone?.suffix(10).description ?? ""
        print("截取的时间",dataSource[sender.tag].visitTime?.split(separator: " ")[0] ?? "")
        let aadd = dataSource[sender.tag].visitTime?.split(separator: " ")[0] ?? ""
        let str  = aadd + " " + (dataSource[sender.tag].endTime ?? "")
        print(str)
        let time = str.timeStrChangeTotimeInterval("yyyy-MM-dd HH:mm")
        print("time == \(time)")
        vc.time = TimeInterval(time) ?? 0
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    func get_link(){
       
        struct Login: Encodable {
            let pageNum: String
            let pageSize: String
            let params: Params
        }
        struct Params: Encodable {
          
        }
        
        let login = Login(pageNum: "1",pageSize: "200", params: Params())
             //JSONParameterEncoder.default //URLEncodedFormParameterEncoder.default
             AF.request(URL+"/app/elder/getElderInfoByAppoint",
               method: .post,
               parameters: login,
               encoder: JSONParameterEncoder.default,
               headers: [HTTPHeader(name: "token", value: Defaults.token ?? "")]).responseString { response in
                print("返回值",response.value!)
                    DispatchQueue.main.async {
                    do{
                        self.qmuiTip?.hide(animated: true)
                        let handyModel = try JSONDecoder().decode([BBModel].self, from: response.data ?? Data())
                        print(handyModel.isEmpty)
                        self.dataSource=[]
                        if handyModel.isEmpty{
                            self.kongBox.isHidden = false //空数据
                         }else{
                            self.kongBox.isHidden = true
                            for item in handyModel {
                                self.dataSource.append(item)
                            }
                         }
                        self.collectionView?.reloadData()
                        //self.collectionView!.es.stopPullToRefresh()
                        self.ref.endRefreshing()
                }catch{
                    print(error,"错误")
                }
            }
               
        }
    }

}


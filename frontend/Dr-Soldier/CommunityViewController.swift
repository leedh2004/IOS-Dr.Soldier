//
//  ViewController.swift
//  Dr-Soldier
//
//  Created by LDH on 2020/04/21.
//  Copyright © 2020 LDH. All rights reserved.
//

import UIKit
import Alamofire

class CommunityViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var mainTableView: UITableView!
    
    var docs : Array<Document> = []
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return docs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = mainTableView.dequeueReusableCell(withIdentifier: "DocumentCell", for: indexPath) as! DocumentCell
        let document = docs[indexPath.row]
        cell.titleLabel.text = document.title
        cell.descriptionLabel.text = document.description
        cell.informationLabel.text = "유저이름 | " + document.created
        cell.thumbsUpBtn.titleLabel?.text = String(document.thumbsUp)
        cell.thumbsDownBtn.titleLabel?.text = String(document.thumbsDown)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let nextView = self.storyboard?.instantiateViewController(withIdentifier: "DocumentDetailViewController") as! DocumentDetailViewController
        let document = docs[indexPath.row]
        nextView.titleString = document.title
        nextView.descriptionString = document.description
        self.navigationController?.pushViewController(nextView, animated: true)
        
    }
    
    func getDocs(){
        self.docs.insert(Document(title: "헬로우 스위프트~", description: "킾고잉~ 코더스하이!", created: "temp", writer: "관리자", thumbsUp: 0, thumbsDown: 0, isDeleted: false), at: 0)
        AF.request("http://127.0.0.1:8000/documents").responseJSON { response in
            switch response.result{
            case .success(let value):
                print("DIE")
                print(type(of: value))
                let responseList = value as! Array<AnyObject>
                print(responseList[0])
                
                let dateFormatter = DateFormatter()
                let now = Date()
                dateFormatter.dateFormat="yyyy-MM-dd HH:mm:ss"
                dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
                
                for (index, element) in responseList.enumerated(){
                    //let obj = element["fields"] as! AnyObject
                    let title = responseList[index]["title"] as! String
                    let description = responseList[index]["title"] as! String
                    let likes = responseList[index]["likes_number"] as! Int
                    let dislikes = responseList[index]["dislikes_number"] as! Int
                    //let host = responseList[index]["host"] as! String
                    let created = responseList[index]["created"] as! String
                    let end = created.index(created.endIndex, offsetBy: -7)
                    let tmpstr = String(created[...end]) // Date 로 바꾸기 위해 잘라준다.
                    print(title)
                    print(description)
                    print(likes)
                    print(dislikes)
                    //print(host)
                    
                    let date = dateFormatter.date(from: tmpstr)
                    let intervalSecond = now.timeIntervalSince(date!)
                    let createdStr : String
                    print(intervalSecond)
                    switch intervalSecond {
                    case 0...3600:
                        let m : Int = Int(intervalSecond / 60)
                        if(m == 0){ createdStr = "방금" }
                        else{ createdStr = "\(m)분 전" }
                    case 3601...3600*24:
                        let h : Int = Int(intervalSecond / 3600)
                        createdStr = "\(h)시간 전"
                    case 3600*24...3600*24*365:
                        let d : Int = Int(intervalSecond / (3600*24))
                        createdStr = "\(d)일 전"
                    default:
                        let d : Int = Int(intervalSecond / (3600*24*365))
                        createdStr = "\(d)년 전"
                    }
                    print(createdStr)
                    self.docs.insert(Document(title: title, description: description, created: createdStr, writer: "leedh2004", thumbsUp: likes, thumbsDown: dislikes, isDeleted: false), at: index)
                }
            case .failure(let error):
                print("maybe server down")
            }
//            let responseList = response.value as! Array<AnyObject>
//            for (index, element) in responseList.enumerated(){
//                let obj = element["fields"] as! AnyObject
//                let title = obj["title"] as! String
//                let description = obj["text"] as! String
//                self.docs.insert(Document(title: title, description: description, created: Date(), writer: "leedh2004", thumbsUp: 30, thumbsDown: 10, isDeleted: false), at: index)
//            }
            DispatchQueue.main.async {
                self.mainTableView.reloadData()
            }
           
        }
        print("getDocs()!")
    }
    
    @objc func writeButtonClicked(){
        let nextView = self.storyboard?.instantiateViewController(withIdentifier: "WriteViewController") as! WriteViewController
         self.navigationController?.pushViewController(nextView, animated: true)
    }
    @objc func refreshButtonClicked(){
        print("refresh button Clicked!")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        self.navigationItem.hidesBackButton = true;
//        self.navigationItem.leftBarButtonItem = nil;
        let navview = Variable_Functions.init()
        self.navigationItem.titleView = navview.navView
        getDocs()
        mainTableView.delegate = self
        mainTableView.dataSource = self
        // 라이트 뷰 생성
        let rightView = UIView()
        rightView.frame = CGRect(x: 0, y: 0, width: 80, height: 40)
        // rItem이라는 UIBarButtonItem 객체 생성
        let rItem = UIBarButtonItem(customView: rightView)
        self.navigationItem.rightBarButtonItem = rItem
        // 새로고침 버튼 생성
        let refreshButton = UIButton(type:.system)
        refreshButton.frame = CGRect(x:50, y:8, width: 30, height: 30)
        refreshButton.setImage(UIImage(systemName: "arrow.clockwise"), for: .normal)
        refreshButton.tintColor = .white
        refreshButton.addTarget(self, action: #selector(refreshButtonClicked), for: .touchUpInside)
        // 라이트 뷰에 버튼 추가
        rightView.addSubview(refreshButton)
        // 글쓰기 버튼 생성
        let writeButton = UIButton(type:.system)
        writeButton.frame = CGRect(x:10, y:8, width: 30, height: 30)
        writeButton.setImage(UIImage(systemName: "pencil.circle"), for: .normal)
        writeButton.tintColor = .white
        writeButton.addTarget(self, action: #selector(writeButtonClicked), for: .touchUpInside)
        // 라이트 뷰에 버튼 추가
        rightView.addSubview(writeButton)
//
//        let writeButton = UIButton(type: .system)
//        wrtieButton.frame = CGRect(
//
//        let writeButton = UIBarButtonItem(barButtonSystemItem:.add, target: self, action: #selector(buttonClicked))
        
    }


}



//
//  ViewController.swift
//  testAbhay
//
//  Created by Sagar Kamble on 25/03/18.
//  Copyright © 2018 Abhay Raj. All rights reserved.
//

import UIKit

struct WeatherData {
    var humidity: String
    var pressure: String
    var temp:String
    var name:String
    var lat:String
    var lon:String
    var descriptionWeather:String
}

class ViewController: UIViewController ,UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var loader: UIActivityIndicatorView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var weatherTableView: UITableView!
    @IBOutlet weak var temperatureLabel: UILabel!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    
    var indexPath:IndexPath?
    var weatherData:[WeatherData] = []
//    var data = [] as! NSArray;
    var carName = ["Sydney", "Melbourne", "Brisbane"]
    var dataId = ["4163971", "2147714", "2174003"]
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        weatherTableView.tableFooterView = UIView(frame: .zero);
//        for id in dataId{
            self.makeGetCall(id: "2147714");
        let context = appDelegate.persistentContainer.viewContext
        let userEntity = NSEntityDescription.entity(forEntityName: "User", in: managedContext)!
        
        let user = NSManagedObject(entity: userEntity, insertInto: managedContext)
//        }
    }
    
    func makeGetCall(id : String) {
        // Set up the URL request
        self.view.bringSubview(toFront: self.loader)
        self.loader.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        let weatherPointDataURL: String = "https://api.openweathermap.org/data/2.5/weather?id=\(id)&APPID=e7d9e3b70bde4d6bd9261af92b164daf"
        guard let url = URL(string: weatherPointDataURL) else {
            print("Error: cannot create URL")
            self.loader.stopAnimating()
            self.view.sendSubview(toBack: self.loader)
            UIApplication.shared.endIgnoringInteractionEvents()
            
            return
        }
        let urlRequest = URLRequest(url: url)
        
        // set up the session
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        // make the request
        let task = session.dataTask(with: urlRequest) {
            (data, response, error) in
            // check for any errors
            guard error == nil else {
                print("error calling GET on /weather/1")
                self.loader.stopAnimating()
                self.view.sendSubview(toBack: self.loader)
                UIApplication.shared.endIgnoringInteractionEvents()
                print(error!)
                return
            }
            // make sure we got data
            guard let responseData = data else {
                print("Error: did not receive data")
                self.loader.stopAnimating()
                self.view.sendSubview(toBack: self.loader)
                UIApplication.shared.endIgnoringInteractionEvents()
                
                return
            }
            // parse the result as JSON, since that's what the API provides
            do {
                guard let todo = try JSONSerialization.jsonObject(with: responseData, options: [])
                    as? [String: Any] else {
                        print("error trying to convert data to JSON")
                        self.loader.stopAnimating()
                        self.view.sendSubview(toBack: self.loader)
                        UIApplication.shared.endIgnoringInteractionEvents()
                        
                        return
                }
                // now we have the todo
                // let's just print it to prove we can access it
                print("The todo is: " + todo.description)
                var array = Array(todo)
                var weatherInfo:WeatherData?
//                JSONSerialization.data(withJSONObject: <#T##Any#>, options: <#T##JSONSerialization.WritingOptions#>)
//                weatherInfo?.humidity = todo.description.main.humidity;
//                weatherInfo?.pressure = todo.description.main.pressure;
//                weatherInfo?.temp = todo.description.main.temp;
//                weatherInfo?.lat = todo.description.main.humidity;
//                weatherInfo?.humidity = todo.description.main.humidity;
//                weatherInfo?.humidity = todo.description.main.humidity;
//                weatherInfo?.humidity = todo.description.main.humidity;
//                weatherInfo?.humidity = todo.description.main.humidity;
//
                
//                self.weatherData.append()
                // the todo object is a dictionary
                // so we just access the title using the "title" key
                // so check for a title and print it if we have one
                guard let todoTitle = todo["title"] as? String else {
                    print("Could not get todo title from JSON")
                    self.loader.stopAnimating()
                    self.view.sendSubview(toBack: self.loader)
                    UIApplication.shared.endIgnoringInteractionEvents()
                    
                    return
                }
                print("The title is: " + todoTitle)
            } catch  {
                print("error trying to convert data to JSON")
                self.loader.stopAnimating()
                self.view.sendSubview(toBack: self.loader)
                UIApplication.shared.endIgnoringInteractionEvents()
                
                return
            }
        }
        task.resume()
    }
    
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return carName.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellReuseIdentifier")! //1.
        
        let text = carName[indexPath.row] //2.
        
        cell.textLabel?.text = text //3.
        cell.detailTextLabel?.text = text
        return cell //4.
    }
    
    var valueToPass:String!
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You selected cell #\(indexPath.row)!")
        
        // Get Cell Label
        self.indexPath = tableView.indexPathForSelectedRow!
        let currentCell = tableView.cellForRow(at: indexPath)! as UITableViewCell
        
        valueToPass = currentCell.textLabel?.text
        
        self.performSegue(withIdentifier: "yourSegueIdentifer", sender: nil);
        
    }
    
    func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?){
        if segue.identifier == "yourSegueIdentifer" {
        // initialize new view controller and cast it as your view controller
        let viewController = segue.destination as! DetailViewController
        // your new view controller should have property that will store passed value
//        viewController.passedValue = "";
        let text = self.carName[(self.indexPath?.row)!]
        viewController.passedValue = text;
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let backItem = UIBarButtonItem()
        backItem.title = "Back"
        navigationItem.backBarButtonItem = backItem // This will show in the next view controller being pushed
        
        if segue.identifier == "yourSegueIdentifer" {
            // initialize new view controller and cast it as your view controller
            let viewController = segue.destination as! DetailViewController
            // your new view controller should have property that will store passed value
            //        viewController.passedValue = "";
            let text = self.carName[(self.indexPath?.row)!]
            viewController.passedValue = text;
        }
    }
}


import UIKit
import Firebase
import PassKit
import Stripe

class CartViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, PayPalPaymentDelegate, PKPaymentAuthorizationViewControllerDelegate {
    
    @IBOutlet weak var cartTable: UITableView!
    var cartRef: DatabaseReference!
    var ref2: DatabaseReference!
    var delref: DatabaseReference!
    var cartList = [Cart]()
    var payedCartList = [Cart]()
    let userID = Auth.auth().currentUser?.uid
    var total = 0.0
    var count = 0
    var totalDollar = 0.0
    var userInfoRef : DatabaseReference!
    var adrRef : DatabaseReference!
    
    /* func getUserInfo(){
     userInfoRef = Database.database().reference().child("users");
     adrRef = Database.database().reference().child("users");
     userInfoRef.child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
     self.adrRef.child(self.userID!).child("Address").observeSingleEvent(of: .value, with: { (snapshot1) in
     // Get user value
     let userObject = snapshot.value as? [String: AnyObject]
     let adrObject = snapshot1.value as? [String: AnyObject]
     //let userName  = userObject?["Name"]
     // let userAge  = userObject?["Age"]
     // let userGender = userObject?["Gender"]
     let userMRN = userObject?["MRN"]
     //   let userMedHistory = userObject?["MedicalHistory"]
     let userPhone = userObject?["PhoneNo"]
     let bNo = adrObject?["BuildingNo"]
     let uStreet = adrObject?["Street Name"]
     let uNieghborhood = adrObject?["Neighborhood"]
     let uCity = adrObject?["City"]
     let uPC = adrObject?["Postal Code"]
     let uAN = adrObject?["AdditionalNo"]
     self.AdditionalNo = uAN as! String
     self.BuildingNo = bNo as! String
     self.City = uCity as! String
     self.Neighborhood = uNieghborhood as! String
     self.PostalCode = uPC as! String
     self.StreetName = uStreet as! String
     self.phoneNo = userPhone as! String
     self.mrn = userMRN as! String
     })
     })
     }*/
    
    @IBOutlet weak var Total: UILabel!
    
    @IBOutlet weak var itemTotal: UILabel!
    @IBOutlet weak var checkoutButton: UIButton!
    
    @IBOutlet weak var applePayButton: UIButton!
    
    @IBOutlet weak var shipping: UILabel!
    
    
    var payPalConfig = PayPalConfiguration()
    
    var environment:String = PayPalEnvironmentNoNetwork {
        willSet(newEnvironment) {
            if (newEnvironment != environment) {
                PayPalMobile.preconnect(withEnvironment: newEnvironment)
            }
        }
    }
    
    var acceptCreditCards: Bool = true {
        didSet {
            payPalConfig.acceptCreditCards = acceptCreditCards
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up payPalConfig
        
        payPalConfig.acceptCreditCards = acceptCreditCards;
        payPalConfig.merchantName = "MedEx"
        payPalConfig.merchantPrivacyPolicyURL = URL(string: "https://www.paypal.com/webapps/mpp/ua/privacy-full")
        payPalConfig.merchantUserAgreementURL = URL(string: "https://www.paypal.com/webapps/mpp/ua/useragreement-full")
        payPalConfig.languageOrLocale = Locale.preferredLanguages[0]
        payPalConfig.payPalShippingAddressOption = .payPal;
        
        PayPalMobile.preconnect(withEnvironment: environment)
        
        
        // For Apple Pay
        //addApplePayPaymentButtonToView()
        
        checkoutButton.layer.cornerRadius = 3
        checkoutButton.layer.masksToBounds = true
        checkoutButton.layer.borderWidth = 1
        checkoutButton.layer.borderColor = UIColor.gray.cgColor
        
        applePayButton.layer.cornerRadius = 3
        applePayButton.layer.masksToBounds = true
        applePayButton.layer.borderWidth = 1
        applePayButton.layer.borderColor = UIColor.gray.cgColor
        
        
        
        cartRef = Database.database().reference().child("users").child(userID!).child("Cart");
        cartRef.observe(DataEventType.value, with: { (snapshot) in
            
            
            
            print("payed cart list:")
            print(self.payedCartList)
            print("cart list:")
            print(self.cartList)
            self.cartList.removeAll()
            //iterating through all the values
            self.total = 0.0
            self.count = 0
            for carts in snapshot.children.allObjects as! [DataSnapshot] {
                
                //here
                //getting values
                let CartObject = carts.value as? [String: AnyObject]
                let medName  = CartObject?["Name"]
                let medPrice  = CartObject?["Price"]
                print (medPrice)
                let medRX = CartObject?["RX"]
                let medID = CartObject?["medID"]
                if let medPrice = medPrice as? String {
                    let price = Double(medPrice)
                    print ("Price string: \(price as Any)")
                    print ("Price double: \(price as Any)")
                    self.total = self.total + price!
                    self.count = self.count + 1
                    print (self.total)
                    self.itemTotal.text = "\(self.total) SR"
                    self.cartTable.reloadData()
                }
                
                
                //creating Cart object with model and fetched values
                let Cart1 = Cart (orderNo: medRX as! String?, medName: medName as! String?, price: medPrice as! String?, medID: medID as! String?)
                
                //appending it to list
                self.cartList.append(Cart1)
                print("payed cart list after append:")
                print(self.payedCartList)
                print("cart list after append:")
                print(self.cartList)
            }
            print ("Item Total: \(self.total)")
            print ("Total with shipping: \(self.total  + 15)")
            if (self.total != 0 ){
                self.Total.text = "\(self.total + 15) SR"
                self.shipping.text = "15 SR"
            }
            
            //reloading the tableview
            self.cartTable.reloadData()
            
        })
        
        // Do any additional setup after loading the view.
        cartTable.allowsMultipleSelectionDuringEditing = true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cartList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as!
        CartTableViewCell
        //the Cart element object
        let cart: Cart
        //getting the cartElement of selected position
        cart = cartList[indexPath.row]
        //adding values to labels
        cell.orderNum.text = cart.orderNo
        cell.medicineName.text = cart.medName
        cell.price.text = "\(cart.price ?? "0") SR"
        //returning cell
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        print(indexPath.row)
        let cartElement  = cartList[indexPath.row]
        deleteCartElement(id: cartElement.medID!, index: indexPath.row)
    }
    func deleteCartElement(id:String, index:Int){
        
        delref = Database.database().reference().child("users").child(userID!).child("Cart").child(id)
        delref.setValue(nil)
        ref2 = Database.database().reference().child("Medices IDs").child(id)
        ref2.setValue(nil)
        self.count = self.count - 1
        if (self.count == 0 ){
            self.total = 0
            self.itemTotal.text = "0 SR"
            self.shipping.text = "0 SR"
            self.Total.text = "0 SR"
        }
        self.cartTable.reloadData()
        print("index path = ")
        print(index)
        print("before remove from payed cart:")
        print(payedCartList)
        print("after remove from payed cart:")
        print(payedCartList)
        
        let alertController = UIAlertController(title: "Order is removed", message: "The medicine is successfully removed from the cart!", preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(defaultAction)
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    
    //Function to make table view backgound clear
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell,
                   forRowAt indexPath: IndexPath) {
        cell.layer.backgroundColor = UIColor.clear.cgColor
        cell.backgroundColor = .clear
        tableView.layer.backgroundColor = UIColor.clear.cgColor
        tableView.backgroundColor = .clear
    }
    
    
    
    //Payment Method
    @IBAction func paymentBtn(_ sender: Any) {
        
        print ("Total: \(total)")
        if total != 0 {
            totalDollar = total/3.75
            
            print ("Total in Dollars: \(totalDollar)")
            
            // Process Payment once the pay button is clicked.
            let Totalstr = String(format: "%.2f", totalDollar)
            
            let item1 = PayPalItem(name: "Items", withQuantity: 1, withPrice: NSDecimalNumber(string: Totalstr), withCurrency: "USD", withSku: "SivaGanesh-0001")
            
            let items = [item1]
            print ("Test items array")
            print (items)
            let subtotal = PayPalItem.totalPrice(forItems: items)
            
            // Optional: include payment details
            let shipping = NSDecimalNumber(string: "4.00")
            let tax = NSDecimalNumber(string: "0.00")
            let paymentDetails = PayPalPaymentDetails(subtotal: subtotal, withShipping: shipping, withTax: tax)
            
            let TOTAL = subtotal.adding(shipping).adding(tax)
            
            let payment = PayPalPayment(amount: TOTAL, currencyCode: "USD", shortDescription: "MedEx", intent: .sale)
            
            payment.items = items
            payment.paymentDetails = paymentDetails
            
            if (payment.processable) {
                
                let paymentViewController = PayPalPaymentViewController(payment: payment, configuration: payPalConfig, delegate: self)
                present(paymentViewController!, animated: true, completion: nil)
                
                //            //Here change order status (Bad placment)
                
                
            }
                
            else {
                
                print("Payment not processalbe: \(payment)")
            }
        }  else {
            let alertController = UIAlertController(title: "Empty Cart", message: "Your cart is empty! cannot proceed payment", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    // PayPalPaymentDelegate
    
    func payPalPaymentDidCancel(_ paymentViewController: PayPalPaymentViewController) {
        print("PayPal Payment Cancelled")
        paymentViewController.dismiss(animated: true, completion: nil)
    }
    
    func payPalPaymentViewController(_ paymentViewController: PayPalPaymentViewController, didComplete completedPayment: PayPalPayment) {
        
        print("PayPal Payment Success !")
        paymentViewController.dismiss(animated: true, completion: { () -> Void in
            // send completed confirmaion to your server
            
            print("Here is your proof of payment:\n\n\(completedPayment.confirmation)\n\nSend this to your server for confirmation and fulfillment.")
            
        })
        //Here change order status
        let userID = Auth.auth().currentUser!.uid
        let CartRefrence = Database.database().reference().child("users").child(userID).child("Cart")
        CartRefrence.observe(DataEventType.value, with: { (snapshot) in
            for Medicines in snapshot.children.allObjects as! [DataSnapshot] {
                let medicineObject = Medicines.value as? [String: AnyObject]
                let medID = Medicines.key
                let medRX = medicineObject?["RX"]
                let medName  = medicineObject?["Name"]
                let medPrice  = medicineObject?["Price"]
                let Cart1 = Cart (orderNo: medRX as! String?, medName: medName as! String?, price: medPrice as! String?, medID: medID as String?)
                //appending it to list
                self.payedCartList.append(Cart1)
                print("here RXXXXX")
                let uOrderRef = Database.database().reference().child("users").child(userID).child("Orders").child(medRX! as! String)
                print("here inside rx reference. will it change????:(")
                uOrderRef.child(medID).child("OrderStatus").setValue("Order Sent")
                print("CHANGED")
                
            } //end of for
        }) //end of cart snapshot
        creatPayedOrder()
        //Then clear cart
        let CartRefrence2 = Database.database().reference().child("users").child(userID).child("Cart")
        CartRefrence2.setValue(nil)
        print("CART cleared")
        self.total = 0
        self.itemTotal.text = "0 SR"
        self.shipping.text = "0 SR"
        self.Total.text = "0 SR"
        // here creating new node in database "PayedOrders"
        
    }
    func creatPayedOrder(){
        // getUserInfo()
        userInfoRef = Database.database().reference().child("users");
        adrRef = Database.database().reference().child("users");
        userInfoRef.child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            self.adrRef.child(self.userID!).child("Address").observeSingleEvent(of: .value, with: { (snapshot1) in
                // Get user value
                let userObject = snapshot.value as? [String: AnyObject]
                let adrObject = snapshot1.value as? [String: AnyObject]
                //let userName  = userObject?["Name"]
                // let userAge  = userObject?["Age"]
                // let userGender = userObject?["Gender"]
                let userMRN = userObject?["MRN"]
                //   let userMedHistory = userObject?["MedicalHistory"]
                let userPhone = userObject?["PhoneNo"]
                let bNo = adrObject?["BuildingNo"]
                let uStreet = adrObject?["Street Name"]
                let uNieghborhood = adrObject?["Neighborhood"]
                let uCity = adrObject?["City"]
                let uPC = adrObject?["Postal Code"]
                let uAN = adrObject?["AdditionalNo"]
                let payedRef = Database.database().reference().child("PayedOrders")
                let orId = payedRef.childByAutoId().key
                let OrderDate = Date().string(format: "dd/MM/yyyy")
                let payOrd = ["AdditionalNo": uAN, "AssignedDriver": "-", "BuildingNo": bNo, "City": uCity, "MRN": userMRN, "Neighborhood": uNieghborhood, "OrderDate": OrderDate, "PostalCode": uPC, "StreetName": uStreet, "phoneNo": userPhone, "id": orId, "Status": "--", "UID" : self.userID] as [String : Any]
                payedRef.child(orId!).setValue(payOrd)
                for carts in self.payedCartList {
                    print("cart list inside rx creation loop:")
                    print(self.cartList)
                    //.child(carts.orderNo!).child(carts.medID!).setValue(carts.medID!)
                    let rx_id = ["RX" : carts.orderNo!, "ID": carts.medID!]
                    payedRef.child(orId!).child("RXs").childByAutoId().setValue(rx_id)
                }
                self.payedCartList.removeAll()
            })
        })
        
    }
    
    @IBAction func applePayButtonPressed(_ sender: Any) {
        applePayButton.addTarget(self, action: #selector(applePayButtonTapped(sender:)), for: .touchUpInside)
    }
    
    
    @objc private func applePayButtonTapped(sender: UIButton) {
        if (total != 0){
            
            // Cards that should be accepted
            let paymentNetworks:[PKPaymentNetwork] = [.amex,.masterCard,.visa]
            
            if PKPaymentAuthorizationViewController.canMakePayments(usingNetworks: paymentNetworks) {
                let request = PKPaymentRequest()
                
                request.merchantIdentifier = "merchant.AseelMohimeed.iOSMedEx"
                request.countryCode = "SA"
                request.currencyCode = "SAR"
                request.supportedNetworks = paymentNetworks
                request.requiredShippingContactFields = [.name, .postalAddress]
                // This is based on using Stripe
                request.merchantCapabilities = .capability3DS
                
                let Totalstr = String(format: "%.2f", total)
                print ("Apply Pay total sting = ")
                print (Totalstr)
                
                let totalWithShipping = Double(total + 15)
                let totalWithShippingstr = String(format: "%.2f", totalWithShipping)
                print ("Apply Pay total with SHIPPING sting = ")
                print (totalWithShippingstr)
                
                let tshirt = PKPaymentSummaryItem(label: "Item Total", amount: NSDecimalNumber(string:Totalstr), type: .final)
                let shipping = PKPaymentSummaryItem(label: "Shipping", amount: NSDecimalNumber(decimal:15.00), type: .final)
                //let tax = PKPaymentSummaryItem(label: "Tax", amount: NSDecimalNumber(decimal:0.00), type: .final)
                //Totalstr
                
                
                let total1 = PKPaymentSummaryItem(label: "Total", amount: NSDecimalNumber(string:totalWithShippingstr), type: .final)
                request.paymentSummaryItems = [tshirt, shipping, total1]
                
                let authorizationViewController = PKPaymentAuthorizationViewController(paymentRequest: request)
                
                if let viewController = authorizationViewController {
                    viewController.delegate = self
                    present(viewController, animated: true, completion: nil)
                }
            }
        } else {
            let alertController = UIAlertController(title: "Empty Cart", message: "Your cart is empty! cannot proceed payment", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, handler completion: @escaping (PKPaymentAuthorizationResult) -> Void) {
        // Use Stripe to charge the user
        STPAPIClient.shared().createToken(with: payment) { (stripeToken, error) in
            guard error == nil, let stripeToken = stripeToken else {
                print(error!)
                return
            }
            
            let url = URL(string:"http://localhost:3000/pay")
            guard let apiUrl = url else {
                print("Error creating url")
                return
            }
            
            var request = URLRequest(url: apiUrl)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            
            // Stripe doesn't allow decimal, so have to convert the amount
            // into cents by multiplying by 100
            let body:[String : Any] = ["stripeToken" : stripeToken.tokenId,
                                       "amount" : 300,
                                       "description" : "Purchase of a t-shirt"]
            
            // Convert the body to JSON
            try? request.httpBody = JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)
            
            // Make an HTTP request to our backend
            let task = URLSession.shared.dataTask(with: request) {data, response, error in
                guard error == nil else {
                    print (error!)
                    completion(PKPaymentAuthorizationResult(status: .failure, errors: nil))
                    return
                }
                
                guard let response = response else {
                    print ("Empty or erronous response")
                    completion(PKPaymentAuthorizationResult(status: .failure, errors: nil))
                    return
                }
                
                print (response)
                
                if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                    // Once the payment is successful, show the user that the purchase has been successful
                    completion(PKPaymentAuthorizationResult(status: .success, errors: nil))
                } else {
                    completion(PKPaymentAuthorizationResult(status: .failure, errors: nil))
                }
            }
            
            task.resume()
        }
        
        completion(PKPaymentAuthorizationResult(status: .success, errors: nil))
        //Here change order status
        let userID = Auth.auth().currentUser!.uid
        let CartRefrence = Database.database().reference().child("users").child(userID).child("Cart")
        CartRefrence.observe(DataEventType.value, with: { (snapshot) in
            for Medicines in snapshot.children.allObjects as! [DataSnapshot] {
                let medicineObject = Medicines.value as? [String: AnyObject]
                let medID = Medicines.key
                let medRX = medicineObject?["RX"]
                let medName  = medicineObject?["Name"]
                let medPrice  = medicineObject?["Price"]
                let Cart1 = Cart (orderNo: medRX as! String?, medName: medName as! String?, price: medPrice as! String?, medID: medID as String?)
                //appending it to list
                self.payedCartList.append(Cart1)
                print("here RXXXXX")
                let uOrderRef = Database.database().reference().child("users").child(userID).child("Orders").child(medRX! as! String)
                print("here inside rx reference. will it change????:(")
                uOrderRef.child(medID).child("OrderStatus").setValue("Order Sent")
                print("CHANGED")
                
            } //end of for
        }) //end of cart snapshot
        creatPayedOrder()
        let CartRefrence2 = Database.database().reference().child("users").child(userID).child("Cart")
        CartRefrence2.setValue(nil)
        print("CART cleared")
        self.total = 0
        self.itemTotal.text = "0 SR"
        self.shipping.text = "0 SR"
        self.Total.text = "0 SR"
        // here creating new node in database "PayedOrders"
        //creatPayedOrder()
    }
    
    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        // Dismiss the Apple Pay UI
        dismiss(animated: true, completion: nil)
        
    }
}

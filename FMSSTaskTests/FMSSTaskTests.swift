
import XCTest
@testable import FMSSTask

class FMSSTaskTests: XCTestCase {
    
    func testTextFields() {
        
        let vc = getPackageVC()
        
        XCTAssertEqual(vc.filterTypeTextField.placeholder, nil)
        XCTAssertEqual(vc.filterValueTextField.tintColor, .clear)
        XCTAssertEqual(vc.sortTextField.contentHorizontalAlignment, .center)
        
    }
    
    func testTableView() {
        
        let vc = getPackageVC()
        
        XCTAssertEqual(vc.listTableView.rowHeight, UITableView.automaticDimension)
        XCTAssertEqual(vc.listTableView.separatorStyle, .none)
        XCTAssertEqual(vc.listTableView.dequeueReusableCell(withIdentifier: "BasicCell")!.selectionStyle, .none)
        
    }
    
    func testPackagesArray() {
        
        let vc = getPackageVC()
        
        let packagesArray = vc.arrayToShow
        
        for obj in packagesArray {
            
            XCTAssertNotEqual(obj.name, nil)
            XCTAssertNotEqual(obj.desc, nil)
            XCTAssertNotEqual(obj.subscriptionType, nil)
            XCTAssertNotEqual(obj.didUseBefore, nil)
            XCTAssertNotEqual(obj.benefits, nil)
            XCTAssertNotEqual(obj.price, nil)
            XCTAssertNotEqual(obj.tariff, nil)
            XCTAssertNotEqual(obj.availableUntil, nil)
            XCTAssertNotEqual(obj.isFavorited, nil)
            
        }
    }
    
    func getPackageVC() -> PackagesVC {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "PackagesVCID") as! PackagesVC
        let _ = vc.view
        
        return vc
        
    }
}

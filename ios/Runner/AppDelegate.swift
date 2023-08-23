import UIKit
import Flutter
//import YandexMapKit
import YandexMapsMobile

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    
    var channel: FlutterMethodChannel!;
    var drivingRouter: YMKDrivingSessionRouteHandler!;
    var drivingSession: YMKDrivingSession?
    
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    YMKMapKit.setApiKey("06495363-2976-4cbb-a0b7-f09387554b9d")
    GeneratedPluginRegistrant.register(with: self)
    
    drivingRouter = {
            (routesResponse: [YMKDrivingRoute]?, _ error: Error?) -> Void in
            if let routes = routesResponse {
                self.onRouteReceived(routes)
            } else {
                let routingError = (error as! NSError).userInfo[YRTUnderlyingErrorKey] as! YRTError
                var errorMessage = "Unknown error"
                if routingError.isKind(of: YRTNetworkError.self) {
                    errorMessage = "Network error"
                } else {
                    errorMessage = "Remote server error"
                }
                let alert = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            }
        }
    
    let controller: FlutterViewController = window?.rootViewController as! FlutterViewController
    channel = FlutterMethodChannel(name: "com.yellow.taxi/stream", binaryMessenger: controller.binaryMessenger)
    channel.setMethodCallHandler({
        (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
        if call.method == "getRoute" {
            guard let args = call.arguments as? [String:Any] else {
                return
            }
            let lat1 = args["lat1"] as? Double
            let lon1 = args["lon1"] as? Double
            let lat2 = args["lat2"] as? Double
            let lon2 = args["lon2"] as? Double
            result(self.getRoute(p1: YMKPoint(latitude: lat1!, longitude: lon1!), p2: YMKPoint(latitude: lat2!, longitude: lon2!)))
        } else {
            result(FlutterMethodNotImplemented)
            return
        }
    })
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    
    func getRoute(p1: YMKPoint, p2: YMKPoint) -> String {
        let drivingOptions = YMKDrivingDrivingOptions()
        let vehicleOptions = YMKDrivingVehicleOptions()
        var points = [YMKRequestPoint]()
        points.append(YMKRequestPoint(point: p1, type: YMKRequestPointType.waypoint, pointContext: nil))
        points.append(YMKRequestPoint(point: p2, type: YMKRequestPointType.waypoint, pointContext: nil))
        let drivingRouter = YMKDirections.sharedInstance().createDrivingRouter()
        drivingSession = drivingRouter.requestRoutes(with: points, drivingOptions: drivingOptions, vehicleOptions: vehicleOptions, routeHandler: self.drivingRouter)
        return "get route ios";
    }
    
    func onRouteReceived(_ routes: [YMKDrivingRoute]) {
        var result = "";
        var first = true;
        for route in routes {
            for p in route.geometry.points {
                if first {
                    first  = false
                } else {
                    result += ","
                }
                let lat = p.latitude
                let lon = p.longitude
                result += "{\"lat\":\(lat),\"lon\":\(lon)}";
            }
            break
        }
        result = "{\"points\":[\(result)]}"
        channel.invokeMethod("routeResponse", arguments: result)
    }
    
}

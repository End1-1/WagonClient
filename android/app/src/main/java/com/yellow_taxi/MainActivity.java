package com.wagon_client;

import android.os.Bundle;
import android.util.Log;
import com.google.gson.JsonObject;
import com.google.gson.JsonArray;

import com.yandex.mapkit.MapKitFactory;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import androidx.annotation.NonNull;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

import com.yandex.mapkit.RequestPoint;
import com.yandex.mapkit.RequestPointType;
import com.yandex.mapkit.directions.DirectionsFactory;
import com.yandex.mapkit.directions.driving.DrivingOptions;
import com.yandex.mapkit.directions.driving.DrivingRoute;
import com.yandex.mapkit.directions.driving.DrivingRouter;
import com.yandex.mapkit.directions.driving.DrivingSession;
import com.yandex.mapkit.directions.driving.JamSegment;
import com.yandex.mapkit.directions.driving.VehicleOptions;
import com.yandex.mapkit.geometry.Point;
import com.yandex.runtime.Error;

import java.util.ArrayList;
import java.util.List;

public class MainActivity extends FlutterActivity  {

    public static final String CHANNEL = "com.yellow.taxi/stream";
    public MethodChannel mMethodChannel;
    public static boolean mApiKeySet = false;

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        if (mApiKeySet == false) {
            MapKitFactory.setApiKey("06495363-2976-4cbb-a0b7-f09387554b9d");
        }
        mApiKeySet = true;
        super.configureFlutterEngine(flutterEngine);

        GeneratedPluginRegistrant.registerWith(flutterEngine);

        mMethodChannel = new MethodChannel(getFlutterEngine().getDartExecutor().getBinaryMessenger(), CHANNEL);
        mMethodChannel.setMethodCallHandler(
                new MethodChannel.MethodCallHandler() {
                    @Override
                    public void onMethodCall(MethodCall call, MethodChannel.Result result) {
                        Log.d(CHANNEL, String.format("Start invoke method '%s'", call.method));
                        if (call.method.equals("getRoute")) {
                            Object o = call.arguments;
                            Log.d(CHANNEL, o.toString());
                            Log.d(CHANNEL, o.getClass().getName());

                            double lat1 = call.argument("lat1");
                            double lon1 = call.argument("lon1");
                            double lat2 = call.argument("lat2");
                            double lon2 = call.argument("lon2");
                            String sr = getRoute(new Point(lat1, lon1), new Point(lat2, lon2));
                            result.success(sr);
                        }
                    }});
    }

    String getRoute(Point p1, Point p2) {
        DrivingOptions options = new DrivingOptions();
        VehicleOptions vehicleOptions = new VehicleOptions();
        List<RequestPoint> points = new ArrayList<>();
        points.add(new RequestPoint(p1, RequestPointType.WAYPOINT, null));
        points.add(new RequestPoint(p2, RequestPointType.WAYPOINT, null));
        DrivingRouter drivingRouter = DirectionsFactory.getInstance().createDrivingRouter();
        drivingRouter.requestRoutes(points, options, vehicleOptions,  mDrivingRouteListener);
        return "get route";
    }

    private DrivingSession.DrivingRouteListener mDrivingRouteListener = new DrivingSession.DrivingRouteListener(){
        @Override
        public void onDrivingRoutes(@NonNull List<DrivingRoute> list) {
            Log.d(CHANNEL, "Driving response");
            JsonArray ja = new JsonArray();
            for (DrivingRoute r: list) {
                List<Point> ps = r.getGeometry().getPoints();
                for (Point p: ps) {
                    JsonObject jo = new JsonObject();
                    jo.addProperty("lat", p.getLatitude());
                    jo.addProperty("lon", p.getLongitude());
                    ja.add(jo);
                }
                break;
            }
            JsonObject jr = new JsonObject();
            jr.add("points", ja);
            mMethodChannel.invokeMethod("routeResponse", jr.toString());
        }

        @Override
        public void onDrivingRoutesError(@NonNull Error error) {
            Log.d(CHANNEL, "Driving error");
            Log.d(CHANNEL, error.toString());
        }
    };

}

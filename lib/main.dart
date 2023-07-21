import 'dart:async';

import 'package:applovin_poc/ad_combo.dart';
import 'package:applovin_poc/utils/constants.dart';
import 'package:applovin_poc/widgets/banner_ad.dart';
import 'package:flutter/material.dart';
import 'package:applovin_max/applovin_max.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/services.dart';
import 'scroll_adview.dart';
import 'native_adview.dart';
import 'ad_combo.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
  });

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var _isInitialized = false;
  var _isProgrammaticBannerCreated = false;
  var _isProgrammaticBannerShowing = false;
  var _isWidgetBannerShowing = false;
  final MaxNativeAdViewController _nativeAdViewController =
      MaxNativeAdViewController();

  bool isnativeLoaded = false;
  MaxNativeAdView? nativeAdViewRef;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initializeAppLovin();
  }

  Future<void> initializeAppLovin() async {
    final connectivityResult = await (Connectivity().checkConnectivity());
    print('connectivity $connectivityResult');
    if (connectivityResult == ConnectivityResult.none) {
      print("No Internet Connetion");
      return;
    }
    // AppLovinMAX.setTestDeviceAdvertisingIds(['3a83a420-a8d7-4c20-a760-7b7ec73aecce','2f549018-4729-469e-ac69-04007507a5bb']);
    Map? sdkConfiguration = await AppLovinMAX.initialize(
      Constants.applovinSdkKey,
    );
    if (sdkConfiguration != null) {
      setState(() {
        _isInitialized = true;
      });
      attachAdListeners();

      // setState(() {
      // isnativeLoaded=true;
      // print("timer changed");
      nativeAdViewRef = MaxNativeAdView(
        height: 250,
        width: 468,
        controller: _nativeAdViewController,
        adUnitId: Constants.nativeAdUnitId,
        listener: NativeAdListener(onAdLoadedCallback: (ad) {
          print('AdCombo Native ad loaded from ${ad.networkName}');
        }, onAdLoadFailedCallback: (adUnitId, error) {
          print(
              'AdCombo Native ad failed to load with error code ${error.code} and message: ${error.message}');
        }, onAdClickedCallback: (ad) {
          print('AdCombo Native ad clicked');
        }, onAdRevenuePaidCallback: (ad) {
          print('AdCombo Native ad revenue paid: ${ad.revenue}');
        }),
        child: Container(
          height: 250,
          width: 468,
          color: Color.fromARGB(255, 232, 224, 71),
          child: Row(
            children: [
              MaxNativeAdMediaView(
                width: 100,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      MaxNativeAdTitleView(
                        maxLines: 1,
                        overflow: TextOverflow.fade,
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                  MaxNativeAdAdvertiserView(
                    style:
                        TextStyle(fontWeight: FontWeight.normal, fontSize: 12),
                    maxLines: 1,
                    overflow: TextOverflow.fade,
                  ),
                  MaxNativeAdStarRatingView(
                    size: 10,
                  ),
                  MaxNativeAdBodyView(
                    maxLines: 1,
                    overflow: TextOverflow.fade,
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  MaxNativeAdCallToActionView(
                    style: ButtonStyle(
                      elevation: MaterialStateProperty.all(0),
                      backgroundColor: MaterialStatePropertyAll(
                          Color.fromARGB(255, 11, 123, 151)),
                      foregroundColor: MaterialStatePropertyAll(Colors.white),
                      textStyle: MaterialStatePropertyAll(
                          TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      MaxNativeAdIconView(
                        height: 20,
                        width: 20,
                      ),
                      MaxNativeAdOptionsView(
                        height: 20,
                        width: 20,
                      ),
                    ],
                  )
                ],
              ),
              
            ],
          ),
        ),
      );

      nativeAdViewRef!.controller!.loadAd();
      print("ok11");
      Timer.periodic(Duration(seconds: 1), (timer) {
        setState(() {
          isnativeLoaded = true;
        });
        // _nativeAdViewController.loadAd();
        // });
      });
    }
  }

  void attachAdListeners() {
    /// Banner Ad Listeners
    AppLovinMAX.setBannerListener(AdViewAdListener(onAdLoadedCallback: (ad) {
      print('Banner ad loaded from ${ad.networkName}');
    }, onAdLoadFailedCallback: (adUnitId, error) {
      print(
          'Banner ad failed to load with error code ${error.code} and message: ${error.message}');
    }, onAdClickedCallback: (ad) {
      print('Banner ad clicked');
    }, onAdExpandedCallback: (ad) {
      print('Banner ad expanded');
    }, onAdCollapsedCallback: (ad) {
      print('Banner ad collapsed');
    }, onAdRevenuePaidCallback: (ad) {
      print('Banner ad revenue paid: ${ad.revenue}');
    }));
  }

  static const adChannel = MethodChannel('custom_height/bannerAd');

  String getProgrammaticBannerButtonTitle() {
    return _isProgrammaticBannerShowing
        ? 'Hide Programmatic Banner'
        : 'Show Programmatic Banner';
  }

  String getWidgetBannerButtonTitle() {
    return _isWidgetBannerShowing ? 'Hide Widget Banner' : 'Show Widget Banner';
  }

  Future getAd() async {
    final arguments = {'width': 300};
    final bannerAd = await adChannel.invokeMethod('getBannerAd', arguments);
    print('bannerAd $bannerAd');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('App Lovin POC'),
        ),
        body: !isnativeLoaded ? Container() : nativeAdViewRef);
  }
}

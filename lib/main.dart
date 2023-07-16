import 'package:applovin_poc/ad_combo.dart';
import 'package:applovin_poc/utils/constants.dart';
import 'package:applovin_poc/widgets/banner_ad.dart';
import 'package:flutter/material.dart';
import 'package:applovin_max/applovin_max.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'scroll_adview.dart';
import 'native_adview.dart';

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
  const MyHomePage({super.key,});



  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var _isInitialized = false;
  var _isProgrammaticBannerCreated = false;
var _isProgrammaticBannerShowing = false;
var _isWidgetBannerShowing = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initializeAppLovin();
    
  }

  Future<void> initializeAppLovin() async{
    final connectivityResult = await (Connectivity().checkConnectivity());
    print('connectivity $connectivityResult');
    if (connectivityResult==ConnectivityResult.none){
      print("No Internet Connetion");
      return ;
    }
    // AppLovinMAX.setTestDeviceAdvertisingIds(['3a83a420-a8d7-4c20-a760-7b7ec73aecce','2f549018-4729-469e-ac69-04007507a5bb']);
    Map? sdkConfiguration = await AppLovinMAX.initialize(Constants.applovinSdkKey,);
    if (sdkConfiguration != null) {
      setState(() {
        _isInitialized = true;
      });
      attachAdListeners();
    }
  }

  void attachAdListeners() {
    /// Banner Ad Listeners
    AppLovinMAX.setBannerListener(AdViewAdListener(onAdLoadedCallback: (ad) {
      print('Banner ad loaded from ${ad.networkName}');
    }, onAdLoadFailedCallback: (adUnitId, error) {
      print('Banner ad failed to load with error code ${error.code} and message: ${error.message}');
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

  String getProgrammaticBannerButtonTitle() {
    return _isProgrammaticBannerShowing ? 'Hide Programmatic Banner' : 'Show Programmatic Banner';
  }

  String getWidgetBannerButtonTitle() {
    return _isWidgetBannerShowing ? 'Hide Widget Banner' : 'Show Widget Banner';
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: Text('App Lovin POC'),),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          ElevatedButton(
            onPressed: (_isInitialized)
                ? () async {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const NativeAdView()),
                    );
                  }
                : null,
            child: const Text("Show Native Ad"),
          ),
          ElevatedButton(
            onPressed: (_isInitialized)
                ? () async {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const AdCombo()),
                    );
                  }
                : null,
            child: const Text("Ad Combo"),
          ),
          
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: (_isInitialized && !_isWidgetBannerShowing)
                      ? () async {
                          if (_isProgrammaticBannerShowing) {
                            AppLovinMAX.hideBanner(Constants.bannerAdUnitId);
                          } else {
                            if (!_isProgrammaticBannerCreated) {
                              //
                              // Programmatic banner creation - banners are automatically sized to 320x50 on phones and 728x90 on tablets
                              //
                              AppLovinMAX.createBanner(Constants.bannerAdUnitId, AdViewPosition.bottomCenter);
          
                              // Set banner background color - PLEASE USE HEX STRINGS ONLY
                              AppLovinMAX.setBannerBackgroundColor(Constants.bannerAdUnitId, '#FFBF00');
                              // AppLovinMAX.setBannerPlacement(Constants.bannerAdUnitId, "BottomAd");
                              // AppLovinMAX.setBannerExtraParameter(Constants.bannerAdUnitId, "adaptive_banner", "true");
                              

                              
          
                              _isProgrammaticBannerCreated = true;
                            }
                            AppLovinMAX.startBannerAutoRefresh(Constants.bannerAdUnitId);
                            AppLovinMAX.showBanner(Constants.bannerAdUnitId);
                          }
          
                          setState(() {
                            _isProgrammaticBannerShowing = !_isProgrammaticBannerShowing;
                          });
                        }
                      : null,
                  child: Text(getProgrammaticBannerButtonTitle()),
                ),
                // To show widgetbanner 
                ElevatedButton(
                  onPressed: (_isInitialized && !_isProgrammaticBannerShowing)
                      ? () async {
                          setState(() {
                            _isWidgetBannerShowing = !_isWidgetBannerShowing;
                          });
                        }
                      : null,
                  child: Text(getWidgetBannerButtonTitle()),
                )
                // To destroy the programmatic banner ad
                ,ElevatedButton(onPressed: (){
                  AppLovinMAX.destroyBanner(Constants.bannerAdUnitId);
                    _isProgrammaticBannerCreated=false;
                    setState(() {
                      _isProgrammaticBannerShowing=false;
                    });
                  

                }, child: const Text("Kill pBanner")),
              ],
            ),
          ),
          if (_isWidgetBannerShowing)
            const BannnerWidget()
        ],
      ),
    );
  }
}

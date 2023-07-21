import 'package:applovin_max/applovin_max.dart';
import 'package:applovin_poc/utils/constants.dart';
import 'package:flutter/material.dart';
import 'dart:developer';

class NativeAdView extends StatefulWidget {
  const NativeAdView({
    super.key,
  });


  @override
  State createState() => NativeAdViewState();
}

class NativeAdViewState extends State<NativeAdView> {
  static const double _kMediaViewAspectRatio = 16 / 9;

  double _mediaViewAspectRatio = _kMediaViewAspectRatio;
  bool _adLoaded=false;

  final MaxNativeAdViewController _nativeAdViewController =
      MaxNativeAdViewController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: 
      Container(
        margin: const EdgeInsets.all(8.0),
        height: double.infinity,
        child: 
        MaxNativeAdView(
          adUnitId: Constants.nativeAdUnitId,
          controller: _nativeAdViewController,
          listener: NativeAdListener(onAdLoadedCallback: (ad) {
            print('Native ad loaded from ${ad.networkName}');
            setState(() {
              _adLoaded=true;
              _mediaViewAspectRatio =
                  ad.nativeAd?.mediaContentAspectRatio ?? _kMediaViewAspectRatio;
            });
          }, onAdLoadFailedCallback: (adUnitId, error) {
            print('Native ad failed to load with error code ${error.code} and message: ${error.message}');
          }, onAdClickedCallback: (ad) {
            print('Native ad clicked');
          }, onAdRevenuePaidCallback: (ad) {
            print('Native ad revenue paid: ${ad.revenue}');
          }),
          child: Container(
            color: !_adLoaded?Colors.transparent:Color.fromARGB(255, 232, 224, 71),
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(4.0),
                      child: const MaxNativeAdIconView(
                        width: 60,
                        height: 60,
                      ),
                    ),
                    Flexible(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          MaxNativeAdTitleView(
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                            maxLines: 1,
                            overflow: TextOverflow.visible,
                          ),
                          MaxNativeAdAdvertiserView(
                            style: TextStyle(
                                fontWeight: FontWeight.normal, fontSize: 10),
                            maxLines: 1,
                            overflow: TextOverflow.fade,
                          ),
                          MaxNativeAdStarRatingView(
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                    const MaxNativeAdOptionsView(
                      width: 40,
                      height: 40,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Flexible(
                      child: MaxNativeAdBodyView(
                        style: TextStyle(
                            fontWeight: FontWeight.normal, fontSize: 14),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: AspectRatio(
                    aspectRatio: _mediaViewAspectRatio,
                    child: const MaxNativeAdMediaView(),
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: MaxNativeAdCallToActionView(
                    style: ButtonStyle(
                      elevation: MaterialStateProperty.all(0),
                      backgroundColor:
                          MaterialStatePropertyAll(!_adLoaded?Colors.transparent:Color.fromARGB(255, 11, 123, 151)),
                      textStyle: MaterialStatePropertyAll(
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      
      ),
    
    );
  }
}

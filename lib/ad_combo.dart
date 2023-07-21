import 'package:flutter/material.dart';
import 'utils/constants.dart';
import 'package:applovin_max/applovin_max.dart';

class AdCombo extends StatefulWidget {
  const AdCombo({super.key});

  @override
  State<AdCombo> createState() => AdComboState();
}

class AdComboState extends State<AdCombo> {
  static const double _kMediaViewAspectRatio = 16 / 9;
  double _mediaViewAspectRatio = _kMediaViewAspectRatio;
  bool _adLoaded = false;

  final MaxNativeAdViewController _nativeAdViewController =
      MaxNativeAdViewController();

  Future<void> loadAd() async {
    _nativeAdViewController.loadAd();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    AppLovinMAX.setBannerExtraParameter(
        Constants.bannerAdUnitId, "adaptive_banner", "true");
    return SafeArea(
        child: Scaffold(
      body:
          // SingleChildScrollView(
          Column(
        mainAxisAlignment: MainAxisAlignment.end,
        // mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Hello, how are you",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
          ),
          SizedBox(
            height: 20,
            // padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            child: MaxAdView(
              adFormat: AdFormat.banner,
              adUnitId: Constants.bannerAdUnitId,
              isAutoRefreshEnabled: true,
              listener: AdViewAdListener(
                onAdLoadedCallback: (ad) {
                  print('AdCombo banner ad loaded: ${ad.waterfall}');
                },
                onAdLoadFailedCallback: (adUnitId, error) {
                  print(
                      'AdCombo banner ad failed to load with error code ${error.code} and message: ${error.message}');
                },
                onAdClickedCallback: (ad) {
                  print('AdCombo banner ad clicked');
                },
                onAdExpandedCallback: (ad) {
                  print('AdCombo banner ad expanded');
                },
                onAdCollapsedCallback: (ad) {
                  print('AdCombo banner ad collapsed');
                },
                onAdRevenuePaidCallback: (ad) {
                  print('AdCombo banner ad revenue paid: ${ad.revenue}');
                },
              ),
            ),
          ),
          // Container(
          //   margin: const EdgeInsets.all(8.0),
          //   height: size.width,
          //   child: MaxNativeAdView(
          //     adUnitId: Constants.nativeAdUnitId,
          //     controller: _nativeAdViewController,
          //     listener: NativeAdListener(onAdLoadedCallback: (ad) {
          //       print('AdCombo Native ad loaded from ${ad.networkName}');
          //       setState(() {
          //         _adLoaded = true;
          //         _mediaViewAspectRatio =
          //             ad.nativeAd?.mediaContentAspectRatio ??
          //                 _kMediaViewAspectRatio;
          //       });
          //     }, onAdLoadFailedCallback: (adUnitId, error) {
          //       print(
          //           'AdCombo Native ad failed to load with error code ${error.code} and message: ${error.message}');
          //     }, onAdClickedCallback: (ad) {
          //       print('AdCombo Native ad clicked');
          //     }, onAdRevenuePaidCallback: (ad) {
          //       print('AdCombo Native ad revenue paid: ${ad.revenue}');
          //     }),
          //     child: Container(
          //       color: !_adLoaded
          //           ? Colors.transparent
          //           : Color.fromARGB(255, 232, 224, 71),
          //       padding: const EdgeInsets.all(8.0),
          //       child: Column(
          //         mainAxisSize: MainAxisSize.min,
          //         children: [
          //           Row(
          //             mainAxisAlignment: MainAxisAlignment.center,
          //             children: [
          //               Container(
          //                 padding: const EdgeInsets.all(4.0),
          //                 child: const MaxNativeAdIconView(
          //                   width: 60,
          //                   height: 60,
          //                 ),
          //               ),
          //               Flexible(
          //                 child: Column(
          //                   mainAxisAlignment: MainAxisAlignment.start,
          //                   crossAxisAlignment: CrossAxisAlignment.start,
          //                   children: [
          //                     MaxNativeAdTitleView(
          //                       style: TextStyle(
          //                           fontWeight: FontWeight.bold,
          //                           fontSize: 16),
          //                       maxLines: 1,
          //                       overflow: TextOverflow.visible,
          //                     ),
          //                     MaxNativeAdAdvertiserView(
          //                       style: TextStyle(
          //                           fontWeight: FontWeight.normal,
          //                           fontSize: 10),
          //                       maxLines: 1,
          //                       overflow: TextOverflow.fade,
          //                     ),
          //                     MaxNativeAdStarRatingView(
          //                       size: 20,
          //                     ),
          //                   ],
          //                 ),
          //               ),
          //               const MaxNativeAdOptionsView(
          //                 width: 40,
          //                 height: 40,
          //               ),
          //             ],
          //           ),
          //           Row(
          //             mainAxisAlignment: MainAxisAlignment.start,
          //             children: [
          //               Flexible(
          //                 child: MaxNativeAdBodyView(
          //                   style: TextStyle(
          //                       fontWeight: FontWeight.normal,
          //                       fontSize: 14),
          //                   maxLines: 3,
          //                   overflow: TextOverflow.ellipsis,
          //                 ),
          //               ),
          //             ],
          //           ),
          //           const SizedBox(height: 8),
          //           Expanded(
          //             child: AspectRatio(
          //               aspectRatio: _mediaViewAspectRatio,
          //               child: const MaxNativeAdMediaView(),
          //             ),
          //           ),
          //           SizedBox(
          //             width: double.infinity,
          //             child: MaxNativeAdCallToActionView(
          //               style: ButtonStyle(
          //                 elevation: MaterialStateProperty.all(0),
          //                 backgroundColor: MaterialStatePropertyAll(
          //                     !_adLoaded
          //                         ? Colors.transparent
          //                         : Color.fromARGB(255, 11, 123, 151)),
          //                 textStyle: MaterialStatePropertyAll(TextStyle(
          //                     fontSize: 20, fontWeight: FontWeight.bold)),
          //               ),
          //             ),
          //           ),
          //         ],
          //       ),
          //     ),
          //   ),
          // ),
          Container(
            height: 150,
            width: 468,
            child: MaxNativeAdView(
              adUnitId: Constants.nativeAdUnitId,
              controller: _nativeAdViewController,
              listener: NativeAdListener(onAdLoadedCallback: (ad) {
                print('AdCombo Native ad loaded from ${ad.networkName}');
                setState(() {
                  _adLoaded = true;
                  _mediaViewAspectRatio =
                      ad.nativeAd?.mediaContentAspectRatio ??
                          _kMediaViewAspectRatio;
                });
              }, onAdLoadFailedCallback: (adUnitId, error) {
                print(
                    'AdCombo Native ad failed to load with error code ${error.code} and message: ${error.message}');
              }, onAdClickedCallback: (ad) {
                print('AdCombo Native ad clicked');
              }, onAdRevenuePaidCallback: (ad) {
                print('AdCombo Native ad revenue paid: ${ad.revenue}');
              }),
              child: Container(
                height: 60,
                width: 468,
                color: !_adLoaded
                    ? Colors.transparent
                    : Color.fromARGB(255, 232, 224, 71),
                child: Row(
                  children: [
                    Expanded(
                      child: MaxNativeAdMediaView(),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            // MaxNativeAdIconView(
                            //   height: 30,
                            //   width: 30,
                            // ),
                            MaxNativeAdTitleView(
                              maxLines: 1,
                              overflow: TextOverflow.fade,
                              style: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                        MaxNativeAdAdvertiserView(
                          style: TextStyle(
                              fontWeight: FontWeight.normal, fontSize: 12),
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
                        MaxNativeAdCallToActionView(
                          style: ButtonStyle(
                            elevation: MaterialStateProperty.all(0),
                            backgroundColor: MaterialStatePropertyAll(!_adLoaded
                                ? Colors.transparent
                                : Color.fromARGB(255, 11, 123, 151)),
                            foregroundColor: MaterialStatePropertyAll(
                                !_adLoaded ? Colors.transparent : Colors.white),
                            textStyle: MaterialStatePropertyAll(TextStyle(
                                fontSize: 12, fontWeight: FontWeight.bold)),
                          ),
                        ),
                        Row(
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
                    )
                    // Expanded(child: child)
                    // SizedBox(
                    //   width: double.infinity,
                    //   child: MaxNativeAdCallToActionView(
                    //     style: ButtonStyle(
                    //       elevation: MaterialStateProperty.all(0),
                    //       backgroundColor: MaterialStatePropertyAll(
                    //           !_adLoaded
                    //               ? Colors.transparent
                    //               : Color.fromARGB(255, 11, 123, 151)),
                    //       textStyle: MaterialStatePropertyAll(TextStyle(
                    //           fontSize: 20, fontWeight: FontWeight.bold)),
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
          
          ),
          SizedBox(
            height: 55,
          )

          // Text(
          //   "See You Soon!",
          //   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
          // ),
        ],
      ),
      // ),
    ));
  }
}

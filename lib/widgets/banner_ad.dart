import 'package:flutter/material.dart';
import 'package:applovin_max/applovin_max.dart';
import 'package:applovin_poc/utils/constants.dart';

class BannnerWidget extends StatefulWidget {
  const BannnerWidget({super.key});

  @override
  State<BannnerWidget> createState() => _BannnerWidgetState();
}

class _BannnerWidgetState extends State<BannnerWidget> {
  @override
  Widget build(BuildContext context) {
    return MaxAdView(
      adUnitId: Constants.bannerAdUnitId,
      adFormat: AdFormat.banner,
      isAutoRefreshEnabled: true,
      listener: AdViewAdListener(
        onAdLoadedCallback: (ad) {
          print('${ad.creativeId} ${ad.dspName} ${ad.nativeAd} ${ad.networkName} ${ad.placement} ${ad.waterfall}');
          print('Banner widget ad loaded from ${ad.networkName}');
        },
        onAdLoadFailedCallback: (adUnitId, error) {
          print(
              'Banner widget ad failed to load with error code ${error.code} and message: ${error.message}');
        },
        onAdClickedCallback: (ad) {
          print('Banner widget ad clicked');
        },
        onAdExpandedCallback: (ad) {
          print('Banner widget ad expanded');
        },
        onAdCollapsedCallback: (ad) {
          print('Banner widget ad collapsed');
        },
        onAdRevenuePaidCallback: (ad) {
          print('Banner widget ad revenue paid: ${ad.revenue}');
        },
      ),
    );
  }
}

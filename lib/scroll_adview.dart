import 'package:applovin_max/applovin_max.dart';
import 'package:flutter/material.dart';

class ScrolledAdView extends StatefulWidget {
  const ScrolledAdView({
    super.key,
    required this.bannerAdUnitId,
    required this.mrecAdUnitId,
  });

  final String bannerAdUnitId;
  final String mrecAdUnitId;

  @override
  State createState() => ScrolledAdViewState();
}

class ScrolledAdViewState extends State<ScrolledAdView> {
  static const String _sampleText = "Hey, This is a sample text";

  bool _isAdEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Scrolled Banner / MREC'),
        ),
        body: SafeArea(
            child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _isAdEnabled = !_isAdEnabled;
              });
            },
            child: _isAdEnabled ? const Text('Disable ads') : const Text('Enable ads'),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(4),
              shrinkWrap: true,
              itemCount: 10,
              itemBuilder: (BuildContext context, int index) {
                return Column(children: [
                  const Text(
                    _sampleText,
                    textAlign: TextAlign.justify,
                    style: TextStyle(fontSize: 18.0),
                  ),
                  _isAdEnabled
                      ? MaxAdView(adUnitId: widget.bannerAdUnitId, adFormat: AdFormat.banner)
                      : const SizedBox(
                          height: 50,
                          child: Center(child: Text('Ad Placeholder')),
                        ),
                  const Text(
                    _sampleText,
                    textAlign: TextAlign.justify,
                    style: TextStyle(fontSize: 18.0),
                  ),
                ]);
              },
            ),
          ),
          _isAdEnabled
              ? MaxAdView(adUnitId: widget.bannerAdUnitId, adFormat: AdFormat.banner)
              : const SizedBox(
                  height: 50,
                  child: Center(child: Text('Ad Placeholder')),
                ),
        ])));
  }
}
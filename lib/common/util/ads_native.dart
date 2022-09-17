import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:monsey/common/constant/colors.dart';

// import '../constant/env.dart';

class AdsNative extends StatefulWidget {
  const AdsNative({Key? key}) : super(key: key);

  @override
  _AdsNativeState createState() => _AdsNativeState();
}

class _AdsNativeState extends State<AdsNative> {
  late NativeAd _ad;
  final bool _isAdLoaded = false;

  @override
  void initState() {
    // _ad = NativeAd(
    //   adUnitId: AdHelper().nativeAdUnitId,
    //   factoryId: 'listTile',
    //   request: const AdRequest(),
    //   listener: NativeAdListener(
    //     onAdLoaded: (ad) {
    //       setState(() {
    //         _isAdLoaded = true;
    //       });
    //     },
    //     onAdFailedToLoad: (ad, error) {
    //       ad.dispose();
    //       print('Ad load failed (code=${error.code} message=${error.message})');
    //     },
    //   ),
    // );
    // _ad.load();
    super.initState();
  }

  @override
  void dispose() {
    _ad.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _isAdLoaded
        ? Container(
            child: AdWidget(ad: _ad),
            height: 64,
            decoration: BoxDecoration(
                color: white, borderRadius: BorderRadius.circular(16)),
            alignment: Alignment.center,
          )
        : const SizedBox();
  }
}

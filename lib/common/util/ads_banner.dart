import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:monsey/common/constant/env.dart';

import '../constant/colors.dart';

class AdsBanner extends StatefulWidget {
  const AdsBanner({Key? key, this.hasBorderRadius = true}) : super(key: key);
  final bool hasBorderRadius;
  @override
  _AdsBannerState createState() => _AdsBannerState();
}

class _AdsBannerState extends State<AdsBanner> {
  late BannerAd _ad;
  bool _isAdLoaded = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _ad = BannerAd(
      adUnitId: AdHelper().bannerAdUnitId,
      size: AdSize(
        height: (MediaQuery.of(context).size.height / 10).round(),
        width: MediaQuery.of(context).size.width.round() - 32,
      ),
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          setState(() {
            _isAdLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          print('Ad load failed (code=${error.code} message=${error.message})');
        },
      ),
    );
    _ad.load();
    super.didChangeDependencies();
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
            height: MediaQuery.of(context).size.height / 10,
            width: double.infinity,
            decoration: BoxDecoration(
                color: white,
                borderRadius:
                    BorderRadius.circular(widget.hasBorderRadius ? 16 : 0)),
            child: ClipRRect(
              borderRadius:
                  BorderRadius.circular(widget.hasBorderRadius ? 8 : 0),
              child: AdWidget(
                ad: _ad,
              ),
            ),
          )
        : const SizedBox();
  }
}

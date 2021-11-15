import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter/material.dart';

class GoogleBanner extends StatefulWidget {
  final String adUnitId;
  GoogleBanner(this.adUnitId);

  @override
  _GoogleBannerState createState() => _GoogleBannerState(adUnitId);
}

class _GoogleBannerState extends State<GoogleBanner> {
  late BannerAd myBanner;
  late AdWidget adWidget;

  _GoogleBannerState(String adUnitId) {
    myBanner = BannerAd(
      adUnitId: adUnitId,
      size: AdSize.banner,
      request: AdRequest(),
      listener: BannerAdListener(),
    );
    myBanner.load();
    adWidget = AdWidget(ad: myBanner);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: adWidget,
      width: myBanner.size.width.toDouble(),
      height: myBanner.size.height.toDouble(),
    );
  }
}

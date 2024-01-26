// ad_helper.dart
import 'dart:io';

class AdHelper {
  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-9883120375163682/8703879693';
      //return 'ca-app-pub-3940256099942544/6300978111';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/2934735716';
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  /*static String get interstitialAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/7049598008';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/3964253750';
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }*/

  static String get rewardedAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-9883120375163682/5686834110';
      //return 'ca-app-pub-3940256099942544/8673189370';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/7552160883';
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  /*static String get rewardedInterstitialAd {
    if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/5354046379';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/6978759866';
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  static String get nativeAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/2247696110';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/3986624511';
    }
    throw UnsupportedError("Unsupported platform");
  }*/
}
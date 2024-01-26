import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../All Functions Page/Functions.dart';
import 'adhelper.dart';

class AdmobPage extends StatefulWidget {
  const AdmobPage({super.key});

  @override
  State<AdmobPage> createState() => _AdmobPageState();
}

class _AdmobPageState extends State<AdmobPage> {
  static const AdRequest request = AdRequest();

  int maxFailedLoadAttempts = 3;
  //int coinGained = 0;
  late BannerAd _bannerAd;
  bool _isBannerAdReady = false;

  RewardedAd? _rewardedAd;
  int _numRewardedLoadAttempts = 0;

  RewardedInterstitialAd? _rewardedInterstitialAd;

  @override
  void initState() {
    super.initState();
    _loadBannerAd();
    _createRewardedAd();
  }

  // Ads creation starts here
  void _loadBannerAd() {
    _bannerAd = BannerAd(
        adUnitId: AdHelper.bannerAdUnitId,
        request: const AdRequest(),
        size: AdSize.banner,
        listener: BannerAdListener(onAdLoaded: (_) {
          setState(() => _isBannerAdReady = true);
        }, onAdFailedToLoad: (ad, err) {
          _isBannerAdReady = false;
          ad.dispose();
        }));
    _bannerAd.load();
  }

  void _createRewardedAd() {
    RewardedAd.load(
        adUnitId: AdHelper.rewardedAdUnitId,
        request: request,
        rewardedAdLoadCallback: RewardedAdLoadCallback(onAdLoaded: (RewardedAd ad) {
          _rewardedAd = ad;
          _numRewardedLoadAttempts = 0;
        }, onAdFailedToLoad: (LoadAdError error) {
          _rewardedAd = null;
          _numRewardedLoadAttempts += 1;
          if (_numRewardedLoadAttempts < maxFailedLoadAttempts) {
            _createRewardedAd();
          }
        }));
  }

  // Showing ads from here
  void _showRewardedAd() {
    if (_rewardedAd == null) return;

    _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdShowedFullScreenContent: (RewardedAd ad) => print('ad onAdShowedFullScreenContent.'),
        onAdDismissedFullScreenContent: (RewardedAd ad) {
          ad.dispose();
          _createRewardedAd();
        },
        onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
          ad.dispose();
          _createRewardedAd();
        });

    _rewardedAd!.setImmersiveMode(true);
    _rewardedAd!.show(onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
      //setState(() => coinGained += 1000);
      updateCoin();
    });
    _rewardedAd = null;
  }

  updateCoin() {
    FirebaseFirestore.instance.runTransaction((transaction) async {
      try {
        String? userEmail = FirebaseAuth.instance.currentUser?.email;
        var coinUpdateDocRef = FirebaseFirestore.instance.collection('Gold_Coin').doc(userEmail);
        transaction.update(coinUpdateDocRef, {'count': FieldValue.increment(1)});
        transaction.update(coinUpdateDocRef, {'coin': FieldValue.increment(1000)});
      } catch (e) {
        showToast('Error! Coin update failed.');
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _rewardedAd?.dispose();
    _rewardedInterstitialAd?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String? userEmail = FirebaseAuth.instance.currentUser?.email;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('AdMob Income'), backgroundColor: Colors.orange),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance.doc('Gold_Coin/$userEmail').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
            if (!snapshot.data!.exists) {
              FirebaseFirestore.instance.doc('Gold_Coin/$userEmail').set({"coin": 0, "count": 0, "timestamp": Timestamp.fromDate(DateTime(2024, 01, 06, 12, 0, 0))});
            }

            var data = snapshot.data!.data();
            int coinGained = data!['coin'];
            int count = data['count'];
            Timestamp storedTimestamp = data['timestamp'];
            Timestamp currentTimestamp = Timestamp.now();
            int timeDifference = currentTimestamp.millisecondsSinceEpoch - storedTimestamp.millisecondsSinceEpoch;
            String status = 'off';
            if (timeDifference > 3600000) status = "on";
            return Stack(children: [
              Center(
                child: Column(children: <Widget>[
                  const SizedBox(height: 20),
                  Wrap(alignment: WrapAlignment.center, children: [
                    const Text('Reward gained: ', style: TextStyle(fontSize: 28)),
                    Text('$coinGained', style: const TextStyle(fontSize: 28)),
                  ]),
                  const SizedBox(height: 16),
                  const Divider(color: Colors.black, thickness: 4),
                  const SizedBox(height: 20),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    InkWell(
                        onTap: () {
                          if (status == 'on') {
                            _showRewardedAd();
                            if (count == 5) FirebaseFirestore.instance.collection('Gold_Coin').doc(userEmail).update({"count": 0, "timestamp": Timestamp.now()});
                          } else {
                            showToast("Wait for ${60 - (timeDifference ~/ 60000)} minutes");
                          }
                        },
                        child: Card(
                            color: status == 'on' ? Colors.orange : Colors.white24,
                            child: const Padding(
                              padding: EdgeInsets.all(20.0),
                              child: Text(' Reward:\nAd', softWrap: true, textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            ))),
                    const InkWell(
                        //onTap: () => _showRewardedAd(),
                        child: Card(
                            color: Colors.white24,
                            child: Padding(
                              padding: EdgeInsets.all(20.0),
                              child:
                                  Text(' Reward: \nComing..', softWrap: true, textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            ))),
                    const InkWell(
                        //onTap: () => _showRewardedAd(),
                        child: Card(
                            color: Colors.white24,
                            child: Padding(
                              padding: EdgeInsets.all(20.0),
                              child: Text(' Reward:\nComing..', softWrap: true, textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            ))),
                  ]),
                  const SizedBox(height: 20),
                  const Divider(color: Colors.black, thickness: 4),
                  const SizedBox(height: 50),
                  const Text('1 মিলিয়ন কয়েন = 100 টাকা \n(প্রতি মিলিয়ন হিসাবে কয়েন রূপান্তর করতে হবে)',
                      softWrap: true, textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28)),
                  /*const Text('For this you need to\nAdd 2 member\nto earn AD income',
                      softWrap: true, textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 34)),*/
                ]),
              ),
              if (_isBannerAdReady)
                Align(
                  alignment: Alignment.bottomCenter,
                  child: SizedBox(width: _bannerAd.size.width.toDouble(), height: _bannerAd.size.height.toDouble(), child: AdWidget(ad: _bannerAd)),
                ),
            ]);
          }),
    );
  }
}

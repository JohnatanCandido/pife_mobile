import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:pife_mobile/app/controllers/user_data_controller.dart';
import 'package:pife_mobile/app/models/ad_state.dart';

class AdController {

  static AdController instance = AdController();

  static const int _gamesPerAd = 5;

  int _gamesSinceLastAd = 1;
  late AdState _adState;
  late InterstitialAd _interstitialAd;
  bool _adLoaded = false;
  late Function disposeCallback;

  void checkShowAd(Function callback) {
    if (_shouldShowAd() && _adLoaded) {
      disposeCallback = callback;
      _interstitialAd.show();
    } else {
      callback();
    }
    UserDataController.save('gamesSinceLastAd', _gamesSinceLastAd);
  }

  void initialize(AdState adState) {
    _adState = adState;
    _loadGameCountSinceLastAd();
    _loadNewAd();
  }

  bool _shouldShowAd() {
    if (_gamesSinceLastAd < _gamesPerAd) {
      _gamesSinceLastAd++;
      return false;
    }
    _gamesSinceLastAd = 1;
    return true;
  }

  void _loadGameCountSinceLastAd() async {
    Object? lastDayPlayed = await UserDataController.load('lastDayPlayed', 'int');
    int currentDay = DateTime.now().day;
    if (lastDayPlayed == null || lastDayPlayed as int != currentDay) {
      _gamesSinceLastAd = 1;
      UserDataController.save('lastDayPlayed', currentDay);
      UserDataController.save('gamesSinceLastAd', 1);
    } else {
      _gamesSinceLastAd = UserDataController.load('gamesSinceLastAd', 'int') as int;
    }
  }

  void _loadNewAd() {
    _adState.initialization.then((status) {
      InterstitialAd.load(
        adUnitId: _adState.interstitialAdUnitId,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: _onAdLoaded,
          onAdFailedToLoad: (error) {},
        ),
      );
    });
  }

  void _onAdLoaded(InterstitialAd ad) {
    _interstitialAd = ad;
    _adLoaded = true;

    _interstitialAd.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) => _disposeAd(),
      onAdFailedToShowFullScreenContent: (ad, error) => _disposeAd(),
    );
  }

  void _disposeAd() {
    _interstitialAd.dispose();
    _adLoaded = false;
    _loadNewAd();
    disposeCallback();
  }
}
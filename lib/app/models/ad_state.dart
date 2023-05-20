import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdState {

  AdState(this.initialization);

  Future<InitializationStatus> initialization;

  String get interstitialAdUnitId => dotenv.get('INTERSTITIAL_AD_UNIT_ID', fallback: '');

}
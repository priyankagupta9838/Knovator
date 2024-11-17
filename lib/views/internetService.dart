import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class ConnectivityService {
  // Check for internet connection
  Future<bool> isConnected() async {
    var connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      // Checks if there is an actual internet connection
      return await InternetConnectionChecker().hasConnection;
    }
    return false;
  }

  Stream<ConnectivityResult> get onConnectivityChanged => Connectivity().onConnectivityChanged;
}

import 'package:auto_size_text/auto_size_text.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'HomePage.dart';
import 'internetService.dart';

class ConnectionHandler extends StatefulWidget {
  const ConnectionHandler({super.key});

  @override
  _ConnectionHandlerState createState() => _ConnectionHandlerState();
}

class _ConnectionHandlerState extends State<ConnectionHandler> {
  late ConnectivityService connectivityService;
  bool isConnected = true;

  @override
  void initState() {
    super.initState();
    connectivityService = ConnectivityService();
    checkConnectionStatus();
  }

  // Check the initial status and subscribe to connection changes
  void checkConnectionStatus() async {
    isConnected = await connectivityService.isConnected();
    setState(() {});

    // Listen to connectivity changes
    connectivityService.onConnectivityChanged.listen((ConnectivityResult result) async {
      if (result == ConnectivityResult.none) {
        setState(() {
          isConnected = false;
        });
      } else {
        bool hasConnection = await connectivityService.isConnected();
        setState(() {
          isConnected = hasConnection;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isConnected ? const HomePage() : const OfflineScreen(),
    );
  }
}


class OfflineScreen extends StatelessWidget {
  const OfflineScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Size size=MediaQuery.of(context).size;
    return  Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.amber,
        title: AutoSizeText("Knovator",
          maxLines: 1,
          style: GoogleFonts.openSans(
              color: Colors.white,
              fontSize: size.height*0.022,
              fontWeight: FontWeight.w600
          ),),
        centerTitle: true,
      ),
      backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
      body: Center(
        child: SizedBox(
          height: size.height*0.3,
          width: size.width*0.8,
          child: Image.asset("assets/images/no_internet.jpg",fit: BoxFit.contain),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Controller/UserController.dart';
import '../utils/theme.dart';

class ShowDetails extends StatefulWidget {
  final int userId;

  const ShowDetails({Key? key, required this.userId}) : super(key: key);

  @override
  State<ShowDetails> createState() => _ShowDetailsState();
}

class _ShowDetailsState extends State<ShowDetails> {
  final PostController userController = Get.find<PostController>(tag: "fetchUser");

  @override
  void initState() {
    super.initState();

      // Delay fetch to avoid modifying state during the build phase
      Future.delayed(Duration.zero, () {
        userController.fetchPostDetails(widget.userId);
      });

  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
            size: size.height * 0.03,
          ),
          onPressed: () {
            Get.back();
          },
        ),
        elevation: 0,
        backgroundColor: Colors.amber,
        title: AutoSizeText(
          "Post Detail",
          maxLines: 1,
          style: GoogleFonts.openSans(
            color: Colors.white,
            fontSize: size.height * 0.022,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: false,
      ),
      body: Obx(() {
        return userController.isLoadingDetails.isTrue
            ? shimmerEffect(size)
            :
        Card(
          margin: EdgeInsets.all(size.height*0.01),
          elevation: 4.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Padding(
            padding:EdgeInsets.all(size.height*0.02),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                AutoSizeText(
                  userController.postDetails["title"].toString(),
                  style: GoogleFonts.openSans(
                      fontSize: size.height*0.022,
                      fontWeight: FontWeight.w700,
                      color: Colors.black
                  ),
                ),
                const SizedBox(height: 8.0),
                AutoSizeText(
                  userController.postDetails["body"].toString(),
                  style: GoogleFonts.openSans(
                      fontSize: size.height*0.02,
                      fontWeight: FontWeight.w400,
                      color: Colors.black87
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget shimmerEffect(Size size) {
    return ListView.builder(
      itemCount: 10,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Padding(
            padding: EdgeInsets.all(size.height * 0.01),
            child: Row(
              children: [
                Container(
                  width: size.height * 0.07,
                  height: size.height * 0.07,
                  decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                ),
                SizedBox(width: size.width * 0.03),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(width: size.width * 0.6, height: size.height * 0.02, color: Colors.white),
                    SizedBox(height: size.height * 0.01),
                    Container(width: size.width * 0.4, height: size.height * 0.02, color: Colors.white),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget buildRow(String title, String value, Size size) {
    return Row(
      children: [
        AutoSizeText(
          "$title: ",
          style: GoogleFonts.openSans(
            color: Colors.black87,
            fontWeight: FontWeight.w600,
            fontSize: size.height * 0.019,
          ),
        ),
        Expanded(
          child: AutoSizeText(
            value,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.openSans(
              color: Colors.black54,
              fontWeight: FontWeight.w600,
              fontSize: size.height * 0.019,
            ),
          ),
        ),
      ],
    );
  }

  Widget _sectionTitle(String title, Size size) {
    return Padding(
      padding: EdgeInsets.only(bottom: size.height * 0.01),
      child: AutoSizeText(
        title,
        style: GoogleFonts.openSans(
          color: Colors.black87,
          fontWeight: FontWeight.w600,
          fontSize: size.height * 0.022,
        ),
      ),
    );
  }

  Widget _detailCard(BuildContext context, Size size, List<Widget> children) {
    return Card(
      elevation: 0,
      color: AppTheme.primaryColor,
      child: Padding(
        padding: EdgeInsets.all(size.height * 0.018),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: children),
      ),
    );
  }
}

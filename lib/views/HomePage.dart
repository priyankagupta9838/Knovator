

import 'package:Knovator/views/showUserDetails.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../Controller/UserController.dart';
import '../utils/custumScrollBehaviour.dart';
import '../utils/theme.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PostController userController = Get.put(PostController(), tag: "fetchUser");
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      userController.fetchUsers();
    });
  }


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;


    return Scaffold(
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
        centerTitle: false,
      ),
      backgroundColor: AppTheme.primaryColor,
      body: ScrollConfiguration(
        behavior: CustomScrollBehavior(),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              Container(
                decoration: const BoxDecoration(
                  color: AppTheme.backgroundColor,
                  borderRadius: BorderRadius.only(
                  ),
                ),
                child: Obx(() {
                  if (userController.isLoading.isTrue) {
                    return shimmerEffect(size);
                  } else {
                    if (userController.filteredUsers.isEmpty ) {
                      return Center(
                        child: SizedBox(
                          height: size.height,
                          width: size.width * 0.8,
                          child: Padding(
                            padding:  EdgeInsets.only(top: size.height*0.3),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.search,
                                  size: size.height * 0.05,
                                  color: Colors.black87,
                                ),
                                SizedBox(
                                  height: size.height * 0.02,
                                ),
                                AutoSizeText(
                                  'No result found',
                                  style: TextStyle(
                                    fontSize: size.height * 0.022,
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w600,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    }

                    // List of users
                    return SizedBox(
                      height: size.height,
                      width: size.width,
                      child: ListView.builder(
                        itemCount: userController.filteredUsers.length,
                        itemBuilder: (context, index) {
                          final post = userController.filteredUsers[index];
                          final isRead = post["isRead"] as bool;
                          final randomDuration = post["timerDuration"] ?? 10;

                          return VisibilityDetector(

                            key: Key(post["id"].toString()), // Unique key for each post
                            onVisibilityChanged: (info) {
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                if (info.visibleFraction == 1.0) {
                                  userController.startTimer(index, randomDuration); // Start timer if fully visible
                                } else {
                                  userController.stopTimer(index); // Stop timer if not fully visible
                                }
                              });},
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: GestureDetector(
                                onTap: () {
                                  userController.markAsRead(index);
                                  Get.to(
                                    ShowDetails (userId: post["id"]),
                                    transition: Transition.fade,
                                  );
                                },
                                child: Card(

                                  color: isRead ? Colors.white : Colors.yellow.shade100, // Background color
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        AutoSizeText(
                                          post["title"].toString(),
                                          style: GoogleFonts.openSans(
                                            fontSize: size.height * 0.02,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.black,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        AutoSizeText(
                                          post["body"].toString(),
                                          style: GoogleFonts.openSans(
                                            fontSize: size.height * 0.02,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.black87,
                                          ),
                                        ),
                                        TimerIcon(index:index ,)

                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    );


                  }
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget shimmerEffect(Size size) {
    return ListView.builder(
      shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 10, // Number of shimmer items
        itemBuilder: (context, index) {
          return Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Padding(
              padding: EdgeInsets.only(
                  top: size.height * 0.014,
                  right: size.height * 0.014,
                  bottom: size.height * 0.014,
                  left: size.width * 0.055),
              child: Row(
                children: [

                  SizedBox(width: size.width * 0.03),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: size.width * 0.65,
                        height: size.height * 0.032,
                        color: Colors.white,
                      ),
                      SizedBox(height: size.height * 0.01),
                      Container(
                        width: size.width * 0.4,
                        height: size.height * 0.015,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }

}


class TimerIcon extends StatelessWidget {
  final int index;
  const TimerIcon({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    final PostController userController = Get.find<PostController>(tag: "fetchUser");

    return Obx(() {
      int remainingTime = userController.timerValues[index] ?? 0;
      return SizedBox(
        width: 80, // Set a width for the timer icon to ensure it's properly sized
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end, // Align timer to the right
          children: [
            const Icon(Icons.timer, size: 24, color: Colors.black),
            const SizedBox(width: 8),
            Text('$remainingTime s', style: const TextStyle(fontSize: 16)),
          ],
        ),
      );
    });
  }
}




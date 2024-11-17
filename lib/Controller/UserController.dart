import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class PostController extends GetxController {
  var filteredUsers = [].obs;
  Rx<TextEditingController> searchFieldController = TextEditingController().obs;
  var isLoading = true.obs;
  var isLoadingDetails = false.obs;
  RxInt isSearch = 0.obs;
  RxMap postDetails = {}.obs;
  RxMap<int, int> timerValues = <int, int>{}.obs; // Store timer values for each post
  Timer? timer;


  Future<void> fetchUsers() async {
    try {
      isLoading(true);
      var response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/posts'));
      if (response.statusCode == 200) {
        // Parse and add the `isRead` property
        filteredUsers.value = List<Map<String, dynamic>>.from(json.decode(response.body))
            .map((post) => {...post, "isRead": false})
            .toList();

        print("Post list is: $filteredUsers");
      } else {
        Get.snackbar('Error', 'Failed to load users');
      }
    } catch (e) {
      print("Error: $e");
    } finally {
      isLoading(false);
    }
  }

  Future<void> fetchPostDetails(int userId) async {
    try {
      isLoadingDetails(true);
      var response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/posts/$userId'));
      if (response.statusCode == 200) {
        postDetails.clear();
        postDetails.value = json.decode(response.body);
        print("Post details are: $postDetails");
      } else {
        Get.snackbar('Error', 'Failed to load post details');
      }
    } catch (e) {
      print("Error: $e");
    } finally {
      isLoadingDetails(false);
    }
  }



  void startTimer(int index, int duration) {
    if (timer != null && timer!.isActive) {
      stopTimer(index);
    }

    // Start new timer
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (timerValues[index] == null || timerValues[index]! <= 0) {
        stopTimer(index);
      } else {
        timerValues[index] = timerValues[index]! - 1;
      }
    });

    // Set initial timer value
    timerValues[index] = duration;
  }

  void stopTimer(int index) {
    timer?.cancel();
    timerValues[index] = 0; // Reset to 0 when stopped
  }

  void markAsRead(int index) {
    filteredUsers[index]["isRead"] = true;
  }

  // Mark a post as read
  // void markAsRead(int index) {
  //   filteredUsers[index]["isRead"] = true;
  //   filteredUsers.refresh(); // Notify UI to update
  // }
}

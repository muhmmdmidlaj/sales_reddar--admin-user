import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../controller/provider/user_provider.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  bool isEditingName = false;
  bool isEditingEmail = false;

  late TextEditingController nameController;
  late TextEditingController emailController;

  @override
  void initState() {
    super.initState();
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    userProvider.fetchUserProfile(context).then((_) {
      if (userProvider.user != null) {
        nameController =
            TextEditingController(text: userProvider.user!.userName);
        emailController =
            TextEditingController(text: userProvider.user!.userEmail);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: SizedBox(width: 0.w),
        actions: [
          Padding(
            padding: EdgeInsets.all(9.w),
            child:
                Image.asset('asset/image/logo.png', width: 50.w, height: 70.h),
          ),
          SizedBox(width: 20.w),
        ],
        iconTheme: const IconThemeData(color: Colors.black),
        title: Text(
          "Profile",
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 20.sp,
            color: Colors.black,
          ),
        ),
      ),
      body: Center(
        child: userProvider.isLoading
            ? const CircularProgressIndicator()
            : userProvider.errorMessage != null
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error, color: Colors.red, size: 50),
                      const SizedBox(height: 10),
                      Text("Error: ${userProvider.errorMessage}",
                          style: const TextStyle(color: Colors.red)),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () => userProvider.fetchUserProfile(context),
                        child: const Text("Retry"),
                      ),
                    ],
                  )
                : userProvider.user != null
                    ? SingleChildScrollView(
                        child: Column(
                          children: [
                            SizedBox(height: 50.h),
                            Container(
                              height: 750.h,
                              width: 500.w,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(50.r),
                                border: Border.all(width: 0.12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 10.r,
                                    offset: Offset(0, 4.h),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 80.h),
                                  Center(
                                    child: CircleAvatar(
                                      radius: 110.r,
                                      child: Icon(Icons.person, size: 50.sp),
                                    ),
                                  ),
                                  SizedBox(height: 40.h),
                                  // Name Editing Section
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 40.w, vertical: 15.h),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          flex: 3,
                                          child: isEditingName
                                              ? TextField(
                                                  controller: nameController,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 22.sp,
                                                  ),
                                                  decoration:
                                                      const InputDecoration(
                                                    border: InputBorder.none,
                                                  ),
                                                )
                                              : Text(
                                                  userProvider.user!.userName,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 22.sp,
                                                  ),
                                                ),
                                        ),
                                        IconButton(
                                          icon: Icon(
                                            isEditingName
                                                ? Icons.save
                                                : Icons.edit,
                                            size: 24.sp,
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              if (isEditingName) {
                                                userProvider.updateUserProfile(
                                                    context,
                                                    nameController.text,
                                                    emailController.text);
                                              }
                                              isEditingName = !isEditingName;
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 35.w),
                                    child: const Divider(),
                                  ),
                                  // Email Editing Section
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 40.w, vertical: 15.h),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          flex: 3,
                                          child: isEditingEmail
                                              ? TextField(
                                                  controller: emailController,
                                                  style: TextStyle(
                                                    fontSize: 22.sp,
                                                    color: Colors.grey,
                                                  ),
                                                  decoration:
                                                      const InputDecoration(
                                                    border: InputBorder.none,
                                                  ),
                                                )
                                              : Text(
                                                  userProvider.user!.userEmail
                                                          .isNotEmpty
                                                      ? userProvider
                                                          .user!.userEmail
                                                      : "No email available",
                                                  style: TextStyle(
                                                    fontSize: 22.sp,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                        ),
                                        IconButton(
                                          icon: Icon(
                                            isEditingEmail
                                                ? Icons.save
                                                : Icons.edit,
                                            size: 24.sp,
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              if (isEditingEmail) {
                                                userProvider.updateUserProfile(
                                                    context,
                                                    nameController.text,
                                                    emailController.text);
                                              }
                                              isEditingEmail = !isEditingEmail;
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    : const Text('Data not Found'),
      ),
    );
  }
}

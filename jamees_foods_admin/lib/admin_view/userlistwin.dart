import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jamees_foods_admin/admin_provider/user_list_provider.dart';
import 'package:jamees_foods_admin/admin_view/usercart.dart';
import 'package:jamees_foods_admin/model/user_model.dart';
import 'package:provider/provider.dart';

class UserListPage extends StatefulWidget {
  const UserListPage({super.key});

  @override
  _UserListPageState createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
        () => Provider.of<UserProvider>(context, listen: false).fetchUsers());
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Two tabs for Active & Deactivated Users
      child: Scaffold(
        backgroundColor: const Color(0xFFF7F7F7),
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            "User Management",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp),
          ),
          bottom: TabBar(
            labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            labelColor: Colors.black,
            indicatorColor: Colors.red,
            tabs: [
              Tab(
                text: "Active Users",
              ),
              Tab(text: "Deactivated Users"),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            IsActiveUser(isActive: true),
            IsActiveUser(isActive: false)
          ],
        ),
      ),
    );
  }
}

class UserCardWidget extends StatelessWidget {
  final UserModel user;
  const UserCardWidget({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => UserCard(userId: user.userId)));
      },
      child: Card(
        color: Colors.white,
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Padding(
          padding: EdgeInsets.all(12.w),
          child: Row(
            children: [
              CircleAvatar(
                radius: 50.r,
                backgroundColor: Colors.grey[300],
                child: Center(
                  child: Icon(Icons.person, size: 30.sp, color: Colors.black),
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        user.userName,
                        style: TextStyle(
                            fontSize: 16.sp, fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        user.userRole,
                        style: TextStyle(fontSize: 12.sp, color: Colors.black),
                      ),
                      Text(
                        user.userEmail.isNotEmpty ? user.userEmail : "No Email",
                        style: TextStyle(fontSize: 12.sp, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 10.w),
            ],
          ),
        ),
      ),
    );
  }
}

class IsActiveUser extends StatefulWidget {
  const IsActiveUser({super.key, required this.isActive});
  final bool isActive;

  @override
  State<IsActiveUser> createState() => _IsActiveUserState();
}

class _IsActiveUserState extends State<IsActiveUser> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.microtask(
        () => Provider.of<UserProvider>(context, listen: false).fetchUsers());
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        if (userProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (userProvider.errorMessage != null) {
          return Center(
            child: Text(userProvider.errorMessage!,
                style: TextStyle(color: Colors.red, fontSize: 16.sp)),
          );
        }

        final List<UserModel> users = widget.isActive
            ? userProvider.activeUsers
            : userProvider.deactivatedUsers;

        if (users.isEmpty) {
          return Center(
            child: Text(
              widget.isActive ? "No Active Users" : "No Deactivated Users",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          );
        }

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: GridView.builder(
            padding: EdgeInsets.symmetric(vertical: 10.h),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, // Two columns
              mainAxisSpacing: 16.w,
              crossAxisSpacing: 16.h,
              childAspectRatio: 2,
            ),
            itemCount: users.length,
            itemBuilder: (context, index) {
              return UserCardWidget(user: users[index]);
            },
          ),
        );
      },
    );
  }
}

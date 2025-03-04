import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:jamees_foods_admin/admin_provider/user_list_provider.dart';
import 'package:provider/provider.dart';
import '../admin_provider/each_user_provider.dart';
import '../model/each_user_model.dart';

class UserCard extends StatefulWidget {
  final int userId;

  const UserCard({super.key, required this.userId});

  @override
  _UserCardState createState() => _UserCardState();
}

class _UserCardState extends State<UserCard> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => Provider.of<SalesmanProvider>(context, listen: false)
        .fetchSalesmanDetails(widget.userId, context));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'User Card',
          style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
        ),
      ),
      body: Consumer<SalesmanProvider>(
        builder: (context, salesPrvdr, child) {
          if (salesPrvdr.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (salesPrvdr.errorMessage != null) {
            return Center(
              child: Text(
                salesPrvdr.errorMessage!,
                style: const TextStyle(color: Colors.red, fontSize: 16),
              ),
            );
          }

          if (salesPrvdr.salesmanDetails == null) {
            return const Center(child: Text("No Salesman Data Found"));
          }

          final EachUser user = salesPrvdr.salesmanDetails!.user;
          final dynamic visitsData = salesPrvdr.salesmanDetails!.visits;

          /// **Check if visits data is a List or a String ("No visits found")**
          bool hasVisits = visitsData is List<Visit> && visitsData.isNotEmpty;

          return SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildUserInfo(user, visitsData),
                  if (!hasVisits) _buildNoVisitsMessage(),
                  if (hasVisits) _buildVisitsSection(visitsData),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  /// **User Info Card**
  Widget _buildUserInfo(EachUser user, dynamic visitsData) {
    final provider = Provider.of<UserProvider>(context);
    return Center(
      child: Padding(
        padding: EdgeInsets.all(10.w),
        child: Container(
          width: 500.w,
          height: 300.h,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 3,
                blurRadius: 5,
                offset: Offset(0, 2.h),
              ),
            ],
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Padding(
            padding: EdgeInsets.all(20.w),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 60.r,
                  child:
                      const Icon(Icons.person, size: 50, color: Colors.black),
                ),
                SizedBox(width: 20.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(user.userName,
                          style: TextStyle(
                              fontSize: 18.sp, fontWeight: FontWeight.bold)),
                      Text(user.userRole,
                          style: TextStyle(
                              fontSize: 14.sp, fontWeight: FontWeight.w500)),
                      user.userEmail.isNotEmpty
                          ? Text(user.userEmail,
                              style: TextStyle(fontSize: 14.sp))
                          : Text('Email not updated',
                              style: TextStyle(
                                  fontSize: 14.sp, color: Colors.grey)),
                      Text(user.userPhone, style: TextStyle(fontSize: 14.sp)),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    provider.activateDeactivateUser(user.userId, context);
                  },
                  child: provider.isActiveLoading
                      ? Center(child: CircularProgressIndicator())
                      : Container(
                          height: 80.h,
                          width: 150,
                          decoration: BoxDecoration(
                              color: !provider.isActive
                                  ? Colors.red
                                  : Colors.green,
                              borderRadius: BorderRadius.circular(8)),
                          child: Center(
                              child: Text(
                            !provider.isActive ? "Deactive" : "Active",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.bold),
                          )),
                        ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// **No Visits Message**
  Widget _buildNoVisitsMessage() {
    return Center(
      child: Padding(
        padding: EdgeInsets.only(top: 50.h),
        child: Text(
          "No visits found for this user.",
          style: TextStyle(
              fontSize: 18.sp, fontWeight: FontWeight.w500, color: Colors.grey),
        ),
      ),
    );
  }

  /// **Visits Section**
  Widget _buildVisitsSection(List<Visit> visits) {
    /// **Group Visits by Date**
    final todayVisits =
        visits.where((v) => isSameDate(v.checkinTime, DateTime.now())).toList();

    final yesterdayVisits = visits
        .where((v) => isSameDate(
            v.checkinTime, DateTime.now().subtract(const Duration(days: 1))))
        .toList();

    final olderVisits = visits
        .where((v) =>
            !isSameDate(v.checkinTime, DateTime.now()) &&
            !isSameDate(v.checkinTime,
                DateTime.now().subtract(const Duration(days: 1))))
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (todayVisits.isNotEmpty)
          _buildVisitSection("Today's Visits", todayVisits),
        if (yesterdayVisits.isNotEmpty)
          _buildVisitSection("Yesterday's Visits", yesterdayVisits),
        if (olderVisits.isNotEmpty) _buildOlderVisitsSection(olderVisits),
      ],
    );
  }

  /// **Visit Section**
  Widget _buildVisitSection(String title, List<Visit> visits) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
          child: Text(
            title,
            style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
          ),
        ),
        _buildVisitGrid(visits),
      ],
    );
  }

  /// **Older Visits Section**
  Widget _buildOlderVisitsSection(List<Visit> visits) {
    Map<String, List<Visit>> groupedVisits = {};
    for (var visit in visits) {
      String dateStr = DateFormat('dd-MM-yyyy').format(visit.checkinTime);
      groupedVisits[dateStr] = groupedVisits[dateStr] ?? [];
      groupedVisits[dateStr]!.add(visit);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: groupedVisits.entries.map((entry) {
        return _buildVisitSection(entry.key, entry.value);
      }).toList(),
    );
  }

  /// **Visit GridView**
  Widget _buildVisitGrid(List<Visit> visits) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 20.w,
          mainAxisSpacing: 20.h,
          childAspectRatio: 3 / 1,
        ),
        itemCount: visits.length,
        itemBuilder: (context, index) {
          return _buildVisitCard(visits[index]);
        },
      ),
    );
  }

  /// **Visit Card**
  Widget _buildVisitCard(Visit visit) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 3,
            blurRadius: 5,
            offset: Offset(0, 2.h),
          ),
        ],
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(10.w),
        child: Row(
          children: [
            SizedBox(
              height: 100.h,
              child: Image.asset(
                "asset/image/store.png",
                height: 70.h,
                fit: BoxFit.contain,
              ),
            ),
            SizedBox(
              width: 30.w,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Store: ${visit.storeName}',
                    style: TextStyle(
                        fontSize: 14.sp, fontWeight: FontWeight.bold)),
                Text('Check-in: ${formatDateTime(visit.checkinTime)}',
                    style: TextStyle(fontSize: 12.sp)),
                Text('Check-out: ${formatDateTime(visit.checkoutTime)}',
                    style: TextStyle(fontSize: 12.sp)),
                Text('Amount: ${visit.salesAmount}',
                    style: TextStyle(
                        fontSize: 12.sp, fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  bool isSameDate(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  String formatDateTime(DateTime? dateTime) => dateTime == null
      ? "N/A"
      : DateFormat('dd-MM-yyyy hh:mm a').format(dateTime);
}

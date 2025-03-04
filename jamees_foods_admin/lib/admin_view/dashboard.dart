import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jamees_foods_admin/admin_provider/dashboard_provider.dart';
import 'package:provider/provider.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.microtask(() => Provider.of<DataProvider>(context, listen: false)
      ..fetchStoreCount(context)
      ..fetchUserCount(context));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Search Bar with Logo
                Row(
                  children: [
                    SizedBox(width: 16.w), // Add spacing
                    Expanded(
                      flex: 1,
                      child: Image.asset(
                        'asset/image/logo.png',
                        height: 80.h,
                        width: 80.w,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 30.h),
                Center(
                  child: SizedBox(
                    width: 800.w,
                    height: 850.h,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Stores Section
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 40.w),
                              child: const SectionTitle(title: 'STORES'),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 40.w),
                              child: SizedBox(
                                height: 300.h,
                                child: Card(
                                  elevation: 4,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.r),
                                  ),
                                  color: Colors.white,
                                  child: Padding(
                                    padding: EdgeInsets.all(16.w),
                                    child: Consumer<DataProvider>(
                                      builder: (context, provider, child) {
                                        return Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            // Icon or Image Section
                                            Padding(
                                              padding:
                                                  EdgeInsets.only(left: 20.w),
                                              child: Container(
                                                width: 100.w,
                                                height: 150.h,
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.r),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.black26,
                                                      blurRadius: 3.r,
                                                      spreadRadius: 2.r,
                                                      offset: Offset(0, 0),
                                                    ),
                                                  ],
                                                  image: const DecorationImage(
                                                    image: AssetImage(
                                                        'asset/image/storesmall.png'),
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 12.w),

                                            // Text Content Section
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 20.w),
                                                    child: Text(
                                                      'Jamees Foods',
                                                      style: TextStyle(
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        fontSize: 14.sp,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                  Row(
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 20.w),
                                                        child: const Icon(
                                                            Icons.location_on),
                                                      ),
                                                      Text(
                                                        'Thamarassery',
                                                        style: TextStyle(
                                                          fontSize: 12.sp,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),

                                            // Vertical Divider
                                            const Expanded(
                                              child: VerticalDivider(
                                                thickness: 1,
                                                color: Colors.black,
                                              ),
                                            ),

                                            // Total Stores Section
                                            Padding(
                                              padding:
                                                  EdgeInsets.only(right: 20.w),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        'Active Store :  ',
                                                        style: TextStyle(
                                                            fontSize: 12.sp,
                                                            color: Colors
                                                                .grey[700]),
                                                      ),
                                                      Text(
                                                        provider.activeStores
                                                            .toString(),
                                                        style: TextStyle(
                                                          fontSize: 16.sp,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        'Deactivated Stores :  ',
                                                        style: TextStyle(
                                                            fontSize: 12.sp,
                                                            color: Colors
                                                                .grey[700]),
                                                      ),
                                                      Text(
                                                        provider
                                                            .deactivatedStores
                                                            .toString(),
                                                        style: TextStyle(
                                                          fontSize: 16.sp,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: const Color
                                                              .fromARGB(
                                                              255, 255, 92, 92),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Expanded(
                                                      child: SizedBox(
                                                          width: 100.w,
                                                          child: Divider())),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        'Total Stores :  ',
                                                        style: TextStyle(
                                                            fontSize: 14.sp,
                                                            color: const Color
                                                                .fromARGB(
                                                                255, 0, 0, 0),
                                                            fontWeight:
                                                                FontWeight
                                                                    .w800),
                                                      ),
                                                      Text(
                                                        provider.totalStores
                                                            .toString(),
                                                        style: TextStyle(
                                                          fontSize: 16.sp,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(height: 4.h),
                                                ],
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 50.h),

                        // User Section
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 40.w),
                              child: const SectionTitle(title: 'USER'),
                            ),
                            SizedBox(height: 14.h),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 40.w),
                              child: SizedBox(
                                height: 300.h,
                                child: Card(
                                  elevation: 4,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.r),
                                  ),
                                  color: Colors.white,
                                  child: Padding(
                                    padding: EdgeInsets.all(16.w),
                                    child: Consumer<DataProvider>(
                                      builder: (context, provider, child) {
                                        return Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            // Icon or Image Section
                                            Padding(
                                              padding:
                                                  EdgeInsets.only(left: 20.w),
                                              child: Container(
                                                width: 100.w,
                                                height: 140.h,
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.r),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.black26,
                                                      blurRadius: 3.r,
                                                      spreadRadius: 2.r,
                                                      offset: Offset(0, 0),
                                                    ),
                                                  ],
                                                  image: const DecorationImage(
                                                    image: AssetImage(
                                                        'asset/image/rect.png'),
                                                    fit: BoxFit.contain,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 15.w),

                                            // Text Content Section
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 20.w),
                                                    child: Text(
                                                      'Jamees Foods',
                                                      style: TextStyle(
                                                        fontSize: 14.sp,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 20.w),
                                                    child: Text(
                                                      'Sales Executive',
                                                      style: TextStyle(
                                                        fontSize: 12.sp,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),

                                            // Vertical Divider
                                            Expanded(
                                              child: Padding(
                                                padding: EdgeInsets.only(
                                                    right: 10.w),
                                                child: const VerticalDivider(
                                                  thickness: 1,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),

                                            // Total Users Section
                                            Expanded(
                                              child: Padding(
                                                padding: EdgeInsets.only(
                                                    right: 10.w),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Text(
                                                          'Activated Users :    ',
                                                          style: TextStyle(
                                                              fontSize: 12.sp,
                                                              color: Colors
                                                                  .grey[700]),
                                                        ),
                                                        Text(
                                                          provider.activeUsers
                                                              .toString(),
                                                          style: TextStyle(
                                                            fontSize: 16.sp,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Row(
                                                      children: [
                                                        Text(
                                                          'Deactivated Users :    ',
                                                          style: TextStyle(
                                                              fontSize: 12.sp,
                                                              color: Colors
                                                                  .grey[700]),
                                                        ),
                                                        Text(
                                                          provider
                                                              .deactivatedUsers
                                                              .toString(),
                                                          style: TextStyle(
                                                            fontSize: 16.sp,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: const Color
                                                                .fromARGB(255,
                                                                255, 40, 40),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Expanded(
                                                        child: SizedBox(
                                                            width: 100.w,
                                                            child: Divider())),
                                                    Row(
                                                      children: [
                                                        Text(
                                                          'Total Users :    ',
                                                          style: TextStyle(
                                                              fontSize: 14.sp,
                                                              color: const Color
                                                                  .fromARGB(
                                                                  255, 0, 0, 0),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w800),
                                                        ),
                                                        Text(
                                                          provider.totalUsers
                                                              .toString(),
                                                          style: TextStyle(
                                                            fontSize: 16.sp,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(height: 4.h),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 40.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle({required this.title, super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 16.sp,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

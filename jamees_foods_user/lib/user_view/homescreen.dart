import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jamees_foods_frontend/controller/provider/sidebar_provider.dart';
import 'package:jamees_foods_frontend/controller/provider/store_provider.dart';
import 'package:jamees_foods_frontend/controller/provider/user_provider.dart';
import 'package:jamees_foods_frontend/user_view/storeview.dart';
import 'package:provider/provider.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  String getGreeting() {
    final hour = DateTime.now().hour;
    if (hour >= 5 && hour < 12) {
      return "Good Morning";
    } else if (hour >= 12 && hour < 17) {
      return "Good Afternoon";
    } else if (hour >= 17 && hour < 21) {
      return "Good Evening";
    } else {
      return "Good Night";
    }
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<GetStoreProvider>(context, listen: false)
          .fetchStores(context);
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      userProvider.fetchUserProfile(context);
    });
    _searchController.addListener(() {
      if (mounted) {
        setState(() {
          _searchQuery = _searchController.text.toLowerCase();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    return Consumer<GetStoreProvider>(
      builder: (context, storeProvider, child) {
        if (storeProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (storeProvider.errorMessage.isNotEmpty) {
          return Center(
            child: Text(
              storeProvider.errorMessage,
              style: const TextStyle(color: Colors.red),
            ),
          );
        } else if (storeProvider.stores.isEmpty) {
          return const Center(child: Text("No stores available."));
        }

        // **Filter stores based on search query**
        final filteredStores = storeProvider.stores
            .where((store) =>
                store.storeName.toLowerCase().contains(_searchQuery) ||
                store.storeArea.toLowerCase().contains(_searchQuery) ||
                store.storeEmirate.toLowerCase().contains(_searchQuery))
            .toList();

        return Scaffold(
          backgroundColor: Colors.white54,
          body: Column(
            children: [
              // **Search Bar**
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: 120.w, top: 30.h),
                      child: SizedBox(
                        width: 400.w, // Responsive width
                        child: TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            hintText: 'Search Stores...',
                            hintStyle: TextStyle(
                              color: const Color.fromARGB(255, 192, 191, 191),
                              fontSize: 14.sp, // Responsive font size
                            ),
                            prefixIcon: const Icon(Icons.search),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.r),
                              borderSide: const BorderSide(color: Colors.red),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(9.r),
                              borderSide: const BorderSide(
                                  color: Colors.red, width: 1.3),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 60.w),
                  Padding(
                    padding: EdgeInsets.only(top: 25.h),
                    child: SizedBox(
                      height: 64.h,
                      child: Image.asset('asset/image/logo.png'),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30.h),
              Text(
                "Hi, ${userProvider.user!.userName} ${getGreeting()} !",
                style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 30.h),

              // **Create Store Button**
              GestureDetector(
                onTap: () {
                  Provider.of<UserSidebarProvider>(context, listen: false)
                      .switchTab(1);
                },
                child: Container(
                  height: 100.h,
                  width: 305.w,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.r),
                    border: Border.all(width: 0.1),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 5.r,
                        offset: Offset(0, 4.h),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                            child: Text(
                          "Create Store",
                          style: TextStyle(
                              fontSize: 20.sp, fontWeight: FontWeight.w600),
                        )),
                        SizedBox(width: 70.w),
                        Icon(Icons.add_outlined, size: 20.sp),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 40.h),

              // **Store Listing GridView**
              Expanded(
                child: SizedBox(
                  width: 500.w,
                  child: filteredStores.isEmpty
                      ? const Center(
                          child: Text("No matching stores found."),
                        )
                      : GridView.builder(
                          itemCount: filteredStores.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 20.w,
                            mainAxisSpacing: 20.h,
                            childAspectRatio: 12 / 6,
                          ),
                          itemBuilder: (context, index) {
                            final store = filteredStores[index];
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => StoreView(
                                      storeName: store.storeName,
                                      areaName: store.storeArea,
                                      emiratesName: store.storeEmirate,
                                      phoneNumber: store.storePhoneNumber,
                                      storeId: store.storeId,
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                height: 90.h,
                                width: 270.w,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.r),
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 5.r,
                                      offset: Offset(0, 4.h),
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        height: 41.28.h,
                                        width: 64.56.w,
                                        child:
                                            Image.asset('asset/image/logo.png'),
                                      ),
                                      SizedBox(width: 20.w),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            store.storeName,
                                            style: TextStyle(
                                                fontSize: 14.sp,
                                                fontWeight: FontWeight.bold),
                                            textAlign: TextAlign.center,
                                          ),
                                          Text(
                                            "📍${store.storeArea}",
                                            style: TextStyle(fontSize: 14.sp),
                                            textAlign: TextAlign.center,
                                          ),
                                          Text(
                                            "📍${store.storeEmirate}",
                                            style: TextStyle(fontSize: 14.sp),
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

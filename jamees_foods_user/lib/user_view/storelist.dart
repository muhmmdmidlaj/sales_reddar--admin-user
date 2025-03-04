import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:jamees_foods_frontend/controller/provider/store_provider.dart';
import 'package:jamees_foods_frontend/user_view/storeview.dart';

class StoreListPage extends StatefulWidget {
  const StoreListPage({Key? key}) : super(key: key);

  @override
  _StoreListPageState createState() => _StoreListPageState();
}

class _StoreListPageState extends State<StoreListPage> {
  TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<GetStoreProvider>(context, listen: false)
          .fetchStores(context);
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
    return Consumer<GetStoreProvider>(
      builder: (context, storeProvider, child) {
        if (storeProvider.isLoading) {
          return Center(child: CircularProgressIndicator());
        } else if (storeProvider.errorMessage.isNotEmpty) {
          return Center(
            child: Text(
              storeProvider.errorMessage,
              style: TextStyle(color: Colors.red),
            ),
          );
        } else if (storeProvider.stores.isEmpty) {
          return Center(child: Text("No stores available."));
        }

        // **Filter stores based on search query**
        final filteredStores = storeProvider.stores
            .where((store) =>
                store.storeName.toLowerCase().contains(_searchQuery) ||
                store.storeArea.toLowerCase().contains(_searchQuery) ||
                store.storeEmirate.toLowerCase().contains(_searchQuery))
            .toList();

        return Scaffold(
          backgroundColor: Colors.white,
          body: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // **Header with Search Bar**
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 12.h,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: EdgeInsets.all(15.w),
                            child: Text(
                              'Stores List',
                              style: TextStyle(
                                fontSize: 29.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Row(
                              children: [
                                // **Search Bar**
                                Expanded(
                                  flex: 5,
                                  child: SizedBox(
                                    width: 400.w,
                                    height: 80.h,
                                    child: TextField(
                                      controller: _searchController,
                                      decoration: InputDecoration(
                                        hintText: 'Search Stores...',
                                        hintStyle: TextStyle(
                                          fontSize: 14.sp,
                                          color: Colors.grey,
                                        ),
                                        prefixIcon: Icon(Icons.search),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8.r),
                                          borderSide:
                                              BorderSide(color: Colors.red),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8.r),
                                          borderSide: BorderSide(
                                              color: Colors.red, width: 1.3),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10.w),
                                Expanded(
                                  child: Image.asset(
                                    'asset/image/logo.png',
                                    width: 60.w,
                                    height: 55.h,
                                  ),
                                ),
                                SizedBox(width: 20.w),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 16.h),

                    // **Store List**
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: filteredStores.isEmpty
                            ? Center(
                                child: Text(
                                  "No matching stores found.",
                                  style: TextStyle(fontSize: 16.sp),
                                ),
                              )
                            : GridView.builder(
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  mainAxisSpacing: 16.h,
                                  crossAxisSpacing: 16.w,
                                  childAspectRatio: 2,
                                ),
                                itemCount: filteredStores.length,
                                itemBuilder: (context, index) {
                                  return StoreCard(
                                    storeNumber:
                                        filteredStores[index].storePhoneNumber,
                                    storeName: filteredStores[index].storeName,
                                    storeArea: filteredStores[index].storeArea,
                                    storeEmirate:
                                        filteredStores[index].storeEmirate,
                                    storeId: filteredStores[index].storeId,
                                  );
                                },
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// **Updated Store Card with Dynamic Data**
class StoreCard extends StatelessWidget {
  final String storeName;
  final String storeArea;
  final String storeEmirate;
  final String storeNumber;
  final int storeId;

  const StoreCard({
    Key? key,
    required this.storeName,
    required this.storeArea,
    required this.storeEmirate,
    required this.storeNumber,
    required this.storeId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => StoreView(
              emiratesName: storeEmirate,
              areaName: storeArea,
              phoneNumber: storeNumber,
              storeId: storeId,
              storeName: storeName,
            ),
          ),
        );
      },
      child: Card(
        color: Colors.white,
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(12.w),
            child: Row(
              children: [
                Container(
                  width: 40.w,
                  height: 40.h,
                  child: Image.asset(
                    'asset/image/rect.png',
                    width: 50.w,
                    height: 50.h,
                    fit: BoxFit.contain,
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        storeName,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '📍 $storeArea, $storeEmirate',
                        style: TextStyle(
                          fontSize: 10.sp,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        "📞 $storeNumber",
                        style: TextStyle(
                          fontSize: 10.sp,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

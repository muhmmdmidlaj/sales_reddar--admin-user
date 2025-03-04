import 'package:flutter/material.dart';
import 'package:jamees_foods_admin/admin_provider/store_provider.dart';
import 'package:jamees_foods_admin/model/store_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class StorCard extends StatelessWidget {
  final Store store;
  final bool isSelected;

  const StorCard({required this.store, super.key, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: isSelected
          ? const Color.fromARGB(255, 194, 192, 192)
          : Colors.white, // Highlight selected card
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(12.w),
        child: Row(
          children: [
            SizedBox(
              height: 90.h,
              child: Image.asset(
                "asset/image/store.png",
                height: 70.h,
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
                    store.storeName,
                    style:
                        TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '📍 ${store.storeArea}',
                    style: TextStyle(fontSize: 12.sp, color: Colors.black),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class StoreDetails extends StatelessWidget {
  final Store store;

  const StoreDetails({required this.store, super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SelectedStoreProvider>(context, listen: false);
    return Padding(
      padding: EdgeInsets.only(bottom: 16.w, right: 16.w),
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 15.r,
              spreadRadius: 6.r,
              offset: Offset(0, 4.h),
            ),
          ],
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Container(
                width: 100.w,
                height: 200.h,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.r),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 3.r,
                        spreadRadius: 3.r,
                        offset: Offset(0, 0),
                      )
                    ]),
                child: Center(
                  child: Image.asset(
                    "asset/image/store.png",
                    width: 100.w,
                    height: 100.h,
                  ),
                ),
              ),
            ),
            SizedBox(height: 16.h),
            Center(
              child: Text(
                store.storeName,
                style: TextStyle(fontSize: 26.sp, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 8.h),
            Center(
                child: Row(
              children: [
                Expanded(
                  child: Text('Location:', style: TextStyle(fontSize: 14.sp)),
                ),
                Expanded(
                  child:
                      Text(store.storeArea, style: TextStyle(fontSize: 14.sp)),
                ),
              ],
            )),
            Center(
                child: Row(
              children: [
                Expanded(
                  child: Text('Store Emirates:',
                      style: TextStyle(fontSize: 14.sp)),
                ),
                Expanded(
                  child: Text(store.storeEmirate,
                      style: TextStyle(fontSize: 14.sp)),
                ),
              ],
            )),
            Center(
                child: Row(
              children: [
                Expanded(
                  child:
                      Text('Phone Number:', style: TextStyle(fontSize: 14.sp)),
                ),
                Expanded(
                    child: Text(store.storePhoneNumber,
                        style: TextStyle(fontSize: 14.sp))),
              ],
            )),
            SizedBox(height: 36.h),
            Padding(
              padding: EdgeInsets.only(right: 20.w),
              child: GestureDetector(
                onTap: () {
                  if (provider.selectedStore != null) {
                    // Show confirmation dialog
                    showDialog(
                      context: context,
                      builder: (context) {
                        final isActive = provider.selectedStore!.isActive;
                        return AlertDialog(
                          title: Text(
                              isActive ? "Deactivate Store" : "Activate Store"),
                          content: Text(
                            "Are you sure you want to ${isActive ? "deactivate" : "activate"} this store?",
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop(); // Close dialog
                              },
                              child: const Text(
                                "Cancel",
                                style: TextStyle(color: Colors.grey),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                await provider.activateDeactivateStore(
                                    provider.selectedStore!.storeId,context);
                                provider.toggleStoreActivation(
                                    provider.selectedStore!);
                                Navigator.of(context).pop(); // Close dialog
                              },
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.r)),
                                backgroundColor:
                                    isActive ? Colors.red : Colors.green,
                              ),
                              child: Text(isActive ? "Deactivate" : "Activate"),
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
                child: Container(
                  width: 160.w,
                  height: 70.h,
                  decoration: BoxDecoration(
                    color: provider.selectedStore?.isActive == true
                        ? Colors.red
                        : Colors.green, // Change color based on active state
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Center(
                    child: Text(
                      provider.selectedStore?.isActive == true
                          ? "Deactivate"
                          : "Activate", // Change text based on active state
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

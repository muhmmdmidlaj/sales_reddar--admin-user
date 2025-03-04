import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jamees_foods_frontend/controller/provider/checkin_checkout_provider.dart';
import 'package:provider/provider.dart';

class StoreView extends StatelessWidget {
  final int storeId;
  final String storeName;
  final String areaName;
  final String emiratesName;
  final String phoneNumber;

  const StoreView({
    super.key,
    required this.storeId,
    required this.storeName,
    required this.areaName,
    required this.emiratesName,
    required this.phoneNumber,
  });

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<StoreVisitProvider>(context);
    final _formKey = GlobalKey<FormState>();

    bool isStoreCheckedIn = provider.storeVisits.containsKey(storeId);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Icon(Icons.arrow_back_ios_new_rounded,
              color: Colors.black, size: 24.sp),
        ),
        title: Text(
          "$storeName - Store Data",
          style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 20.sp,
              color: Colors.black),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: 400.w,
                padding: EdgeInsets.all(20.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15.r),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 3.r,
                        blurRadius: 5.r),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text("$storeName",
                                style: TextStyle(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                        Text("$areaName",
                            style: TextStyle(
                                fontSize: 16.sp, fontWeight: FontWeight.w400)),
                        Text("$emiratesName",
                            style: TextStyle(
                                fontSize: 16.sp, fontWeight: FontWeight.w400)),
                        Text(phoneNumber,
                            style: TextStyle(
                                fontSize: 17.sp, fontWeight: FontWeight.w500)),
                        SizedBox(height: 10.h),
                        isStoreCheckedIn
                            ? Text("🟢 Checked In",
                                style: TextStyle(
                                    fontSize: 16.sp, color: Colors.green))
                            : Text("🔴 Not Checked In",
                                style: TextStyle(
                                    fontSize: 16.sp, color: Colors.red)),
                      ],
                    ),
                    Card(
                        child: Container(
                      decoration: BoxDecoration(color: Colors.white),
                      height: 200.h,
                      width: 100.w,
                      child: Image.asset('asset/image/store.png'),
                    ))
                  ],
                ),
              ),
              SizedBox(height: 40.h),
              SizedBox(
                width: 343.w,
                height: 80.h,
                child: provider.ischknLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ElevatedButton(
                        onPressed: !isStoreCheckedIn
                            ? () async {
                                await provider.checkIn(storeId, context);
                              }
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              !isStoreCheckedIn ? Colors.red : Colors.grey,
                        ),
                        child: Text("Check-in",
                            style: TextStyle(
                                fontSize: 16.sp, color: Colors.white)),
                      ),
              ),
              SizedBox(height: 40.h),
              Form(
                key: _formKey,
                child: SizedBox(
                  width: 343.w,
                  child: TextFormField(
                    controller: provider.salesAmountController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Amount',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(13.r)),
                    ),
                    style: TextStyle(fontSize: 16.sp),
                    validator: (value) {
                      if (value == null || value.isEmpty)
                        return 'Enter Sales Amount';
                      return null;
                    },
                  ),
                ),
              ),
              SizedBox(height: 40.h),
              SizedBox(
                width: 343.w,
                height: 80.h,
                child: provider.ischktLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ElevatedButton(
                        onPressed: isStoreCheckedIn
                            ? () async {
                                if (_formKey.currentState!.validate()) {
                                  final salesAmount = int.tryParse(provider
                                          .salesAmountController.text) ??
                                      0;
                                  await provider.checkOut(
                                      storeId, salesAmount, context);
                                }
                              }
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              isStoreCheckedIn ? Colors.green : Colors.grey,
                        ),
                        child: Text("Check-out",
                            style: TextStyle(
                                fontSize: 16.sp, color: Colors.white)),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

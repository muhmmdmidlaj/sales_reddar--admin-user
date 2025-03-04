import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jamees_foods_frontend/controller/provider/create_store_provider.dart';
import 'package:provider/provider.dart';

class CreateStorePage extends StatelessWidget {
  const CreateStorePage({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final storeProvider = Provider.of<StoreProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: SizedBox(width: 0.w),
        actions: [
          Padding(
            padding: EdgeInsets.all(9.w),
            child: Image.asset(
              'asset/image/logo.png',
              width: 44.w,
              height: 50.h,
            ),
          ),
          SizedBox(width: 20.w),
        ],
        iconTheme: const IconThemeData(color: Colors.black),
        title: Text(
          "Create Store",
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 25.sp,
            color: Colors.black,
          ),
        ),
      ),
      body: Form(
        key: formKey,
        child: Stack(
          children: [
            Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 66.w),
                      child: Container(
                        width: 658.w,
                        padding: EdgeInsets.all(16.w),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(40.r),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.25),
                              blurRadius: 12.r,
                              offset: Offset(0, 4.h),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 60.w, top: 30.h),
                              child: Text(
                                "Store Data",
                                style: TextStyle(
                                  fontSize: 22.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            SizedBox(height: 16.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Flexible(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text("Store Name",
                                          style: TextStyle(fontSize: 16.sp)),
                                      SizedBox(height: 3.h),
                                      SizedBox(
                                        width: 343.w,
                                        child: TextFormField(
                                          controller:
                                              storeProvider.storeNameController,
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10.r),
                                            ),
                                          ),
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Store Name is required';
                                            }
                                            return null;
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 16.w),
                                Flexible(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text("Number",
                                          style: TextStyle(fontSize: 16.sp)),
                                      SizedBox(height: 3.h),
                                      SizedBox(
                                        width: 343.w,
                                        child: TextFormField(
                                          keyboardType: TextInputType.phone,
                                          controller:
                                              storeProvider.numberController,
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10.r),
                                            ),
                                          ),
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Phone Number is required';
                                            }
                                            if (!RegExp(r'^[0-9]{10,15}$')
                                                .hasMatch(value)) {
                                              return 'Enter a valid phone number (10-15 digits)';
                                            }
                                            return null;
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 16.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Flexible(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text("Area",
                                          style: TextStyle(fontSize: 16.sp)),
                                      SizedBox(height: 3.h),
                                      SizedBox(
                                        width: 343.w,
                                        child: TextFormField(
                                          controller:
                                              storeProvider.areaController,
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10.r),
                                            ),
                                          ),
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Store Area is required';
                                            }
                                            return null;
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 16.w),
                                Flexible(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text("Emirate",
                                          style: TextStyle(fontSize: 16.sp)),
                                      SizedBox(height: 3.h),
                                      SizedBox(
                                        width: 343.w,
                                        child: DropdownButtonFormField<String>(
                                          value: storeProvider.selectedEmirate,
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10.r),
                                            ),
                                          ),
                                          hint: const Text("Select Emirate"),
                                          items: storeProvider.emirates
                                              .map((String emirate) {
                                            return DropdownMenuItem<String>(
                                              value: emirate,
                                              child: Text(emirate),
                                            );
                                          }).toList(),
                                          onChanged: (String? newValue) {
                                            storeProvider.setEmirate(newValue);
                                          },
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Please select an Emirate';
                                            }
                                            return null;
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 65.h),
                            Center(
                              child: ElevatedButton(
                                onPressed: () async {
                                  if (formKey.currentState!.validate()) {
                                    await storeProvider.createStore(context);
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                  padding: EdgeInsets.symmetric(
                                      vertical: 16.h, horizontal: 70.w),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.r),
                                  ),
                                ),
                                child: Text('Create Store',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 16.sp)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (storeProvider.isLoading)
              const Center(
                child: CircularProgressIndicator(),
              ),
          ],
        ),
      ),
    );
  }
}

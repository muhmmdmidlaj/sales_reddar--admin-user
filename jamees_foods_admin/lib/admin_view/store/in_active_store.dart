import 'package:flutter/material.dart';
import 'package:jamees_foods_admin/admin_provider/store_provider.dart';
import 'package:jamees_foods_admin/admin_view/store/store_widget/widget.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class InActiveStore extends StatelessWidget {
  final String searchQuery;
  const InActiveStore({super.key, required this.searchQuery});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SelectedStoreProvider()..fetchStores(),
      child:
          Consumer<SelectedStoreProvider>(builder: (context, provider, child) {
        final selectedStore = provider.selectedStore;

        // Filter stores based on search query
        final stores = provider.deActivatedStores
            .where((store) =>
                store.storeName.toLowerCase().contains(searchQuery.toLowerCase()))
            .toList();

        return SafeArea(
          child: Column(
            children: [
              SizedBox(height: 16.h),
              provider.deActivatedStores.isEmpty
                  ? Expanded(
                      child: Center(
                        child: provider.message == null
                            ? CircularProgressIndicator()
                            : Text(
                                'No stores available',
                                style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold),
                              ),
                      ),
                    )
                  : provider.selectedStore == null
                      ? Expanded(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10.w),
                            child: GridView.builder(
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                mainAxisSpacing: 16.h,
                                crossAxisSpacing: 16.w,
                                childAspectRatio: 2,
                              ),
                              itemCount: stores.length,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    Provider.of<SelectedStoreProvider>(context,
                                            listen: false)
                                        .selectStore(stores[index]);
                                  },
                                  child: StorCard(
                                    store: stores[index],
                                    isSelected: selectedStore == stores[index],
                                  ),
                                );
                              },
                            ),
                          ),
                        )
                      : Expanded(
                          child: Row(
                            children: [
                              Expanded(
                                flex: 3,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10.w),
                                        child: GridView.builder(
                                          gridDelegate:
                                              SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 2,
                                            mainAxisSpacing: 10.h,
                                            crossAxisSpacing: 10.w,
                                            childAspectRatio: 2,
                                          ),
                                          itemCount: stores.length,
                                          itemBuilder: (context, index) {
                                            return GestureDetector(
                                              onTap: () {
                                                Provider.of<SelectedStoreProvider>(
                                                        context,
                                                        listen: false)
                                                    .selectStore(stores[index]);
                                              },
                                              child: StorCard(
                                                store: stores[index],
                                                isSelected: selectedStore ==
                                                    stores[index],
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: selectedStore == null
                                    ? Center(
                                        child: Text(
                                          'Select a store to view details',
                                          style: TextStyle(
                                              fontSize: 16.sp,
                                              color: Colors.grey),
                                        ),
                                      )
                                    : StoreDetails(store: selectedStore),
                              ),
                            ],
                          ),
                        ),
            ],
          ),
        );
      }),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jamees_foods_frontend/controller/provider/regenerating_tocken.dart';
import 'package:jamees_foods_frontend/controller/provider/sidebar_provider.dart';
import 'package:jamees_foods_frontend/user_view/create.dart';
import 'package:jamees_foods_frontend/user_view/homescreen.dart';
import 'package:jamees_foods_frontend/user_view/profile.dart';
import 'package:jamees_foods_frontend/user_view/storelist.dart';
import 'package:provider/provider.dart';

class SidebarWithTabView extends StatefulWidget {
  const SidebarWithTabView({Key? key}) : super(key: key);

  @override
  _SidebarWithTabViewState createState() => _SidebarWithTabViewState();
}

class _SidebarWithTabViewState extends State<SidebarWithTabView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this); // Fixed length
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) {
        final provider = UserSidebarProvider();
        provider.setTabController(_tabController);
        return provider;
      },
      child: Consumer<UserSidebarProvider>(
        builder: (context, sidebarProvider, child) {
          return Scaffold(
            body: SizedBox(
              height: double.infinity,
              child: Row(
                children: [
                  // Sidebar
                  AnimatedContainer(
                    height: double.infinity,
                    duration: const Duration(milliseconds: 300),
                    width: sidebarProvider.isExpanded ? 220 : 70,
                    color: const Color.fromARGB(255, 213, 20, 6),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: IconButton(
                                  icon: const Icon(Icons.menu,
                                      color: Colors.white),
                                  onPressed: () {
                                    sidebarProvider.toggleSidebar();
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 30),
                          _buildSidebarItem(context, Icons.home, "Home", 0),
                          _buildSidebarItem(
                              context, Icons.add, "Create Store", 1),
                          _buildSidebarItem(
                              context, Icons.storefront_outlined, "Stores", 2),
                          _buildSidebarItem(
                              context, Icons.person_pin, "Profile", 3),
                          const SizedBox(height: 200),
                          _buildLogoutItem(context),
                        ],
                      ),
                    ),
                  ),

                  // Tab View
                  Expanded(
                    child: TabBarView(
                      controller: sidebarProvider.tabController,
                      children: const [
                        Homescreen(),
                        CreateStorePage(),
                        StoreListPage(),
                        Profile(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // Sidebar Item Builder
  Widget _buildSidebarItem(
      BuildContext context, IconData icon, String label, int index) {
    final sidebarProvider = Provider.of<UserSidebarProvider>(context);
    final isSelected = sidebarProvider.selectedTabIndex == index;

    return InkWell(
      onTap: () {
        sidebarProvider.switchTab(index);
      },
      child: Container(
        height: 60,
        decoration: BoxDecoration(
          color: isSelected
              ? const Color.fromARGB(255, 24, 23, 23).withOpacity(0.2)
              : Colors.transparent,
        ),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
        child: Row(
          children: [
            const SizedBox(width: 10),
            Icon(icon, color: isSelected ? Colors.white : Colors.white70),
            if (sidebarProvider.isExpanded)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
                    label,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.white70,
                      fontSize: 17,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // Logout Item (separate to avoid tab index error)
  Widget _buildLogoutItem(BuildContext context) {
    final sidebarProvider = Provider.of<UserSidebarProvider>(context);

    return InkWell(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              content: Container(
                height: 100,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(5)),
                child: Column(
                  children: [
                    const Text(
                      "Confirm Logout",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                    ),
                    SizedBox(height: 30.h),
                    const Text(
                      "Are you sure you want to log out?",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close dialog
                  },
                  child: const Text("Cancel"),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 191, 13, 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onPressed: () async {
                    await logoutUser(context);
                  },
                  child: const Text(
                    "Logout",
                    style: TextStyle(color: Colors.white),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            );
          },
        );
      },
      child: Container(
        height: 60,
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
        child: Row(
          children: [
            const SizedBox(width: 10),
            const Icon(Icons.logout, color: Colors.white70),
            if (sidebarProvider.isExpanded)
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: 18.w),
                  child: const Text(
                    "Logout",
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: Colors.white70,
                        fontSize: 17,
                        fontWeight: FontWeight.w400),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

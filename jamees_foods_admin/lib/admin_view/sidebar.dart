import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jamees_foods_admin/admin_provider/admin_logout.dart';

import 'package:jamees_foods_admin/admin_provider/sidebar_provider.dart';
import 'package:jamees_foods_admin/admin_view/dashboard.dart';

import 'package:jamees_foods_admin/admin_view/store/storelist.dart';
import 'package:jamees_foods_admin/admin_view/userlistwin.dart';
import 'package:provider/provider.dart';

class AdminSidebarWithTabView extends StatefulWidget {
  const AdminSidebarWithTabView({super.key});

  @override
  _AdminSidebarWithTabViewState createState() =>
      _AdminSidebarWithTabViewState();
}

class _AdminSidebarWithTabViewState extends State<AdminSidebarWithTabView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
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
        final provider = AdminSidebarProvider();
        provider.setTabController(_tabController); // Initialize TabController
        return provider;
      },
      child: Consumer<AdminSidebarProvider>(
        builder: (context, sidebarProvider, child) {
          return Scaffold(
            body: SizedBox(
              height: double.infinity,
              child: Row(
                children: [
                  // Animated Sidebar
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
                              context, Icons.storefront_outlined, "Store", 1),
                          _buildSidebarItem(
                              context, Icons.supervised_user_circle, "User", 2),
                          const SizedBox(height: 200),
                          _buildSidebarItem(context,
                              Icons.support_agent_rounded, "Support", 3),
                          _buildSidebarItem(context, Icons.logout, "Logout", 4),
                        ],
                      ),
                    ),
                  ),
                  // Tab View
                  Expanded(
                    child: TabBarView(
                      controller: sidebarProvider.tabController,
                      children: const [
                        DashboardPage(),
                        StoreListPage(),
                        UserListPage(),
                        Center(child: Text('Logout Tab')),
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

  // Sidebar item builder
  Widget _buildSidebarItem(
      BuildContext context, IconData icon, String label, int index) {
    final sidebarProvider = Provider.of<AdminSidebarProvider>(context);
    final isSelected = sidebarProvider.selectedTabIndex == index;

    return InkWell(
      onTap: () {
        if (label == "Logout") {
          // Show confirmation dialog for logout
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
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w500),
                        ),
                        SizedBox(
                          height: 30.h,
                        ),
                        const Text(
                          "Are you sure you want to log out?",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w400),
                        ),
                      ],
                    )),
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
                    ),
                  ),
                ],
              );
            },
          );
        } else {
          sidebarProvider.switchTab(index); // Switch tab for other items
        }
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
            Icon(
              icon,
              color: isSelected ? Colors.white : Colors.white70,
            ),
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
}

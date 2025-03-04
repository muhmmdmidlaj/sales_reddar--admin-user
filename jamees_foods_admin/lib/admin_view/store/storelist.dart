import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jamees_foods_admin/admin_view/store/active_store.dart';
import 'package:jamees_foods_admin/admin_view/store/in_active_store.dart';

class StoreListPage extends StatefulWidget {
  const StoreListPage({super.key});

  @override
  _StoreListPageState createState() => _StoreListPageState();
}

class _StoreListPageState extends State<StoreListPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    setState(() {
      _searchQuery = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          onChanged: _onSearchChanged,
          decoration: InputDecoration(
            hintText: 'Search stores...',
            hintStyle: TextStyle(fontSize: 16.sp),
            border: InputBorder.none,
            prefixIcon: const Icon(Icons.search),
            suffixIcon: _searchController.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      setState(() {
                        _searchController.clear();
                        _searchQuery = '';
                      });
                    },
                  )
                : null,
          ),
        ),
        bottom: TabBar(
          labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          labelColor: Colors.black,
          controller: _tabController,
          indicatorColor: Colors.red,
          tabs: const [
            Tab(text: 'Active Stores'),
            Tab(text: 'Inactive Stores'),
          ],
        ),
      ),
      backgroundColor: const Color(0xFFF7F7F7),
      body: SafeArea(
        child: TabBarView(
          controller: _tabController,
          children: [
            ActiveStore(searchQuery: _searchQuery),
            InActiveStore(searchQuery: _searchQuery),
          ],
        ),
      ),
    );
  }
}

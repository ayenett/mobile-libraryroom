import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/logout_function.dart';
import 'staff_dashboard.dart'; // class: StaffDashboard

class StaffHistory extends StatefulWidget {
  const StaffHistory({super.key});

  @override
  State<StaffHistory> createState() => _StaffHistoryState();
}

class _StaffHistoryState extends State<StaffHistory>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final String username = 'Staff';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // Sample Data
  final List<Map<String, dynamic>> _allBookings = [
    {
      'room': 'Study Room A',
      'date': 'Mon, Oct 20',
      'time': '08:00 - 10:00',
      'status': 0,
      'approver': '',
      'booked_by': 'Lisa',
    },
    {
      'room': 'Study Room B',
      'date': 'Wed, Oct 27',
      'time': '12:00 - 14:00',
      'status': 0,
      'approver': '',
      'booked_by': 'Tom',
    },
    {
      'room': 'Study Room C',
      'date': 'Mon, Oct 29',
      'time': '10:00 - 12:00',
      'status': 0,
      'approver': '',
      'booked_by': 'Adam',
    },
    {
      'room': 'Study Room A',
      'date': 'Mon, Oct 6',
      'time': '08:00 - 10:00',
      'status': 1,
      'approver': 'Ajarn Surapong',
      'booked_by': 'Lisa',
    },
    {
      'room': 'Multimedia Room A',
      'date': 'Wed, Oct 1',
      'time': '08:00 - 10:00',
      'status': 1,
      'approver': 'Ajarn Bryan',
      'booked_by': 'John',
    },
    {
      'room': 'Study Room C',
      'date': 'Tue, Sep 30',
      'time': '13:00 - 15:00',
      'status': 0, // Rejected
      'approver': 'Ajarn Nick',
      'booked_by': 'Emma',
      'reason': 'Exceeded booking limit for this week',
    },
    {
      'room': 'Meeting Room A',
      'date': 'Fri, Sep 26',
      'time': '10:00 - 12:00',
      'status': 1,
      'approver': 'Ajarn Surapong',
      'booked_by': 'Olivia',
    },
    {
      'room': 'Meeting Room A',
      'date': 'Fri, Sep 26',
      'time': '10:00 - 12:00',
      'status': 1,
      'approver': 'Ajarn Surapong',
      'booked_by': 'Liam',
    },
  ];

  // Booking card
  Widget _buildBookingCard(Map<String, dynamic> b) {
    final int status = b['status'] as int;
    final bool isPending = status == 0 && b['approver'].isEmpty;

    String statusText;
    Color statusColor;
    IconData statusIcon;

    if (isPending) {
      statusText = 'Pending Approval';
      statusColor = Colors.amber;
      statusIcon = Icons.circle_outlined;
    } else if (status == 0) {
      statusText = 'Rejected';
      statusColor = Colors.red;
      statusIcon = Icons.close;
    } else {
      statusText = 'Approved';
      statusColor = Colors.green;
      statusIcon = Icons.check;
    }

    return Card(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Room name
            RichText(
              text: TextSpan(
                style: const TextStyle(fontSize: 16, color: Colors.black),
                children: [
                  const TextSpan(text: 'Session in '),
                  TextSpan(
                    text: b['room'],
                    style: const TextStyle(color: Colors.orange),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),

            // Date & time
            Row(
              children: [
                const Icon(Icons.calendar_month_outlined, size: 20),
                const SizedBox(width: 6),
                Text(b['date'], style: const TextStyle(fontSize: 14)),
                const SizedBox(width: 20),
                const Icon(Icons.access_time, size: 18),
                const SizedBox(width: 6),
                Text(b['time'], style: const TextStyle(fontSize: 14)),
              ],
            ),

            const SizedBox(height: 8),

            // Booked by
            Row(
              children: [
                const Icon(Icons.person_outline, size: 20),
                const SizedBox(width: 6),
                RichText(
                  text: TextSpan(
                    style: const TextStyle(fontSize: 14, color: Colors.black),
                    children: [
                      const TextSpan(text: 'Booked by '),
                      TextSpan(
                        text: b['booked_by'],
                        style: const TextStyle(color: Colors.orange),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 7),

            // Status
            Row(
              children: [
                Icon(statusIcon, color: statusColor, size: 20),
                const SizedBox(width: 6),
                RichText(
                  text: TextSpan(
                    style: const TextStyle(fontSize: 14, color: Colors.black),
                    children: [
                      TextSpan(text: statusText),
                      if (b['approver'].isNotEmpty) ...[
                        const TextSpan(text: ' by '),
                        TextSpan(
                          text: b['approver'],
                          style: const TextStyle(color: Colors.orange),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),

            // ─── REJECTION REASON (only for rejected bookings) ───────────────
            if (status == 0 && b['approver'].isNotEmpty && b.containsKey('reason')) ...[
              const SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.info_outline, size: 20, color: Colors.redAccent),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      'Reason: ${b['reason']}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                        
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(String title) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inbox_outlined, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text('$title is empty', style: TextStyle(fontSize: 18, color: Colors.grey[600])),
            const SizedBox(height: 8),
            Text('No ${title.toLowerCase()} bookings found', style: TextStyle(color: Colors.grey[500])),
          ],
        ),
      );

  // -------------------------------------------------------------------------
  // MAIN BUILD
  // -------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    final pending = _allBookings.where((b) => b['approver'].isEmpty).toList();
    final history = _allBookings.where((b) => b['approver'].isNotEmpty).toList();
    final headerHeight = MediaQuery.of(context).size.height * 0.24;
    return Scaffold(
      backgroundColor: const Color(0xFFD9D9D9),
      extendBody: true,

      // Bottom Nav
      bottomNavigationBar: SafeArea(
        top: false,
        child: Container(
          height: 56,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 1),
          decoration: BoxDecoration(
            color: Colors.black87,
            borderRadius: BorderRadius.circular(28),
            boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(0, 3))],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(icon: const Icon(Icons.arrow_back_ios, color: Colors.white), onPressed: () => Navigator.maybePop(context)),
              IconButton(
                icon: const Icon(Icons.home_filled, color: Colors.white, size: 28),
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const StaffDashboard())),
              ),
              IconButton(
                icon: const Icon(Icons.calendar_today, color: Colors.white),
                onPressed: () {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('You are already on the Booking page'),
                      duration: const Duration(milliseconds: 1200),
                      behavior: SnackBarBehavior.floating,
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),

      // Body
      body: Column(
        children: [
          // Header
          Container(
            decoration: const BoxDecoration(
              color: Color(0xFF003366),
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30)),
              border: Border(bottom: BorderSide(color: Colors.black, width: 2)),
            ),
            width: double.infinity,
            height: headerHeight,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 60),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Greeting
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                            text: TextSpan(
                              children: [
                                const TextSpan(
                                  text: 'Hi',
                                  style: TextStyle(fontSize: 28, color: Colors.white, fontWeight: FontWeight.bold),
                                ),
                                TextSpan(text: ', $username', style: const TextStyle(fontSize: 28, color: Colors.white)),
                              ],
                            ),
                          ),
                          const Text('Bookings', style: TextStyle(fontSize: 25, color: Colors.white)),
                        ],
                      ),
                      IconButton(
                        onPressed: () => showLogoutDialog(context),
                        icon: const Icon(Icons.logout_rounded, color: Colors.white, size: 40),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: SizedBox(
                    width: 185,
                    child: TabBar(
                      controller: _tabController,
                      labelColor: Colors.amber,
                      unselectedLabelColor: Colors.white70,
                      indicatorColor: Colors.amber,
                      indicatorSize: TabBarIndicatorSize.label,
                      dividerColor: Colors.transparent,
                      labelStyle: const TextStyle(fontSize: 20),
                      labelPadding: const EdgeInsets.symmetric(horizontal: 0),
                      tabs: const [Tab(text: 'Pending'), Tab(text: 'History')],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Tab Views
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                pending.isEmpty
                    ? _buildEmptyState('Pending')
                    : ListView.builder(
                        padding: const EdgeInsets.only(top: 10, bottom: 100),
                        itemCount: pending.length,
                        itemBuilder: (_, i) => _buildBookingCard(pending[i]),
                      ),
                history.isEmpty
                    ? _buildEmptyState('History')
                    : ListView.builder(
                        padding: const EdgeInsets.only(top: 10, bottom: 100),
                        itemCount: history.length,
                        itemBuilder: (_, i) => _buildBookingCard(history[i]),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

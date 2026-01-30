import 'package:flutter/material.dart';
import 'package:flutter_application_1/logout_function.dart';
import 'package:flutter_application_1/lecturer_dashboard.dart';

class LecturerHistory extends StatefulWidget {
  const LecturerHistory({super.key});

  @override
  State<LecturerHistory> createState() => _LecturerHistoryState();
}

class _LecturerHistoryState extends State<LecturerHistory>
    with SingleTickerProviderStateMixin {

  late TabController _tabController;
  final String username = 'Aj.Surapong';

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

  // ---------------------------------------------------------------------------
  // SAMPLE DATA
  // ---------------------------------------------------------------------------
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

  // ---------------------------------------------------------------------------
  // DIALOG HELPERS (Figma-style)
  // ---------------------------------------------------------------------------
  Future<void> _showApprovedDialog() async {
    await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (ctx) {
        Future.delayed(const Duration(milliseconds: 1200), () {
          if (Navigator.of(ctx, rootNavigator: true).canPop()) {
            Navigator.of(ctx, rootNavigator: true).pop();
          }
        });
        return Dialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 40),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 28, 24, 28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.check_circle, size: 120, color: Color(0xFF1FA22A)),
                SizedBox(height: 14),
                Text('Booking Approved',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _showRejectedDialog() async {
    await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (ctx) {
        Future.delayed(const Duration(milliseconds: 1200), () {
          if (Navigator.of(ctx, rootNavigator: true).canPop()) {
            Navigator.of(ctx, rootNavigator: true).pop();
          }
        });
        return Dialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 40),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 28, 24, 28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.cancel, size: 120, color: Color(0xFFDA351C)),
                SizedBox(height: 14),
                Text('Booking Rejected',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
              ],
            ),
          ),
        );
      },
    );
  }

  // ---------------------------------------------------------------------------
  // ACTIONS
  // ---------------------------------------------------------------------------
  Future<void> _approveBooking(Map<String, dynamic> booking) async {
    await _showApprovedDialog(); // stay on page
    if (!mounted) return;
    setState(() {
      final idx = _allBookings.indexOf(booking);
      if (idx != -1) {
        _allBookings[idx]['status'] = 1;
        _allBookings[idx]['approver'] = username;
      }
    });
  }

  Future<void> _rejectBooking(Map<String, dynamic> booking) async {
    final reasonController = TextEditingController();
    bool enabled = false;

    final bool? ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialog) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text('Reason for Rejection'),
          content: TextField(
            controller: reasonController,
            autofocus: true,
            maxLines: 3,
            decoration: InputDecoration(
              labelText: 'Reason',
              hintText: 'e.g., Room maintenance',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
            ),
            onChanged: (t) => setDialog(() => enabled = t.trim().isNotEmpty),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: enabled ? () => Navigator.of(ctx).pop(true) : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF003366),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );

    if (ok == true) {
      await _showRejectedDialog(); // stay on page
      if (!mounted) return;
      setState(() {
        final idx = _allBookings.indexOf(booking);
        if (idx != -1) {
          _allBookings[idx]['status'] = 0;
          _allBookings[idx]['approver'] = username;
          _allBookings[idx]['reason'] = reasonController.text.trim();
        }
      });
    }
  }

  // ---------------------------------------------------------------------------
  // CARD & EMPTY
  // ---------------------------------------------------------------------------
  Widget _buildBookingCard(Map<String, dynamic> b) {
    final int status = b['status'] as int;
    final bool isPending = status == 0 && (b['approver'] as String).isEmpty;

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
            // Title + room
            RichText(
              text: TextSpan(
                style: const TextStyle(fontSize: 16, color: Colors.black),
                children: [
                  const TextSpan(text: 'Session in '),
                  TextSpan(text: b['room'], style: const TextStyle(color: Colors.orange)),
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
                      TextSpan(text: b['booked_by'], style: const TextStyle(color: Colors.orange)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Pending actions OR status line
            if (isPending) ...[
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _approveBooking(b),
                      icon: const Icon(Icons.check, size: 18, color: Colors.white),
                      label: const Text('Approve', style: TextStyle(color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1FA22A),
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        shape: const StadiumBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _rejectBooking(b),
                      icon: const Icon(Icons.close, size: 18, color: Colors.white),
                      label: const Text('Reject', style: TextStyle(color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFDA351C),
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        shape: const StadiumBorder(),
                      ),
                    ),
                  ),
                ],
              ),
            ] else ...[
              Row(
                children: [
                  Icon(statusIcon, color: statusColor, size: 20),
                  const SizedBox(width: 6),
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(fontSize: 14, color: Colors.black),
                      children: [
                        TextSpan(text: statusText),
                        const TextSpan(text: ' by '),
                        TextSpan(text: b['approver'], style: const TextStyle(color: Colors.orange)),
                      ],
                    ),
                  ),
                ],
              ),
              if (status == 0 && (b['approver'] as String).isNotEmpty && b.containsKey('reason')) ...[
                const SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.info_outline, size: 20, color: Colors.redAccent),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        'Reason: ${b['reason']}',
                        style: const TextStyle(fontSize: 14, color: Colors.black87),
                      ),
                    ),
                  ],
                ),
              ],
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

  // ---------------------------------------------------------------------------
  // BUILD
  // ---------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    final pending = _allBookings.where((b) => (b['approver'] as String).isEmpty).toList();
    final history = _allBookings.where((b) => (b['approver'] as String).isNotEmpty).toList();
    final headerHeight = MediaQuery.of(context).size.height * 0.24;
    return Scaffold(
      backgroundColor: const Color(0xFFD9D9D9),
      extendBody: true,
  
      // ===== Bottom Nav (same format as Staff) =====
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
              IconButton(
                icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                onPressed: () => Navigator.maybePop(context),
              ),
              IconButton(
                icon: const Icon(Icons.home_filled, color: Colors.white, size: 28),
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LecturerDashboard())),
              ),
              IconButton(
                icon: const Icon(Icons.calendar_today, color: Colors.white),
                onPressed: () {
                  // already here
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

      // ===== Body =====
      body: Column(
        children: [
          // ===== Header (matched to StaffHistory) =====
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
                      // Greeting + subtitle
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                            text: TextSpan(
                              children: [
                                const TextSpan(
                                  text: 'Hi',
                                  style: TextStyle(
                                    fontSize: 28,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                TextSpan(
                                  text: ', $username',
                                  style: const TextStyle(fontSize: 28, color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                          const Text('Booking Requests', style: TextStyle(fontSize: 25, color: Colors.white)),
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

                // Tabs
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

          // ===== Tab Content =====
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

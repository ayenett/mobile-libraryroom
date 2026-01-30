import 'package:flutter/material.dart';
import 'package:flutter_application_1/logout_function.dart';
import 'staff_add_room.dart';
import 'staff_edit_room.dart';
import 'staff_dashboard.dart'; // class: StaffDashboard
import 'staff_history.dart'; // class: StaffHistory

class StaffRoomManagementPage extends StatefulWidget {
  const StaffRoomManagementPage({super.key});
  @override
  State<StaffRoomManagementPage> createState() =>
      _StaffRoomManagementPageState();
}

class _StaffRoomManagementPageState extends State<StaffRoomManagementPage> {
  static const kNavy = Color(0xFF003366);

  // Map room name -> asset
  String _imageFor(String name) {
    if (name.toLowerCase().startsWith('study room a')) {
      return 'assets/images/study room A.jpg';
    } else if (name.toLowerCase().startsWith('multimedia room a')) {
      return 'assets/images/multi room A.jpg';
    } else {
      return 'assets/images/study room B.jpg';
    }
  }

  final List<_RoomData> rooms = [
    _RoomData(
      name: 'Meeting Room A',
      capacity: 8,
      status: RoomStatus.available,
      imagePath: 'assets/images/study room B.jpg',
    ),
    _RoomData(
      name: 'Study Room A',
      capacity: 4,
      status: RoomStatus.disabled,
      imagePath: 'assets/images/study room A.jpg',
    ),
    _RoomData(
      name: 'Multimedia Room A',
      capacity: 11,
      status: RoomStatus.available,
      imagePath: 'assets/images/multi room A.jpg',
    ),
  ];

  void toggleStatus(int i) {
    setState(() {
      rooms[i] = rooms[i].copyWith(
        status: rooms[i].status == RoomStatus.available
            ? RoomStatus.disabled
            : RoomStatus.available,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final headerHeight = MediaQuery.of(context).size.height * 0.26;

    return Scaffold(
      // ===== BOTTOM NAV BAR =====
      bottomNavigationBar: SafeArea(
        top: false,
        child: Container(
          height: 56,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 1),
          decoration: BoxDecoration(
            color: Colors.black87,
            borderRadius: BorderRadius.circular(28),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 8,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                onPressed: () => Navigator.maybePop(context),
              ),
              IconButton(
                icon: const Icon(
                  Icons.home_filled,
                  color: Colors.white,
                  size: 28,
                ),
                onPressed: () {
                  // Go to StaffDashboard
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const StaffDashboard()),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.calendar_today, color: Colors.white),
                onPressed: () {
                  // Go to StaffHistory
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const StaffHistory()),
                  );
                },
              ),
            ],
          ),
        ),
      ),

      // ===== PAGE BODY =====
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ===== HEADER (modified like LecturerHistory) =====
          Container(
            decoration: const BoxDecoration(
              color: kNavy,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
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
                      // Hi, Staff / Room Management
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                            text: const TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Hi',
                                  style: TextStyle(
                                    fontSize: 28,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                TextSpan(
                                  text: ', Staff',
                                  style: TextStyle(
                                    fontSize: 28,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Text(
                            'Room Management',
                            style: TextStyle(fontSize: 25, color: Colors.white),
                          ),
                        ],
                      ),

                      // Logout button
                      IconButton(
                        onPressed: () => showLogoutDialog(context),
                        icon: const Icon(
                          Icons.logout_rounded,
                          color: Colors.white,
                          size: 40,
                        ),
                      ),
                    ],
                  ),
                ),

                // Add New Room button
                const SizedBox(height: 35),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const StaffAddRoomPage(),
                      ),
                    ),
                    child: Container(
                      height: 46,
                      decoration: BoxDecoration(
                        color: const Color(0xFFC9C0C0),
                        borderRadius: BorderRadius.circular(28),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 6,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          SizedBox(width: 14),
                          CircleAvatar(
                            radius: 14,
                            backgroundColor: Colors.grey,
                            child: Icon(
                              Icons.add,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                          SizedBox(width: 10),
                          Text(
                            'Add New Room',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(width: 16),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ===== ROOM LIST =====
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
              itemCount: rooms.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, i) => _RoomCard(
                data: rooms[i],
                onToggle: () => toggleStatus(i),
                onEdit: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => StaffEditRoomPage(
                        initialName: rooms[i].name,
                        initialCapacity: '${rooms[i].capacity} People',
                        initialDescription: _descFor(rooms[i].name),
                        imagePath:
                            rooms[i].imagePath ?? _imageFor(rooms[i].name),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _descFor(String name) {
    if (name.toLowerCase().contains('study'))
      return 'Quiet Room, Aircon, Whiteboard';
    if (name.toLowerCase().contains('multimedia'))
      return 'TV, Aircon, Projects available';
    return 'Quiet Room, Aircon, Projector';
  }
}

/* ===== MODELS / ROOM CARD ===== */

enum RoomStatus { available, disabled }

class _RoomData {
  final String name;
  final int capacity;
  final RoomStatus status;
  final String? imagePath;

  const _RoomData({
    required this.name,
    required this.capacity,
    required this.status,
    this.imagePath,
  });

  _RoomData copyWith({
    String? name,
    int? capacity,
    RoomStatus? status,
    String? imagePath,
  }) {
    return _RoomData(
      name: name ?? this.name,
      capacity: capacity ?? this.capacity,
      status: status ?? this.status,
      imagePath: imagePath ?? this.imagePath,
    );
  }
}

class _RoomCard extends StatelessWidget {
  const _RoomCard({
    required this.data,
    required this.onToggle,
    required this.onEdit,
  });
  final _RoomData data;
  final VoidCallback onToggle;
  final VoidCallback onEdit;

  static const kGreen = Color(0xFF1FA22A);
  static const kRed = Color(0xFFDA351C);

  @override
  Widget build(BuildContext context) {
    final isAvailable = data.status == RoomStatus.available;
    final img =
        data.imagePath ??
        (data.name.toLowerCase().contains('study a')
            ? 'assets/images/study room A.jpg'
            : data.name.toLowerCase().contains('multimedia')
            ? 'assets/images/multi room A.jpg'
            : 'assets/images/study room B.jpg');

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 3)),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(img, width: 92, height: 72, fit: BoxFit.cover),
            ),
            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Capacity : ${data.capacity} people',
                    style: const TextStyle(color: Colors.black87, fontSize: 15),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Text(
                        'Status : ',
                        style: TextStyle(color: Colors.black87, fontSize: 15),
                      ),
                      Text(
                        isAvailable ? 'Available' : 'Disabled',
                        style: TextStyle(
                          color: isAvailable ? kGreen : kRed,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _roundIcon(
                  icon: Icons.edit_outlined,
                  bg: const Color(0xFFF0F0F0),
                  fg: Colors.black87,
                  onTap: onEdit,
                ),
                const SizedBox(height: 10),
                _roundIcon(
                  icon: Icons.power_settings_new,
                  bg: isAvailable ? kRed : kGreen,
                  fg: Colors.white,
                  onTap: onToggle,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _roundIcon({
    required IconData icon,
    required Color bg,
    required Color fg,
    required VoidCallback onTap,
  }) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
      child: IconButton(
        padding: EdgeInsets.zero,
        icon: Icon(icon, color: fg, size: 20),
        onPressed: onTap,
      ),
    );
  }
}

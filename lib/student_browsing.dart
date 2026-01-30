import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/logout_function.dart';
import 'package:flutter_application_1/student_history.dart';

class StudentBrowsing extends StatefulWidget {
  const StudentBrowsing({super.key});

  @override
  State<StudentBrowsing> createState() => _StudentBrowsingState();
}

class _StudentBrowsingState extends State<StudentBrowsing> {
  // ────────────────────────────────────────────────────────────────────────────
  // Date formatter: FRI, OCT 24, 2025
  String _formatHeaderDate(DateTime d) {
    const w = ['MON','TUE','WED','THU','FRI','SAT','SUN'];
    const m = ['JAN','FEB','MAR','APR','MAY','JUN','JUL','AUG','SEP','OCT','NOV','DEC'];
    final weekday = w[(d.weekday + 6) % 7];
    final month = m[d.month - 1];
    return '$weekday, $month ${d.day}, ${d.year}';
  }

  // Status → color
  Color getStatusColor(String status) {
    switch (status) {
      case 'available': return Colors.teal;
      case 'pending':   return Colors.orange;
      case 'reserved':  return const Color.fromARGB(255, 12, 143, 209);
      case 'disabled':  return Colors.red;
      default:          return Colors.grey;
    }
  }

  // ────────────────────────────────────────────────────────────────────────────
  // Config
  final List<String> categories = ['Study', 'Multimedia', 'Meeting'];
  String selectedCategory = 'Multimedia';

  final List<String> timeSlots = [
    '8:00 - 10:00',
    '10:00 - 12:00',
    '13:00 - 14:00',
    '14:00 - 16:00',
  ];

  // Hard-coded rooms per category (student flavor)
  late final Map<String, List<Map<String, dynamic>>> roomsByCategory = {
    'Study': [
      {
        'name': 'Study Room A',
        'details': 'Quiet, Whiteboard, Aircon',
        'max': 4,
        'statuses': {
          '8:00 - 10:00': 'available',
          '10:00 - 12:00': 'reserved',
          '13:00 - 14:00': 'pending',
          '14:00 - 16:00': 'disabled',
        },
        'image': 'assets/images/study room A.jpg',
      },
      {
        'name': 'Study Room B',
        'details': 'Quiet, Whiteboard',
        'max': 6,
        'statuses': {
          '8:00 - 10:00': 'pending',
          '10:00 - 12:00': 'available',
          '13:00 - 14:00': 'reserved',
          '14:00 - 16:00': 'disabled',
        },
        'image': 'assets/images/study room B.jpg',
      },
    ],
    'Multimedia': [
      {
        'name': 'Multimedia Room A',
        'details': 'TV, Aircon, Netflix, Prime',
        'max': 6,
        'statuses': {
          '8:00 - 10:00': 'available',
          '10:00 - 12:00': 'pending',
          '13:00 - 14:00': 'reserved',
          '14:00 - 16:00': 'disabled',
        },
        'image': 'assets/images/multi room A.jpg',
      },
      {
        'name': 'Multimedia Room B',
        'details': 'TV, Aircon, Netflix, Prime',
        'max': 4,
        'statuses': {
          '8:00 - 10:00': 'available',
          '10:00 - 12:00': 'pending',
          '13:00 - 14:00': 'reserved',
          '14:00 - 16:00': 'disabled',
        },
        'image': 'assets/images/multi room A.jpg',
      },
      {
        'name': 'Multimedia Room C',
        'details': 'TV, Aircon, Netflix, Prime',
        'max': 8,
        'statuses': {
          '8:00 - 10:00': 'available',
          '10:00 - 12:00': 'pending',
          '13:00 - 14:00': 'reserved',
          '14:00 - 16:00': 'disabled',
        },
        'image': 'assets/images/multi room A.jpg',
      },
    ],
    'Meeting': [
      {
        'name': 'Meeting Room A',
        'details': 'TV, Aircon, Projects',
        'max': 6,
        'statuses': {
          '8:00 - 10:00': 'available',
          '10:00 - 12:00': 'pending',
          '13:00 - 14:00': 'reserved',
          '14:00 - 16:00': 'disabled',
        },
        'image': 'assets/images/study room A.jpg',
      },
      {
        'name': 'Meeting Room B',
        'details': 'Whiteboard, Aircon',
        'max': 4,
        'statuses': {
          '8:00 - 10:00': 'available',
          '10:00 - 12:00': 'pending',
          '13:00 - 14:00': 'reserved',
          '14:00 - 16:00': 'disabled',
        },
        'image': 'assets/images/study room A.jpg',
      },
    ],
  };

  // Each category keeps its own selected time per card
  late Map<String, Map<int, String>> selectedTimesByCat;

  @override
  void initState() {
    super.initState();
    selectedTimesByCat = {
      for (final cat in categories)
        cat: {for (int i = 0; i < roomsByCategory[cat]!.length; i++) i: timeSlots.first}
    };
  }

  // ────────────────────────────────────────────────────────────────────────────
  // Booking UI
  Future<void> _showConfirmDialog({
    required Map<String, dynamic> room,
    required String slot,
  }) async {
    await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (ctx) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
          child: AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: const Text('Confirm Booking',
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    style: const TextStyle(color: Colors.black87, fontSize: 16),
                    children: [
                      const TextSpan(text: 'Session in '),
                      TextSpan(text: room['name'], style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Row(children: [
                  const Icon(Icons.calendar_month, size: 18),
                  const SizedBox(width: 6),
                  Text(_formatHeaderDate(DateTime.now()).replaceAll(',', ','),
                      style: const TextStyle(fontSize: 14)),
                ]),
                const SizedBox(height: 6),
                Row(children: [
                  const Icon(Icons.access_time, size: 18),
                  const SizedBox(width: 6),
                  Text(slot, style: const TextStyle(fontSize: 14)),
                ]),
                const SizedBox(height: 6),
                Row(children: [
                  const Icon(Icons.people, size: 18),
                  const SizedBox(width: 6),
                  Text('Quiet space for up to ${room['max']} people.',
                      style: const TextStyle(fontSize: 14)),
                ]),
              ],
            ),
            actionsAlignment: MainAxisAlignment.spaceEvenly,
            actions: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: () async {
                  Navigator.of(ctx).pop();
                  await _showSuccessDialog();
                },
                child: const Text('Confirm'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: () => Navigator.of(ctx).pop(),
                child: const Text('Cancel'),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _showSuccessDialog() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(Icons.check_circle, size: 140, color: Colors.green),
              SizedBox(height: 14),
              Text('Your reservation is completed',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                  textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
    await Future.delayed(const Duration(milliseconds: 1200));
    if (mounted) Navigator.of(context, rootNavigator: true).pop();
  }

  // ────────────────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final headerHeight = MediaQuery.of(context).size.height * 0.28;
    final rooms = roomsByCategory[selectedCategory]!;
    final timesForCat = selectedTimesByCat[selectedCategory]!;

    return Scaffold(
      backgroundColor: const Color(0xFFD9D9D9),

      // Bottom nav (student: Home == this page)
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
                onPressed: () {
                  // already here
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('You are already on the Home page'),
                      duration: const Duration(milliseconds: 1200),
                      behavior: SnackBarBehavior.floating,
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.calendar_today, color: Colors.white),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const StudentHistory()),
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
          // Header (same format as Staff Browsing)
          Container(
            width: double.infinity,
            height: headerHeight,
            decoration: const BoxDecoration(
              color: Color(0xFF003366),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
              border: Border(bottom: BorderSide(color: Colors.black, width: 2)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 60),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const _HeaderText(title: 'Hi, David', subtitle: 'Reserve the room'),
                      IconButton(
                        onPressed: () => showLogoutDialog(context),
                        icon: const Icon(Icons.logout_rounded, color: Colors.white, size: 40),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 18),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(28),
                      boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 3))],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 30, height: 30,
                          decoration: const BoxDecoration(color: Colors.black87, shape: BoxShape.circle),
                          child: const Icon(Icons.calendar_month, color: Colors.white, size: 24),
                        ),
                        const SizedBox(width: 12),
                        Text(_formatHeaderDate(DateTime.now()),
                            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color: Colors.black87)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // Category chips (3 across, no checkmark)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: Row(
              children: List.generate(categories.length, (i) {
                final cat = categories[i];
                final isSelected = cat == selectedCategory;
                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: i == 0 ? 0 : 8, right: i == categories.length - 1 ? 0 : 8),
                    child: ChoiceChip(
                      showCheckmark: false,
                      label: Center(child: Text(cat.toLowerCase())),
                      selected: isSelected,
                      backgroundColor: Colors.white,
                      selectedColor: const Color(0xFF184D83),
                      shape: const StadiumBorder(side: BorderSide(color: Color(0xFFBDBDBD), width: 1)),
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : Colors.black87,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      onSelected: (_) => setState(() => selectedCategory = cat),
                    ),
                  ),
                );
              }),
            ),
          ),

          const SizedBox(height: 5),

          // Cards (horizontal list)
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              itemCount: rooms.length,
              itemBuilder: (context, index) {
                const double cardH = 420;
                const double cardW = 320;
                final double imgH = cardH * 0.70;

                final room = rooms[index];
                final currentSlot = timesForCat[index]!;
                final currentStatus = room['statuses'][currentSlot] ?? 'unknown';
                final isAvailable = currentStatus == 'available';

                return Container(
                  width: cardW,
                  height: cardH,
                  margin: EdgeInsets.only(
                    left: index == 0 ? 0 : 12,
                    right: index == rooms.length - 1 ? 0 : 12,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 2))],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Image 70%
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                        child: SizedBox(
                          height: imgH,
                          width: double.infinity,
                          child: Image.asset(room['image'], fit: BoxFit.cover),
                        ),
                      ),
                      // Info 30%
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // title + details
                              Text(room['name'],
                                  style: const TextStyle(fontSize: 16.5, fontWeight: FontWeight.w700),
                                  maxLines: 1, overflow: TextOverflow.ellipsis),
                              const SizedBox(height: 2),
                              Text("${room['details']}  •  Max : ${room['max']} people",
                                  style: const TextStyle(color: Colors.black54, fontSize: 12.5, height: 1.25),
                                  maxLines: 2, overflow: TextOverflow.ellipsis),

                              const Spacer(),

                              // controls row: people icon + dropdown + status + booking icon
                              Row(
                                children: [
                                  Container(
                                    width: 28, height: 28,
                                    decoration: BoxDecoration(color: const Color(0xFFF2F2F2), borderRadius: BorderRadius.circular(14)),
                                    child: const Icon(Icons.groups_outlined, size: 18, color: Colors.black87),
                                  ),
                                  const SizedBox(width: 8),

                                  // time dropdown
                                  Expanded(
                                    child: Container(
                                      height: 36,
                                      padding: const EdgeInsets.symmetric(horizontal: 10),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(color: const Color(0xFFBDBDBD)),
                                      ),
                                      child: DropdownButtonHideUnderline(
                                        child: DropdownButton<String>(
                                          isExpanded: true,
                                          value: currentSlot,
                                          icon: const Icon(Icons.arrow_drop_down),
                                          style: const TextStyle(fontSize: 13.5, color: Colors.black87),
                                          items: timeSlots
                                              .map((slot) => DropdownMenuItem(
                                                    value: slot,
                                                    child: Text(slot, overflow: TextOverflow.ellipsis),
                                                  ))
                                              .toList(),
                                          onChanged: (v) {
                                            if (v != null) {
                                              setState(() => selectedTimesByCat[selectedCategory]![index] = v);
                                            }
                                          },
                                        ),
                                      ),
                                    ),
                                  ),

                                  const SizedBox(width: 8),

                                  // status pill
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                    decoration: BoxDecoration(
                                      color: getStatusColor(currentStatus),
                                      borderRadius: BorderRadius.circular(18),
                                    ),
                                    child: Text(currentStatus,
                                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 12.5)),
                                  ),

                                  const SizedBox(width: 8),

                                  // booking icon (student extra)
                                  InkWell(
                                    borderRadius: BorderRadius.circular(10),
                                    onTap: isAvailable
                                        ? () => _showConfirmDialog(room: room, slot: selectedTimesByCat[selectedCategory]![index]!)
                                        : null,
                                    child: Container(
                                      width: 34,
                                      height: 34,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(color: const Color(0xFFBDBDBD)),
                                        color: Colors.white,
                                      ),
                                      child: Icon(
                                        Icons.note_alt_outlined,
                                        size: 20,
                                        color: isAvailable ? const Color(0xFF003366) : Colors.grey,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// Reusable header text
class _HeaderText extends StatelessWidget {
  const _HeaderText({required this.title, required this.subtitle});
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
        Text(subtitle,
            style: const TextStyle(color: Colors.white, fontSize: 22)),
      ],
    );
  }
}

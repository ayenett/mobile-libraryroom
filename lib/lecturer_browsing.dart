import 'package:flutter/material.dart';
import 'package:flutter_application_1/logout_function.dart';
import 'package:flutter_application_1/lecturer_dashboard.dart';
import 'package:flutter_application_1/lecturer_history.dart';

class LecturerBrowsing extends StatefulWidget {
  const LecturerBrowsing({super.key});

  @override
  State<LecturerBrowsing> createState() => _LecturerBrowsingState();
}

class _LecturerBrowsingState extends State<LecturerBrowsing> {
 
  String _formatHeaderDate(DateTime d) {
    const w = ['MON','TUE','WED','THU','FRI','SAT','SUN'];
    const m = ['JAN','FEB','MAR','APR','MAY','JUN','JUL','AUG','SEP','OCT','NOV','DEC'];
    final weekday = w[(d.weekday + 6) % 7];
    final month = m[d.month - 1];
    return '$weekday, $month ${d.day}, ${d.year}';
  }

  // Room status colors
  Color getStatusColor(String status) {
    switch (status) {
      case 'available': return Colors.teal;
      case 'pending':   return Colors.orange;
      case 'reserved':  return const Color.fromARGB(255, 12, 143, 209);
      case 'disabled':  return Colors.red;
      default:          return Colors.grey;
    }
  }

 
  final List<String> categories = ['Study', 'Multimedia', 'Meeting'];
  String selectedCategory = 'Meeting';

  final List<String> timeSlots = [
    '8:00 - 10:00',
    '10:00 - 12:00',
    '13:00 - 14:00',
    '14:00 - 16:00',
  ];

  // Hard-coded rooms per category (reuse the same assets you used for staff)
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
        'details': 'TV, Projector, Aircon',
        'max': 8,
        'statuses': {
          '8:00 - 10:00': 'reserved',
          '10:00 - 12:00': 'available',
          '13:00 - 14:00': 'pending',
          '14:00 - 16:00': 'disabled',
        },
        'image': 'assets/images/multi room A.jpg',
      },
      {
        'name': 'Multimedia Room B',
        'details': 'TV, Aircon',
        'max': 6,
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
      {
        'name': 'Meeting Room C',
        'details': 'TV, Aircon, 8 seats',
        'max': 8,
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

  // Selected time per card per category (so it remembers when switching tabs)
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
  @override
  Widget build(BuildContext context) {
    final headerHeight = MediaQuery.of(context).size.height * 0.28;

    return Scaffold(
      backgroundColor: const Color(0xFFD9D9D9),

      // ===== Bottom Navigation (standard) =====
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
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const LecturerDashboard()),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.calendar_today, color: Colors.white),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const LecturerHistory()),
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
          // ===== Header (unified look) =====
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
                    children: const [
                      _HeaderText(
                        title: 'Hi, Aj.Surapong',
                        subtitle: 'Browse Rooms',
                      ),
                      _LogoutBtn(),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                // Date pill
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
                          child: const Icon(Icons.calendar_month, color: Colors.white, size: 25),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          _formatHeaderDate(DateTime.now()),
                          style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color: Colors.black87),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // ===== ROOM TYPE SELECT (3 across, no checkmark) =====
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

          // ===== Horizontal Cards (image 70%, info 30%) =====
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              itemCount: roomsByCategory[selectedCategory]!.length,
              itemBuilder: (context, index) {
                const double cardH = 420;
                const double cardW = 320;
                final double imgH = cardH * 0.70;

                final room = roomsByCategory[selectedCategory]![index];
                final timesForCat = selectedTimesByCat[selectedCategory]!;
                final currentSlot = timesForCat[index]!;
                final currentStatus = room['statuses'][currentSlot] ?? 'unknown';

                return Container(
                  width: cardW,
                  height: cardH,
                  margin: EdgeInsets.only(
                    left: index == 0 ? 0 : 12,
                    right: index == roomsByCategory[selectedCategory]!.length - 1 ? 0 : 12,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 2))],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Image
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                        child: SizedBox(
                          height: imgH,
                          width: double.infinity,
                          child: Image.asset(room['image'], fit: BoxFit.cover),
                        ),
                      ),
                      // Info
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(7, 4, 5, 1),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                room['name'],
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 1),
                              Text(
                                "${room['details']}  •  Max : ${room['max']} people",
                                style: const TextStyle(color: Colors.black54, fontSize: 16, height: 1.25),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 18),
                              Row(
                                children: [
                                  Container(
                                    width: 28, height: 28,
                                    decoration: BoxDecoration(color: const Color(0xFFF2F2F2), borderRadius: BorderRadius.circular(14)),
                                    child: const Icon(Icons.groups_outlined, size: 18, color: Colors.black87),
                                  ),
                                  const SizedBox(width: 10),
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
                                              .map((slot) => DropdownMenuItem(value: slot, child: Text(slot, overflow: TextOverflow.ellipsis)))
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
                                  const SizedBox(width: 10),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                    decoration: BoxDecoration(
                                      color: getStatusColor(currentStatus),
                                      borderRadius: BorderRadius.circular(18),
                                    ),
                                    child: Text(
                                      currentStatus,
                                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 12.5),
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

class _HeaderText extends StatelessWidget {
  const _HeaderText({required this.title, required this.subtitle});
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
        Text(subtitle, style: const TextStyle(color: Colors.white, fontSize: 22)),
      ],
    );
  }
}

class _LogoutBtn extends StatelessWidget {
  const _LogoutBtn();

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => showLogoutDialog(context),
      icon: const Icon(Icons.logout_rounded, color: Colors.white, size: 36),
    );
  }
}

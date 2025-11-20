import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/online_class_controller.dart';
import '../../models/online_class_model.dart';

class AdminOnlineClassMonitoringView extends StatelessWidget {
  const AdminOnlineClassMonitoringView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OnlineClassController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Online Class Monitoring'),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFFF6B6B), Color(0xFFFFE66D)],
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              Get.snackbar('Refreshing', 'Updating class data...');
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Statistics Cards
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    children: [
                      Obx(
                        () => _buildStatCard(
                          'Total Classes',
                          controller.allClasses.length.toString(),
                          Icons.video_library,
                          const Color(0xFF4ECDC4),
                          const Color(0xFF44A08D),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Obx(
                        () => _buildStatCard(
                          'Live Now',
                          controller.liveClasses.length.toString(),
                          Icons.circle,
                          const Color(0xFFFF6B6B),
                          const Color(0xFFFF8E53),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Obx(
                        () => _buildStatCard(
                          'Upcoming',
                          controller.upcomingClasses.length.toString(),
                          Icons.schedule,
                          const Color(0xFF6C5CE7),
                          const Color(0xFFA29BFE),
                        ),
                      ),
                      const SizedBox(width: 12),
                      _buildStatCard(
                        'Completed',
                        '45',
                        Icons.check_circle,
                        const Color(0xFF4CAF50),
                        const Color(0xFF81C784),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Live Classes Section
            Obx(() {
              if (controller.liveClasses.isNotEmpty) {
                return _buildSection(
                  'Live Classes',
                  Icons.circle,
                  Colors.red,
                  controller.liveClasses,
                  isLive: true,
                );
              }
              return const SizedBox.shrink();
            }),

            // Upcoming Classes Section
            Obx(() {
              if (controller.upcomingClasses.isNotEmpty) {
                return _buildSection(
                  'Upcoming Classes',
                  Icons.schedule,
                  const Color(0xFF6C5CE7),
                  controller.upcomingClasses,
                );
              }
              return const SizedBox.shrink();
            }),

            // All Classes Section
            Obx(() {
              return _buildSection(
                'All Classes',
                Icons.video_library,
                const Color(0xFF4ECDC4),
                controller.allClasses,
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color1,
    Color color2,
  ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [color1, color2]),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: color1.withValues(alpha: 0.3),
              spreadRadius: 1,
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 32, color: Colors.white),
            const SizedBox(height: 12),
            Text(
              value,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                color: Colors.white.withValues(alpha: 0.9),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(
    String title,
    IconData icon,
    Color color,
    List<OnlineClass> classes, {
    bool isLive = false,
  }) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 24),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${classes.length}',
                  style: TextStyle(color: color, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: classes.length,
            itemBuilder: (context, index) {
              return _buildClassCard(classes[index], isLive: isLive);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildClassCard(OnlineClass classData, {bool isLive = false}) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: isLive ? 4 : 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: isLive
            ? const BorderSide(color: Colors.red, width: 2)
            : BorderSide.none,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (isLive)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.circle, size: 8, color: Colors.white),
                        SizedBox(width: 4),
                        Text(
                          'LIVE',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    classData.subject,
                    style: const TextStyle(
                      color: Colors.blue,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                PopupMenuButton(
                  icon: const Icon(Icons.more_vert),
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'view',
                      child: Row(
                        children: [
                          Icon(Icons.visibility, size: 20),
                          SizedBox(width: 8),
                          Text('View Details'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'monitor',
                      child: Row(
                        children: [
                          Icon(Icons.monitor, size: 20),
                          SizedBox(width: 8),
                          Text('Monitor'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'cancel',
                      child: Row(
                        children: [
                          Icon(Icons.cancel, size: 20, color: Colors.red),
                          SizedBox(width: 8),
                          Text(
                            'Cancel Class',
                            style: TextStyle(color: Colors.red),
                          ),
                        ],
                      ),
                    ),
                  ],
                  onSelected: (value) {
                    if (value == 'view') {
                      _showClassDetails(classData);
                    } else if (value == 'monitor') {
                      Get.snackbar(
                        'Monitoring',
                        'Opening monitoring dashboard...',
                      );
                    } else if (value == 'cancel') {
                      _showCancelDialog(classData);
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              classData.title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.person, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  classData.teacherName,
                  style: TextStyle(color: Colors.grey.shade700),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.access_time, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  '${classData.formattedDate} • ${classData.formattedTime}',
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.timer, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  '${classData.duration} minutes',
                  style: const TextStyle(color: Colors.grey),
                ),
                const SizedBox(width: 16),
                const Icon(Icons.people, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  '${classData.enrolledStudents.length}/${classData.maxStudents} enrolled',
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: LinearProgressIndicator(
                    value:
                        classData.enrolledStudents.length /
                        classData.maxStudents,
                    backgroundColor: Colors.grey.shade200,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      classData.enrolledStudents.length >= classData.maxStudents
                          ? Colors.red
                          : const Color(0xFF4ECDC4),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '${((classData.enrolledStudents.length / classData.maxStudents) * 100).toStringAsFixed(0)}%',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            if (isLive) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline, color: Colors.red, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Class is currently in progress',
                        style: TextStyle(
                          color: Colors.red.shade700,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Get.snackbar(
                          'Monitoring',
                          'Opening live monitoring...',
                        );
                      },
                      child: const Text('Monitor'),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _showClassDetails(OnlineClass classData) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: const EdgeInsets.all(24),
          constraints: const BoxConstraints(maxWidth: 500),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.video_library,
                      size: 32,
                      color: Color(0xFF4ECDC4),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        'Class Details',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Get.back(),
                    ),
                  ],
                ),
                const Divider(height: 32),
                _buildDetailRow('Title', classData.title),
                _buildDetailRow('Subject', classData.subject),
                _buildDetailRow('Teacher', classData.teacherName),
                _buildDetailRow('Teacher ID', classData.teacherId),
                _buildDetailRow(
                  'Scheduled',
                  '${classData.formattedDate} at ${classData.formattedTime}',
                ),
                _buildDetailRow('Duration', '${classData.duration} minutes'),
                _buildDetailRow('Status', classData.status.displayName),
                _buildDetailRow('Class Code', classData.classCode),
                _buildDetailRow(
                  'Enrollment',
                  '${classData.enrolledStudents.length}/${classData.maxStudents}',
                ),
                _buildDetailRow('Meeting Link', classData.meetingLink),
                const SizedBox(height: 16),
                const Text(
                  'Description',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(classData.description),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Get.back();
                          _showCancelDialog(classData);
                        },
                        icon: const Icon(Icons.cancel),
                        label: const Text('Cancel Class'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.red,
                          side: const BorderSide(color: Colors.red),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Get.back();
                          Get.snackbar(
                            'Monitoring',
                            'Opening monitoring dashboard...',
                          );
                        },
                        icon: const Icon(Icons.monitor),
                        label: const Text('Monitor'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4ECDC4),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  void _showCancelDialog(OnlineClass classData) {
    final reasonController = TextEditingController();

    Get.dialog(
      AlertDialog(
        title: const Text('Cancel Class'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Are you sure you want to cancel "${classData.title}"?'),
            const SizedBox(height: 16),
            TextField(
              controller: reasonController,
              decoration: const InputDecoration(
                labelText: 'Reason for cancellation',
                border: OutlineInputBorder(),
                hintText: 'Enter reason...',
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 8),
            Text(
              '${classData.enrolledStudents.length} students will be notified',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Keep Class'),
          ),
          ElevatedButton(
            onPressed: () {
              if (reasonController.text.isEmpty) {
                Get.snackbar('Error', 'Please provide a reason');
                return;
              }
              Get.back();
              Get.find<OnlineClassController>().cancelClass(
                classData.id,
                reasonController.text,
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Cancel Class'),
          ),
        ],
      ),
    );
  }
}

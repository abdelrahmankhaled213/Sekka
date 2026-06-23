import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sekka/Core/Constants/app_color.dart';

class NotificationPreferencesWidget extends StatefulWidget {
  const NotificationPreferencesWidget({super.key});

  @override
  State<NotificationPreferencesWidget> createState() =>
      _NotificationPreferencesWidgetState();
}

class _NotificationPreferencesWidgetState
    extends State<NotificationPreferencesWidget> {
  late SharedPreferences _prefs;
  late bool _notificationsEnabled;
  late bool _commentsEnabled;
  late bool _postsEnabled;
  late bool _announcementsEnabled;
  bool _isLoading = true;

  // ── SharedPreferences Keys ──────────────────────────────────────────────
  static const String _keyNotificationsEnabled = 'notificationsEnabled';
  static const String _keyCommentsEnabled = 'commentsEnabled';
  static const String _keyPostsEnabled = 'postsEnabled';
  static const String _keyAnnouncementsEnabled = 'announcementsEnabled';

  @override
  void initState() {
    super.initState();
    _initializeNotificationPreferences();
  }

  // ── Initialize من SharedPreferences ──────────────────────────────────
  Future<void> _initializeNotificationPreferences() async {
    try {
      _prefs = await SharedPreferences.getInstance();

      // ✅ جلب الإعدادات المحفوظة (قيم افتراضية: true)
      final notificationsEnabled =
          _prefs.getBool(_keyNotificationsEnabled) ?? true;
      final commentsEnabled = _prefs.getBool(_keyCommentsEnabled) ?? true;
      final postsEnabled = _prefs.getBool(_keyPostsEnabled) ?? true;
      final announcementsEnabled =
          _prefs.getBool(_keyAnnouncementsEnabled) ?? true;

      // ✅ التحقق من وضع الإخطارات الفعلي من Firebase
      final authStatus =
          await FirebaseMessaging.instance.getNotificationSettings();
      final isAuthorized = authStatus.authorizationStatus ==
          AuthorizationStatus.authorized;

      setState(() {
        _notificationsEnabled = notificationsEnabled && isAuthorized;
        _commentsEnabled = commentsEnabled;
        _postsEnabled = postsEnabled;
        _announcementsEnabled = announcementsEnabled;
        _isLoading = false;
      });

      debugPrint('✅ Notification preferences loaded from SharedPreferences');
      debugPrint('  - Notifications Enabled: $_notificationsEnabled');
      debugPrint('  - Comments: $_commentsEnabled');
      debugPrint('  - Posts: $_postsEnabled');
      debugPrint('  - Announcements: $_announcementsEnabled');
    } catch (e) {
      debugPrint('❌ Error initializing preferences: $e');
      setState(() => _isLoading = false);
    }
  }

  // ── Toggle Notifications Master Switch ─────────────────────────────────
  Future<void> _toggleNotifications(bool value) async {
    setState(() => _isLoading = true);

    try {
      if (value) {
        // ✅ تفعيل الإخطارات - طلب الإذن
        final settings = await FirebaseMessaging.instance.requestPermission(
          alert: true,
          badge: true,
          sound: true,
        );

        final isAuthorized = settings.authorizationStatus ==
            AuthorizationStatus.authorized;

        if (isAuthorized) {
          // ✅ إعادة الاشتراك في كل الـ topics
          await _resubscribeToAllTopics();

          // ✅ حفظ الإعدادات في SharedPreferences
          await _prefs.setBool(_keyNotificationsEnabled, true);

          setState(() => _notificationsEnabled = true);
          _showSnackBar('✅ Notifications enabled', Colors.green);
          debugPrint('✅ Notifications enabled & saved to SharedPreferences');
        } else {
          _showSnackBar('❌ Permission denied', Colors.red);
          setState(() => _isLoading = false);
          return;
        }
      } else {
        // ❌ تعطيل الإخطارات - إلغاء الاشتراك من كل الـ topics
        await _unsubscribeFromAllTopics();

        // ✅ حفظ الإعدادات في SharedPreferences
        await _prefs.setBool(_keyNotificationsEnabled, false);

        setState(() => _notificationsEnabled = false);
        _showSnackBar('🔕 Notifications disabled', Colors.orange);
        debugPrint('✅ Notifications disabled & saved to SharedPreferences');
      }

      setState(() => _isLoading = false);
    } catch (e) {
      debugPrint('❌ Error toggling notifications: $e');
      _showSnackBar('Error: $e', Colors.red);
      setState(() => _isLoading = false);
    }
  }

  // ── Toggle Individual Topic ────────────────────────────────────────────
  Future<void> _toggleTopic(String topicName, String topicKey, bool value) async {
    try {
      if (value) {
        // ✅ الاشتراك في الـ topic
        await FirebaseMessaging.instance.subscribeToTopic(topicName);

        // ✅ حفظ الإعداد في SharedPreferences
        await _prefs.setBool(topicKey, true);

        _showSnackBar('✅ Subscribed to $topicName', Colors.green);
        debugPrint('✅ Subscribed to $topicName & saved to SharedPreferences');
      } else {
        // ❌ إلغاء الاشتراك من الـ topic
        await FirebaseMessaging.instance.unsubscribeFromTopic(topicName);

        // ✅ حفظ الإعداد في SharedPreferences
        await _prefs.setBool(topicKey, false);

        _showSnackBar('🔕 Unsubscribed from $topicName', Colors.orange);
        debugPrint(
            '✅ Unsubscribed from $topicName & saved to SharedPreferences');
      }

      // ✅ تحديث الـ state
      setState(() {
        if (topicKey == _keyCommentsEnabled) {
          _commentsEnabled = value;
        } else if (topicKey == _keyPostsEnabled) {
          _postsEnabled = value;
        } else if (topicKey == _keyAnnouncementsEnabled) {
          _announcementsEnabled = value;
        }
      });
    } catch (e) {
      debugPrint('❌ Error toggling topic $topicName: $e');
      _showSnackBar('Error: $e', Colors.red);
    }
  }

  // ── Re-subscribe to All Topics ─────────────────────────────────────────
  Future<void> _resubscribeToAllTopics() async {
    const topics = [
      ('comments', _keyCommentsEnabled),
      ('posts', _keyPostsEnabled),
      ('announcements', _keyAnnouncementsEnabled),
    ];

    for (final (topic, key) in topics) {
      try {
        // ✅ تحقق من الإعداد المحفوظ قبل الاشتراك
        final isEnabled = _prefs.getBool(key) ?? true;

        if (isEnabled) {
          await FirebaseMessaging.instance.subscribeToTopic(topic);
          debugPrint('✅ Resubscribed to: $topic');
        }
      } catch (e) {
        debugPrint('❌ Error resubscribing to $topic: $e');
      }
    }
  }

  // ── Unsubscribe from All Topics ────────────────────────────────────────
  Future<void> _unsubscribeFromAllTopics() async {
    const topics = ['comments', 'posts', 'announcements'];

    for (final topic in topics) {
      try {
        await FirebaseMessaging.instance.unsubscribeFromTopic(topic);
        debugPrint('✅ Unsubscribed from: $topic');
      } catch (e) {
        debugPrint('❌ Error unsubscribing from $topic: $e');
      }
    }
  }

  // ── Show SnackBar ──────────────────────────────────────────────────────
  void _showSnackBar(String message, Color backgroundColor) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.withAlpha(30)),
        ),
        padding: const EdgeInsets.all(16),
        child: const Center(
          child: CircularProgressIndicator(color: AppColor.main),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withAlpha(30)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header ───────────────────────────────────────────────────
            Row(
              children: [
                 Icon(
                  Icons.notifications_rounded,
                  color: AppColor.main,
                  size: 24.sp,
                ),
                const SizedBox(width: 12),
                Text(
                  'Notifications',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        
                      ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // ── Master Toggle (Enable/Disable All) ───────────────────────
            _NotificationTile(
              title: 'Enable Notifications',
              subtitle: _notificationsEnabled
                  ? 'All notifications are on'
                  : 'All notifications are off',
              icon: Icons.notifications_active,
              value: _notificationsEnabled,
              onChanged: _toggleNotifications,
            ),
             
             SizedBox(height: 12.h),

            // ── Divider ──────────────────────────────────────────────────
            if (_notificationsEnabled)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Divider(color: Colors.grey.withAlpha(30)),
              ),

            // ── Individual Topic Toggles ─────────────────────────────────
            if (_notificationsEnabled) ...[
              Text(
                'Notification Types',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[700],
                    ),
              ),
              const SizedBox(height: 8),
              _NotificationTile(
                title: 'Comments',
                subtitle: 'Get notified about comments',
                icon: Icons.comment_rounded,
                value: _commentsEnabled,
                onChanged: (value) {
                  setState(() => _commentsEnabled = value);
                  _toggleTopic('comments', _keyCommentsEnabled, value);
                },
              ),
              const SizedBox(height: 12),
              _NotificationTile(
                title: 'Posts',
                subtitle: 'Get notified about new posts',
                icon: Icons.article_rounded,
                value: _postsEnabled,
                onChanged: (value) {
                  setState(() => _postsEnabled = value);
                  _toggleTopic('posts', _keyPostsEnabled, value);
                },
              ),
              const SizedBox(height: 12),
              _NotificationTile(
                title: 'Announcements',
                subtitle: 'Get notified about announcements',
                icon: Icons.campaign_rounded,
                value: _announcementsEnabled,
                onChanged: (value) {
                  setState(() => _announcementsEnabled = value);
                  _toggleTopic(
                      'announcements', _keyAnnouncementsEnabled, value);
                },
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ── Notification Tile Widget ──────────────────────────────────────────────
class _NotificationTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool value;
  final Function(bool) onChanged;

  const _NotificationTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: value ? AppColor.main.withAlpha(10) : Colors.grey.withAlpha(5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: value ? AppColor.main.withAlpha(30) : Colors.grey.withAlpha(20),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          children: [
            // ── Icon ────────────────────────────────────────────────────
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color:
                    value ? AppColor.main.withAlpha(30) : Colors.grey.withAlpha(20),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                size: 20.sp,
                color: value ? AppColor.main : Colors.grey,
              ),
            ),
            
             SizedBox(width: 12.w),

            // ── Text ────────────────────────────────────────────────────
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      fontFamily: 'Roboto',
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontFamily: 'Roboto',
                      
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),

            Switch.adaptive(
              value: value,
              onChanged: onChanged,
              activeColor: AppColor.main,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ],
        ),
      ),
    );
  }
}
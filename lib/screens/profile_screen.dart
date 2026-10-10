
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  static const Color primaryColor = Color(0xFF0D6EFD);
  static const Color textColor = Color(0xFF172033);
  static const Color secondaryColor = Color(0xFF687386);
  static const Color backgroundColor = Color(0xFFF5F7FB);

  Widget sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 4,
        bottom: 10,
        top: 22,
      ),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: secondaryColor,
        ),
      ),
    );
  }

  Widget settingItem({
    required IconData icon,
    required String title,
    String? subtitle,
    Widget? trailing,
    VoidCallback? onTap,
    Color iconColor = primaryColor,
  }) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 3,
      ),
      leading: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: iconColor.withValues(alpha: 0.10),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          icon,
          color: iconColor,
          size: 22,
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
      subtitle: subtitle == null
          ? null
          : Text(
        subtitle,
        style: const TextStyle(
          fontSize: 12,
          color: secondaryColor,
        ),
      ),
      trailing: trailing ??
          const Icon(
            Icons.chevron_right,
            color: secondaryColor,
          ),
    );
  }

  Widget settingCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: children,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Hồ sơ cá nhân',
          style: TextStyle(
            color: textColor,
            fontSize: 19,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: textColor,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(18, 10, 18, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // THÔNG TIN CÁ NHÂN
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Column(
                  children: [
                    const CircleAvatar(
                      radius: 42,
                      backgroundColor: Color(0xFFE4EEFF),
                      child: Icon(
                        Icons.person,
                        size: 48,
                        color: primaryColor,
                      ),
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      'Người dùng',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      'Quản lý thông tin tài khoản của bạn',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        color: secondaryColor,
                      ),
                    ),
                    const SizedBox(height: 16),
                    OutlinedButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Chức năng chỉnh sửa hồ sơ sẽ được bổ sung sau.',
                            ),
                          ),
                        );
                      },
                      icon: const Icon(Icons.edit_outlined, size: 18),
                      label: const Text('Chỉnh sửa hồ sơ'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: primaryColor,
                        side: const BorderSide(color: primaryColor),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // TÀI KHOẢN
              sectionTitle('TÀI KHOẢN'),
              settingCard([
                settingItem(
                  icon: Icons.person_outline,
                  title: 'Thông tin cá nhân',
                  subtitle: 'Tên, email và số điện thoại',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Chức năng này sẽ được bổ sung sau.',
                        ),
                      ),
                    );
                  },
                ),
                const Divider(height: 1, indent: 70),
                settingItem(
                  icon: Icons.account_balance_wallet_outlined,
                  title: 'Quản lý tài chính',
                  subtitle: 'Thiết lập quản lý thu chi',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Chức năng này sẽ được bổ sung sau.',
                        ),
                      ),
                    );
                  },
                ),
              ]),

              // TÙY CHỈNH
              sectionTitle('TÙY CHỈNH'),
              settingCard([
                settingItem(
                  icon: Icons.notifications_none,
                  title: 'Thông báo',
                  subtitle: 'Quản lý thông báo ứng dụng',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Cài đặt thông báo sẽ được bổ sung sau.',
                        ),
                      ),
                    );
                  },
                ),
                const Divider(height: 1, indent: 70),
                settingItem(
                  icon: Icons.palette_outlined,
                  title: 'Giao diện',
                  subtitle: 'Tùy chỉnh giao diện ứng dụng',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Cài đặt giao diện sẽ được bổ sung sau.',
                        ),
                      ),
                    );
                  },
                ),
                const Divider(height: 1, indent: 70),
                settingItem(
                  icon: Icons.language,
                  title: 'Ngôn ngữ',
                  subtitle: 'Tiếng Việt',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Ứng dụng hiện sử dụng tiếng Việt.',
                        ),
                      ),
                    );
                  },
                ),
              ]),

              // BẢO MẬT VÀ HỖ TRỢ
              sectionTitle('BẢO MẬT VÀ HỖ TRỢ'),
              settingCard([
                settingItem(
                  icon: Icons.lock_outline,
                  title: 'Bảo mật',
                  subtitle: 'Quản lý bảo mật tài khoản',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Chức năng bảo mật sẽ được bổ sung sau.',
                        ),
                      ),
                    );
                  },
                ),
                const Divider(height: 1, indent: 70),
                settingItem(
                  icon: Icons.help_outline,
                  title: 'Trợ giúp',
                  subtitle: 'Thông tin và hướng dẫn sử dụng',
                  onTap: () {
                    showAboutDialog(
                      context: context,
                      applicationName: 'Expense Manager',
                      applicationVersion: '1.0.0',
                      applicationLegalese:
                      'Ứng dụng quản lý thu chi cá nhân.',
                    );
                  },
                ),
                const Divider(height: 1, indent: 70),
                settingItem(
                  icon: Icons.info_outline,
                  title: 'Về ứng dụng',
                  subtitle: 'Phiên bản 1.0.0',
                  onTap: () {
                    showAboutDialog(
                      context: context,
                      applicationName: 'Expense Manager',
                      applicationVersion: '1.0.0',
                      applicationLegalese:
                      'Ứng dụng quản lý thu chi cá nhân.',
                    );
                  },
                ),
              ]),

              const SizedBox(height: 24),
              const Center(
                child: Text(
                  'EXPENSE MANAGER · VERSION 1.0.0',
                  style: TextStyle(
                    fontSize: 10,
                    letterSpacing: 1,
                    color: secondaryColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

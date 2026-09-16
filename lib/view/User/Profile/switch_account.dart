import 'package:flutter/material.dart';

import '../../../components/shared_widgets.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/responsive.dart';

// ============================================================
// SwitchAccountPage — หน้าเปลี่ยนบัญชี
// ============================================================
class SwitchAccountPage extends StatefulWidget {
  const SwitchAccountPage({
    super.key,
    this.onBack,
    this.onAddAccount,
    this.onSwitchAccount,
    this.accounts = const [
      AccountItem(
        username: 'darawadee.x_x',
        imagePath: null,
        isActive: true,
      ),
    ],
  });

  final VoidCallback? onBack;
  final VoidCallback? onAddAccount;
  final void Function(String username)? onSwitchAccount;
  final List<AccountItem> accounts;

  @override
  State<SwitchAccountPage> createState() => _SwitchAccountPageState();
}

class _SwitchAccountPageState extends State<SwitchAccountPage> {
  late List<AccountItem> _accounts;

  @override
  void initState() {
    super.initState();
    _accounts = List.from(widget.accounts);
  }

  void _switchTo(String username) {
    setState(() {
      _accounts = _accounts
          .map((a) => AccountItem(
                username: a.username,
                imagePath: a.imagePath,
                isActive: a.username == username,
              ))
          .toList();
    });
    widget.onSwitchAccount?.call(username);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              Color(0xFFFFFFFF),
              Color(0xFFC5DEE8),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // ---- AppBar ----
              AppBarBack(
                title: 'เปลี่ยนบัญชี',
                onBack: widget.onBack,
              ),

              // ---- Body ----
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(
                    context.rs(16),
                    context.rs(16),
                    context.rs(16),
                    context.rs(32),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.homeBackground,
                      borderRadius: BorderRadius.circular(context.rs(16)),
                    ),
                    child: Column(
                      children: [
                        // ---- รายการบัญชี ----
                        ..._accounts.map(
                          (acc) => _AccountRow(
                            account: acc,
                            onTap: () => _switchTo(acc.username),
                          ),
                        ),

                        // ---- divider ----
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: context.rs(16),
                          ),
                          child: const Divider(
                            color: AppColors.inputBorder,
                            height: 1,
                            thickness: 0.5,
                          ),
                        ),

                        // ---- ปุ่มเพิ่มบัญชี ----
                        _AddAccountRow(onTap: widget.onAddAccount),
                      ],
                    ),
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

// ============================================================
// AccountItem — data model บัญชี (public)
// ============================================================
class AccountItem {
  const AccountItem({
    required this.username,
    this.imagePath,
    this.isActive = false,
  });

  final String username;
  final String? imagePath;
  final bool isActive;
}

// ============================================================
// _AccountRow — แถวบัญชีผู้ใช้
// ============================================================
class _AccountRow extends StatelessWidget {
  const _AccountRow({required this.account, required this.onTap});
  final AccountItem account;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(context.rs(16)),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: context.rs(16),
          vertical: context.rs(14),
        ),
        child: Row(
          children: [
            // ---- avatar ----
            Container(
              width: context.rs(36),
              height: context.rs(36),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.purpleLight,
                border: account.isActive
                    ? Border.all(color: AppColors.purple, width: 2)
                    : null,
              ),
              child: ClipOval(
                child: account.imagePath != null
                    ? Image.asset(
                        account.imagePath!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, e, s) =>
                            _defaultIcon(context),
                      )
                    : _defaultIcon(context),
              ),
            ),

            SizedBox(width: context.rs(12)),

            // ---- username ----
            Expanded(
              child: Text(
                account.username,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: context.rs(13),
                  fontWeight: account.isActive
                      ? FontWeight.w600
                      : FontWeight.w400,
                  color: AppColors.black,
                ),
              ),
            ),

            // ---- active indicator ----
            if (account.isActive)
              Icon(
                Icons.check_circle,
                size: context.rs(18),
                color: AppColors.purple,
              ),
          ],
        ),
      ),
    );
  }

  Widget _defaultIcon(BuildContext context) {
    return Icon(
      Icons.person,
      size: context.rs(20),
      color: AppColors.purple,
    );
  }
}

// ============================================================
// _AddAccountRow — แถวเพิ่มบัญชีใหม่
// ============================================================
class _AddAccountRow extends StatelessWidget {
  const _AddAccountRow({this.onTap});
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(context.rs(16)),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: context.rs(16),
          vertical: context.rs(14),
        ),
        child: Row(
          children: [
            // ---- icon + ----
            Container(
              width: context.rs(36),
              height: context.rs(36),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.inputBorder,
                  width: 1.5,
                ),
              ),
              child: Icon(
                Icons.add,
                size: context.rs(18),
                color: AppColors.textGray,
              ),
            ),

            SizedBox(width: context.rs(12)),

            Text(
              'เพิ่มบัญชี',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: context.rs(13),
                fontWeight: FontWeight.w400,
                color: AppColors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

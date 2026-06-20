import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../components/common/AppUI.dart';
import '../../components/common/Modal.dart';
import '../../components/common/PageHeader.dart';
import '../../components/common/Toast.dart';
import '../../config/roles.dart';
import '../../config/theme.dart';
import '../../context/BootstrapContext.dart';
import '../../types/index.dart';
import '../../data/userStore.dart';
import '../../utils/responsive.dart';

class UserManagement extends StatefulWidget {
  const UserManagement({super.key});

  @override
  State<UserManagement> createState() => _UserManagementState();
}

class _UserManagementState extends State<UserManagement> {
  bool _modalOpen = false;
  User? _editUser;
  final _form = _UserForm();

  @override
  Widget build(BuildContext context) {
    context.watch<BootstrapProvider>();
    final users = [...userStore.getAllUsers()]..sort((a, b) => b.createdAt.compareTo(a.createdAt));

    return Stack(
      children: [
        AppScreen(
          children: [
            PageHeader(
              title: 'User Management',
              description: 'All registered and admin-created users appear here — synced from Prisma in real time',
              action: ElevatedButton(onPressed: _openAdd, child: const Text('Add User')),
            ),
            ...users.map((user) => AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppListItem(
                        showDivider: false,
                        title: Text(user.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text('${user.email}\nRegistered: ${user.createdAt}'),
                        trailing: Wrap(spacing: 4, children: [roleBadge(user.role), statusBadge(user.status)]),
                      ),
                      Wrap(
                        spacing: 8,
                        children: [
                          TextButton(onPressed: () => _openEdit(user), child: const Text('Edit')),
                          TextButton(
                            onPressed: () async {
                              await userStore.updateUser(user.id, {'status': user.status == 'active' ? 'inactive' : 'active'});
                              if (mounted) showToast(context, 'User status updated');
                              setState(() {});
                            },
                            child: Text(user.status == 'active' ? 'Deactivate' : 'Activate'),
                          ),
                          TextButton(
                            style: TextButton.styleFrom(foregroundColor: Colors.red),
                            onPressed: () async {
                              await userStore.deleteUser(user.id);
                              if (mounted) showToast(context, 'User deleted');
                              setState(() {});
                            },
                            child: const Text('Delete'),
                          ),
                        ],
                      ),
                    ],
                  ),
                )),
          ],
        ),
        AppModal(
          isOpen: _modalOpen,
          onClose: () => setState(() => _modalOpen = false),
          title: _editUser == null ? 'Add User' : 'Edit User',
          child: FormSection(
            children: [
              TextField(decoration: const InputDecoration(labelText: 'Name'), controller: _form.name),
              TextField(decoration: const InputDecoration(labelText: 'Email'), controller: _form.email),
              DropdownButtonFormField<String>(
                value: _form.role,
                decoration: const InputDecoration(labelText: 'Role'),
                items: roleLabels.entries.map((e) => DropdownMenuItem(value: e.key, child: Text(e.value))).toList(),
                onChanged: (v) => setState(() => _form.role = v ?? UserRoles.contentCreator),
              ),
              DropdownButtonFormField<String>(
                value: _form.status,
                decoration: const InputDecoration(labelText: 'Status'),
                items: const [
                  DropdownMenuItem(value: 'active', child: Text('Active')),
                  DropdownMenuItem(value: 'inactive', child: Text('Inactive')),
                ],
                onChanged: (v) => setState(() => _form.status = v ?? 'active'),
              ),
              if (_editUser == null)
                TextField(decoration: const InputDecoration(labelText: 'Password'), controller: _form.password, obscureText: true),
              ResponsiveButtonRow(
                alignment: WrapAlignment.end,
                children: [
                  TextButton(onPressed: () => setState(() => _modalOpen = false), child: const Text('Cancel')),
                  ElevatedButton(onPressed: _save, child: const Text('Save')),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _openAdd() {
    _editUser = null;
    _form.reset();
    setState(() => _modalOpen = true);
  }

  void _openEdit(User user) {
    _editUser = user;
    _form.name.text = user.name;
    _form.email.text = user.email;
    _form.role = user.role;
    _form.status = user.status;
    _form.password.clear();
    setState(() => _modalOpen = true);
  }

  Future<void> _save() async {
    if (_editUser != null) {
      await userStore.updateUser(_editUser!.id, {
        'name': _form.name.text,
        'email': _form.email.text,
        'role': _form.role,
        'status': _form.status,
      });
      if (mounted) showToast(context, 'User updated successfully');
    } else {
      if (_form.password.text.length < 6) {
        showToast(context, 'Password must be at least 6 characters', type: ToastType.error);
        return;
      }
      await userStore.addUser({
        'name': _form.name.text,
        'email': _form.email.text,
        'role': _form.role,
        'status': _form.status,
      }, _form.password.text);
      if (mounted) showToast(context, 'User created successfully — they can now log in');
    }
    setState(() => _modalOpen = false);
  }
}

class _UserForm {
  final name = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  String role = UserRoles.contentCreator;
  String status = 'active';

  void reset() {
    name.clear();
    email.clear();
    password.clear();
    role = UserRoles.contentCreator;
    status = 'active';
  }
}

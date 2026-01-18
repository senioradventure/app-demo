import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:senior_circle/core/local_db/app_database.dart';
import 'package:senior_circle/debug/individual_chat_backup_service.dart';

class DebugMenu extends StatefulWidget {
  const DebugMenu({super.key});

  @override
  State<DebugMenu> createState() => _DebugMenuState();
}

class _DebugMenuState extends State<DebugMenu> {
  bool _isBackingUp = false;

  Future<void> _backupIndividualChat() async {
    if (_isBackingUp) return;

    setState(() {
      _isBackingUp = true;
    });

    try {
      final database = Provider.of<AppDatabase>(context, listen: false);
      final backupService = IndividualChatBackupService(database: database);

      // Show loading snackbar
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Starting backup...'),
            duration: Duration(seconds: 1),
          ),
        );
      }

      // Perform backup
      final result = await backupService.backupAll();

      // Show result
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message'] as String),
            backgroundColor: (result['success'] as bool)
                ? Colors.green
                : Colors.red,
            duration: const Duration(seconds: 4),
          ),
        );
      }

      debugPrint('📦 Backup Result: $result');
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Backup failed: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 4),
          ),
        );
      }
      debugPrint('❌ Backup error: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isBackingUp = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Debug Menu'), centerTitle: true),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {},
              child: const Text('Backup Room Chat'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _isBackingUp ? null : _backupIndividualChat,
              child: _isBackingUp
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Backup Individual Chat'),
            ),
          ],
        ),
      ),
    );
  }
}

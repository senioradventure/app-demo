import 'dart:async';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AllUsersWithFriendStatusPage extends StatefulWidget {
  const AllUsersWithFriendStatusPage({super.key});

  @override
  State<AllUsersWithFriendStatusPage> createState() =>
      _AllUsersWithFriendStatusPageState();
}

class _AllUsersWithFriendStatusPageState
    extends State<AllUsersWithFriendStatusPage> {
  final supabase = Supabase.instance.client;

  late String myId;

  List<String> allPeople = [];                // <-- NO `users` USED
  List<Map<String, dynamic>> relations = [];  // friend rows

  @override
  void initState() {
    super.initState();
    myId = supabase.auth.currentUser!.id;
    loadData();
  }

  Future<void> loadData() async {
    try {
      // Load all friend request rows
      relations = await supabase.from("friend_requests").select();

      final ids = <String>{};

      // Add all sender + receiver ids
      for (var r in relations) {
        ids.add(r["sender_id"]);
        ids.add(r["receiver_id"]);
      }

      // Remove myself
      ids.remove(myId);

      allPeople = ids.toList();

      setState(() {});
    } catch (e) {
      debugPrint("❌ ERROR LOADING: $e");
    }
  }

  /// Get latest friend relation between me & another user
  Map<String, dynamic>? getRelation(String otherId) {
    final list = relations.where((r) =>
        (r["sender_id"] == myId && r["receiver_id"] == otherId) ||
        (r["sender_id"] == otherId && r["receiver_id"] == myId));

    if (list.isEmpty) return null;

    final sorted = list.toList()
      ..sort((a, b) =>
          DateTime.parse(b["created_at"]).compareTo(DateTime.parse(a["created_at"])));

    return sorted.first;
  }

  /// SEND REQUEST (pending → auto accept 5s → accepted)
 Future<void> sendRequest(String otherId) async {
  // Check if a relation already exists
  final existing = await supabase
      .from("friend_requests")
      .select()
      .or('and(sender_id.eq.$myId,receiver_id.eq.$otherId),and(sender_id.eq.$otherId,receiver_id.eq.$myId)')
      .maybeSingle();

  if (existing != null) {
    final id = existing["id"];

    // If relation exists → change status back to pending
    await supabase
        .from("friend_requests")
        .update({"status": "pending"})
        .eq("id", id);

    loadData();

    // Auto-accept in 5 seconds
    Timer(const Duration(seconds: 5), () async {
      await supabase
          .from("friend_requests")
          .update({"status": "accepted"})
          .eq("id", id);

      loadData();
    });

    return; // stop here
  }

  // No relation exists → new insert
  final row = await supabase.from("friend_requests").insert({
    "sender_id": myId,
    "receiver_id": otherId,
    "status": "pending",
  }).select().single();

  final reqId = row["id"];

  loadData();

  Timer(const Duration(seconds: 5), () async {
    await supabase
        .from("friend_requests")
        .update({"status": "accepted"})
        .eq("id", reqId);
    loadData();
  });
}


  /// INCOMING ACCEPT
  Future<void> acceptIncoming(String id) async {
    await supabase
        .from("friend_requests")
        .update({"status": "accepted"})
        .eq("id", id);

    loadData();
  }

  /// REJECT or UNFRIEND
  Future<void> unfriendOrReject(String id) async {
    await supabase
        .from("friend_requests")
        .update({"status": "rejected"})
        .eq("id", id);

    loadData();
  }

  /// BUTTON FOR EACH USER
  Widget actionButton(Map<String, dynamic>? rel, String otherId) {
    if (rel == null) {
      return ElevatedButton(
        onPressed: () => sendRequest(otherId),
        child: const Text("Add Friend"),
      );
    }

    final status = rel["status"];
    final isOutgoing = rel["sender_id"] == myId;
    final isIncoming = rel["receiver_id"] == myId;

    if (status == "pending" && isOutgoing) {
      return const Text("Pending");
    }

    if (status == "pending" && isIncoming) {
      return ElevatedButton(
        onPressed: () => acceptIncoming(rel["id"]),
        child: const Text("Accept"),
      );
    }

    if (status == "accepted") {
      return ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
        onPressed: () => unfriendOrReject(rel["id"]),
        child: const Text("Unfriend"),
      );
    }

    // rejected → allow add again
    return ElevatedButton(
      onPressed: () => sendRequest(otherId),
      child: const Text("Add Friend"),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Users & Friend Status")),

      body: allPeople.isEmpty
          ? const Center(child: Text("No users found"))
          : ListView.builder(
              itemCount: allPeople.length,
              itemBuilder: (_, index) {
                final otherId = allPeople[index];
                final rel = getRelation(otherId);

                return Card(
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                    leading: const CircleAvatar(child: Icon(Icons.person)),
                    title: Text("User: $otherId"),
                    subtitle: Text("Status: ${rel?["status"] ?? "none"}"),
                    trailing: actionButton(rel, otherId),
                  ),
                );
              },
            ),
    );
  }
}

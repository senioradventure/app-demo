import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:senior_circle/features/view_friends/models/friends_model.dart';
import '../../repositories/chat_details_repository.dart';
import '../../models/chat_details_models.dart';
import '../../bloc/add_friends/add_friends_bloc.dart';
import '../../bloc/add_friends/add_friends_event.dart';
import '../../bloc/add_friends/add_friends_state.dart';

class AddFriendsBottomSheet extends StatelessWidget {
  final String chatId;
  final List<ChatMember> currentMembers;
  final Function() onMembersAdded;

  const AddFriendsBottomSheet({
    super.key,
    required this.chatId,
    required this.currentMembers,
    required this.onMembersAdded,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AddFriendsBloc(
        repository: ChatDetailsRepository(Supabase.instance.client),
      )..add(LoadFriendsEvent(currentMembers: currentMembers)),
      child: _AddFriendsView(chatId: chatId, onMembersAdded: onMembersAdded),
    );
  }
}

class _AddFriendsView extends StatefulWidget {
  final String chatId;
  final Function() onMembersAdded;

  const _AddFriendsView({required this.chatId, required this.onMembersAdded});

  @override
  State<_AddFriendsView> createState() => _AddFriendsViewState();
}

class _AddFriendsViewState extends State<_AddFriendsView> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AddFriendsBloc, AddFriendsState>(
      listener: (context, state) {
        if (state.status == AddFriendsStatus.submitted) {
          Navigator.pop(context);
          widget.onMembersAdded();
        } else if (state.status == AddFriendsStatus.failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage ?? 'An error occurred')),
          );
        }
      },
      builder: (context, state) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.85,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Column(
            children: [
              const SizedBox(height: 20),

              // Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Add Friends (${state.allFriends.length})',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Search Field
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  controller: _searchController,
                  onChanged: (query) {
                    context.read<AddFriendsBloc>().add(
                      SearchFriendsEvent(query),
                    );
                  },
                  decoration: InputDecoration(
                    hintText: 'Search for friends',
                    prefixIcon: const Icon(Icons.search, color: Colors.grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 0,
                      horizontal: 16,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // List
              Expanded(
                child: state.status == AddFriendsStatus.loading
                    ? const Center(child: CircularProgressIndicator())
                    : state.filteredFriends.isEmpty
                    ? const Center(
                        child: Text(
                          'No friends found',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      )
                    : ListView.builder(
                        itemCount: state.filteredFriends.length,
                        itemBuilder: (context, index) {
                          final friend = state.filteredFriends[index];
                          final isSelected = state.selectedFriendIds.contains(
                            friend.id,
                          );

                          return InkWell(
                            onTap: () {
                              context.read<AddFriendsBloc>().add(
                                ToggleFriendSelectionEvent(friend.id),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: Colors.grey.shade100,
                                    width: 1,
                                  ),
                                ),
                              ),
                              child: Row(
                                children: [
                                  // Custom Checkbox
                                  Container(
                                    width: 24,
                                    height: 24,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: isSelected
                                          ? Colors.blue
                                          : Colors.grey.shade200,
                                      border: isSelected
                                          ? null
                                          : Border.all(
                                              color: Colors.grey.shade300,
                                            ),
                                    ),
                                    child: isSelected
                                        ? const Icon(
                                            Icons.check,
                                            size: 16,
                                            color: Colors.white,
                                          )
                                        : null,
                                  ),
                                  const SizedBox(width: 16),

                                  // Avatar
                                  CircleAvatar(
                                    radius: 20,
                                    backgroundImage:
                                        friend.profileImage != null &&
                                            friend.profileImage!.isNotEmpty
                                        ? NetworkImage(friend.profileImage!)
                                        : const AssetImage(
                                                'assets/images/avatar.png',
                                              )
                                              as ImageProvider,
                                  ),
                                  const SizedBox(width: 16),

                                  // Name
                                  Expanded(
                                    child: Text(
                                      friend.name,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),

              // Add Button
              Padding(
                padding: const EdgeInsets.all(20),
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed:
                        state.selectedFriendIds.isNotEmpty &&
                            state.status != AddFriendsStatus.submitting
                        ? () {
                            context.read<AddFriendsBloc>().add(
                              AddSelectedMembersEvent(widget.chatId),
                            );
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      elevation: 0,
                      disabledBackgroundColor: Colors.blue.withOpacity(0.5),
                    ),
                    child: state.status == AddFriendsStatus.submitting
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(Icons.add),
                              SizedBox(width: 8),
                              Text(
                                'ADD',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

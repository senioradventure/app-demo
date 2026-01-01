import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:senior_circle/core/common/widgets/image_picker_widget.dart';
import 'package:senior_circle/features/createCircle/bloc/create_circle_bloc.dart';

class CircleCreationScreen extends StatefulWidget {
  const CircleCreationScreen({super.key});

  @override
  State<CircleCreationScreen> createState() => _CircleCreationScreenState();
}

class _CircleCreationScreenState extends State<CircleCreationScreen> {
  var nameLength = 0;
  XFile? _pickedImage;
  final TextEditingController txtController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<CreateCircleBloc>().add(LoadCircleFriends());
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    try {
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          _pickedImage = image;
        });
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,

      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back, color: Colors.black),
        ),
        title: const Text(
          'Create Circle',
          style: TextStyle(
            color: Colors.black,
            fontSize: 23.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              /*More details*/
            },
            icon: Icon(Icons.more_vert, color: Colors.black),
          ),
        ],
      ),
      body: BlocConsumer<CreateCircleBloc, CreateCircleState>(
        listener: (context, state) {
          if (state.status == CreateCircleStatus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage ?? 'An error occurred'),
              ),
            );
          } else if (state.status == CreateCircleStatus.success) {
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          return Column(
            children: [
              Container(height: 1, color: Colors.grey.shade300),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      color: Colors.grey.shade200,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 20),
                            // Camera Placeholder
                            Center(
                              child: ImagePickerCircle(
                                image: _pickedImage,
                                onImagePicked: _pickImage,
                                size: 80,
                              ),
                            ),
                            const SizedBox(height: 25),
                            // Name Header
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Name",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  "$nameLength/40",
                                  style: TextStyle(color: Colors.grey.shade500),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            // Name field
                            TextField(
                              controller: txtController,
                              onChanged: (value) {
                                setState(() {
                                  nameLength = value.length;
                                });
                              },
                              maxLength: 40,
                              decoration: InputDecoration(
                                fillColor: Colors.white,
                                filled: true,
                                hintText: "Give you circle a name",
                                hintStyle: TextStyle(
                                  color: Colors.grey.shade400,
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 14,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(
                                    color: Colors.grey.shade300,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(
                                    color: Colors.blue,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 25),
                            // Add Friends Header
                            Text(
                              "Add Friends (${state.selectedFriendIds.length})",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            TextField(
                              decoration: InputDecoration(
                                fillColor: Colors.white,
                                filled: true,
                                hintText: "Search for friends",
                                prefixIcon: const Icon(
                                  Icons.search,
                                  color: Colors.grey,
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(
                                    color: Colors.grey.shade300,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(
                                    color: Colors.blue,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: state.status == CreateCircleStatus.loadingFriends
                          ? const Center(child: CircularProgressIndicator())
                          : state.friends.isEmpty
                          ? const Center(child: Text("No friends found"))
                          : ScrollConfiguration(
                              behavior: const ScrollBehavior().copyWith(
                                overscroll: false,
                              ),
                              child: Container(
                                color: Colors.white,
                                child: ListView.builder(
                                  itemCount: state.friends.length,
                                  itemBuilder: (context, index) {
                                    final friend = state.friends[index];
                                    final isSelected = state.selectedFriendIds
                                        .contains(friend.id);

                                    return Container(
                                      decoration: BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(
                                            color: Colors.grey.shade200,
                                            width: 1,
                                          ),
                                        ),
                                      ),
                                      child: ListTile(
                                        tileColor: Colors.white,
                                        leading: Checkbox(
                                          value: isSelected,
                                          onChanged: (value) {
                                            context
                                                .read<CreateCircleBloc>()
                                                .add(
                                                  ToggleFriendSelection(
                                                    friend.id,
                                                  ),
                                                );
                                          },
                                        ),
                                        title: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Container(
                                              width: 44.0,
                                              height: 44.0,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                                image: DecorationImage(
                                                  image:
                                                      friend.avatarUrl != null
                                                      ? NetworkImage(
                                                          friend.avatarUrl!,
                                                        )
                                                      : const AssetImage(
                                                              'assets/images/member_avatar.jpg',
                                                            )
                                                            as ImageProvider,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            Expanded(
                                              child: Text(
                                                friend.fullName,
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.black,
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
                            ),
                    ),
                  ],
                ),
              ),
              // Container(height: 1, color: Colors.grey.shade300),
              // InkWell(
              //   onTap: state.status == CreateCircleStatus.submitting
              //       ? null
              //       : () {
              //           if (txtController.text.trim().isEmpty) {
              //             ScaffoldMessenger.of(context).showSnackBar(
              //               const SnackBar(
              //                 content: Text('Please enter a circle name'),
              //               ),
              //             );
              //             return;
              //           }
              //           context.read<CreateCircleBloc>().add(
              //             CreateCircle(
              //               name: txtController.text.trim(),
              //               image: _pickedImage != null
              //                   ? File(_pickedImage!.path)
              //                   : null,
              //             ),
              //           );
              //         },
              //   child: Container(
              //     width: double.infinity,
              //     height: 55,
              //     color: state.status == CreateCircleStatus.submitting
              //         ? Colors.grey
              //         : const Color(0xFF4A90E2),
              //     child: Row(
              //       mainAxisAlignment: MainAxisAlignment.center,
              //       children: [
              //         if (state.status == CreateCircleStatus.submitting)
              //           const Padding(
              //             padding: EdgeInsets.only(right: 8.0),
              //             child: SizedBox(
              //               width: 20,
              //               height: 20,
              //               child: CircularProgressIndicator(
              //                 color: Colors.white,
              //                 strokeWidth: 2,
              //               ),
              //             ),
              //           )
              //         else
              //           const Icon(Icons.add, color: Colors.white),
              //         if (state.status != CreateCircleStatus.submitting)
              //           const SizedBox(width: 8),
              //         const Text(
              //           "CREATE",
              //           style: TextStyle(
              //             color: Colors.white,
              //             fontSize: 16,
              //             fontWeight: FontWeight.bold,
              //             letterSpacing: 1.0,
              //           ),
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
            ],
          );
        },
      ),
      bottomNavigationBar: BlocBuilder<CreateCircleBloc, CreateCircleState>(
  builder: (context, state) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(height: 1, color: Colors.grey.shade300),

          InkWell(
            onTap: state.status == CreateCircleStatus.submitting
                ? null
                : () {
                    if (txtController.text.trim().isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please enter a circle name'),
                        ),
                      );
                      return;
                    }

                    context.read<CreateCircleBloc>().add(
                      CreateCircle(
                        name: txtController.text.trim(),
                        image: _pickedImage != null
                            ? File(_pickedImage!.path)
                            : null,
                      ),
                    );
                  },
            child: Container(
              width: double.infinity,
              height: 55,
              color: state.status == CreateCircleStatus.submitting
                  ? Colors.grey
                  : const Color(0xFF4A90E2),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (state.status == CreateCircleStatus.submitting)
                    const Padding(
                      padding: EdgeInsets.only(right: 8.0),
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      ),
                    )
                  else
                    const Icon(Icons.add, color: Colors.white),

                  if (state.status != CreateCircleStatus.submitting)
                    const SizedBox(width: 8),

                  const Text(
                    "CREATE",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                    ),
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

    );
  }
}

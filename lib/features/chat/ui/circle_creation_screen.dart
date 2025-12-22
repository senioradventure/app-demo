import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:senior_circle/core/common/widgets/image_picker_widget.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:io';

/*Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://bnfozroolcequclltwjb.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImJuZm96cm9vbGNlcXVjbGx0d2piIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjQ1NzEzNzMsImV4cCI6MjA4MDE0NzM3M30.0MQAK_yOPZX8MxvmsmSnXkV2tcMPzKcGOOTpl2XdTlA',
  );

  runApp(
    const MaterialApp(
      home: CircleCreationScreen(),
      debugShowCheckedModeBanner: false,
    ),
  );
}*/

class CircleCreationScreen extends StatefulWidget {
  const CircleCreationScreen({super.key});

  @override
  State<CircleCreationScreen> createState() => _CircleCreationScreenState();
}

class _CircleCreationScreenState extends State<CircleCreationScreen> {
  var nameLength = 0;
  XFile? _pickedImage;
  final TextEditingController txtController = TextEditingController();

  final supabase = Supabase.instance.client;
  bool _isLoading = false;

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

  Future<String?> _uploadImage(File image) async {
    try {
      final String fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
      final String path = 'circle_images/$fileName';

      await supabase.storage
          .from('media')
          .upload(
            path,
            image,
            fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
          );
      final String imageUrl = supabase.storage.from('media').getPublicUrl(path);
      return imageUrl;
    } catch (e) {
      debugPrint('Error uploading image: $e');
      return null;
    }
  }

  Future<String?> _createCircleInDb(String name, String? imageUrl) async {
    try {
      final userId = supabase.auth.currentUser?.id;
      if (userId == null) throw Exception('User not logged in');

      final response = await supabase.from('circles').insert({
        'name': name,
        'image_url': imageUrl,
        'admin_id': userId,
      }).select();

      if (response.isNotEmpty) {
        return response.first['id'] as String;
      }
      return null;
    } catch (e) {
      debugPrint('Error creating circle in DB: $e');
      return null;
    }
  }

  Future<void> _addMembersToCircle(String circleId) async {
    try {
      final userId = supabase.auth.currentUser?.id;

      // 1. Add current user (Creator)
      final List<Map<String, dynamic>> membersToAdd = [
        {
          'circle_id': circleId,
          'user_id': userId,
          'role': 'admin',
          'joined_at': DateTime.now().toIso8601String(),
        },
      ];
      /*
      membersToAdd.addAll([
        {'circle_id': circleId, 'user_id': 'placeholder_uuid_1', 'role': 'member'},
        {'circle_id': circleId, 'user_id': 'placeholder_uuid_2', 'role': 'member'},
      ]);
      */

      await supabase.from('circle_members').insert(membersToAdd);
    } catch (e) {
      debugPrint('Error adding members: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            /*Go back to the previous screen*/
            ;
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
              ;
            },
            icon: Icon(Icons.more_vert, color: Colors.black),
          ),
        ],
      ),
      body: Column(
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
                            hintStyle: TextStyle(color: Colors.grey.shade400),
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
                              borderSide: const BorderSide(color: Colors.blue),
                            ),
                          ),
                        ),
                        const SizedBox(height: 25),
                        // Add Friends Header
                        const Text(
                          "Add Friends (1)",
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
                              borderSide: const BorderSide(color: Colors.blue),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: ScrollConfiguration(
                    behavior: const ScrollBehavior().copyWith(
                      overscroll: false,
                    ),
                    child: Container(
                      color: Colors.white,
                      child: ListView(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: Colors.grey.shade200,
                                  width: 1,
                                ),
                              ),
                            ),
                          ),
                          ...List.generate(
                            10,
                            (index) => Container(
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
                                  value: false,
                                  onChanged: (value) {},
                                ),
                                title: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      width: 44.0,
                                      height: 44.0,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                          8.0,
                                        ),
                                        image: DecorationImage(
                                          image: const AssetImage(
                                            'assets/images/member_avatar.jpg',
                                          ),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        'Chai Talks',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(height: 1, color: Colors.grey.shade300),
          InkWell(
            onTap: () async {
              if (txtController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please enter a circle name')),
                );
                return;
              }
              setState(() => _isLoading = true);
              try {
                String? imageUrl;
                if (_pickedImage != null) {
                  imageUrl = await _uploadImage(File(_pickedImage!.path));
                }
                final String? circleId = await _createCircleInDb(txtController.text, imageUrl);
                if (circleId != null) {
                  // Add Members
                  await _addMembersToCircle(circleId);

                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Circle created successfully!'),
                      ),
                    );
                    Navigator.pop(context); // Go back
                  }
                } else {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Failed to create circle. Please try again.',
                        ),
                      ),
                    );
                  }
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('An unexpected error occurred: $e')),
                  );
                }
              } finally {
                if (mounted) {
                  setState(() => _isLoading = false);
                }
              }
            },

            child: Container(
              width: double.infinity,
              height: 55,
              color: const Color(0xFF4A90E2),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (_isLoading)
                    const Padding(
                      padding: EdgeInsets.only(right: 12.0),
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

                  if (!_isLoading) const SizedBox(width: 8),

                  Text(
                    _isLoading ? "CREATING..." : "CREATE",
                    style: const TextStyle(
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
  }
}

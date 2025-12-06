import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(
    const MaterialApp(
      home: CircleCreationScreen(),
      debugShowCheckedModeBanner: false,
    ),
  );
}

class CircleCreationScreen extends StatelessWidget {
  const CircleCreationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
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
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),
                        // Camera Placeholder
                        Center(
                          child: DottedBorder(
                            borderType: BorderType.Circle,
                            dashPattern: const [6, 3],
                            color: Colors.grey,
                            strokeWidth: 2,
                            child: Container(
                              height: 80,
                              width: 80,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xFFF5F5F5),
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.camera_alt_outlined,
                                  color: Colors.grey,
                                  size: 35,
                                ),
                              ),
                            ),
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
                              "0/40",
                              style: TextStyle(color: Colors.grey.shade500),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),

                        // Name field
                        TextField(
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
                  ListView(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
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
                        5,
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
                            leading: CircleAvatar(
                              radius: 22.0,
                              backgroundImage: AssetImage(
                                'assets/images/member_avatar.jpg',
                              ),
                            ),
                            title: Text(
                              'Chai Talks',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Container(height: 1, color: Colors.grey.shade300),
          InkWell(
            onTap: () {
              // Handle Creation
            },
            child: Container(
              width: double.infinity,
              height: 55,
              color: const Color(0xFF4A90E2),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.add, color: Colors.white),
                  SizedBox(width: 8),
                  Text(
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
  }
}

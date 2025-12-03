import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(home: ChatDetailsScreen()));
}

const name = "Chai Talks";

class ChatDetailsScreen extends StatelessWidget {
  const ChatDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        /*Pink tint will appear w/o this */
        //elevation: 500,
        /*Elevation is not working. No idea why*/
        leading: IconButton(
          onPressed: () {
            /*Go back to the previous screen*/
            ;
          },
          icon: Icon(Icons.arrow_back, color: Colors.black),
        ),
        title: const Text(
          'Details',
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
      body: Container(
        child: Column(
          children: [
            Container(
              color: Colors.grey.shade100,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 20,
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(color: Colors.grey.shade300, width: 1),
                      ),
                    ),
                  ),
                  const CircleAvatar(
                    radius: 50.0,
                    backgroundImage: AssetImage('assets/images/avatar.png'),
                  ),
                  const SizedBox(height: 16),
                  // Group Name
                  const Text(
                    '$name',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.white,
                      ),
                      child: const Text(
                        'Masala chai, the spiced milk tea widely loved in India today, was actually popularized only in the 20th century — after the British encouraged tea consumption in India to boost sales for their tea companies.',
                        style: TextStyle(
                          color: Colors.black87,
                          height: 1.4,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Members',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: 9,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.grey.shade300,
                          width: 1,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            ListView(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              children: [
                ListTile(
                  leading: CircleAvatar(
                    radius: 22.0,
                    backgroundImage: AssetImage('assets/images/avatar.png'),
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
                ...List.generate(
                    5,
                    (index) => ListTile(
                      leading: CircleAvatar(
                        radius: 22.0,
                        backgroundImage: AssetImage('assets/images/avatar.png'),
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
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

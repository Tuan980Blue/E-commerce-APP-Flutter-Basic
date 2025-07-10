import 'package:flutter/material.dart';

class ContactPage extends StatelessWidget {
  const ContactPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F6FC),
        appBar: AppBar(
          backgroundColor: const Color(0xFFF8F6FC),
          elevation: 0,
          title: const Text('Liên hệ', style: TextStyle(color: Colors.black)),
          iconTheme: const IconThemeData(color: Colors.black),
          bottom: const TabBar(
            labelColor: Color(0xFF1877F3),
            unselectedLabelColor: Colors.black54,
            indicatorColor: Color(0xFF1877F3),
            tabs: [
              Tab(
                icon: Icon(Icons.facebook),
                text: 'Facebook',
              ),
              Tab(
                icon: Icon(Icons.message),
                text: 'Messenger',
              ),
              Tab(
                icon: Icon(Icons.more_horiz),
                text: 'Other',
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Facebook Tab
            Center(
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                color: const Color(0xFFF4F2F8),
                child: SizedBox(
                  width: 320,
                  height: 260,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 36,
                        backgroundColor: const Color(0xFFE3F0FB),
                        child: Icon(Icons.facebook, color: Color(0xFF1877F3), size: 48),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Facebook',
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Facebook',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1877F3),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                          child: Text('Kết nối', style: TextStyle(fontSize: 16, color: Colors.white)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Messenger Tab
            Center(
              child: Text('Messenger', style: TextStyle(fontSize: 18, color: Colors.grey)),
            ),
            // Other Tab
            Center(
              child: Text('Other', style: TextStyle(fontSize: 18, color: Colors.grey)),
            ),
          ],
        ),
      ),
    );
  }
} 
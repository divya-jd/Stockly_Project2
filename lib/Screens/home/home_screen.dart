import 'package:flutter/material.dart';
import 'package:stockly/Screens/home/settings_form.dart';
import 'package:stockly/Screens/stock%20screen/top_stocks.dart';
import 'package:stockly/Screens/stock%20screen/top_stocks_page.dart';
import 'package:stockly/services/auth.dart';
import 'package:stockly/services/database.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stockly/models/user_model.dart';
import 'package:stockly/Screens/stock%20screen/my_stocks.dart';

class Home extends StatelessWidget {
  final AuthService _auth = AuthService();

  Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<Our_User?>(context);
    var UID = user!.uid;
    final db = DatabaseService(uid: '$UID');

    // Settings Panel for Modal Bottom Sheet
    void settingsPanel() {
      showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder: (context) {
          return Container(
            padding: const EdgeInsets.all(20),
            child: const SettingsForm(),
          );
        },
      );
    }

    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFF121212)
          : const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text(
          'Dashboard',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? const Color(0xFF1E1E2C)
            : const Color(0xFF4CAF50),
        elevation: 5,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await _auth.SignOut();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Message
            StreamBuilder<DocumentSnapshot>(
              stream: db.StockCollection.doc(UID).snapshots(),
              builder: (context, snapshots) {
                if (!snapshots.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                return Text(
                  'Welcome back, ${(snapshots.data?.data() as Map<String, dynamic>?)?['NAME'] ?? 'Investor'}!',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal,
                  ),
                );
              },
            ),
            const SizedBox(height: 20),

            // Dashboard Cards
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildDashboardCard(
                  context,
                  icon: Icons.auto_graph,
                  label: 'Top Stocks',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const StockScreen()),
                  ),
                ),
                _buildDashboardCard(
                  context,
                  icon: Icons.account_balance_wallet,
                  label: 'My Stocks',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const MyStockScreen()),
                  ),
                ),
                _buildDashboardCard(
                  context,
                  icon: Icons.settings,
                  label: 'Settings',
                  onTap: settingsPanel,
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Portfolio Section
            const Text(
              'Your Portfolio',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark
                    ? const Color(0xFF1E1E2C)
                    : const Color(0xFFFFFFFF),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    blurRadius: 5,
                    spreadRadius: 2,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // News Section: Display My Stocks
            const Text(
              'My Stocks',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87),
            ),
            const SizedBox(height: 10),
            StreamBuilder<DocumentSnapshot>(
              stream: db.StockCollection.doc(UID).snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final List<String> myStocks = (snapshot.data?.data()
                            as Map<String, dynamic>?)?['MY STOCKS']
                        ?.cast<String>() ??
                    [];
                if (myStocks.isEmpty) {
                  return const Center(
                    child: Text(
                      'No stocks added yet.',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  );
                }
                return SizedBox(
                  height: 150,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: myStocks.length,
                    itemBuilder: (context, index) {
                      final symbol = myStocks[index];
                      final company = Stock.getComp(symbol);
                      return _buildStockCard(symbol, company);
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardCard(BuildContext context,
      {required IconData icon,
      required String label,
      required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark
              ? const Color(0xFF1E1E2C)
              : const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 5,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 30, color: Colors.teal),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStockCard(String symbol, String company) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        padding: const EdgeInsets.all(10),
        width: 150,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              symbol,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            Text(
              company,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

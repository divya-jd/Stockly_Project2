import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:stockly/Screens/stock%20screen/stock_price.dart';
import 'package:stockly/Screens/stock%20screen/newsfeed.dart';
import 'package:stockly/Screens/stock%20screen/top_stocks.dart';
import 'package:stockly/models/user_model.dart';
import 'package:stockly/services/database.dart';
import 'choose_stocks.dart';

class MyStockScreen extends StatefulWidget {
  const MyStockScreen({Key? key}) : super(key: key);

  @override
  _MyStockScreenState createState() => _MyStockScreenState();
}

class _MyStockScreenState extends State<MyStockScreen> {
  List<String> myStockSymbols = [];
  List<Stock> myStocks = [];
  String searchStr = '';

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    var user = Provider.of<Our_User?>(context);
    String uid = user?.uid ?? 'default_uid';
    final db = DatabaseService(uid: uid);

    return Scaffold(
      backgroundColor: isDarkTheme ? const Color(0xFF121212) : const Color(0xFFFFFFFF),
      appBar: AppBar(
        title: const Text(
          'My Stocks',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        backgroundColor: isDarkTheme ? const Color(0xFF1E1E2C) : const Color(0xFF4CAF50),
        centerTitle: true,
        elevation: 5,
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: db.StockCollection.doc(uid).snapshots(),
        builder: (context, snapshots) {
          if (!snapshots.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final stockSymbols = List<String>.from(snapshots.data!['MY STOCKS'] ?? []);
          myStockSymbols = stockSymbols;
          myStocks = myStockSymbols.map((symbol) {
            final company = Stock.getComp(symbol);
            return Stock(symbol: symbol, company: company);
          }).toList();

          return Column(
            children: <Widget>[
              // Search Bar
              Padding(
                padding: const EdgeInsets.all(10),
                child: TextField(
                  cursorColor: isDarkTheme ? Colors.tealAccent : const Color(0xFF4CAF50),
                  style: TextStyle(
                    color: isDarkTheme ? Colors.white : Colors.black87,
                  ),
                  onChanged: (value) {
                    setState(() {
                      searchStr = value.toLowerCase();
                    });
                  },
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: isDarkTheme ? const Color(0xFF1E1E1E) : const Color(0xFFF5F5F5),
                    labelText: 'Search Stocks',
                    labelStyle: TextStyle(
                      color: isDarkTheme ? Colors.grey[400] : Colors.grey[700],
                    ),
                    prefixIcon: Icon(
                      Icons.search,
                      color: isDarkTheme ? Colors.tealAccent : const Color(0xFF4CAF50),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              // Stock List
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(6),
                  itemCount: myStocks.length,
                  itemBuilder: (context, index) {
                    final stock = myStocks[index];
                    if (stock.company.toLowerCase().contains(searchStr) ||
                        stock.symbol.toLowerCase().contains(searchStr)) {
                      return buildStockTile(stock.symbol, stock.company, isDarkTheme);
                    } else {
                      return const SizedBox.shrink();
                    }
                  },
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton.extended(
            heroTag: 'addStocks',
            backgroundColor: isDarkTheme ? Colors.tealAccent : const Color(0xFF4CAF50),
            label: Text(
              'Add Stocks',
              style: TextStyle(
                color: isDarkTheme ? const Color(0xFF121212) : Colors.white,
              ),
            ),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChooseStocksPage(ss: myStockSymbols),
              ),
            ),
            icon: Icon(
              Icons.add,
              color: isDarkTheme ? const Color(0xFF121212) : Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          FloatingActionButton.extended(
            heroTag: 'viewNews',
            backgroundColor: isDarkTheme ? Colors.tealAccent : const Color(0xFF4CAF50),
            label: Text(
              'View News',
              style: TextStyle(
                color: isDarkTheme ? const Color(0xFF121212) : Colors.white,
              ),
            ),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NewsFeedScreen(myStockSymbols: myStockSymbols),
              ),
            ),
            icon: Icon(
              Icons.newspaper,
              color: isDarkTheme ? const Color(0xFF121212) : Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildStockTile(String symbol, String company, bool isDarkTheme) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: isDarkTheme ? const Color(0xFF2B2B3A) : const Color(0xFFF5F5F5),
      child: ListTile(
        contentPadding: const EdgeInsets.all(15),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => StockPrice(symb: symbol, comp: company),
          ),
        ),
        title: Text(
          symbol,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: isDarkTheme ? Colors.tealAccent : const Color(0xFF4CAF50),
          ),
        ),
        subtitle: Text(
          company,
          style: TextStyle(
            color: isDarkTheme ? Colors.grey[400] : Colors.grey[700],
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          color: isDarkTheme ? Colors.tealAccent : const Color(0xFF4CAF50),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stockly/models/user_model.dart';
import 'top_stocks.dart';
import 'package:stockly/services/database.dart';

class ChooseStocksPage extends StatefulWidget {
  final List<String> ss;
  const ChooseStocksPage({required this.ss, Key? key}) : super(key: key);

  @override
  _ChooseStocksPageState createState() => _ChooseStocksPageState();
}

class _ChooseStocksPageState extends State<ChooseStocksPage> {
  String searchStr = '';
  List<Stock> allStocks = Stock.getAll();
  List<String> selectedStocks = [];

  @override
  void initState() {
    super.initState();
    selectedStocks = List.from(widget.ss); // Clone the selected stocks
  }

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    var user = Provider.of<Our_User?>(context);
    var UID = user!.uid;
    final db = DatabaseService(uid: '${UID}');

    return Scaffold(
      backgroundColor: isDarkTheme ? const Color(0xFF121212) : const Color(0xFFFFFFFF),
      appBar: AppBar(
        title: const Text(
          'Choose Stocks',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        backgroundColor: isDarkTheme ? const Color(0xFF1E1E2C) : const Color(0xFF4CAF50),
        centerTitle: true,
        elevation: 5,
      ),
      body: Column(
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
              padding: const EdgeInsets.symmetric(vertical: 10),
              itemCount: allStocks.length,
              itemBuilder: (context, index) {
                final stock = allStocks[index];
                if (stock.company.toLowerCase().contains(searchStr) ||
                    stock.symbol.toLowerCase().contains(searchStr)) {
                  final isSelected = selectedStocks.contains(stock.symbol);
                  return buildStockTile(
                    stock.symbol,
                    stock.company,
                    isSelected,
                    isDarkTheme,
                    selectStock,
                  );
                } else {
                  return const SizedBox.shrink();
                }
              },
            ),
          ),
          // Select Stocks Button
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: const StadiumBorder(),
                minimumSize: const Size.fromHeight(50),
                backgroundColor: isDarkTheme ? Colors.tealAccent : const Color(0xFF4CAF50),
                padding: const EdgeInsets.symmetric(horizontal: 50),
              ),
              child: Text(
                'Select Stocks',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDarkTheme ? const Color(0xFF121212) : Colors.white,
                ),
              ),
              onPressed: () async {
                try {
                  await db.StockCollection.doc(UID).set({'MY STOCKS': selectedStocks});
                  Navigator.pop(context, selectedStocks);
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to save stocks. Please try again.')),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  void selectStock(String symbol) {
    final isSelected = selectedStocks.contains(symbol);
    setState(() {
      isSelected ? selectedStocks.remove(symbol) : selectedStocks.add(symbol);
    });
  }

  Widget buildStockTile(
      String symbol,
      String company,
      bool isSelected,
      bool isDarkTheme,
      ValueChanged<String> onSelectedStock,
      ) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      color: isSelected
          ? (isDarkTheme ? Colors.teal.withOpacity(0.2) : const Color(0xFF4CAF50).withOpacity(0.2))
          : (isDarkTheme ? const Color(0xFF2B2B3A) : const Color(0xFFF5F5F5)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        onTap: () => onSelectedStock(symbol),
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
        trailing: isSelected
            ? Icon(
          Icons.check_circle,
          color: isDarkTheme ? Colors.tealAccent : const Color(0xFF4CAF50),
          size: 25,
        )
            : null,
      ),
    );
  }
}

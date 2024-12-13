import 'package:flutter/material.dart';
import 'package:stockly/Screens/stock%20screen/stock_price.dart';
import 'package:stockly/Screens/stock%20screen/top_stocks.dart';
import 'package:stockly/shared/loading.dart';

class StockScreen extends StatefulWidget {
  const StockScreen({Key? key}) : super(key: key);

  @override
  State<StockScreen> createState() => _StockScreenState();
}

class _StockScreenState extends State<StockScreen> {
  bool loading = true;
  String searchStr = '';
  List<Stock> allStocks = Stock.getAll();

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;

    return loading
        ? const Loading()
        : Scaffold(
            backgroundColor:
                isDarkTheme ? const Color(0xFF121212) : const Color(0xFFFFFFFF),
            appBar: AppBar(
              title: const Text(
                'Top Stocks',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              backgroundColor: isDarkTheme
                  ? const Color(0xFF1E1E2C)
                  : const Color(0xFF4CAF50),
              elevation: 5,
            ),
            body: Column(
              children: [
                // Search Bar
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: TextField(
                    cursorColor: isDarkTheme
                        ? Colors.tealAccent
                        : const Color(0xFF4CAF50),
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
                      fillColor: isDarkTheme
                          ? const Color(0xFF1E1E1E)
                          : const Color(0xFFF5F5F5),
                      prefixIcon: Icon(
                        Icons.search,
                        color: isDarkTheme
                            ? Colors.tealAccent
                            : const Color(0xFF4CAF50),
                      ),
                      labelText: 'Search Stocks',
                      labelStyle: TextStyle(
                        color:
                            isDarkTheme ? Colors.grey[400] : Colors.grey[700],
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
                    padding: const EdgeInsets.all(10),
                    itemCount: allStocks.length,
                    itemBuilder: (context, index) {
                      final stock = allStocks[index];
                      if (stock.company.toLowerCase().contains(searchStr) ||
                          stock.symbol.toLowerCase().contains(searchStr)) {
                        return buildStockTile(
                            stock.symbol, stock.company, isDarkTheme);
                      } else {
                        return const SizedBox.shrink();
                      }
                    },
                  ),
                ),
              ],
            ),
          );
  }

  Widget buildStockTile(String symbol, String company, bool isDarkTheme) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      color: isDarkTheme ? const Color(0xFF2B2B3A) : const Color(0xFFFFFFFF),
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

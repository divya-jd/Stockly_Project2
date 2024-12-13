/// Represents a stock with its symbol and company name.
class Stock {
  /// The stock symbol (e.g., 'GOOG').
  final String symbol;

  /// The name of the company (e.g., 'Alphabet Inc.').
  final String company;

  /// Creates a Stock instance.
  const Stock({this.symbol = '', this.company = ''});

  /// Static list of predefined stocks with their symbols and company names.
  static final Map<String, String> stockList = {
    'GOOG': 'Alphabet Inc.',
    'AMZN': 'Amazon.com, Inc.',
    'AAPL': 'Apple Inc.',
    'MSFT': 'Microsoft Corporation',
    'TSLA': 'Tesla, Inc.',
    'FB': 'Meta Platforms, Inc.',
    'NVDA': 'NVIDIA Corporation',
    'JPM': 'JP Morgan Chase and Co',
    'HD': 'Home Depot, Inc.',
    'JNJ': 'Johnson and Johnson',
    'UNH': 'United Health Group Incorporated',
    'PG': 'Procter and Gamble Company',
    'BAC': 'Bank of America Corporation',
    'ADBE': 'Adobe Inc.',
    'DIS': 'The Walt Disney Company',
  };

  /// Retrieves all predefined stocks as a list of Stock objects.
  ///
  /// Returns a `List` of `Stock` objects created from `stockList`.
  static List<Stock> getAll() {
    return stockList.entries
        .map((entry) => Stock(symbol: entry.key, company: entry.value))
        .toList();
  }

  /// Retrieves the company name for a given stock symbol.
  ///
  /// Converts the symbol to uppercase to ensure case-insensitive lookups.
  /// Returns `'Not Found!'` if the symbol does not exist in the list.
  static String getComp(String symb) {
    assert(symb.isNotEmpty, 'Symbol cannot be empty');
    return stockList[symb.toUpperCase()] ?? 'Not Found!';
  }
}

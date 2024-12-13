import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'dart:convert';
import 'dart:async';
import 'package:stockly/shared/loading.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class StockPrice extends StatefulWidget {
  final symb;
  final comp;
  const StockPrice({required this.symb, required this.comp, Key? key})
      : super(key: key);

  @override
  _StockPriceState createState() => _StockPriceState();
}

class _StockPriceState extends State<StockPrice> {
  bool loading = true;
  final channel = WebSocketChannel.connect(Uri.parse(
      'wss://ws.finnhub.io?token=ct7md91r01qkgg0urj1gct7md91r01qkgg0urj20'));
  late Stream myStream;

  @override
  void initState() {
    super.initState();
    myStream = channel.stream.asBroadcastStream();
    // Subscribe to stock symbol after connection is established
    channel.sink.add(jsonEncode({'type': 'subscribe', 'symbol': widget.symb}));
    // Delay to stop loading after initial state
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? const Loading()
        : Scaffold(
            backgroundColor: const Color.fromARGB(221, 92, 206, 229),
            appBar: AppBar(
              title: const Center(child: Text('Stock Price')),
              backgroundColor: const Color.fromARGB(221, 100, 208, 237),
            ),
            body: StreamBuilder(
              stream: myStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Loading(); // Show loading spinner during the initial connection
                }

                if (snapshot.hasData) {
                  var data1 = snapshot.data!.toString();
                  Map<String, dynamic> data2 = json.decode(data1);

                  // Handle the ping response from the WebSocket server
                  if (data2['type'] == 'ping') {
                    return _buildLoadingState();
                  } else {
                    return _buildStockDataDisplay(data2);
                  }
                } else {
                  return const Loading(); // Show loading if no data is available
                }
              },
            ),
          );
  }

  Widget _buildLoadingState() {
    return Container(
      alignment: Alignment.center,
      child: Column(
        children: <Widget>[
          const SizedBox(height: 50),
          Text(widget.symb,
              style: const TextStyle(color: Colors.white, fontSize: 70)),
          const SizedBox(height: 10),
          Text(widget.comp,
              style: const TextStyle(color: Colors.white, fontSize: 36)),
          const SizedBox(height: 90),
          Container(
            color: Colors.black,
            child: const Center(
              child: SpinKitFadingCircle(
                color: Colors.white,
                size: 50,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStockDataDisplay(Map<String, dynamic> data2) {
    return Container(
      alignment: Alignment.center,
      child: Column(
        children: <Widget>[
          const SizedBox(height: 50),
          Text(widget.symb,
              style: const TextStyle(color: Colors.white, fontSize: 70)),
          const SizedBox(height: 10),
          Text(widget.comp,
              style: const TextStyle(color: Colors.white, fontSize: 36)),
          const SizedBox(height: 90),
          Text(
            (data2['data'][0]['p']).toString(),
            style: TextStyle(
                color: Colors.white,
                fontSize: 70,
                backgroundColor: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    channel.sink
        .close(); // Ensure channel is closed when the widget is disposed
    super.dispose();
  }
}

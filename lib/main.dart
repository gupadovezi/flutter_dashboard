import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

void main() {
  runApp(const DataAnalyzerApp());
}

class DataAnalyzerApp extends StatelessWidget {
  const DataAnalyzerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Data Analyzer',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const DashboardScreen(),
    );
  }
}

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  // 1. THE DATA: Mock monthly revenue data
  final List<double> monthlyRevenue =[
    1200.50, 1500.00, 1100.25, 1800.75, 
    2100.00, 1950.00, 2400.00, 2800.50, 
    2600.00, 3100.00, 2900.00, 3500.00
  ];

  final List<String> months =[
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
  ];

  // Variables to hold our analyzed data
  double totalRevenue = 0;
  double averageRevenue = 0;
  double maxRevenue = 0;

  @override
  void initState() {
    super.initState();
    _analyzeData();
  }

  // 2. THE ANALYSIS: Process the data
  void _analyzeData() {
    double sum = 0;
    double max = 0;

    for (double revenue in monthlyRevenue) {
      sum += revenue;
      if (revenue > max) max = revenue;
    }

    setState(() {
      totalRevenue = sum;
      averageRevenue = sum / monthlyRevenue.length;
      maxRevenue = max;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Data Analytics Dashboard', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.indigo,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children:[
            const Text(
              'Key Metrics',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            // 3. DISPLAY ANALYSIS: Summary Cards
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children:[
                _buildSummaryCard('Total', '\$${totalRevenue.toStringAsFixed(0)}', Colors.blue),
                _buildSummaryCard('Average', '\$${averageRevenue.toStringAsFixed(0)}', Colors.green),
                _buildSummaryCard('Maximum', '\$${maxRevenue.toStringAsFixed(0)}', Colors.orange),
              ],
            ),
            const SizedBox(height: 32),
            const Text(
              'Revenue Over Time',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            // 4. DISPLAY GRAPH: Line Chart
            Container(
              height: 350,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow:[
                  BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)
                ],
              ),
              child: LineChart(
                LineChartData(
                  gridData: const FlGridData(show: true, drawVerticalLine: false),
                  titlesData: FlTitlesData(
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        getTitlesWidget: (value, meta) {
                          if (value.toInt() >= 0 && value.toInt() < months.length) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(months[value.toInt()], style: const TextStyle(fontSize: 12)),
                            );
                          }
                          return const Text('');
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  lineBarsData:[
                    LineChartBarData(
                      spots: List.generate(
                        monthlyRevenue.length,
                        (index) => FlSpot(index.toDouble(), monthlyRevenue[index]),
                      ),
                      isCurved: true,
                      color: Colors.indigo,
                      barWidth: 4,
                      isStrokeCapRound: true,
                      dotData: const FlDotData(show: true),
                      belowBarData: BarAreaData(
                        show: true,
                        color: Colors.indigo.withOpacity(0.2),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper widget to build the metric cards
  Widget _buildSummaryCard(String title, String value, Color color) {
    return Expanded(
      child: Card(
        elevation: 2,
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 8.0),
          child: Column(
            children: [
              Text(title, style: TextStyle(color: Colors.grey[600], fontSize: 14)),
              const SizedBox(height: 8),
              Text(value, style: TextStyle(color: color, fontSize: 20, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }
}
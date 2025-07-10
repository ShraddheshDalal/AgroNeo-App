import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MarketPlacePage extends StatefulWidget {
  const MarketPlacePage({super.key});
  static String routeNameM = "/market2";

  @override
  State<MarketPlacePage> createState() => _MarketPlacePageState();
}

class _MarketPlacePageState extends State<MarketPlacePage> {
  List<CropData> cropDataList = [];
  bool isLoading = true;
  String errorMessage = '';
  String selectedLocation = 'Akola';

  @override
  void initState() {
    super.initState();
    fetchCropData();
  }

  Future<void> fetchCropData() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      final response = await http.get(
        Uri.parse('http://192.168.48.134:5000/api/crops?location=$selectedLocation'),
      ).timeout(const Duration(seconds: 10));


      if (response.statusCode == 200) {
        final Map<String, dynamic> decodedData = jsonDecode(response.body);
        if (decodedData['success'] == true) {
          final List<dynamic> cropsData = decodedData['data'];
          print("😀😀😀😀😀😀😀😀😀");
          print(cropsData);
          final today = DateTime.now();
          final filteredData = cropsData.where((item) {
            final itemDate = DateTime.tryParse(item['date'] ?? '');
            return itemDate != null &&
                itemDate.year == today.year &&
                itemDate.month == today.month &&
                itemDate.day == today.day;
          }).toList();
          print(filteredData);

          setState(() {
            cropDataList = filteredData.map((item) => CropData.fromJson(item)).toList();
            print("😀😀😀😀😀😀😀😀😀😀😀");
            print(cropDataList);
            isLoading = false;
          });
        } else {
          setState(() {
            errorMessage = 'Failed to load data: ${decodedData['message'] ?? 'Unknown error'}';
            isLoading = false;
          });
        }
      } else {
        setState(() {
          errorMessage = 'Server error: ${response.statusCode}';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Network error: ${e.toString()}';
        isLoading = false;
      });
    }
  }

  void updateLocation(String location) {
    setState(() {
      selectedLocation = location;
    });
    fetchCropData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const Center(
                  child: Text(
                    'Market Place',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF7B8CDE),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: () => _showLocationPicker(context),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFBDC4F1),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.search, color: Colors.white, size: 28),
                      const SizedBox(width: 16),
                      Text(
                        selectedLocation,
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Spacer(),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              if (errorMessage.isNotEmpty)
                Container(
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.red.shade100,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.red.shade300),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.error_outline, color: Colors.red.shade700),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          errorMessage,
                          style: TextStyle(color: Colors.red.shade700),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.refresh),
                        onPressed: fetchCropData,
                        color: Colors.red.shade700,
                      ),
                    ],
                  ),
                ),
              if (!isLoading && cropDataList.isNotEmpty && errorMessage.isEmpty)
                Container(
                  height: 200,
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(229, 217, 242, 1.0),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Price Comparison',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Expanded(child: CropBarChart(cropDataList: cropDataList)),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildLegendItem('Min', Colors.blue.shade300),
                          const SizedBox(width: 16),
                          _buildLegendItem('Max', Colors.red.shade300),
                          const SizedBox(width: 16),
                          _buildLegendItem('Avg', Colors.green.shade300),
                        ],
                      ),
                    ],
                  ),
                ),
              Expanded(
                child: isLoading
                    ? const Center(child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(height: 16),
                          Text('Fetching crop data...'),
                        ],
                      ))
                    : errorMessage.isEmpty && cropDataList.isEmpty
                        ? const Center(child: Text('No crop data available for today'))
                        : ListView.builder(
                            itemCount: cropDataList.length,
                            itemBuilder: (context, index) {
                              return CropCard(cropData: cropDataList[index]);
                            },
                          ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: fetchCropData,
        backgroundColor: const Color(0xFF7B8CDE),
        child: const Icon(Icons.refresh),
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(2)),
        ),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  void _showLocationPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Select Location', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  'Akola', 'Nagpur', 'Amravati', 'Wardha', 'Yavatmal', 'Buldhana'
                ].map((location) => _buildLocationChip(location)).toList(),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLocationChip(String location) {
    final isSelected = location == selectedLocation;
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
        if (location != selectedLocation) {
          updateLocation(location);
        }
      },
      child: Chip(
        label: Text(location),
        backgroundColor: isSelected ? const Color(0xFF7B8CDE) : Colors.grey.shade200,
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : Colors.black,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }
}

class CropCard extends StatelessWidget {
  final CropData cropData;

  const CropCard({super.key, required this.cropData});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color.fromRGBO(229, 217, 242, 1.0),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(cropData.crop, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Text(cropData.cropEng, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildPriceColumn('Max Price', cropData.max.toString()),
              _buildPriceColumn('Min Price', cropData.min.toString()),
              _buildPriceColumn('Avg Price', cropData.average.toString()),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPriceColumn(String label, String value) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 14, color: Colors.black54)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      ],
    );
  }
}

class CropBarChart extends StatelessWidget {
  final List<CropData> cropDataList;

  const CropBarChart({super.key, required this.cropDataList});

  @override
  Widget build(BuildContext context) {
    if (cropDataList.isEmpty) {
    return const Center(child: Text('No data to display'));
  }
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: _getMaxValue() * 1.2,
        barTouchData: BarTouchData(
          enabled: true,
          touchTooltipData: BarTouchTooltipData(
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              String value = rod.toY.toStringAsFixed(1);
              String cropName = cropDataList[group.x.toInt()].cropEng;
              String metric = rodIndex == 0 ? 'Min' : rodIndex == 1 ? 'Max' : 'Avg';
              return BarTooltipItem('$cropName\n$metric: $value', const TextStyle(color: Colors.white));
            },
          ),
        ),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                if (value >= 0 && value < cropDataList.length) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      cropDataList[value.toInt()].cropEng.substring(0, min(3, cropDataList[value.toInt()].cropEng.length)),
                      style: const TextStyle(color: Colors.black54, fontWeight: FontWeight.bold, fontSize: 10),
                    ),
                  );
                }
                return const Text('');
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              getTitlesWidget: (value, meta) {
                if (value % 10 == 0 && value > 0) {
                  return Text(value.toInt().toString(), style: const TextStyle(color: Colors.black54, fontWeight: FontWeight.bold, fontSize: 10));
                }
                return const Text('');
              },
            ),
          ),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        gridData: FlGridData(
          show: true,
          horizontalInterval: 10,
          getDrawingHorizontalLine: (value) => FlLine(color: Colors.grey.withOpacity(0.2), strokeWidth: 1),
        ),
        borderData: FlBorderData(show: false),
        barGroups: _getBarGroups(),
      ),
    );
  }

  double _getMaxValue() {
    double maxValue = 0;
    for (var crop in cropDataList) {
      if (crop.max > maxValue) maxValue = crop.max;
    }
    return maxValue;
  }

  List<BarChartGroupData> _getBarGroups() {
    List<BarChartGroupData> barGroups = [];
    for (int i = 0; i < cropDataList.length; i++) {
      barGroups.add(BarChartGroupData(x: i, barRods: [
        BarChartRodData(toY: cropDataList[i].min.toDouble(), color: Colors.blue.shade300, width: 8, borderRadius: const BorderRadius.only(topLeft: Radius.circular(4), topRight: Radius.circular(4))),
        BarChartRodData(toY: cropDataList[i].max.toDouble(), color: Colors.red.shade300, width: 8, borderRadius: const BorderRadius.only(topLeft: Radius.circular(4), topRight: Radius.circular(4))),
        BarChartRodData(toY: cropDataList[i].average.toDouble(), color: Colors.green.shade300, width: 8, borderRadius: const BorderRadius.only(topLeft: Radius.circular(4), topRight: Radius.circular(4))),
      ]));
    }
    return barGroups;
  }
}

class CropData {
  final String crop;
  final String cropEng;
  final double min;
  final double max;
  final double average;

  CropData({
    required this.crop,
    required this.cropEng,
    required this.min,
    required this.max,
    required this.average,
  });

  factory CropData.fromJson(Map<String, dynamic> json) {
  return CropData(
    crop: json['cropName'] ?? 'Unknown',
    cropEng: json['cropName'] ?? 'Unknown', // Or provide English name separately if available
    min: (json['Minprice'] ?? 0).toDouble(),
    max: (json['Maxprice'] ?? 0).toDouble(),
    average: (json['Avgprice'] ?? 0).toDouble(),
  );
}

}


int min(int a, int b) => a < b ? a : b;
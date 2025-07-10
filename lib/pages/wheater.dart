import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});
  final String Routerwh = '/weather';

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  bool isLoading = true;
  String errorMessage = '';
  Map<String, dynamic> weatherData = {};
  String cityName = 'New Delhi'; // Default city
  bool showCitySelector = false;
  
  // List of available cities
  final List<String> availableCities = [
    'New Delhi',
    'Mumbai',
    'Kolkata',
    'Chennai',
    'Bangalore',
    'Hyderabad',
    'Akola',
    'Nagpur',
    'Amravati',
    'Wardha',
    'Yavatmal',
    'Buldhana',
  ];
  
  // Colors from the provided color scheme
  final Color lightLavender = const Color(0xFFF3EEFF);
  final Color mediumLavender = const Color(0xFFE6E0F0);
  final Color primaryPurple = const Color(0xFFB19CD9);
  final Color deepPurple = const Color(0xFF9F90D0);
  final Color darkPurple = const Color(0xFF8878C1);

  // TODO: Replace with your actual API key
  final String apiKey = '3503ec39783d15113df1af26ca69233e';

  @override
  void initState() {
    super.initState();
    fetchWeatherData();
  }

  Future<void> fetchWeatherData() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      // Get current weather
      final currentResponse = await http.get(Uri.parse(
          'https://api.openweathermap.org/data/2.5/weather?q=$cityName&appid=$apiKey&units=metric'));
      
      // Get hourly forecast
      final forecastResponse = await http.get(Uri.parse(
          'https://api.openweathermap.org/data/2.5/forecast?q=$cityName&appid=$apiKey&units=metric'));

      if (currentResponse.statusCode == 200 && forecastResponse.statusCode == 200) {
        final currentData = json.decode(currentResponse.body);
        final forecastData = json.decode(forecastResponse.body);
        
        setState(() {
          weatherData = {
            'current': currentData,
            'forecast': forecastData,
          };
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Failed to load weather data. Please try again.';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error: ${e.toString()}';
        isLoading = false;
      });
    }
  }

  void _showCitySelector() {
    setState(() {
      showCitySelector = true;
    });
  }

  void _selectCity(String city) {
    setState(() {
      cityName = city;
      showCitySelector = false;
    });
    fetchWeatherData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightLavender,
      body: Stack(
        children: [
          isLoading 
            ? _buildLoadingView() 
            : errorMessage.isNotEmpty 
              ? _buildErrorView() 
              : _buildWeatherView(),
          
          // City selector modal
          if (showCitySelector)
            _buildCitySelectorModal(),
        ],
      ),
    );
  }

  Widget _buildLoadingView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: primaryPurple),
          const SizedBox(height: 16),
          Text(
            'Loading weather data...',
            style: TextStyle(
              color: darkPurple,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 60, color: darkPurple),
            const SizedBox(height: 16),
            Text(
              errorMessage,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: darkPurple,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: fetchWeatherData,
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryPurple,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeatherView() {
    // For demo purposes, using hardcoded data when API key is not provided
    bool isUsingMockData = apiKey == 'YOUR_OPENWEATHER_API_KEY';
    
    // Mock data for preview
    final mockCurrentTemp = 28;
    final mockCondition = 'Clear Sky';
    final mockHumidity = 65;
    final mockWindSpeed = 12;
    final mockFeelsLike = 30;
    final mockPressure = 1013;
    
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 300,
          pinned: true,
          backgroundColor: primaryPurple,
          flexibleSpace: FlexibleSpaceBar(
            background: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [primaryPurple, deepPurple],
                ),
              ),
              child: SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: _showCitySelector,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              cityName,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Icon(
                              Icons.keyboard_arrow_down,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Text(
                      DateFormat('EEEE, d MMMM').format(DateTime.now()),
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          isUsingMockData ? Icons.wb_sunny : _getWeatherIcon(),
                          color: Colors.white,
                          size: 70,
                        ),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${isUsingMockData ? mockCurrentTemp : _getCurrentTemp()}°C',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 48,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              isUsingMockData ? mockCondition : _getWeatherCondition(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Hourly Forecast',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 120,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: isUsingMockData ? 24 : _getHourlyForecastCount(),
                    itemBuilder: (context, index) {
                      return _buildHourlyForecastItem(index, isUsingMockData);
                    },
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Weather Details',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                _buildWeatherDetailsGrid(isUsingMockData, mockHumidity, mockWindSpeed, mockFeelsLike, mockPressure),
                const SizedBox(height: 24),
                _buildForecastCard(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCitySelectorModal() {
    return GestureDetector(
      onTap: () {
        setState(() {
          showCitySelector = false;
        });
      },
      child: Container(
        color: Colors.black.withOpacity(0.5),
        width: double.infinity,
        height: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            GestureDetector(
              onTap: () {}, // Prevent tap through
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Center(
                      child: Text(
                        'Select Location',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: availableCities.map((city) {
                        bool isSelected = city == cityName;
                        return GestureDetector(
                          onTap: () => _selectCity(city),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                            decoration: BoxDecoration(
                              color: isSelected ? primaryPurple : lightLavender,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              city,
                              style: TextStyle(
                                color: isSelected ? Colors.white : darkPurple,
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: Container(
                        width: 40,
                        height: 5,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(10),
                        ),
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

  Widget _buildHourlyForecastItem(int index, bool isUsingMockData) {
    // Mock data for preview
    final List<String> mockHours = [
      '6 AM', '7 AM', '8 AM', '9 AM', '10 AM', '11 AM', '12 PM', 
      '1 PM', '2 PM', '3 PM', '4 PM', '5 PM', '6 PM', '7 PM', 
      '8 PM', '9 PM', '10 PM', '11 PM', '12 AM', '1 AM', '2 AM', 
      '3 AM', '4 AM', '5 AM'
    ];
    
    final List<int> mockTemps = [
      23, 24, 25, 26, 27, 28, 29, 30, 31, 30, 29, 28, 
      27, 26, 25, 24, 23, 22, 21, 20, 19, 18, 17, 16
    ];
    
    final List<IconData> mockIcons = [
      Icons.wb_sunny, Icons.wb_sunny, Icons.wb_sunny, Icons.wb_sunny,
      Icons.wb_sunny, Icons.wb_cloudy, Icons.wb_cloudy, Icons.wb_cloudy,
      Icons.wb_cloudy, Icons.cloud, Icons.cloud, Icons.cloud,
      Icons.cloud, Icons.cloud, Icons.cloud, Icons.nightlight,
      Icons.nightlight, Icons.nightlight, Icons.nightlight,
      Icons.nightlight, Icons.nightlight, Icons.nightlight,
      Icons.nightlight, Icons.nightlight,
    ];
    
    return Container(
      margin: const EdgeInsets.only(right: 16),
      padding: const EdgeInsets.all(12),
      width: 80,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            isUsingMockData ? mockHours[index] : _getHourFromForecast(index),
            style: TextStyle(
              color: darkPurple,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Icon(
            isUsingMockData ? mockIcons[index] : _getIconForHour(index),
            color: primaryPurple,
            size: 28,
          ),
          const SizedBox(height: 8),
          Text(
            '${isUsingMockData ? mockTemps[index] : _getTempForHour(index)}°',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherDetailsGrid(bool isUsingMockData, int mockHumidity, int mockWindSpeed, int mockFeelsLike, int mockPressure) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 2.0, // Increased to fix overflow
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      children: [
        _buildDetailCard(
          'Humidity',
          '${isUsingMockData ? mockHumidity : _getHumidity()}%',
          Icons.water_drop,
          primaryPurple,
        ),
        _buildDetailCard(
          'Wind Speed',
          '${isUsingMockData ? mockWindSpeed : _getWindSpeed()} km/h',
          Icons.air,
          primaryPurple,
        ),
        _buildDetailCard(
          'Feels Like',
          '${isUsingMockData ? mockFeelsLike : _getFeelsLike()}°C',
          Icons.thermostat,
          primaryPurple,
        ),
        _buildDetailCard(
          'Pressure',
          '${isUsingMockData ? mockPressure : _getPressure()} hPa',
          Icons.speed,
          primaryPurple,
        ),
      ],
    );
  }

  Widget _buildDetailCard(String title, String value, IconData icon, Color iconColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: iconColor, size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  color: darkPurple,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildForecastCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Today\'s Forecast',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildForecastTimeColumn('Morning', Icons.wb_sunny, '25°'),
              _verticalDivider(),
              _buildForecastTimeColumn('Afternoon', Icons.wb_sunny, '30°'),
              _verticalDivider(),
              _buildForecastTimeColumn('Evening', Icons.wb_twilight, '27°'),
              _verticalDivider(),
              _buildForecastTimeColumn('Night', Icons.nightlight, '22°'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildForecastTimeColumn(String time, IconData icon, String temp) {
    return Column(
      children: [
        Text(
          time,
          style: TextStyle(
            color: darkPurple,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Icon(icon, color: primaryPurple, size: 24),
        const SizedBox(height: 8),
        Text(
          temp,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  Widget _verticalDivider() {
    return Container(
      height: 50,
      width: 1,
      color: mediumLavender,
    );
  }

  // Helper methods to extract data from the API response
  IconData _getWeatherIcon() {
    if (weatherData.isEmpty) return Icons.cloud;
    
    final condition = weatherData['current']['weather'][0]['main'].toString().toLowerCase();
    
    if (condition.contains('clear')) return Icons.wb_sunny;
    if (condition.contains('cloud')) return Icons.wb_cloudy;
    if (condition.contains('rain')) return Icons.water_drop;
    if (condition.contains('snow')) return Icons.ac_unit;
    if (condition.contains('thunder')) return Icons.flash_on;
    if (condition.contains('mist') || condition.contains('fog')) return Icons.cloud;
    
    return Icons.wb_sunny;
  }

  int _getCurrentTemp() {
    if (weatherData.isEmpty) return 0;
    return weatherData['current']['main']['temp'].round();
  }

  String _getWeatherCondition() {
    if (weatherData.isEmpty) return '';
    return weatherData['current']['weather'][0]['description'];
  }

  int _getHourlyForecastCount() {
    if (weatherData.isEmpty) return 0;
    return weatherData['forecast']['list'].length > 24 ? 24 : weatherData['forecast']['list'].length;
  }

  String _getHourFromForecast(int index) {
    if (weatherData.isEmpty) return '';
    final timestamp = weatherData['forecast']['list'][index]['dt'];
    final dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    return DateFormat('h a').format(dateTime);
  }

  IconData _getIconForHour(int index) {
    if (weatherData.isEmpty) return Icons.cloud;
    
    final condition = weatherData['forecast']['list'][index]['weather'][0]['main'].toString().toLowerCase();
    
    if (condition.contains('clear')) return Icons.wb_sunny;
    if (condition.contains('cloud')) return Icons.wb_cloudy;
    if (condition.contains('rain')) return Icons.water_drop;
    if (condition.contains('snow')) return Icons.ac_unit;
    if (condition.contains('thunder')) return Icons.flash_on;
    if (condition.contains('mist') || condition.contains('fog')) return Icons.cloud;
    
    return Icons.wb_sunny;
  }

  int _getTempForHour(int index) {
    if (weatherData.isEmpty) return 0;
    return weatherData['forecast']['list'][index]['main']['temp'].round();
  }

  int _getHumidity() {
    if (weatherData.isEmpty) return 0;
    return weatherData['current']['main']['humidity'].round();
  }

  int _getWindSpeed() {
    if (weatherData.isEmpty) return 0;
    return (weatherData['current']['wind']['speed'] * 3.6).round(); // Convert m/s to km/h
  }

  int _getFeelsLike() {
    if (weatherData.isEmpty) return 0;
    return weatherData['current']['main']['feels_like'].round();
  }

  int _getPressure() {
    if (weatherData.isEmpty) return 0;
    return weatherData['current']['main']['pressure'].round();
  }
}
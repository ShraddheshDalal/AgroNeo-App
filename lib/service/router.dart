import 'package:agri/Home.dart';
import 'package:agri/pages/Marketpalce.dart';
import 'package:agri/pages/Sign-in.dart';
import 'package:agri/pages/Sign-up.dart';
import 'package:agri/pages/chatpage.dart';
import 'package:agri/pages/market2.dart';
import 'package:agri/pages/profile.dart';
import 'package:agri/pages/profile2.dart';
import 'package:agri/pages/schemes.dart';
import 'package:agri/pages/splash.dart';
import 'package:agri/pages/wheater.dart';
import 'package:flutter/material.dart';

Route<dynamic>? onGenerateRoute(RouteSettings settings) {
  switch (settings.name) {
    case "/home":
      return MaterialPageRoute(builder: (_) => HomeScreen());
    case "/sign-in":
      return MaterialPageRoute(builder: (_) => SignInPage());
    case "/sign-up":
      return MaterialPageRoute(builder: (_) => SignUpPage());
    case "/splash":
      return MaterialPageRoute(builder: (_) => SplashScreen());
    case "/profile":
      return MaterialPageRoute(builder: (_) => ProfilePage());
    case "/profile2":
      return MaterialPageRoute(builder: (_) => ProfilePagee());
    case '/market2':
      return MaterialPageRoute(builder: (_)=> MarketPlacePagee()); 
    case '/market':
      return MaterialPageRoute(builder: (_)=> MarketPlacePage());
    case '/chat-bot':
      return MaterialPageRoute(builder: (_)=> ChatScreen());   
    case '/schemes':
      return MaterialPageRoute(builder: (_)=> SchemesPage());  
    case '/forcast':
      return MaterialPageRoute(builder: (_)=> WeatherPage());     
    default:
      return MaterialPageRoute(
        builder: (_) => const Scaffold(
          body: Center(
            child: Text('404 - Page not found'),
          ),
        ),
      );
  }
}

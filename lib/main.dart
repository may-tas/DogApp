import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tot_app/cubit/history_cubit.dart';
import 'package:tot_app/services/dog_api_service.dart';
import 'package:tot_app/views/screens/dog_detail_screen.dart';
import 'package:tot_app/views/screens/dog_list_screen.dart';
import 'package:tot_app/views/screens/history_screen.dart';
import 'package:tot_app/views/screens/home_screen.dart';
import 'package:tot_app/views/screens/tracking_screen.dart';
import 'services/database_service.dart';
import 'services/location_service.dart';
import 'cubit/dog_cubit.dart';
import 'cubit/tracking_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize services
  final apiService = ApiService();
  final databaseService = DatabaseService();
  final locationService = LocationService();

  runApp(MyApp(
    apiService: apiService,
    databaseService: databaseService,
    locationService: locationService,
  ));
}

class MyApp extends StatelessWidget {
  final ApiService apiService;
  final DatabaseService databaseService;
  final LocationService locationService;

  const MyApp({
    super.key,
    required this.apiService,
    required this.databaseService,
    required this.locationService,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<DogCubit>(
          create: (context) => DogCubit(apiService, databaseService),
        ),
        BlocProvider<TrackingCubit>(
          create: (context) => TrackingCubit(locationService, databaseService),
        ),
        BlocProvider(
          create: (context) => HistoryCubit(
            databaseService,
          ),
        ),
      ],
      child: MaterialApp(
        title: 'TOT APP',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          appBarTheme: const AppBarTheme(
            elevation: 0,
            centerTitle: true,
          ),
          cardTheme: CardTheme(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        initialRoute: '/',
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case '/':
              return MaterialPageRoute(
                builder: (_) => const HomeScreen(),
              );
            case '/dogs':
              return MaterialPageRoute(
                builder: (_) => const DogListScreen(),
              );
            case '/dog-detail':
              return MaterialPageRoute(
                builder: (_) => const DogDetailScreen(),
                settings: settings, // Pass arguments to detail screen
              );
            case '/tracking':
              return MaterialPageRoute(
                builder: (_) => const TrackingScreen(),
              );
            case '/history':
              return MaterialPageRoute(
                builder: (_) => const HistoryScreen(),
              );
            default:
              return MaterialPageRoute(
                builder: (_) => Scaffold(
                  body: Center(
                    child: Text('No route defined for ${settings.name}'),
                  ),
                ),
              );
          }
        },
      ),
    );
  }
}

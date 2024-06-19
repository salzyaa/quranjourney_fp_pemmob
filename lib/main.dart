import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quranjourney/bloc/ayat_bloc.dart';
import 'package:quranjourney/cubit/asmaulhusna_cubit.dart';
import 'package:quranjourney/cubit/doa_cubit.dart';
import 'package:quranjourney/cubit/surat_cubit.dart';
import 'package:quranjourney/data/api_services.dart';
import 'package:quranjourney/ui/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => SuratCubit(
                ApiService(
                  client: http.Client(),
                ),
              ),
            ),
            BlocProvider(
              create: (context) => AyatBloc(
                ApiService(
                  client: http.Client(),
                ),
              ),
            ),
            BlocProvider(
              create: (context) => DoaCubit(
                ApiService(
                  client: http.Client(),
                ),
              ),
            ),
            BlocProvider(
              create: (context) => AsmaulHusnaCubit(
                ApiService(
                  client: http.Client(),
                ),
              ),
            ),
          ],
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'QuranJourney',
            theme: ThemeData(
              primarySwatch: Colors.yellow,
              fontFamily: GoogleFonts.poppins().fontFamily,
            ),
            home: const SplashScreen(),
          ),
        );
      },
    );
  }
}

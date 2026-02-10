import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../routes/app_routes.dart';
import '../providers/auth_provider.dart' as app_auth;
import '../providers/user_profile_provider.dart';

class SplashScreen extends StatefulWidget {
  static const String routeName = '/splash';
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _floatController;
  late AnimationController _textController;

  late Animation<double> _logoFade;
  late Animation<double> _logoScale;
  late Animation<double> _logoFloat;
  late Animation<double> _textFade;

  @override
  void initState() {
    super.initState();

    // LOGO: FADE + SCALE
    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _logoFade = CurvedAnimation(parent: _logoController, curve: Curves.easeIn);

    _logoScale = Tween<double>(
      begin: 0.85,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _logoController, curve: Curves.easeOut));

    _logoController.forward();

    // FLOATING EFFECT (SUBTLE)
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _logoFloat = Tween<double>(begin: 0, end: 6).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
    );

    _floatController.repeat(reverse: true);

    // TEXT FADE
    _textController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _textFade = CurvedAnimation(parent: _textController, curve: Curves.easeIn);

    _logoController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _textController.forward();
      }
    });

    // NAVIGATION LOGIC (UNCHANGED)
    Timer(const Duration(seconds: 3), () async {
      final authProvider = Provider.of<app_auth.AuthProvider>(
        context,
        listen: false,
      );

      if (authProvider.user != null) {
        final userProfileProvider = Provider.of<UserProfileProvider>(
          context,
          listen: false,
        );
        await userProfileProvider.checkUserProfile();

        if (!mounted) return;

        Navigator.pushReplacementNamed(
          context,
          userProfileProvider.hasProfile
              ? AppRoutes.dashboard
              : AppRoutes.initialBalance,
        );
      } else {
        if (mounted) {
          Navigator.pushReplacementNamed(context, AppRoutes.onboarding);
        }
      }
    });
  }

  @override
  void dispose() {
    _logoController.dispose();
    _floatController.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.fromARGB(255, 18, 111, 203),
              Color.fromARGB(255, 21, 113, 205),
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // LOGO
              AnimatedBuilder(
                animation: _floatController,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(0, -_logoFloat.value),
                    child: FadeTransition(
                      opacity: _logoFade,
                      child: ScaleTransition(
                        scale: _logoScale,
                        child: SizedBox(
                          height: screenHeight * 0.21, // ✅ perfect splash size
                          child: Image.asset(
                            'assets/images/onboarding.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),

              // TEXT PULLED UP (KEY FIX)
              Transform.translate(
                offset: const Offset(0, -8), // ✅ removes PNG padding illusion
                child: FadeTransition(
                  opacity: _textFade,
                  child: Text(
                    "FineTech",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.6,
                      shadows: [
                        Shadow(
                          // ignore: deprecated_member_use
                          color: Colors.black.withOpacity(0.18),
                          offset: const Offset(1, 2),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

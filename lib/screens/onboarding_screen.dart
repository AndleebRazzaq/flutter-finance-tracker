import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../routes/app_routes.dart';

class OnboardingScreen extends StatefulWidget {
  static const String routeName = '/onboarding';

  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<_OnboardData> _pages = [
    _OnboardData(
      image: 'assets/images/onboard_1.png',
      title: 'The best app for finance tracking',
      subtitle: 'Track income, expenses and savings easily in one place.',
    ),
    _OnboardData(
      image: 'assets/images/onboard_2.png',
      title: 'Manage finances securely',
      subtitle: 'Your data is protected with secure authentication.',
    ),
    _OnboardData(
      image: 'assets/images/onboard_3.png',
      title: 'Achieve your financial goals',
      subtitle: 'Plan smarter and stay in control of your money.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 250, 247, 247),
      body: SafeArea(
        child: Column(
          children: [
            // PAGES
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _pages.length,
                onPageChanged: (index) {
                  setState(() => _currentPage = index);
                },
                itemBuilder: (context, index) {
                  return _OnboardPage(
                    data: _pages[index],
                    isActive: index == _currentPage,
                  );
                },
              ),
            ),

            // DOTS + BUTTON
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 10, 24, 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _DotsIndicator(
                    count: _pages.length,
                    currentIndex: _currentPage,
                  ),
                  const SizedBox(height: 18),

                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 4,
                      ),
                      onPressed: () {
                        if (_currentPage == _pages.length - 1) {
                          Navigator.pushReplacementNamed(
                            context,
                            AppRoutes.welcome,
                          );
                        } else {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 400),
                            curve: Curves.easeInOut,
                          );
                        }
                      },
                      child: Text(
                        _currentPage == _pages.length - 1
                            ? "Get Started"
                            : "Next",
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/* ===================== PAGE ===================== */

class _OnboardPage extends StatelessWidget {
  final _OnboardData data;
  final bool isActive;

  const _OnboardPage({required this.data, required this.isActive});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22),
      child: Column(
        children: [
          const Spacer(flex: 1),

          // BIG IMAGE (HERO)
          AnimatedSlide(
            offset: isActive ? Offset.zero : const Offset(0, 0.08),
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeOut,
            child: AnimatedOpacity(
              opacity: isActive ? 1 : 0,
              duration: const Duration(milliseconds: 500),
              child: SizedBox(
                height: screenHeight * 0.52, // 🔥 BIGGER IMAGE
                child: Image.asset(data.image, fit: BoxFit.contain),
              ),
            ),
          ),

          const SizedBox(height: 22),

          // TEXT
          AnimatedOpacity(
            opacity: isActive ? 1 : 0,
            duration: const Duration(milliseconds: 600),
            child: Column(
              children: [
                Text(
                  data.title,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.text,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  data.subtitle,
                  style: TextStyle(
                    fontSize: 14.5,
                    color: AppColors.grey,
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),

          const Spacer(flex: 2),
        ],
      ),
    );
  }
}

/* ===================== DOTS ===================== */

class _DotsIndicator extends StatelessWidget {
  final int count;
  final int currentIndex;

  const _DotsIndicator({required this.count, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (index) {
        final bool isActive = index == currentIndex;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          height: 8,
          width: isActive ? 22 : 8,
          decoration: BoxDecoration(
            color: isActive
                ? AppColors.primary
                // ignore: deprecated_member_use
                : AppColors.grey.withOpacity(0.4),
            borderRadius: BorderRadius.circular(8),
          ),
        );
      }),
    );
  }
}

/* ===================== DATA MODEL ===================== */

class _OnboardData {
  final String image;
  final String title;
  final String subtitle;

  _OnboardData({
    required this.image,
    required this.title,
    required this.subtitle,
  });
}

import 'dart:async';

import 'package:darboda/constants.dart';
import 'package:darboda/screens/auth/auth_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<StatefulWidget> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  int _currentPage = 0;
  final PageController _pageController = PageController(initialPage: 0);

  @override
  void initState() {
    super.initState();
    Timer.periodic(const Duration(seconds: 5), (Timer timer) {
      if (_currentPage < 2) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Stack(
          alignment: AlignmentDirectional.bottomCenter,
          children: <Widget>[
            PageView.builder(
              scrollDirection: Axis.horizontal,
              controller: _pageController,
              onPageChanged: _onPageChanged,
              itemCount: 3,
              itemBuilder: (ctx, i) => SlideItem(
                index: i,
              ),
            ),
            Stack(
              alignment: AlignmentDirectional.topStart,
              children: <Widget>[
                Align(
                  alignment: Alignment.bottomRight,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        if (_currentPage < 2) {
                          _currentPage++;
                          _onPageChanged(_currentPage);
                        } else {
                          Get.to(() => const AuthScreen());
                        }
                      });
                    },
                    child: const Padding(
                      padding: EdgeInsets.only(right: 25.0, bottom: 25.0),
                      child: Text(
                        'Next',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14.0,
                        ),
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: GestureDetector(
                    onTap: () {
                      Get.to(() => const AuthScreen());
                    },
                    child: const Padding(
                      padding: EdgeInsets.only(left: 25.0, bottom: 25.0),
                      child: Text(
                        'Skip',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14.0,
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  alignment: AlignmentDirectional.bottomCenter,
                  margin: const EdgeInsets.only(bottom: 25.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      for (int i = 0; i < 3; i++)
                        if (i == _currentPage)
                          const SlideDots(true)
                        else
                          const SlideDots(false)
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      );
}

class SlideItem extends StatelessWidget {
  final int index;

  const SlideItem({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Expanded(
          child: Container(
            width: double.infinity,
            color: Colors.black,
            child: Image.asset(
              onboardingTitles[index]['image'],
              fit: BoxFit.cover,
              width: double.infinity,
            ),
          ),
        ),
        const SizedBox(
          height: 20.0,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Text(
            onboardingTitles[index]['title'],
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 20,
            ),
          ),
        ),
        Center(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(25, 10, 40, 25),
            child: Text(
              onboardingTitles[index]['description'],
              style: const TextStyle(
                color: Colors.grey,
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 80.0,
        ),
      ],
    );
  }
}

class SlideDots extends StatelessWidget {
  final bool isActive;
  const SlideDots(this.isActive, {super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      margin: const EdgeInsets.symmetric(horizontal: 3.3),
      height: isActive ? 10 : 6,
      width: isActive ? 10 : 6,
      decoration: BoxDecoration(
        color: isActive ? Colors.white : Colors.grey,
        border: isActive
            ? Border.all(
                color: const Color(0xff927DFF),
                width: 2.0,
              )
            : Border.all(
                color: Colors.transparent,
                width: 1,
              ),
        borderRadius: const BorderRadius.all(Radius.circular(12)),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'dart:ui' as ui;

import 'package:lucide_icons_flutter/lucide_icons.dart';

const double appBarMaxHeight = 350;
const double appBarMinHeight = 120;
const double horizontalPadding = 20;

class ProfileScrollView extends StatefulWidget {
  const ProfileScrollView({super.key});

  @override
  State<ProfileScrollView> createState() => _ProfileScrollViewState();
}

class _ProfileScrollViewState extends State<ProfileScrollView> {
  double dynamicAppBarHeight = 250;
  double maxBlurScrollExtent = 200;
  final ScrollController _scrollController = ScrollController();
  final double _avatarFadeOutThreshold = 100;

  double currentScrollOffset = 0;
  double avatarOpacity = 1;
  double backgroundBlur = 0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final position = _scrollController.position;

    setState(() {
      currentScrollOffset = position.pixels;
    });

    _updateAvatarOpacity(position.pixels);
    _updateBackgroundBlur(position.pixels);
  }

  void _updateAvatarOpacity(double scrollOffset) {
    double opacity =
        1 - (scrollOffset / 4 * 100 / _avatarFadeOutThreshold) / 100;

    if (opacity <= 0) {
      avatarOpacity = 0;
    } else if (opacity >= 1) {
      avatarOpacity = 1;
    } else {
      avatarOpacity = opacity;
    }

    setState(() {});
  }

  void _updateBackgroundBlur(double scrollOffset) {
    double scrollProgress = (scrollOffset * 100 / maxBlurScrollExtent) / 100;
    backgroundBlur = (scrollProgress * 10).clamp(0.0, 10.0).abs();

    setState(() {});
  }

  void snapScroll() {
    Future.delayed(const Duration(milliseconds: 10), () {
      if (!_scrollController.hasClients) return;

      final double threshold = 100;
      final double targetOffset =
          currentScrollOffset > threshold ? appBarMaxHeight : 0.0;

      _scrollController.animateTo(
        targetOffset,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned(
          child: NotificationListener<ScrollNotification>(
            onNotification: (notification) {
              if (notification is ScrollEndNotification) {
                snapScroll();
              }
              return true;
            },
            child: SingleChildScrollView(
              controller: _scrollController,
              padding:
                  const EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: GestureDetector(
                onVerticalDragEnd: (_) => print("interacted"),
                onHorizontalDragEnd: (_) => print("interacted"),
                onVerticalDragUpdate: (_) => print("interacted"),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: appBarMaxHeight / 1.5),
                    Row(
                      children: [
                        AnimatedOpacity(
                          duration: const Duration(milliseconds: 300),
                          opacity:
                              currentScrollOffset <= _avatarFadeOutThreshold
                                  ? 0
                                  : 1,
                          child: Container(
                            clipBehavior: Clip.antiAlias,
                            margin: const EdgeInsets.only(left: 8),
                            height: 85,
                            width: 85,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(1000),
                              border: Border.all(color: Colors.black, width: 4),
                              color: Colors.black,
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(1000),
                              child: Image.network(
                                "https://static.wikia.nocookie.net/studio-ghibli/images/8/8e/Chihiro_Ogino.jpg/revision/latest/smart/width/250/height/250?cb=20210214130251",
                                width: double.infinity,
                                height: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: () => snapScroll(),
                      child: const Text("Scroll up/down"),
                    ),
                    const SizedBox(height: 1000),
                  ],
                ),
              ),
            ),
          ),
        ),
        Positioned(
          child: AnimatedContainer(
            height: dynamicAppBarHeight - currentScrollOffset,
            duration: const Duration(milliseconds: 0),
            constraints: const BoxConstraints(
              maxHeight: appBarMaxHeight,
              minHeight: appBarMinHeight,
            ),
            child: Stack(
              clipBehavior: Clip.antiAlias,
              children: [
                Positioned.fill(
                  child: Image.network(
                    "https://creator.nightcafe.studio/jobs/kI4ftYiSO2wz0vT2G994/kI4ftYiSO2wz0vT2G994--1--jemyn.jpg",
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: appBarMaxHeight,
                  ),
                ),
                Positioned.fill(
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 500),
                    opacity: 1,
                    child: ClipRRect(
                      child: BackdropFilter(
                        enabled: true,
                        filter: ui.ImageFilter.blur(
                          sigmaX: backgroundBlur,
                          sigmaY: backgroundBlur,
                        ),
                        child: Container(
                          color: Colors.black12,
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 60,
                      left: horizontalPadding,
                      right: horizontalPadding,
                    ),
                    child: Row(
                      children: [
                        Container(
                          height: 35,
                          width: 35,
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(157, 0, 0, 0),
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                            size: 19,
                          ),
                        ),
                        const Spacer(),
                        Row(
                          children: [
                            _iconButton(LucideIcons.bell),
                            const SizedBox(width: 14),
                            _iconButton(LucideIcons.search),
                            const SizedBox(width: 14),
                            _iconButton(LucideIcons.upload),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          top: (dynamicAppBarHeight - 50) - currentScrollOffset,
          child: AnimatedScale(
            duration: const Duration(milliseconds: 0),
            scale: avatarOpacity,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 50),
              opacity: currentScrollOffset > _avatarFadeOutThreshold
                  ? 0
                  : avatarOpacity,
              child: Container(
                clipBehavior: Clip.antiAlias,
                margin:
                    const EdgeInsets.symmetric(horizontal: horizontalPadding),
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(1000),
                  border: Border.all(color: Colors.black, width: 4),
                  color: Colors.black,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(1000),
                  child: Image.network(
                    "https://static.wikia.nocookie.net/studio-ghibli/images/8/8e/Chihiro_Ogino.jpg/revision/latest/smart/width/250/height/250?cb=20210214130251",
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _iconButton(IconData icon) {
    return Container(
      height: 40,
      width: 40,
      decoration: BoxDecoration(
        color: const Color.fromARGB(157, 0, 0, 0),
        borderRadius: BorderRadius.circular(100),
      ),
      child: Icon(icon, color: Colors.white, size: 19),
    );
  }
}

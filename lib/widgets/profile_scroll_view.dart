import 'package:animated_scroll_view/widgets/post.dart';
import 'package:animated_scroll_view/widgets/profile_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'dart:ui' as ui;

import 'package:lucide_icons_flutter/lucide_icons.dart';

enum ScrollDirection { up, down, idle }

// Constants for layout
const double appBarMaxHeight = 350;
const double appBarMinHeight = 120;
const double horizontalPadding = 20;
const double dynamicInitialAppBarHeight = 250;
const double maxBlurScrollExtent = 200;
const double avatarSize = 100;
const double avatarBorderWidth = 4;
const double avatarFadeOutThreshold = 100;
const double smallAvatarSize = 85;
const double leftMargin = 8;
const double buttonTopMargin = 10;
const double buttonHorizontalPadding = 20;
const double buttonVerticalPadding = 10;
const double buttonBorderRadius = 100;
const double userNameFontSize = 20;
const double smallSpacing = 4;
const double mediumSpacing = 10;
const double largeSpacing = 20;
const double blurMaxSigma = 10;
const double blurOverlayOpacity = 0.12;
const double topBarPadding = 60;
const double topBarIconSize = 19;
const double topBarButtonSize = 35;
const double iconButtonSize = 40;
const double iconSpacing = 14;
const double nameContainerHeight = 100;
const double nameLeftMargin = 50;
const double nameTopPadding = 40;
const double titleBottomStart = -18;
const double titleBottomEnd = 30;
const double avatarTopOffset = 50;

// Durations
const Duration avatarFadeDuration = Duration(milliseconds: 50);
const Duration avatarOpacityDuration = Duration(milliseconds: 300);
const Duration titleAnimationDuration = Duration(milliseconds: 100);
const Duration appBarAnimationDuration = Duration(milliseconds: 0);

class ProfileScrollView extends StatefulWidget {
  const ProfileScrollView({super.key});

  @override
  State<ProfileScrollView> createState() => _ProfileScrollViewState();
}

class _ProfileScrollViewState extends State<ProfileScrollView> {
  double dynamicAppBarHeight = dynamicInitialAppBarHeight;

  final ScrollController _scrollController = ScrollController();
  final double _avatarFadeOutThreshold = avatarFadeOutThreshold;
  double _titleTopPosition = titleBottomStart;

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
    _animateUserName(position.pixels);
  }

  void _updateAvatarOpacity(double scrollOffset) {
    double opacity =
        1 - (scrollOffset / 4 * 100 / _avatarFadeOutThreshold) / 100;

    if (opacity <= 0) {
      avatarOpacity = 0;
    } else if (opacity >= 1) {
      setState(() {
        avatarOpacity = 1;
      });
    } else {
      setState(() {
        avatarOpacity = opacity;
      });
    }
  }

  void _updateBackgroundBlur(double scrollOffset) {
    double scrollProgress = (scrollOffset * 100 / maxBlurScrollExtent) / 100;

    setState(() {
      backgroundBlur = (scrollProgress * blurMaxSigma).abs();
    });
  }

  void snapScroll() {
    Future.delayed(const Duration(milliseconds: 10), () {
      if (!_scrollController.hasClients) return;

      final double threshold = 100;
      final double targetOffset =
          currentScrollOffset > threshold ? appBarMaxHeight : 0.0;

      _scrollController.animateTo(
        targetOffset,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
      );
    });
  }

  void _animateUserName(double scrollOffset) {
    if (scrollOffset > 200 && _titleTopPosition < titleBottomEnd) {
      setState(() {
        _titleTopPosition = titleBottomEnd;
      });
    } else if (scrollOffset < 195) {
      _titleTopPosition = titleBottomStart;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned(
          child: SingleChildScrollView(
            controller: _scrollController,
            padding: const EdgeInsets.symmetric(horizontal: horizontalPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: appBarMaxHeight / 1.5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AnimatedOpacity(
                      duration: avatarOpacityDuration,
                      opacity: currentScrollOffset <= _avatarFadeOutThreshold
                          ? 0
                          : 1,
                      child: Container(
                        clipBehavior: Clip.antiAlias,
                        margin: const EdgeInsets.only(left: leftMargin),
                        height: smallAvatarSize,
                        width: smallAvatarSize,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(1000),
                          border: Border.all(
                              color: Colors.black, width: avatarBorderWidth),
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
                    GestureDetector(
                      child: Container(
                        margin: const EdgeInsets.only(top: buttonTopMargin),
                        padding: const EdgeInsets.symmetric(
                          horizontal: buttonHorizontalPadding,
                          vertical: buttonVerticalPadding,
                        ),
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(buttonBorderRadius),
                          border: Border.all(width: 1, color: Colors.white54),
                        ),
                        child: const Text(
                          "Edit Profile",
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 14),
                        ),
                      ),
                    )
                  ],
                ),
                const Text(
                  "Djibril Mugisho",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: userNameFontSize),
                ),
                const SizedBox(height: smallSpacing),
                const Text(
                  "@djibril_codes",
                  style: TextStyle(color: Colors.white38),
                ),
                const SizedBox(height: mediumSpacing),
                const Linkify(
                  onOpen: null,
                  linkStyle: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.none,
                  ),
                  text:
                      "🧩 Full-time problem solver, part-time pixel alchemist.🖥️ Building magic with Flutter, Node.js, and Three.js.⚡ Currently decoding life one commit at a time.🔗 https://github.com/DjibrilM",
                ),
                const SizedBox(height: mediumSpacing),
                const TwitterProfileInfo(),
                const SizedBox(height: largeSpacing),
                ...List.generate(4, (_) => const Post())
              ],
            ),
          ),
        ),
        Positioned(
          child: AnimatedContainer(
            height: dynamicAppBarHeight - currentScrollOffset,
            duration: appBarAnimationDuration,
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
                          sigmaX: backgroundBlur > blurMaxSigma
                              ? blurMaxSigma
                              : backgroundBlur,
                          sigmaY: backgroundBlur > blurMaxSigma
                              ? blurMaxSigma
                              : backgroundBlur,
                        ),
                        child: Container(
                          color: Colors.black.withOpacity(blurOverlayOpacity),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: topBarPadding,
                      left: horizontalPadding,
                      right: horizontalPadding,
                    ),
                    child: Row(
                      children: [
                        Container(
                          height: topBarButtonSize,
                          width: topBarButtonSize,
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(157, 0, 0, 0),
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                            size: topBarIconSize,
                          ),
                        ),
                        const Spacer(),
                        Row(
                          children: [
                            _iconButton(LucideIcons.bell),
                            const SizedBox(width: iconSpacing),
                            _iconButton(LucideIcons.search),
                            const SizedBox(width: iconSpacing),
                            _iconButton(LucideIcons.upload),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned.fill(
                  bottom: 0,
                  child: Container(
                    height: nameContainerHeight,
                    margin: const EdgeInsets.only(left: nameLeftMargin),
                    alignment: Alignment.bottomLeft,
                    padding: const EdgeInsets.only(
                      left: horizontalPadding,
                      top: nameTopPadding,
                    ),
                    child: Stack(
                      clipBehavior: Clip.hardEdge,
                      children: [
                        AnimatedPositioned(
                          duration: titleAnimationDuration,
                          bottom: _titleTopPosition,
                          child: const Text(
                            "Djibril mugisho 2",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          top: (dynamicAppBarHeight - avatarTopOffset) - currentScrollOffset,
          child: AnimatedScale(
            duration: appBarAnimationDuration,
            scale: avatarOpacity,
            child: AnimatedOpacity(
              duration: avatarFadeDuration,
              opacity: currentScrollOffset > _avatarFadeOutThreshold
                  ? 0
                  : avatarOpacity,
              child: Container(
                clipBehavior: Clip.antiAlias,
                margin:
                    const EdgeInsets.symmetric(horizontal: horizontalPadding),
                height: avatarSize,
                width: avatarSize,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(1000),
                  border:
                      Border.all(color: Colors.black, width: avatarBorderWidth),
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
      height: iconButtonSize,
      width: iconButtonSize,
      decoration: BoxDecoration(
        color: const Color.fromARGB(157, 0, 0, 0),
        borderRadius: BorderRadius.circular(100),
      ),
      child: Icon(icon, color: Colors.white, size: topBarIconSize),
    );
  }
}

library animated_slideover;

import 'dart:ui';

import 'package:flutter/material.dart';



class AppAnimatedSideBar extends StatefulWidget {
  final List<Widget> contentWidgetList;
  final Text? titleText;
  final Text? subtileText;
  final Color? headerBgColor;
  final List<Widget>? buttonsWidgetList;
  final IconButton headerIcon;
  final VoidCallback? onDispose;


  const AppAnimatedSideBar({
    Key? key,
    required this.contentWidgetList,
    this.titleText,
    this.subtileText,
     this.headerBgColor,
    this.buttonsWidgetList,
    required this.headerIcon,
    this.onDispose,
  }) : super(key: key);

  Color get effectiveHeaderBgColor =>
      headerBgColor ?? const Color(0xFF4338ca);

  @override
  State<AppAnimatedSideBar> createState() => _AppAnimatedSideBarState();
}

class _AppAnimatedSideBarState extends State<AppAnimatedSideBar>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  late Animation<double> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _opacityAnimation = Tween<double>(begin: 0.0, end: 0.75).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _slideAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    widget.onDispose?.call();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [


          Stack(
            children: [



              Positioned.fill(
                child: ClipRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                    child: Container(
                      color: Colors.transparent,
                    ),
                  ),
                ),
              ),

              Positioned.fill(
                child: GestureDetector(
                  onTap: () async {
                    Navigator.pop(context);
                  },
                  child: AnimatedOpacity(
                    opacity: 0.5,
                    duration: const Duration(milliseconds: 500),
                    child: Container(
                      color: Colors.black.withOpacity(0.3),
                    ),
                  ),
                ),
              ),
            ],
          ),



          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Positioned(
                top: 0,
                left:

                Responsive.isDesktop(context)
                    ? _slideAnimation.value * MediaQuery.of(context).size.width * 0.7
                    : Responsive.isTablet(context)
                    ? _slideAnimation.value * MediaQuery.of(context).size.width * 0.5
                    : 0.0,
                bottom: 0,
                child: Container(
                  width:
                  Responsive.isDesktop(context)
                      ? MediaQuery.of(context).size.width * 0.3
                      : Responsive.isTablet(context)
                      ? MediaQuery.of(context).size.width * 0.5 : MediaQuery.of(context).size.width,
                  //_slideAnimation.value * MediaQuery.of(context).size.width,
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      widget.titleText!=null ?

                      Container(
                        width: MediaQuery.of(context).size.width,
                        color: widget.headerBgColor,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 25, bottom: 25, left: 25, right: 25),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start ,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Flexible(child: widget.titleText??const SizedBox()),


                                  widget.headerIcon

                                ],
                              ),
                              widget.subtileText != null
                                  ? Padding(
                                  padding: const EdgeInsets.only(
                                      right: 20, top: 5),
                                  child: widget.subtileText
                              )
                                  : const SizedBox(),
                            ],
                          ),
                        ),
                      ) : const SizedBox(),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(30.0),
                                child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: widget.contentWidgetList
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      widget.buttonsWidgetList != null
                          ? Column(
                        children: [
                          const Divider(
                            height: 1,
                          ),
                          Container(
                            color: Colors.white.withOpacity(0.5),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 15,
                                  bottom: 15,
                                  left: 10,
                                  right: 10),
                              child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.end,
                                  children: [
                                    if (widget.buttonsWidgetList != null)
                                      ...widget.buttonsWidgetList!,
                                  ]


                              ),
                            ),
                          ),
                        ],
                      )
                          : const SizedBox()
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}


class Responsive extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget desktop;

  const Responsive({
    Key? key,
    required this.mobile,
    this.tablet,
    required this.desktop,
  }) : super(key: key);

// This size work fine on my design, maybe you need some customization depends on your design

  // This isMobile, isTablet, isDesktop help us later
  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 850;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width < 1100 &&
          MediaQuery.of(context).size.width >= 850;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= 1100;

  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    // If our width is more than 1100 then we consider it a desktop
    if (_size.width >= 1100) {
      return desktop;
    }
    // If width it less then 1100 and more then 850 we consider it as tablet
    else if (_size.width >= 850 && tablet != null) {
      return tablet!;
    }
    // Or less then that we called it mobile
    else {
      return mobile;
    }
  }
}

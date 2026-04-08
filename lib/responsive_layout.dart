import 'package:enchantment_game/navigation_arrow.dart';
import 'package:enchantment_game/screens/enchant_screen/enchant_screen.dart';
import 'package:enchantment_game/screens/hunting_field_screen/hunting_field_screen.dart';
import 'package:enchantment_game/screens/menu_screen/menu_screen.dart';
import 'package:flutter/material.dart';

/// Breakpoints for responsive layout.
const double _kBreakpointWide = 1280;
const double _kBreakpointNarrow = 640;

/// The default screen to show: EnchantScreen (index 1).
const int _kDefaultScreenIndex = 1;

class ResponsiveLayout extends StatefulWidget {
  const ResponsiveLayout({super.key});

  @override
  State<ResponsiveLayout> createState() => _ResponsiveLayoutState();
}

class _ResponsiveLayoutState extends State<ResponsiveLayout> {
  // --- Medium mode (2 panels) ---
  ScrollController? _scrollController;
  double _lastPanelWidth = 0;

  // --- Narrow mode (1 panel) ---
  PageController? _pageController;

  // --- Shared state ---
  int _currentIndex = _kDefaultScreenIndex;
  _LayoutMode? _lastBuiltMode;

  @override
  void dispose() {
    _scrollController?.dispose();
    _pageController?.dispose();
    super.dispose();
  }

  // ──────────────────────────────────────────────
  // Mode helpers
  // ──────────────────────────────────────────────

  _LayoutMode _getMode(double width) {
    if (width > _kBreakpointWide) return _LayoutMode.wide;
    if (width > _kBreakpointNarrow) return _LayoutMode.medium;
    return _LayoutMode.narrow;
  }

  int _maxIndex(_LayoutMode mode) {
    switch (mode) {
      case _LayoutMode.wide:
        return 0;
      case _LayoutMode.medium:
        return 1; // snap 0 = [Menu,Enchant], snap 1 = [Enchant,Hunting]
      case _LayoutMode.narrow:
        return 2; // page 0 = Menu, 1 = Enchant, 2 = Hunting
    }
  }

  bool _showLeftArrow() => _currentIndex > 0;

  bool _showRightArrow(_LayoutMode mode) => _currentIndex < _maxIndex(mode);

  // ──────────────────────────────────────────────
  // Controller management
  // ──────────────────────────────────────────────

  void _setupForMode(_LayoutMode mode, double panelWidth) {
    if (_lastBuiltMode == mode) {
      // Same mode, but panel width might have changed (window resize within same breakpoint)
      if (mode == _LayoutMode.medium) {
        _lastPanelWidth = panelWidth;
      }
      return;
    }

    // Mode changed — clamp index
    _currentIndex = _currentIndex.clamp(0, _maxIndex(mode));

    // Dispose old controllers
    _scrollController?.dispose();
    _scrollController = null;
    _pageController?.dispose();
    _pageController = null;

    switch (mode) {
      case _LayoutMode.wide:
        break;

      case _LayoutMode.medium:
        _lastPanelWidth = panelWidth;
        _scrollController = ScrollController(
          initialScrollOffset: _currentIndex * panelWidth,
        );

      case _LayoutMode.narrow:
        _pageController = PageController(initialPage: _currentIndex);
    }
  }

  // ──────────────────────────────────────────────
  // Navigation
  // ──────────────────────────────────────────────

  void _goTo(int index) {
    if (_lastBuiltMode == _LayoutMode.narrow) {
      _pageController?.animateToPage(
        index,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else if (_lastBuiltMode == _LayoutMode.medium) {
      _scrollController?.animateTo(
        index * _lastPanelWidth,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  void _onMediumScrollEnd() {
    if (_scrollController == null ||
        !_scrollController!.hasClients ||
        _lastPanelWidth == 0) {
      return;
    }

    final snapIndex = (_scrollController!.offset / _lastPanelWidth).round();
    if (snapIndex != _currentIndex) {
      setState(() {
        _currentIndex = snapIndex;
      });
    }
  }

  // ──────────────────────────────────────────────
  // Build
  // ──────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        final mode = _getMode(screenWidth);

        if (mode == _LayoutMode.wide) {
          _setupForMode(mode, 0);
          _lastBuiltMode = mode;
          return _buildWideLayout(screenWidth);
        }

        if (mode == _LayoutMode.medium) {
          final panelWidth = screenWidth / 2;
          _setupForMode(mode, panelWidth);
          _lastBuiltMode = mode;
          return _buildMediumLayout(panelWidth, mode);
        }

        // Narrow
        _setupForMode(mode, screenWidth);
        _lastBuiltMode = mode;
        return _buildNarrowLayout(mode);
      },
    );
  }

  /// > 1280px — all 3 panels visible side by side.
  Widget _buildWideLayout(double totalWidth) {
    final panelWidth = totalWidth / 3;
    return Row(
      children: [
        MenuScreen(width: panelWidth),
        EnchantScreen(width: panelWidth),
        HuntingFieldScreen(width: panelWidth),
      ],
    );
  }

  /// ≤ 1280px — 2 panels visible, horizontal scroll with snap.
  Widget _buildMediumLayout(double panelWidth, _LayoutMode mode) {
    return Stack(
      children: [
        NotificationListener<ScrollNotification>(
          onNotification: (notification) {
            if (notification is ScrollEndNotification) {
              _onMediumScrollEnd();
            }
            return false;
          },
          child: SingleChildScrollView(
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            physics: _SnapScrollPhysics(snapSize: panelWidth),
            child: SizedBox(
              width: panelWidth * 3,
              child: Row(
                children: [
                  SizedBox(
                      width: panelWidth,
                      child: MenuScreen(width: panelWidth)),
                  SizedBox(
                      width: panelWidth,
                      child: EnchantScreen(width: panelWidth)),
                  SizedBox(
                      width: panelWidth,
                      child: HuntingFieldScreen(width: panelWidth)),
                ],
              ),
            ),
          ),
        ),
        _buildArrows(mode),
      ],
    );
  }

  /// ≤ 640px — 1 panel visible, standard PageView for perfect snapping.
  Widget _buildNarrowLayout(_LayoutMode mode) {
    return Stack(
      children: [
        PageView(
          controller: _pageController,
          onPageChanged: (page) {
            setState(() {
              _currentIndex = page;
            });
          },
          children: const [
            MenuScreen(),
            EnchantScreen(),
            HuntingFieldScreen(),
          ],
        ),
        _buildArrows(mode),
      ],
    );
  }

  /// Floating navigation arrows overlay.
  Widget _buildArrows(_LayoutMode mode) {
    return Stack(
      children: [
        // Left arrow
        Positioned(
          left: 0,
          top: 0,
          bottom: 0,
          child: Center(
            child: NavigationArrow(
              direction: ArrowDirection.left,
              visible: _showLeftArrow(),
              onTap: () => _goTo(_currentIndex - 1),
            ),
          ),
        ),
        // Right arrow
        Positioned(
          right: 0,
          top: 0,
          bottom: 0,
          child: Center(
            child: NavigationArrow(
              direction: ArrowDirection.right,
              visible: _showRightArrow(mode),
              onTap: () => _goTo(_currentIndex + 1),
            ),
          ),
        ),
      ],
    );
  }
}

enum _LayoutMode { wide, medium, narrow }

/// Custom scroll physics that snaps to multiples of [snapSize].
class _SnapScrollPhysics extends ScrollPhysics {
  final double snapSize;

  const _SnapScrollPhysics({required this.snapSize, super.parent});

  @override
  _SnapScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return _SnapScrollPhysics(
        snapSize: snapSize, parent: buildParent(ancestor));
  }

  double _getTargetPixels(
      ScrollMetrics position, Tolerance tolerance, double velocity) {
    double page = position.pixels / snapSize;
    if (velocity < -tolerance.velocity) {
      page -= 0.5;
    } else if (velocity > tolerance.velocity) {
      page += 0.5;
    }
    return (page.roundToDouble() * snapSize)
        .clamp(position.minScrollExtent, position.maxScrollExtent);
  }

  @override
  Simulation? createBallisticSimulation(
      ScrollMetrics position, double velocity) {
    if ((velocity <= 0.0 && position.pixels <= position.minScrollExtent) ||
        (velocity >= 0.0 && position.pixels >= position.maxScrollExtent)) {
      return super.createBallisticSimulation(position, velocity);
    }
    final double target =
        _getTargetPixels(position, toleranceFor(position), velocity);
    if (target != position.pixels) {
      return ScrollSpringSimulation(
        spring,
        position.pixels,
        target,
        velocity,
        tolerance: toleranceFor(position),
      );
    }
    return null;
  }

  @override
  bool get allowImplicitScrolling => false;
}

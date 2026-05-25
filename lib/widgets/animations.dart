import 'package:flutter/material.dart';

class TapScaleEffect extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;
  final double scaleDown;

  const TapScaleEffect({
    super.key,
    required this.child,
    required this.onTap,
    this.scaleDown = 0.95,
  });

  @override
  State<TapScaleEffect> createState() => _TapScaleEffectState();
}

class _TapScaleEffectState extends State<TapScaleEffect>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scale = Tween<double>(begin: 1.0, end: widget.scaleDown).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        widget.onTap();
      },
      onTapCancel: () => _controller.reverse(),
      child: ScaleTransition(scale: _scale, child: widget.child),
    );
  }
}

class FadeSlideIn extends StatelessWidget {
  final Animation<double> animation;
  final Widget child;
  final Offset slideBegin;

  const FadeSlideIn({
    super.key,
    required this.animation,
    required this.child,
    this.slideBegin = const Offset(0, 0.15),
  });

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: animation,
      child: SlideTransition(
        position: Tween<Offset>(begin: slideBegin, end: Offset.zero)
            .animate(animation),
        child: child,
      ),
    );
  }
}

class StaggeredList extends StatefulWidget {
  final List<Widget> children;
  final Duration duration;
  final Duration itemDelay;

  const StaggeredList({
    super.key,
    required this.children,
    this.duration = const Duration(milliseconds: 400),
    this.itemDelay = const Duration(milliseconds: 80),
  });

  @override
  State<StaggeredList> createState() => _StaggeredListState();
}

class _StaggeredListState extends State<StaggeredList>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    final totalMs = widget.duration.inMilliseconds +
        (widget.children.length * widget.itemDelay.inMilliseconds);
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: totalMs),
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final totalMs = _controller.duration!.inMilliseconds;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(widget.children.length, (index) {
        final startMs = index * widget.itemDelay.inMilliseconds;
        final endMs = startMs + widget.duration.inMilliseconds;
        final animation = CurvedAnimation(
          parent: _controller,
          curve: Interval(
            startMs / totalMs,
            (endMs / totalMs).clamp(0.0, 1.0),
            curve: Curves.easeOutCubic,
          ),
        );
        return FadeSlideIn(
          animation: animation,
          child: widget.children[index],
        );
      }),
    );
  }
}

Route createSlideRoute(Widget page) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final curved = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
      );
      return SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0.0, 0.08),
          end: Offset.zero,
        ).animate(curved),
        child: FadeTransition(opacity: curved, child: child),
      );
    },
    transitionDuration: const Duration(milliseconds: 350),
  );
}

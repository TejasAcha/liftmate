import 'package:flutter/material.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/styles.dart';

class TypingIndicatorWidget extends StatefulWidget {
  final String userName;

  const TypingIndicatorWidget({
    super.key,
    required this.userName,
  });

  @override
  State<TypingIndicatorWidget> createState() => _TypingIndicatorWidgetState();
}

class _TypingIndicatorWidgetState extends State<TypingIndicatorWidget>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    )..repeat();

    _animations = List.generate(
      3,
      (index) => Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _animationController,
          curve: Interval(
            index * 0.2,
            0.6 + (index * 0.2),
            curve: Curves.easeInOut,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: Dimensions.paddingSizeSmall,
        horizontal: Dimensions.paddingSizeDefault,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            '${widget.userName} is typing',
            style: textSmall.copyWith(
              color: Theme.of(context).hintColor,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(width: 4),
          SizedBox(
            width: 24,
            height: 12,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                3,
                (index) => AnimatedBuilder(
                  animation: _animations[index],
                  builder: (context, child) {
                    final double yOffset = _animations[index].value * 8;
                    return Transform.translate(
                      offset: Offset(0, -yOffset),
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 2),
                        width: 4,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}

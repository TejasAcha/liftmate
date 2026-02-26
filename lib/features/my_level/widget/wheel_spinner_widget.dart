import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/features/my_level/domain/model/spinner_reward_model.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/styles.dart';

class WheelSpinnerWidget extends StatefulWidget {
  final List<SpinnerRewardModel> rewards;
  final VoidCallback onSpinComplete;

  const WheelSpinnerWidget({
    super.key,
    required this.rewards,
    required this.onSpinComplete,
  });

  @override
  State<WheelSpinnerWidget> createState() => _WheelSpinnerWidgetState();
}

class _WheelSpinnerWidgetState extends State<WheelSpinnerWidget>
    with TickerProviderStateMixin {
  late AnimationController _spinController;
  late Animation<double> _spinAnimation;
  bool isSpinning = false;
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _initializeAnimation();
  }

  void _initializeAnimation() {
    _spinController = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    );

    _spinAnimation = Tween<double>(begin: 0, end: 2 * pi).animate(
      CurvedAnimation(parent: _spinController, curve: Curves.easeInOut),
    );
  }

  void _spinWheel() {
    if (isSpinning) return;

    setState(() {
      isSpinning = true;
    });

    // Generate random selected index
    selectedIndex = Random().nextInt(widget.rewards.length);

    // Calculate rotation angle
    double baseRotation = (2 * pi * 3); // 3 full rotations
    double segmentAngle = (2 * pi) / widget.rewards.length;
    double targetRotation =
        baseRotation + (selectedIndex * segmentAngle) + (segmentAngle / 2);

    _spinAnimation = Tween<double>(begin: 0, end: targetRotation).animate(
      CurvedAnimation(parent: _spinController, curve: Curves.easeInOut),
    );

    _spinController.forward(from: 0).then((_) {
      setState(() {
        isSpinning = false;
      });
      widget.onSpinComplete();
      
      // Show reward dialog
      _showRewardDialog();
    });
  }

  void _showRewardDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
          ),
          child: Padding(
            padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'congratulations'.tr,
                  style: textBold.copyWith(
                    fontSize: Dimensions.fontSizeLarge,
                  ),
                ),
                const SizedBox(height: Dimensions.paddingSizeDefault),
                Icon(
                  Icons.emoji_events,
                  size: 60,
                  color: Colors.amber,
                ),
                const SizedBox(height: Dimensions.paddingSizeDefault),
                Text(
                  widget.rewards[selectedIndex].title,
                  style: textRegular.copyWith(
                    fontSize: Dimensions.fontSizeDefault,
                  ),
                ),
                const SizedBox(height: Dimensions.paddingSizeSmall),
                Text(
                  '${widget.rewards[selectedIndex].points.toStringAsFixed(0)} points',
                  style: textBold.copyWith(
                    fontSize: Dimensions.fontSizeDefault,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(height: Dimensions.paddingSizeDefault),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('claim'.tr),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Wheel
        Center(
          child: SizedBox(
            height: 300,
            width: 300,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Pointer
                Positioned(
                  top: 0,
                  child: Transform.rotate(
                    angle: pi,
                    child: Icon(
                      Icons.arrow_drop_down,
                      size: 40,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),

                // Spinning wheel
                AnimatedBuilder(
                  animation: _spinAnimation,
                  builder: (context, child) {
                    return Transform.rotate(
                      angle: _spinAnimation.value,
                      child: CustomPaint(
                        size: const Size(300, 300),
                        painter: WheelPainter(
                          segments: widget.rewards.length,
                          colors: _getSegmentColors(),
                        ),
                      ),
                    );
                  },
                ),

                // Center circle with text
                Container(
                  height: 80,
                  width: 80,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      'spin'.tr,
                      textAlign: TextAlign.center,
                      style: textBold.copyWith(
                        color: Colors.white,
                        fontSize: Dimensions.fontSizeSmall,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: Dimensions.paddingSizeLarge),

        // Spin button
        SizedBox(
          height: 50,
          width: 150,
          child: ElevatedButton(
            onPressed: isSpinning ? null : _spinWheel,
            child: Text(
              isSpinning ? 'spinning'.tr : 'spin_wheel'.tr,
              style: textBold.copyWith(
                color: Colors.white,
              ),
            ),
          ),
        ),

        const SizedBox(height: Dimensions.paddingSizeDefault),

        // Rewards legend
        SizedBox(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: widget.rewards.length,
            itemBuilder: (context, index) {
              final reward = widget.rewards[index];
              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: Dimensions.paddingSizeSmall,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      backgroundColor: Color(int.parse(
                        '0xff${reward.color.replaceFirst('#', '')}',
                      )),
                      child: const Icon(
                        Icons.card_giftcard,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      reward.title,
                      style: textSmall,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '+${reward.points.toStringAsFixed(0)}',
                      style: textSmall.copyWith(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  List<Color> _getSegmentColors() {
    return widget.rewards
        .map((reward) => Color(int.parse(
              '0xff${reward.color.replaceFirst('#', '')}',
            )))
        .toList();
  }

  @override
  void dispose() {
    _spinController.dispose();
    super.dispose();
  }
}

class WheelPainter extends CustomPainter {
  final int segments;
  final List<Color> colors;

  WheelPainter({
    required this.segments,
    required this.colors,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint();
    final Offset center = Offset(size.width / 2, size.height / 2);
    final double radius = size.width / 2;

    const double borderWidth = 2;
    const double innerRadius = 30;

    for (int i = 0; i < segments; i++) {
      final double startAngle = (2 * pi / segments) * i - pi / 2;
      final double sweepAngle = (2 * pi / segments);

      // Draw segment
      paint.color = colors[i % colors.length];
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        true,
        paint,
      );

      // Draw segment border
      paint.color = Colors.white;
      paint.strokeWidth = borderWidth;
      paint.style = PaintingStyle.stroke;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        true,
        paint,
      );

      // Draw segment lines
      final double lineAngle = startAngle + sweepAngle / 2;
      final Offset start = Offset(
        center.dx + innerRadius * cos(lineAngle),
        center.dy + innerRadius * sin(lineAngle),
      );
      final Offset end = Offset(
        center.dx + radius * cos(lineAngle),
        center.dy + radius * sin(lineAngle),
      );
      canvas.drawLine(start, end, paint);
    }

    // Draw inner circle
    paint.style = PaintingStyle.fill;
    paint.color = Colors.white;
    canvas.drawCircle(center, innerRadius, paint);
  }

  @override
  bool shouldRepaint(WheelPainter oldDelegate) {
    return oldDelegate.segments != segments || oldDelegate.colors != colors;
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/features/ride/domain/models/seat_share_model.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/styles.dart';

class SeatSelectionWidget extends StatefulWidget {
  final SeatShareModel seatShareModel;
  final ValueChanged<int> onSeatSelected;
  final int? selectedSeat;

  const SeatSelectionWidget({
    super.key,
    required this.seatShareModel,
    required this.onSeatSelected,
    this.selectedSeat,
  });

  @override
  State<SeatSelectionWidget> createState() => _SeatSelectionWidgetState();
}

class _SeatSelectionWidgetState extends State<SeatSelectionWidget> {
  late int selectedSeat;

  @override
  void initState() {
    selectedSeat = widget.selectedSeat ?? -1;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
        border: Border.all(
          color: Theme.of(context).primaryColor.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'select_seat'.tr,
            style: textBold.copyWith(
              fontSize: Dimensions.fontSizeDefault,
              color: Theme.of(context).textTheme.bodyMedium?.color,
            ),
          ),
          const SizedBox(height: Dimensions.paddingSizeDefault),

          // Car visualization
          _buildCarVisualization(context),

          const SizedBox(height: Dimensions.paddingSizeDefault),

          // Seat Legend
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildLegendItem(
                Colors.green,
                'available'.tr,
              ),
              _buildLegendItem(
                Colors.amber,
                'reserved'.tr,
              ),
              _buildLegendItem(
                Colors.red,
                'occupied'.tr,
              ),
            ],
          ),

          if (selectedSeat != -1) ...[
            const SizedBox(height: Dimensions.paddingSizeDefault),
            Container(
              padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
              decoration: BoxDecoration(
                color: Colors.green.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                border: Border.all(color: Colors.green),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${'seat'.tr} ${selectedSeat + 1}',
                    style: textRegular.copyWith(
                      color: Colors.green,
                    ),
                  ),
                  Text(
                    '\$${widget.seatShareModel.pricePerSeat.toStringAsFixed(2)}',
                    style: textBold.copyWith(
                      color: Colors.green,
                      fontSize: Dimensions.fontSizeDefault,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCarVisualization(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
          border: Border.all(
            color: Theme.of(context).dividerColor,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Front of car (driver)
            Text(
              'front'.tr,
              style: textSmall.copyWith(
                color: Theme.of(context).hintColor,
              ),
            ),
            const SizedBox(height: Dimensions.paddingSizeSmall),

            // Seat grid for car layout (2x2 for standard car)
            if (widget.seatShareModel.vehicleType == 'car' ||
                widget.seatShareModel.vehicleType == 'car_mini') ...[
              // Front row (driver + front passenger)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildSeatButton(
                    context,
                    0,
                    'D',
                  ), // Driver seat (non-selectable)
                  const SizedBox(width: Dimensions.paddingSizeSmall),
                  _buildSeatButton(context, 1, '1'),
                ],
              ),
              const SizedBox(height: Dimensions.paddingSizeSmall),

              // Back row
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildSeatButton(context, 2, '2'),
                  const SizedBox(width: Dimensions.paddingSizeSmall),
                  _buildSeatButton(context, 3, '3'),
                ],
              ),
            ] else if (widget.seatShareModel.vehicleType == 'bike') ...[
              // Bike only has 1 back seat
              _buildSeatButton(context, 1, '1'),
            ],

            const SizedBox(height: Dimensions.paddingSizeSmall),
            Text(
              'back'.tr,
              style: textSmall.copyWith(
                color: Theme.of(context).hintColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSeatButton(BuildContext context, int seatIndex, String label) {
    final seat = seatIndex < widget.seatShareModel.seats.length
        ? widget.seatShareModel.seats[seatIndex]
        : SeatInfo(
            seatNumber: seatIndex,
            status: 'available',
          );

    bool isSelectable = seat.status == 'available';
    bool isSelected = selectedSeat == seatIndex;

    Color backgroundColor;
    if (seat.status == 'available') {
      backgroundColor = isSelected ? Colors.blue : Colors.green;
    } else if (seat.status == 'reserved') {
      backgroundColor = Colors.amber;
    } else {
      backgroundColor = Colors.red;
    }

    return GestureDetector(
      onTap: isSelectable
          ? () {
              setState(() {
                if (selectedSeat == seatIndex) {
                  selectedSeat = -1;
                } else {
                  selectedSeat = seatIndex;
                }
                widget.onSeatSelected(selectedSeat);
              });
            }
          : null,
      child: Container(
        height: 50,
        width: 50,
        decoration: BoxDecoration(
          color: backgroundColor.withValues(alpha: isSelectable ? 1.0 : 0.6),
          borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.transparent,
            width: 3,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: textBold.copyWith(
              color: Colors.white,
              fontSize: Dimensions.fontSizeSmall,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLegendItem(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 24,
          width: 24,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: textSmall,
        ),
      ],
    );
  }
}

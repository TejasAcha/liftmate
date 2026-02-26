import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/features/trip/controllers/trip_controller.dart';
import 'package:ride_sharing_user_app/helper/date_converter.dart';
import 'package:ride_sharing_user_app/helper/price_converter.dart';
import 'package:ride_sharing_user_app/helper/route_helper.dart';

class InvoiceListScreen extends StatefulWidget {
  const InvoiceListScreen({super.key});

  @override
  State<InvoiceListScreen> createState() => _InvoiceListScreenState();
}

class _InvoiceListScreenState extends State<InvoiceListScreen> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
    // Initialize trip list
    Get.find<TripController>().initData();
    Get.find<TripController>().getTripList(1);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  /// Handle pagination when user scrolls to bottom
  void _onScroll() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      TripController tripController = Get.find<TripController>();
      int currentOffset = int.tryParse(tripController.tripModel?.offset ?? '1') ?? 1;
      int nextOffset = (currentOffset ~/ 10) + 2;
      tripController.getTripList(nextOffset);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TripController>(
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Invoice History'.tr),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Get.back(),
            ),
          ),
          body: controller.tripModel?.data == null || controller.tripModel!.data!.isEmpty
              ? Center(
                  child: Text('no_invoices_found'.tr),
                )
              : ListView.builder(
                  controller: _scrollController,
                  itemCount: controller.tripModel?.data?.length ?? 0,
                  itemBuilder: (context, index) {
                    final trip = controller.tripModel?.data?[index];
                    if (trip == null) {
                      return const SizedBox.shrink();
                    }

                    return Card(
                      margin: const EdgeInsets.all(8),
                      child: ListTile(
                        leading: const Icon(Icons.receipt),
                        title: Text('Trip #${trip.refId ?? 'N/A'}'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(trip.pickupAddress ?? 'N/A', maxLines: 1, overflow: TextOverflow.ellipsis),
                            Text(
                              DateConverter.formatDate(
                                DateTime.tryParse(trip.createdAt ?? '') ?? DateTime.now(),
                              ),
                              style: const TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              PriceConverter.convertPrice(
                                double.tryParse(trip.totalFare?.toString() ?? '0') ?? 0.0,
                              ),
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              trip.paymentStatus?.toUpperCase() ?? 'N/A',
                              style: TextStyle(
                                color: trip.paymentStatus?.toLowerCase() == 'paid' ? Colors.green : Colors.orange,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        onTap: () {
                          // Navigate to invoice detail page with trip ID
                          Get.toNamed(
                            RouteHelper.getInvoiceDetailScreen(),
                            arguments: trip.id,
                          );
                        },
                      ),
                    );
                  },
                ),
        );
      },
    );
  }
}
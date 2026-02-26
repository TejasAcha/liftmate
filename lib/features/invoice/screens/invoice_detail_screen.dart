import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/features/invoice/controllers/invoice_controller.dart';
import 'package:ride_sharing_user_app/helper/date_converter.dart';
import 'package:ride_sharing_user_app/helper/price_converter.dart';

class InvoiceDetailScreen extends StatefulWidget {
  const InvoiceDetailScreen({super.key});

  @override
  State<InvoiceDetailScreen> createState() => _InvoiceDetailScreenState();
}

class _InvoiceDetailScreenState extends State<InvoiceDetailScreen> {
  @override
  void initState() {
    super.initState();
    final invoiceId = Get.arguments as String?;
    if (invoiceId != null && invoiceId.isNotEmpty) {
      Get.find<InvoiceController>().loadInvoiceDetail(invoiceId);
    } else {
      // Show error if invoice ID is invalid
      Future.delayed(const Duration(milliseconds: 100), () {
        Get.back();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<InvoiceController>(
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            title: Text('invoice_detail'.tr),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Get.back(),
            ),
          ),
          body: controller.isDetailLoading
              ? const Center(child: CircularProgressIndicator())
              : controller.invoiceDetailModel?.data == null
                  ? Center(child: Text('no_invoice_found'.tr))
                  : _buildInvoiceDetails(controller.invoiceDetailModel!.data!),
        );
      },
    );
  }

  Widget _buildInvoiceDetails(invoice) {
    // Safety validation: ensure critical fields exist
    if (invoice.id == null || invoice.id!.isEmpty) {
      return Center(child: Text('invalid_invoice_data'.tr));
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Invoice Header
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Invoice #${invoice.invoiceNumber ?? 'N/A'}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            DateConverter.formatDate(
                              DateTime.tryParse(invoice.createdAt ?? '') ?? DateTime.now(),
                            ),
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: (invoice.paymentStatus ?? '').toLowerCase() == 'paid' ? Colors.green : Colors.orange,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          (invoice.paymentStatus ?? 'PENDING').toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Trip Details
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'trip_details'.tr,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildDetailRow('from'.tr, invoice.pickupAddress ?? 'N/A'),
                  const SizedBox(height: 8),
                  _buildDetailRow('to'.tr, invoice.destinationAddress ?? 'N/A'),
                  const SizedBox(height: 8),
                  _buildDetailRow('driver'.tr, invoice.driverName ?? 'N/A'),
                  const SizedBox(height: 8),
                  _buildDetailRow('vehicle'.tr, invoice.vehicleNumber ?? 'N/A'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Fare Breakdown
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'fare_breakdown'.tr,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildFareRow('base_fare'.tr, invoice.baseFare ?? 0.0),
                  const SizedBox(height: 8),
                  _buildFareRow('distance_fare'.tr, invoice.distanceFare ?? 0.0),
                  const SizedBox(height: 8),
                  _buildFareRow('waiting_fare'.tr, invoice.waitingFare ?? 0.0),
                  if ((invoice.discount ?? 0.0) > 0)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: _buildFareRow('discount'.tr, -(invoice.discount ?? 0.0)),
                    ),
                  if ((invoice.tax ?? 0.0) > 0)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: _buildFareRow('tax'.tr, invoice.tax ?? 0.0),
                    ),
                  const Divider(height: 20),
                  _buildFareRow(
                    'total_fare'.tr,
                    invoice.totalFare ?? 0.0,
                    isBold: true,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Payment Details
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'payment_details'.tr,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildDetailRow('payment_method'.tr, invoice.paymentMethod ?? 'N/A'),
                  const SizedBox(height: 8),
                  _buildDetailRow('amount_paid'.tr, PriceConverter.convertPrice(invoice.paidAmount ?? 0.0)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
      ],
    );
  }

  Widget _buildFareRow(String label, double amount, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          PriceConverter.convertPrice(amount),
          style: TextStyle(
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}
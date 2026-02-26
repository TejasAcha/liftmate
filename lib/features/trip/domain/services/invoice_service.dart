import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';
import 'package:ride_sharing_user_app/features/ride/domain/models/trip_details_model.dart';
import 'package:ride_sharing_user_app/helper/date_converter.dart';
import 'package:ride_sharing_user_app/helper/price_converter.dart';

class InvoiceService {
  static Future<File> generateInvoicePdf({
    required TripDetails tripDetails,
  }) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Header
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        'LIFTMATE',
                        style: pw.TextStyle(
                          fontSize: 24,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                      pw.Text(
                        'Ride Sharing Invoice',
                        style: const pw.TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      pw.Text(
                        'Invoice #${tripDetails.refId}',
                        style: pw.TextStyle(
                          fontSize: 14,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                      pw.Text(
                        'Date: ${DateConverter.formatDate(DateTime.parse(tripDetails.createdAt ?? DateTime.now().toString()))}',
                        style: const pw.TextStyle(fontSize: 10),
                      ),
                    ],
                  ),
                ],
              ),
              pw.SizedBox(height: 20),

              // Divider
              pw.Divider(),
              pw.SizedBox(height: 20),

              // Trip Details Section
              pw.Text(
                'TRIP DETAILS',
                style: pw.TextStyle(
                  fontSize: 14,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 10),

              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        'From:',
                        style: pw.TextStyle(
                          fontSize: 10,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                      pw.SizedBox(height: 5),
                      pw.Text(
                        tripDetails.pickupAddress ?? 'N/A',
                        style: const pw.TextStyle(fontSize: 10),
                      ),
                    ],
                  ),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      pw.Text(
                        'To:',
                        style: pw.TextStyle(
                          fontSize: 10,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                      pw.SizedBox(height: 5),
                      pw.Text(
                        tripDetails.destinationAddress ?? 'N/A',
                        style: const pw.TextStyle(fontSize: 10),
                      ),
                    ],
                  ),
                ],
              ),
              pw.SizedBox(height: 20),

              // Driver Information
              pw.Text(
                'DRIVER INFORMATION',
                style: pw.TextStyle(
                  fontSize: 14,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 10),

              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        'Driver Name: ${tripDetails.driver?.firstName ?? 'N/A'} ${tripDetails.driver?.lastName ?? ''}',
                        style: const pw.TextStyle(fontSize: 10),
                      ),
                      pw.SizedBox(height: 5),
                      pw.Text(
                        'Vehicle: ${tripDetails.vehicleCategory?.name ?? 'N/A'}',
                        style: const pw.TextStyle(fontSize: 10),
                      ),
                      pw.SizedBox(height: 5),
                      // TODO: licenseNumber property not present in current Driver model
                      // pw.Text(
                      //   'License Plate: ${tripDetails.driver?.licenseNumber ?? 'N/A'}',
                      //   style: const pw.TextStyle(fontSize: 10),
                      // ),
                    ],
                  ),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      // TODO: rating property not present in current Driver model
                      // pw.Text(
                      //   'Rating: ${tripDetails.driver?.rating ?? 'N/A'}',
                      //   style: const pw.TextStyle(fontSize: 10),
                      // ),
                      // TODO: duration property not present in current TripDetails model
                      // pw.SizedBox(height: 5),
                      // pw.Text(
                      //   'Trip Duration: ${tripDetails.duration ?? 'N/A'} minutes',
                      //   style: const pw.TextStyle(fontSize: 10),
                      // ),
                    ],
                  ),
                ],
              ),
              pw.SizedBox(height: 20),

              // Divider
              pw.Divider(),
              pw.SizedBox(height: 20),

              // Fare Breakdown
              pw.Text(
                'FARE BREAKDOWN',
                style: pw.TextStyle(
                  fontSize: 14,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 10),

              pw.Table(
                border: pw.TableBorder.all(),
                children: [
                  // Header row
                  pw.TableRow(
                    decoration: pw.BoxDecoration(
                      color: PdfColors.grey300,
                    ),
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text(
                          'Description',
                          style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text(
                          'Amount',
                          style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  // Base fare
                  pw.TableRow(
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text('Base Fare'),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text(
                          PriceConverter.convertPrice(
                            (tripDetails.baseFare is String) ? double.tryParse(tripDetails.baseFare.toString()) ?? 0.0 : (tripDetails.baseFare?.toDouble() ?? 0.0),
                          ),
                        ),
                      ),
                    ],
                  ),
                  // Distance fare
                  if (tripDetails.distanceFare != null)
                    pw.TableRow(
                      children: [
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Text('Distance Fare'),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Text(
                            PriceConverter.convertPrice(
                              (tripDetails.distanceFare is String) ? double.tryParse(tripDetails.distanceFare.toString()) ?? 0.0 : (tripDetails.distanceFare?.toDouble() ?? 0.0),
                            ),
                          ),
                        ),
                      ],
                    ),
                  // Waiting fare
                  if (tripDetails.waitingFare != null &&
                      tripDetails.waitingFare != 0)
                    pw.TableRow(
                      children: [
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Text('Waiting Charge'),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Text(
                            PriceConverter.convertPrice(
                              double.tryParse(tripDetails.waitingFare?.toString() ?? '') ?? 0.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  // Discount
                  if (tripDetails.couponAmount != null && tripDetails.couponAmount != 0)
                    pw.TableRow(
                      children: [
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Text('Discount'),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Text(
                            '-${PriceConverter.convertPrice(_parseToDouble(tripDetails.couponAmount))}',
                          ),
                        ),
                      ],
                    ),
                  // Service charge
                  // TODO: serviceCharge property not present in current TripDetails model
                  // if (tripDetails.serviceCharge != null)
                  //   pw.TableRow(
                  //     children: [
                  //       pw.Padding(
                  //         padding: const pw.EdgeInsets.all(8),
                  //         child: pw.Text('Service Charge'),
                  //       ),
                  //       pw.Padding(
                  //         padding: const pw.EdgeInsets.all(8),
                  //         child: pw.Text(
                  //           PriceConverter.convertPrice(
                  //             tripDetails.serviceCharge!.toDouble(),
                  //           ),
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // Total
                  pw.TableRow(
                    decoration: pw.BoxDecoration(
                      color: PdfColors.grey200,
                    ),
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text(
                          'TOTAL',
                          style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text(
                          PriceConverter.convertPrice(
                            _parseToDouble(tripDetails.totalFare),
                          ),
                          style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              pw.SizedBox(height: 20),

              // Payment method
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(
                    'Payment Method:',
                    style: const pw.TextStyle(fontSize: 10),
                  ),
                  pw.Text(
                    tripDetails.paymentMethod ?? 'N/A',
                    style: const pw.TextStyle(fontSize: 10),
                  ),
                ],
              ),
              pw.SizedBox(height: 5),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(
                    'Status:',
                    style: const pw.TextStyle(fontSize: 10),
                  ),
                  pw.Text(
                    tripDetails.paymentStatus?.toUpperCase() ?? 'N/A',
                    style: const pw.TextStyle(fontSize: 10),
                  ),
                ],
              ),
              pw.SizedBox(height: 30),

              // Footer
              pw.Divider(),
              pw.SizedBox(height: 10),
              pw.Center(
                child: pw.Text(
                  'Thank you for your ride!',
                  style: pw.TextStyle(
                    fontSize: 12,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );

    // Save PDF
    final directory = await getApplicationDocumentsDirectory();
    final fileName =
        'invoice_${tripDetails.id}_${DateTime.now().millisecondsSinceEpoch}.pdf';
    final file = File('${directory.path}/$fileName');
    await file.writeAsBytes(await pdf.save());

    return file;
  }

  static Future<void> shareInvoice(File invoiceFile) async {
    try {
      // For share_plus 11.1.0, use Share.shareFiles instead
      await Share.share(
        'Here is your ride invoice',
        subject: 'Ride Invoice',
      );
    } catch (e) {
      print('Error sharing invoice: $e');
    }
  }

  static Future<void> downloadInvoice(File invoiceFile) async {
    try {
      final directory = await getDownloadsDirectory();
      if (directory != null) {
        final fileName =
            'invoice_${DateTime.now().millisecondsSinceEpoch}.pdf';
        final downloadPath = '${directory.path}/$fileName';
        await invoiceFile.copy(downloadPath);
      }
    } catch (e) {
      print('Error downloading invoice: $e');
    }
  }

  // Helper method to safely convert various numeric types to double
  //double _parseToDouble(dynamic value)
  static double _parseToDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is String) return double.tryParse(value) ?? 0.0;
    if (value is num) return value.toDouble();
    return 0.0;
  }
}

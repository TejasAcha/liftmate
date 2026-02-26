import 'package:get/get.dart';
import 'package:ride_sharing_user_app/data/api_checker.dart';
import 'package:ride_sharing_user_app/features/invoice/domain/models/invoice_model.dart';
import 'package:ride_sharing_user_app/features/invoice/domain/services/invoice_service_interface.dart';
import 'package:ride_sharing_user_app/features/ride/domain/models/trip_details_model.dart';
import 'package:ride_sharing_user_app/helper/display_helper.dart';

class InvoiceController extends GetxController implements GetxService {
  final InvoiceServiceInterface invoiceServiceInterface;

  InvoiceController({required this.invoiceServiceInterface});

  bool isLoading = false;
  bool isDetailLoading = false;
  InvoiceListModel? invoiceListModel;
  InvoiceDetailModel? invoiceDetailModel;

  @override
  void onInit() {
    super.onInit();
    getInvoiceList();
  }

  /// Wrapper method for UI - loads invoice list with default offset
  Future<void> getInvoiceList() async {
    await getInvoiceListWithOffset(1);
  }

  Future<void> getInvoiceListWithOffset(int offset) async {
    if (offset == 1) {
      isLoading = true;
    }
    update();

    try {
      Response response = await invoiceServiceInterface.getInvoiceList(offset);

      if (response.statusCode == 200) {
        if (offset == 1) {
          invoiceListModel = InvoiceListModel.fromJson(response.body);
        } else {
          InvoiceListModel newModel = InvoiceListModel.fromJson(response.body);
          // Safely append to existing list, or initialize if null
          if (invoiceListModel?.data != null && newModel.data != null) {
            invoiceListModel!.data!.addAll(newModel.data!);
          } else if (invoiceListModel == null && newModel.data != null) {
            invoiceListModel = newModel;
          }
          // Update pagination metadata safely
          if (newModel.offset != null) {
            invoiceListModel?.offset = newModel.offset;
          }
          if (newModel.totalSize != null) {
            invoiceListModel?.totalSize = newModel.totalSize;
          }
        }
        isLoading = false;
      } else {
        isLoading = false;
        ApiChecker.checkApi(response);
      }
    } catch (e) {
      isLoading = false;
      showCustomSnackBar('failed_to_load_invoices'.tr, isError: true);
    }
    update();
  }

  Future<void> getInvoiceDetail(String invoiceId) async {
    if (invoiceId.isEmpty) {
      showCustomSnackBar('invalid_invoice_id'.tr, isError: true);
      return;
    }

    isDetailLoading = true;
    update();

    try {
      Response response = await invoiceServiceInterface.getInvoiceDetail(invoiceId);

      if (response.statusCode == 200) {
        // The response contains trip details, convert it to invoice data
        try {
          TripDetailsModel tripModel = TripDetailsModel.fromJson(response.body);
          if (tripModel.data != null) {
            // Convert TripDetails to InvoiceData
            InvoiceData invoiceData = _convertTripToInvoice(tripModel.data!);
            invoiceDetailModel = InvoiceDetailModel(data: invoiceData);
          } else {
            showCustomSnackBar('no_invoice_found'.tr, isError: true);
          }
        } catch (parseError) {
          // Try to parse as InvoiceDetailModel if conversion fails
          invoiceDetailModel = InvoiceDetailModel.fromJson(response.body);
          if (invoiceDetailModel?.data == null) {
            showCustomSnackBar('no_invoice_found'.tr, isError: true);
          }
        }
        isDetailLoading = false;
      } else {
        isDetailLoading = false;
        ApiChecker.checkApi(response);
      }
    } catch (e) {
      isDetailLoading = false;
      showCustomSnackBar('failed_to_load_invoice_detail'.tr, isError: true);
    }
    update();
  }

  /// Convert TripDetails to InvoiceData
  InvoiceData _convertTripToInvoice(TripDetails trip) {
    return InvoiceData(
      id: trip.id,
      invoiceNumber: trip.refId,
      tripId: trip.id,
      tripRefId: trip.refId,
      baseFare: trip.baseFare,
      distanceFare: trip.distanceFare,
      waitingFare: trip.waitingFareDouble,
      totalFare: double.tryParse(trip.totalFare?.toString() ?? '0') ?? 0.0,
      paidAmount: trip.paidFare,
      discount: trip.couponAmount,
      tax: trip.vatTax,
      paymentMethod: trip.paymentMethod,
      paymentStatus: trip.paymentStatus,
      invoiceStatus: trip.currentStatus,
      pickupAddress: trip.pickupAddress,
      destinationAddress: trip.destinationAddress,
      createdAt: trip.createdAt,
      driverName: '${trip.driver?.firstName ?? ''} ${trip.driver?.lastName ?? ''}',
      driverPhone: trip.driver?.phone,
      vehicleNumber: trip.vehicle?.licencePlateNumber,
      rating: double.tryParse(trip.driverAvgRating?.toString() ?? '0') ?? 0.0,
    );
  }

  bool get hasInvoices => invoiceListModel?.data != null && invoiceListModel!.data!.isNotEmpty;

  bool get hasMoreInvoices =>
      (invoiceListModel?.offset ?? 0) < (invoiceListModel?.totalSize ?? 0);

  /// Safe wrapper for pagination - validates offset before loading more invoices
  Future<void> loadMoreInvoices() async {
    if (!hasMoreInvoices) {
      showCustomSnackBar('no_more_invoices'.tr, isError: false);
      return;
    }

    final currentOffset = invoiceListModel?.offset ?? 1;
    final nextOffset = currentOffset + 1;
    
    try {
      await getInvoiceListWithOffset(nextOffset);
    } catch (e) {
      showCustomSnackBar('failed_to_load_more_invoices'.tr, isError: true);
    }
  }

  /// Safe wrapper for invoice detail - validates invoice ID before loading
  Future<void> loadInvoiceDetail(String? invoiceId) async {
    if (invoiceId == null || invoiceId.isEmpty) {
      showCustomSnackBar('invalid_invoice_id'.tr, isError: true);
      return;
    }

    try {
      await getInvoiceDetail(invoiceId);
    } catch (e) {
      showCustomSnackBar('failed_to_load_invoice_detail'.tr, isError: true);
    }
  }
}

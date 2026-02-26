import 'package:get/get.dart';
import 'package:ride_sharing_user_app/data/api_client.dart';
import 'package:ride_sharing_user_app/features/invoice/domain/repositories/invoice_repository_interface.dart';
import 'package:ride_sharing_user_app/util/app_constants.dart';

class InvoiceRepository implements InvoiceRepositoryInterface {
  final ApiClient apiClient;

  InvoiceRepository({required this.apiClient});

  @override
  Future<Response> getInvoiceList(int offset) async {
    return await apiClient.getData('${AppConstants.GET_INVOICE_LIST}?offset=$offset');
  }

  @override
  Future<Response> getInvoiceDetail(String invoiceId) async {
    // Instead of calling invoice API, fetch trip details which contains the invoice information
    // The invoiceId here is actually the tripId
    return await apiClient.getData('${AppConstants.tripDetails}$invoiceId');
  }
}

import 'package:get/get.dart';
import 'package:ride_sharing_user_app/features/invoice/domain/repositories/invoice_repository_interface.dart';
import 'package:ride_sharing_user_app/features/invoice/domain/services/invoice_service_interface.dart';

class InvoiceService implements InvoiceServiceInterface {
  final InvoiceRepositoryInterface invoiceRepositoryInterface;

  InvoiceService({required this.invoiceRepositoryInterface});

  @override
  Future<Response> getInvoiceList(int offset) async {
    return await invoiceRepositoryInterface.getInvoiceList(offset);
  }

  @override
  Future<Response> getInvoiceDetail(String invoiceId) async {
    return await invoiceRepositoryInterface.getInvoiceDetail(invoiceId);
  }
}

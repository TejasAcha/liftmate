import 'package:get/get.dart';

abstract class InvoiceRepositoryInterface {
  Future<Response> getInvoiceList(int offset);
  Future<Response> getInvoiceDetail(String invoiceId);
}

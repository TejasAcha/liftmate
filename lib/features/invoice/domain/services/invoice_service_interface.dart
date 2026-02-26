import 'package:get/get.dart';

abstract class InvoiceServiceInterface {
  Future<Response> getInvoiceList(int offset);
  Future<Response> getInvoiceDetail(String invoiceId);
}

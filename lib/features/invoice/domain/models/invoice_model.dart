class InvoiceListModel {
  List<InvoiceData>? data;
  int? totalSize;
  int? offset;

  InvoiceListModel({this.data, this.totalSize, this.offset});

  InvoiceListModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <InvoiceData>[];
      json['data'].forEach((v) {
        data!.add(InvoiceData.fromJson(v));
      });
    }
    totalSize = json['total_size'];
    offset = json['offset'];
  }
}

class InvoiceData {
  String? id;
  String? invoiceNumber;
  String? tripId;
  String? tripRefId;
  double? baseFare;
  double? distanceFare;
  double? waitingFare;
  double? totalFare;
  double? paidAmount;
  double? discount;
  double? tax;
  String? paymentMethod;
  String? paymentStatus;
  String? invoiceStatus;
  String? pickupAddress;
  String? destinationAddress;
  String? createdAt;
  String? driverName;
  String? driverPhone;
  String? vehicleNumber;
  double? rating;

  InvoiceData({
    this.id,
    this.invoiceNumber,
    this.tripId,
    this.tripRefId,
    this.baseFare,
    this.distanceFare,
    this.waitingFare,
    this.totalFare,
    this.paidAmount,
    this.discount,
    this.tax,
    this.paymentMethod,
    this.paymentStatus,
    this.invoiceStatus,
    this.pickupAddress,
    this.destinationAddress,
    this.createdAt,
    this.driverName,
    this.driverPhone,
    this.vehicleNumber,
    this.rating,
  });

  InvoiceData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    invoiceNumber = json['invoice_number'];
    tripId = json['trip_id'];
    tripRefId = json['trip_ref_id'];
    baseFare = json['base_fare'] != null ? double.parse(json['base_fare'].toString()) : 0.0;
    distanceFare = json['distance_fare'] != null ? double.parse(json['distance_fare'].toString()) : 0.0;
    waitingFare = json['waiting_fare'] != null ? double.parse(json['waiting_fare'].toString()) : 0.0;
    totalFare = json['total_fare'] != null ? double.parse(json['total_fare'].toString()) : 0.0;
    paidAmount = json['paid_amount'] != null ? double.parse(json['paid_amount'].toString()) : 0.0;
    discount = json['discount'] != null ? double.parse(json['discount'].toString()) : 0.0;
    tax = json['tax'] != null ? double.parse(json['tax'].toString()) : 0.0;
    paymentMethod = json['payment_method'];
    paymentStatus = json['payment_status'];
    invoiceStatus = json['invoice_status'];
    pickupAddress = json['pickup_address'];
    destinationAddress = json['destination_address'];
    createdAt = json['created_at'];
    driverName = json['driver_name'];
    driverPhone = json['driver_phone'];
    vehicleNumber = json['vehicle_number'];
    rating = json['rating'] != null ? double.parse(json['rating'].toString()) : 0.0;
  }
}

class InvoiceDetailModel {
  InvoiceData? data;

  InvoiceDetailModel({this.data});

  InvoiceDetailModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? InvoiceData.fromJson(json['data']) : null;
  }
}

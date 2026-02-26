class SeatShareModel {
  final String id;
  final String vehicleType; // 'car', 'car_mini', etc.
  final int totalSeats;
  final List<SeatInfo> seats;
  final double pricePerSeat;

  SeatShareModel({
    required this.id,
    required this.vehicleType,
    required this.totalSeats,
    required this.seats,
    required this.pricePerSeat,
  });

  factory SeatShareModel.fromJson(Map<String, dynamic> json) {
    List<SeatInfo> seats = [];
    if (json['seats'] != null) {
      seats = (json['seats'] as List)
          .map((seat) => SeatInfo.fromJson(seat))
          .toList();
    }

    return SeatShareModel(
      id: json['id'] ?? '',
      vehicleType: json['vehicle_type'] ?? 'car',
      totalSeats: json['total_seats'] ?? 4,
      seats: seats,
      pricePerSeat: (json['price_per_seat'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'vehicle_type': vehicleType,
      'total_seats': totalSeats,
      'seats': seats.map((seat) => seat.toJson()).toList(),
      'price_per_seat': pricePerSeat,
    };
  }
}

class SeatInfo {
  final int seatNumber;
  final String status; // 'available', 'reserved', 'occupied'
  final String? passengerName;
  final String? passengerPhone;

  SeatInfo({
    required this.seatNumber,
    required this.status,
    this.passengerName,
    this.passengerPhone,
  });

  factory SeatInfo.fromJson(Map<String, dynamic> json) {
    return SeatInfo(
      seatNumber: json['seat_number'] ?? 0,
      status: json['status'] ?? 'available',
      passengerName: json['passenger_name'],
      passengerPhone: json['passenger_phone'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'seat_number': seatNumber,
      'status': status,
      'passenger_name': passengerName,
      'passenger_phone': passengerPhone,
    };
  }
}

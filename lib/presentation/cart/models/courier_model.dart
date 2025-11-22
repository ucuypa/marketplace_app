class CourierModel {
  final String id;
  final String name;
  final String service;
  final double price;
  final String estimate;

  const CourierModel({
    required this.id,
    required this.name,
    required this.service,
    required this.price,
    required this.estimate,
  });
}

const List<CourierModel> kCouriers = [
  CourierModel(
    id: 'jne_reg',
    name: 'JNE',
    service: 'Regular',
    price: 10.00,
    estimate: '3-5 Days',
  ),
  CourierModel(
    id: 'jne_yes',
    name: 'JNE',
    service: 'Express (YES)',
    price: 25.00,
    estimate: '1 Day',
  ),
  CourierModel(
    id: 'sicepat',
    name: 'SiCepat',
    service: 'Gokil',
    price: 12.00,
    estimate: '2-4 Days',
  ),
  CourierModel(
    id: 'gojek',
    name: 'GoSend',
    service: 'Instant',
    price: 40.00,
    estimate: '2 Hours',
  ),
];

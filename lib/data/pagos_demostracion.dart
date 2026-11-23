import '../models/pago.dart';

final List<Pago> pagosIniciales = [
  Pago(
    id: '1',
    concepto: 'Energía eléctrica',
    monto: 85.0,
    categoria: 'Servicios',
    fechaVencimiento: DateTime.now().subtract(const Duration(days: 2)),
    nota: 'Factura del mes',
    estado: EstadoPago.pendiente,
  ),
  Pago(
    id: '2',
    concepto: 'Arriendo',
    monto: 450.0,
    categoria: 'Vivienda',
    fechaVencimiento: DateTime.now().add(const Duration(days: 5)),
    estado: EstadoPago.pendiente,
  ),
  Pago(
    id: '3',
    concepto: 'Bus urbano',
    monto: 30.0,
    categoria: 'Transporte',
    fechaVencimiento: DateTime.now().subtract(const Duration(days: 1)),
    estado: EstadoPago.pagado,
  ),
];

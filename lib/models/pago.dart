enum EstadoPago { pendiente, pagado }

class Pago {
  final String id;
  String concepto;
  double monto;
  String categoria;
  DateTime fechaVencimiento;
  String nota;
  EstadoPago estado;

  Pago({
    required this.id,
    required this.concepto,
    required this.monto,
    required this.categoria,
    required this.fechaVencimiento,
    this.nota = '',
    this.estado = EstadoPago.pendiente,
  });

  bool get estaVencido {
    final hoy = DateTime.now();
    final soloHoy = DateTime(hoy.year, hoy.month, hoy.day);
    final soloVence = DateTime(
      fechaVencimiento.year,
      fechaVencimiento.month,
      fechaVencimiento.day,
    );
    return estado == EstadoPago.pendiente && soloVence.isBefore(soloHoy);
  }
}


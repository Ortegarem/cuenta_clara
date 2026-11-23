String formatearMoneda(double valor) => '\$${valor.toStringAsFixed(2)}';

String formatearFecha(DateTime fecha) {
  final d = fecha.day.toString().padLeft(2, '0');
  final m = fecha.month.toString().padLeft(2, '0');
  return '$d/$m/${fecha.year}';
}


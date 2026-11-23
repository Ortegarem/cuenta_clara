import 'package:flutter/material.dart';
import '../models/pago.dart';
import '../utils/formato.dart';

class ResumenPagos extends StatelessWidget {
  final List<Pago> pagos;

  const ResumenPagos({super.key, required this.pagos});

  @override
  Widget build(BuildContext context) {
    final pendiente = pagos
        .where((p) => p.estado == EstadoPago.pendiente)
        .fold(0.0, (acc, p) => acc + p.monto);

    final pagado = pagos
        .where((p) => p.estado == EstadoPago.pagado)
        .fold(0.0, (acc, p) => acc + p.monto);

    final vencidas = pagos.where((p) => p.estaVencido).length;

    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          _CajaResumen(
            titulo: 'Pendiente',
            valor: formatearMoneda(pendiente),
            color: Colors.orange.shade100,
          ),
          const SizedBox(width: 8),
          _CajaResumen(
            titulo: 'Pagado',
            valor: formatearMoneda(pagado),
            color: Colors.green.shade100,
          ),
          const SizedBox(width: 8),
          _CajaResumen(
            titulo: 'Vencidas',
            valor: '$vencidas',
            color: Colors.red.shade100,
          ),
        ],
      ),
    );
  }
}

class _CajaResumen extends StatelessWidget {
  final String titulo;
  final String valor;
  final Color color;

  const _CajaResumen({
    required this.titulo,
    required this.valor,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Text(titulo, style: const TextStyle(fontSize: 12)),
            const SizedBox(height: 4),
            Text(
              valor,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
          ],
        ),
      ),
    );
  }
}


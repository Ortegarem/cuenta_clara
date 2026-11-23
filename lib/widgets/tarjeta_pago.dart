import 'package:flutter/material.dart';
import '../models/pago.dart';
import '../utils/formato.dart';

class TarjetaPago extends StatelessWidget {
  final Pago pago;
  final VoidCallback onEditar;
  final VoidCallback onCambiarEstado;
  final VoidCallback onEliminar;

  const TarjetaPago({
    super.key,
    required this.pago,
    required this.onEditar,
    required this.onCambiarEstado,
    required this.onEliminar,
  });

  @override
  Widget build(BuildContext context) {
    final esPagado = pago.estado == EstadoPago.pagado;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        title: Row(
          children: [
            Expanded(
              child: Text(
                pago.concepto,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            if (pago.estaVencido)
              const Chip(
                label: Text('Vencida', style: TextStyle(fontSize: 11)),
                backgroundColor: Colors.redAccent,
              ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${pago.categoria} · Vence: ${formatearFecha(pago.fechaVencimiento)}',
            ),
            if (pago.nota.isNotEmpty) Text('Nota: ${pago.nota}'),
            Text(
              formatearMoneda(pago.monto),
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              tooltip: esPagado ? 'Marcar pendiente' : 'Marcar pagado',
              icon: Icon(
                esPagado ? Icons.undo : Icons.check_circle,
                color: esPagado ? Colors.orange : Colors.green,
              ),
              onPressed: onCambiarEstado,
            ),
            IconButton(
              tooltip: 'Editar',
              icon: const Icon(Icons.edit),
              onPressed: onEditar,
            ),
            IconButton(
              tooltip: 'Eliminar',
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: onEliminar,
            ),
          ],
        ),
      ),
    );
  }
}


import 'package:flutter/material.dart';
import '../data/pagos_demostracion.dart';
import '../models/pago.dart';
import '../widgets/resumen_pagos.dart';
import '../widgets/tarjeta_pago.dart';
import 'formulario_pago_screen.dart';

class InicioScreen extends StatefulWidget {
  const InicioScreen({super.key});

  @override
  State<InicioScreen> createState() => _InicioScreenState();
}

class _InicioScreenState extends State<InicioScreen> {
  final List<Pago> _pagos = List<Pago>.from(pagosIniciales);

  Future<void> _abrirFormulario({Pago? pagoExistente}) async {
    final resultado = await Navigator.push<Pago>(
      context,
      MaterialPageRoute(
        builder: (_) => FormularioPagoScreen(pagoExistente: pagoExistente),
      ),
    );
    if (resultado == null) return;

    setState(() {
      final idx = _pagos.indexWhere((p) => p.id == resultado.id);
      if (idx >= 0) {
        _pagos[idx] = resultado;
      } else {
        _pagos.add(resultado);
      }
    });
  }

  void _alternarEstado(Pago pago) {
    setState(() {
      pago.estado = pago.estado == EstadoPago.pendiente
          ? EstadoPago.pagado
          : EstadoPago.pendiente;
    });
  }

  Future<void> _confirmarEliminar(Pago pago) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Eliminar pago'),
        content: Text('¿Deseas eliminar "${pago.concepto}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );

    if (confirmar == true) {
      setState(() => _pagos.removeWhere((p) => p.id == pago.id));
    }
  }

  Widget _construirLista(List<Pago> filtrados) {
    if (filtrados.isEmpty) {
      return const Center(child: Text('No hay pagos en esta pestaña.'));
    }
    return ListView.builder(
      itemCount: filtrados.length,
      itemBuilder: (_, i) {
        final pago = filtrados[i];
        return TarjetaPago(
          pago: pago,
          onEditar: () => _abrirFormulario(pagoExistente: pago),
          onCambiarEstado: () => _alternarEstado(pago),
          onEliminar: () => _confirmarEliminar(pago),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final pendientes =
        _pagos.where((p) => p.estado == EstadoPago.pendiente).toList();
    final pagados =
        _pagos.where((p) => p.estado == EstadoPago.pagado).toList();

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('CuentaClara'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Todos'),
              Tab(text: 'Pendientes'),
              Tab(text: 'Pagados'),
            ],
          ),
        ),
        body: Column(
          children: [
            ResumenPagos(pagos: _pagos),
            Expanded(
              child: TabBarView(
                children: [
                  _construirLista(_pagos),
                  _construirLista(pendientes),
                  _construirLista(pagados),
                ],
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _abrirFormulario(),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}


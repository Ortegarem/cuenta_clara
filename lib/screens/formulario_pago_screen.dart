import 'package:flutter/material.dart';
import '../models/pago.dart';
import '../utils/formato.dart';

class FormularioPagoScreen extends StatefulWidget {
  final Pago? pagoExistente;

  const FormularioPagoScreen({super.key, this.pagoExistente});

  @override
  State<FormularioPagoScreen> createState() => _FormularioPagoScreenState();
}

class _FormularioPagoScreenState extends State<FormularioPagoScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _conceptoCtrl;
  late final TextEditingController _montoCtrl;
  late final TextEditingController _notaCtrl;
  late String _categoria;
  late DateTime _fechaVencimiento;
  late EstadoPago _estado;

  final _categorias = const ['Servicios', 'Vivienda', 'Transporte', 'Otros'];

  @override
  void initState() {
    super.initState();
    final p = widget.pagoExistente;
    _conceptoCtrl = TextEditingController(text: p?.concepto ?? '');
    _montoCtrl = TextEditingController(
      text: p != null ? p.monto.toString() : '',
    );
    _notaCtrl = TextEditingController(text: p?.nota ?? '');
    _categoria = p?.categoria ?? 'Servicios';
    _fechaVencimiento = p?.fechaVencimiento ?? DateTime.now();
    _estado = p?.estado ?? EstadoPago.pendiente;
  }

  @override
  void dispose() {
    _conceptoCtrl.dispose();
    _montoCtrl.dispose();
    _notaCtrl.dispose();
    super.dispose();
  }

  Future<void> _seleccionarFecha() async {
    final elegida = await showDatePicker(
      context: context,
      initialDate: _fechaVencimiento,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (elegida != null) {
      setState(() => _fechaVencimiento = elegida);
    }
  }

  void _guardar() {
    if (!_formKey.currentState!.validate()) return;

    final monto = double.parse(_montoCtrl.text.trim().replaceAll(',', '.'));
    final resultado = Pago(
      id: widget.pagoExistente?.id ??
          DateTime.now().microsecondsSinceEpoch.toString(),
      concepto: _conceptoCtrl.text.trim(),
      monto: monto,
      categoria: _categoria,
      fechaVencimiento: _fechaVencimiento,
      nota: _notaCtrl.text.trim(),
      estado: _estado,
    );

    Navigator.pop(context, resultado);
  }

  @override
  Widget build(BuildContext context) {
    final esEdicion = widget.pagoExistente != null;

    return Scaffold(
      appBar: AppBar(title: Text(esEdicion ? 'Editar pago' : 'Nuevo pago')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _conceptoCtrl,
                decoration: const InputDecoration(labelText: 'Concepto'),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) {
                    return 'El concepto es obligatorio';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _montoCtrl,
                decoration: const InputDecoration(labelText: 'Monto'),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                validator: (v) {
                  final valor =
                      double.tryParse((v ?? '').trim().replaceAll(',', '.'));
                  if (valor == null || valor <= 0) {
                    return 'El monto debe ser mayor a 0';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: _categoria,
                decoration: const InputDecoration(labelText: 'Categoría'),
                items: _categorias
                    .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                    .toList(),
                onChanged: (v) {
                  if (v != null) setState(() => _categoria = v);
                },
              ),
              const SizedBox(height: 12),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text('Vencimiento: ${formatearFecha(_fechaVencimiento)}'),
                trailing: const Icon(Icons.calendar_today),
                onTap: _seleccionarFecha,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<EstadoPago>(
                initialValue: _estado,
                decoration: const InputDecoration(labelText: 'Estado'),
                items: const [
                  DropdownMenuItem(
                      value: EstadoPago.pendiente, child: Text('Pendiente')),
                  DropdownMenuItem(
                      value: EstadoPago.pagado, child: Text('Pagado')),
                ],
                onChanged: (v) {
                  if (v != null) setState(() => _estado = v);
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _notaCtrl,
                decoration: const InputDecoration(labelText: 'Nota (opcional)'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _guardar,
                child: Text(esEdicion ? 'Guardar cambios' : 'Registrar pago'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


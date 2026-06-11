import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:drift/drift.dart' hide Column;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_theme.dart';
import '../../../data/database/app_database.dart';
import '../../providers/app_providers.dart';

/// Add or edit a product.
class AddProductScreen extends ConsumerStatefulWidget {
  final int? productId;

  const AddProductScreen({super.key, this.productId});

  @override
  ConsumerState<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends ConsumerState<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _priceCtrl = TextEditingController();
  final _sourceCtrl = TextEditingController();
  final _listingCtrl = TextEditingController();
  final _minPriceCtrl = TextEditingController();
  final _salePriceCtrl = TextEditingController();
  final _feesCtrl = TextEditingController();
  final _shippingCtrl = TextEditingController();
  final _packagingCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();

  String _status = 'bought';
  int _quantity = 1;
  int? _categoryId;
  DateTime _purchaseDate = DateTime.now();
  DateTime? _saleDate;
  String? _photoPath;

  bool get _isEditing => widget.productId != null;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    if (_isEditing) _loadProduct();
  }

  Future<void> _loadProduct() async {
    final dao = ref.read(productDaoProvider);
    final p = await dao.getById(widget.productId!);
    if (p == null || !mounted) return;

    setState(() {
      _nameCtrl.text = p.name;
      _descCtrl.text = p.description ?? '';
      _priceCtrl.text = p.purchasePrice.toStringAsFixed(2);
      _sourceCtrl.text = p.source;
      _status = p.status;
      _quantity = p.quantity;
      _categoryId = p.categoryId;
      _purchaseDate = p.purchaseDate;
      _listingCtrl.text = p.listingPrice?.toStringAsFixed(2) ?? '';
      _minPriceCtrl.text = p.minPrice?.toStringAsFixed(2) ?? '';
      _salePriceCtrl.text = p.salePrice?.toStringAsFixed(2) ?? '';
      _saleDate = p.saleDate;
      _feesCtrl.text = p.vintedFees.toStringAsFixed(2);
      _shippingCtrl.text = p.shippingCost.toStringAsFixed(2);
      _packagingCtrl.text = p.packagingCost.toStringAsFixed(2);
      _notesCtrl.text = p.notes ?? '';
      _photoPath = p.photoPath;
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _descCtrl.dispose();
    _priceCtrl.dispose();
    _sourceCtrl.dispose();
    _listingCtrl.dispose();
    _minPriceCtrl.dispose();
    _salePriceCtrl.dispose();
    _feesCtrl.dispose();
    _shippingCtrl.dispose();
    _packagingCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickPhoto() async {
    final picker = ImagePicker();
    final xFile = await picker.pickImage(source: ImageSource.gallery);
    if (xFile != null) setState(() => _photoPath = xFile.path);
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final dao = ref.read(productDaoProvider);
    final now = DateTime.now();

    final companion = ProductsCompanion(
      id: _isEditing ? Value(widget.productId!) : const Value.absent(),
      name: Value(_nameCtrl.text.trim()),
      description: Value(_descCtrl.text.trim().isEmpty ? null : _descCtrl.text.trim()),
      categoryId: Value(_categoryId ?? 1),
      quantity: Value(_quantity),
      purchasePrice: Value(double.parse(_priceCtrl.text.replaceAll(',', '.'))),
      purchaseDate: Value(_purchaseDate),
      source: Value(_sourceCtrl.text.trim().isEmpty ? 'Vinted' : _sourceCtrl.text.trim()),
      status: Value(_status),
      listingPrice: Value(_listingCtrl.text.isEmpty ? null : double.tryParse(_listingCtrl.text.replaceAll(',', '.'))),
      minPrice: Value(_minPriceCtrl.text.isEmpty ? null : double.tryParse(_minPriceCtrl.text.replaceAll(',', '.'))),
      salePrice: Value(_salePriceCtrl.text.isEmpty ? null : double.tryParse(_salePriceCtrl.text.replaceAll(',', '.'))),
      saleDate: Value(_saleDate),
      vintedFees: Value(double.tryParse(_feesCtrl.text.replaceAll(',', '.')) ?? 0),
      shippingCost: Value(double.tryParse(_shippingCtrl.text.replaceAll(',', '.')) ?? 0),
      packagingCost: Value(double.tryParse(_packagingCtrl.text.replaceAll(',', '.')) ?? 0),
      notes: Value(_notesCtrl.text.trim().isEmpty ? null : _notesCtrl.text.trim()),
      photoPath: Value(_photoPath),
      createdAt: _isEditing ? const Value.absent() : Value(now),
      updatedAt: Value(now),
    );

    if (_isEditing) {
      await dao.updateProduct(companion);
    } else {
      await dao.insert(companion);
    }

    HapticFeedback.mediumImpact();
    if (mounted) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    if (_isEditing && _isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Modifier')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final cs = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Modifier' : 'Nouvel achat'),
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
          children: [
            // ── Photo ────────────────────────────────────────────────────────
            GestureDetector(
              onTap: _pickPhoto,
              child: Container(
                height: 200,
                decoration: BoxDecoration(
                  color: cs.surfaceContainerHighest.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: cs.outlineVariant),
                ),
                clipBehavior: Clip.antiAlias,
                child: _photoPath != null
                    ? Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.file(File(_photoPath!), fit: BoxFit.cover),
                          Positioned(
                            top: 8,
                            right: 8,
                            child: GestureDetector(
                              onTap: () => setState(() => _photoPath = null),
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: Colors.black54,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(Icons.close, color: Colors.white, size: 16),
                              ),
                            ),
                          ),
                        ],
                      )
                    : Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.camera_alt_outlined, size: 36, color: cs.onSurfaceVariant),
                            const SizedBox(height: 8),
                            Text('Ajouter une photo', style: textTheme.bodyMedium?.copyWith(color: cs.onSurfaceVariant)),
                          ],
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 20),

            // ── Status ───────────────────────────────────────────────────────
            Text('Statut', style: textTheme.titleSmall),
            const SizedBox(height: 8),
            SegmentedButton<String>(
              segments: const [
                ButtonSegment(value: 'bought', label: Text('Stock')),
                ButtonSegment(value: 'listed', label: Text('En ligne')),
                ButtonSegment(value: 'sold', label: Text('Vendu')),
              ],
              selected: {_status},
              onSelectionChanged: (s) => setState(() => _status = s.first),
              style: SegmentedButton.styleFrom(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 16),

            // ── Name ─────────────────────────────────────────────────────────
            TextFormField(
              controller: _nameCtrl,
              decoration: const InputDecoration(labelText: 'Nom du produit'),
              validator: (v) => v == null || v.trim().isEmpty ? 'Requis' : null,
            ),
            const SizedBox(height: 12),

            // ── Description ──────────────────────────────────────────────────
            TextFormField(
              controller: _descCtrl,
              decoration: const InputDecoration(labelText: 'Description (optionnelle)'),
              maxLines: 2,
            ),
            const SizedBox(height: 12),

            // ── Row: Price + Quantity ────────────────────────────────────────
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _priceCtrl,
                    decoration: const InputDecoration(labelText: 'Prix achat (€)'),
                    keyboardType: TextInputType.number,
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) return 'Requis';
                      if (double.tryParse(v.replaceAll(',', '.')) == null) return 'Invalide';
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 12),
                SizedBox(
                  width: 80,
                  child: Column(
                    children: [
                      Text('Qté', style: textTheme.bodySmall),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove, size: 18),
                            onPressed: _quantity > 1 ? () => setState(() => _quantity--) : null,
                            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                          ),
                          Text('$_quantity', style: textTheme.titleMedium),
                          IconButton(
                            icon: const Icon(Icons.add, size: 18),
                            onPressed: () => setState(() => _quantity++),
                            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // ── Source + Date ────────────────────────────────────────────────
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _sourceCtrl,
                    decoration: const InputDecoration(labelText: 'Provenance'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: GestureDetector(
                    onTap: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: _purchaseDate,
                        firstDate: DateTime(2020),
                        lastDate: DateTime.now(),
                      );
                      if (date != null) setState(() => _purchaseDate = date);
                    },
                    child: InputDecorator(
                      decoration: const InputDecoration(labelText: 'Date achat'),
                      child: Text(DateFormat('dd/MM/yyyy').format(_purchaseDate)),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // ── Sales section ────────────────────────────────────────────────
            Divider(color: cs.outlineVariant),
            const SizedBox(height: 8),
            Text('Vente', style: textTheme.titleSmall),
            const SizedBox(height: 8),

            if (_status == 'sold') ...[
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _salePriceCtrl,
                      decoration: const InputDecoration(labelText: 'Prix vendu (€)'),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GestureDetector(
                      onTap: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: _saleDate ?? DateTime.now(),
                          firstDate: DateTime(2020),
                          lastDate: DateTime.now(),
                        );
                        if (date != null) setState(() => _saleDate = date);
                      },
                      child: InputDecorator(
                        decoration: const InputDecoration(labelText: 'Date vente'),
                        child: Text(DateFormat('dd/MM/yyyy').format(_saleDate ?? DateTime.now())),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
            ],

            TextFormField(
              controller: _listingCtrl,
              decoration: const InputDecoration(labelText: 'Prix de mise en ligne (€)'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _minPriceCtrl,
              decoration: const InputDecoration(labelText: 'Prix minimum (€)'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),

            // ── Fees section ─────────────────────────────────────────────────
            Divider(color: cs.outlineVariant),
            const SizedBox(height: 8),
            Text('Frais', style: textTheme.titleSmall),
            const SizedBox(height: 8),

            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _feesCtrl,
                    decoration: const InputDecoration(labelText: 'Frais Vinted (€)'),
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: _shippingCtrl,
                    decoration: const InputDecoration(labelText: 'Envoi (€)'),
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _packagingCtrl,
              decoration: const InputDecoration(labelText: 'Emballage (€)'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),

            // ── Notes ────────────────────────────────────────────────────────
            TextFormField(
              controller: _notesCtrl,
              decoration: const InputDecoration(labelText: 'Notes (optionnel)'),
              maxLines: 3,
            ),
            const SizedBox(height: 32),

            // ── Save ─────────────────────────────────────────────────────────
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _save,
                child: Text(_isEditing ? 'Enregistrer' : 'Ajouter l\'article'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

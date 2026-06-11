import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:drift/drift.dart' hide Column;
import 'package:uuid/uuid.dart';

import '../../providers/app_providers.dart';
import '../../../data/database/app_database.dart';

/// Add/Edit item screen — full form for creating or updating a product.
class AddEditItemScreen extends ConsumerStatefulWidget {
  final int? id;

  const AddEditItemScreen({super.key, this.id});

  @override
  ConsumerState<AddEditItemScreen> createState() => _AddEditItemScreenState();
}

class _AddEditItemScreenState extends ConsumerState<AddEditItemScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _purchasePriceController;
  late final TextEditingController _listingPriceController;
  late final TextEditingController _minPriceController;
  late final TextEditingController _salePriceController;
  late final TextEditingController _vintedFeesController;
  late final TextEditingController _shippingCostController;
  late final TextEditingController _packagingCostController;
  late final TextEditingController _notesController;

  int? _categoryId;
  DateTime _purchaseDate = DateTime.now();
  DateTime? _saleDate;
  String _source = 'Vinted';
  String _status = 'bought';
  bool _isLoading = false;
  bool _isInitialized = false;

  int _quantity = 1;
  String? _photoPath;

  static const _sources = ['Vinted', 'AliExpress', 'Autre'];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _descriptionController = TextEditingController();
    _purchasePriceController = TextEditingController();
    _listingPriceController = TextEditingController();
    _minPriceController = TextEditingController();
    _salePriceController = TextEditingController();
    _vintedFeesController = TextEditingController();
    _shippingCostController = TextEditingController();
    _packagingCostController = TextEditingController();
    _notesController = TextEditingController();

    // Auto-calc vinted fees when sale price changes
    _salePriceController.addListener(_autoCalcVintedFees);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _purchasePriceController.dispose();
    _listingPriceController.dispose();
    _minPriceController.dispose();
    _salePriceController.removeListener(_autoCalcVintedFees);
    _salePriceController.dispose();
    _vintedFeesController.dispose();
    _shippingCostController.dispose();
    _packagingCostController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  /// Auto-calculate Vinted fees as 5% of sale price.
  void _autoCalcVintedFees() {
    final saleText = _salePriceController.text;
    final salePrice = double.tryParse(saleText.replaceAll(',', '.'));
    if (salePrice != null && salePrice > 0) {
      final fees = salePrice * 0.05;
      _vintedFeesController.text = fees.toStringAsFixed(2);
    } else {
      _vintedFeesController.text = '0.00';
    }
  }

  /// Calculate net profit from current form values.
  double get _netProfit {
    final purchasePrice =
        double.tryParse(_purchasePriceController.text.replaceAll(',', '.')) ??
            0.0;
    final salePrice =
        double.tryParse(_salePriceController.text.replaceAll(',', '.')) ?? 0.0;
    final vintedFees =
        double.tryParse(_vintedFeesController.text.replaceAll(',', '.')) ?? 0.0;
    final shippingCost =
        double.tryParse(_shippingCostController.text.replaceAll(',', '.')) ??
            0.0;
    final packagingCost =
        double.tryParse(_packagingCostController.text.replaceAll(',', '.')) ??
            0.0;

    if (salePrice > 0) {
      return salePrice - purchasePrice - vintedFees - shippingCost - packagingCost;
    }
    return 0.0;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isEditing = widget.id != null;

    // Load existing product if editing
    if (isEditing && !_isInitialized) {
      _loadProduct();
    }

    final categoriesAsync = ref.watch(categoriesStreamProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Modifier l\'article' : 'Ajouter un article'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 80),
          children: [
            // ── Nom ─────────────────────────────────────────────────────
            _sectionLabel('Nom *', theme),
            const SizedBox(height: 6),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                hintText: 'Ex. : Levi\'s 501',
              ),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Le nom est requis' : null,
            ),
            const SizedBox(height: 16),

            // ── Quantité ───────────────────────────────────────────────
            _sectionLabel('Quantité', theme),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: colorScheme.outline,
                ),
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove),
                    onPressed: _quantity > 1
                        ? () => setState(() => _quantity--)
                        : null,
                  ),
                  const Spacer(),
                  Text(
                    '$_quantity',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: _quantity < 99
                        ? () => setState(() => _quantity++)
                        : null,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // ── Description ──────────────────────────────────────────────
            _sectionLabel('Description', theme),
            const SizedBox(height: 6),
            TextFormField(
              controller: _descriptionController,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: 'État, taille, couleur, notes...',
              ),
            ),
            const SizedBox(height: 16),

            // ── Catégorie ─────────────────────────────────────────────────
            _sectionLabel('Catégorie', theme),
            const SizedBox(height: 6),
            categoriesAsync.when(
              data: (categories) => DropdownButtonFormField<int>(
                initialValue: _categoryId,
                decoration: const InputDecoration(
                  hintText: 'Sélectionnez une catégorie',
                ),
                items: categories
                    .map(
                      (cat) => DropdownMenuItem(
                        value: cat.id,
                        child: Text(cat.name),
                      ),
                    )
                    .toList(),
                onChanged: (v) => setState(() => _categoryId = v),
              ),
              loading: () => DropdownButtonFormField<int>(
                items: [],
                onChanged: null,
                decoration: InputDecoration(hintText: 'Chargement...'),
              ),
              error: (e, _) => Text('Erreur : $e'),
            ),
            const SizedBox(height: 16),

            // ── Prix d'achat ───────────────────────────────────────────
            _sectionLabel('Prix d\'achat *', theme),
            const SizedBox(height: 6),
            TextFormField(
              controller: _purchasePriceController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                prefixText: '\u20ac ',
                hintText: '0.00',
              ),
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Requis';
                final val = double.tryParse(v.replaceAll(',', '.'));
                if (val == null || val <= 0) return 'Doit être > 0';
                return null;
              },
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 16),

            // ── Date d'achat ────────────────────────────────────────────
            _sectionLabel('Date d\'achat', theme),
            const SizedBox(height: 6),
            _DatePickerField(
              date: _purchaseDate,
              onTap: () => _pickDate(
                context,
                initial: _purchaseDate,
                onPicked: (d) => setState(() => _purchaseDate = d),
              ),
            ),
            const SizedBox(height: 16),

            // ── Source ───────────────────────────────────────────────────
            _sectionLabel('Source', theme),
            const SizedBox(height: 6),
            DropdownButtonFormField<String>(
              initialValue: _source,
              decoration: const InputDecoration(),
              items: _sources
                  .map(
                    (s) => DropdownMenuItem(value: s, child: Text(s)),
                  )
                  .toList(),
              onChanged: (v) => setState(() => _source = v ?? 'Vinted'),
            ),
            const SizedBox(height: 16),

            // ── Prix annoncé ────────────────────────────────────────────
            _sectionLabel('Prix annoncé', theme),
            const SizedBox(height: 6),
            TextFormField(
              controller: _listingPriceController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                prefixText: '\u20ac ',
                hintText: '0.00',
              ),
            ),
            const SizedBox(height: 16),

            // ── Prix minimum ────────────────────────────────────────────
            _sectionLabel('Prix minimum', theme),
            const SizedBox(height: 6),
            TextFormField(
              controller: _minPriceController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                prefixText: '\u20ac ',
                hintText: 'Pour les négociations',
              ),
            ),
            const SizedBox(height: 16),

            // ── Statut ───────────────────────────────────────────────────
            _sectionLabel('Statut', theme),
            const SizedBox(height: 6),
            SegmentedButton<String>(
              segments: const [
                ButtonSegment(value: 'bought', label: Text('Acheté')),
                ButtonSegment(value: 'listed', label: Text('En ligne')),
                ButtonSegment(value: 'sold', label: Text('Vendu')),
              ],
              selected: {_status},
              onSelectionChanged: (v) =>
                  setState(() => _status = v.first),
              style: SegmentedButton.styleFrom(
                selectedBackgroundColor: colorScheme.primary.withValues(alpha: 0.2),
                selectedForegroundColor: colorScheme.primary,
              ),
            ),
            const SizedBox(height: 16),

            // ── Sale fields (visible when status = sold) ─────────────────
            if (_status == 'sold') ...[
              // Sale Price
              _sectionLabel('Prix de vente', theme),
              const SizedBox(height: 6),
              TextFormField(
                controller: _salePriceController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  prefixText: '\u20ac ',
                  hintText: '0.00',
                ),
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 16),

              // Sale Date
              _sectionLabel('Date de vente', theme),
              const SizedBox(height: 6),
              _DatePickerField(
                date: _saleDate ?? DateTime.now(),
                label: _saleDate != null
                    ? DateFormat('dd/MM/yyyy').format(_saleDate!)
                    : 'Sélectionnez une date',
                onTap: () => _pickDate(
                  context,
                  initial: _saleDate ?? DateTime.now(),
                  onPicked: (d) => setState(() => _saleDate = d),
                ),
              ),
              const SizedBox(height: 16),
            ],

            // ── Vinted Fees ─────────────────────────────────────────────
            _sectionLabel('Vinted Fees', theme),
            const SizedBox(height: 6),
            TextFormField(
              controller: _vintedFeesController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                prefixText: '\u20ac ',
                hintText: 'Auto-calculated (5% of sale)',
              ),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 16),

            // ── Shipping Cost ────────────────────────────────────────────
            _sectionLabel('Shipping Cost', theme),
            const SizedBox(height: 6),
            TextFormField(
              controller: _shippingCostController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                prefixText: '\u20ac ',
                hintText: '0.00',
              ),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 16),

            // ── Packaging Cost ───────────────────────────────────────────
            _sectionLabel('Packaging Cost', theme),
            const SizedBox(height: 6),
            TextFormField(
              controller: _packagingCostController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                prefixText: '\u20ac ',
                hintText: '0.00',
              ),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 16),

            // ── Net Profit Display (live) ────────────────────────────────
            if (_salePriceController.text.isNotEmpty &&
                double.tryParse(_salePriceController.text
                        .replaceAll(',', '.')) !=
                    null &&
                double.parse(
                        _salePriceController.text.replaceAll(',', '.')) >
                    0) ...[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFEEF9D0),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Net Profit',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      '\u20ac${_netProfit.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'monospace',
                        color: _netProfit >= 0
                            ? const Color(0xFF2E7D32)
                            : const Color(0xFFC62828),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],

            // ── Notes ────────────────────────────────────────────────────
            _sectionLabel('Notes', theme),
            const SizedBox(height: 6),
            TextFormField(
              controller: _notesController,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: 'Any additional information...',
              ),
            ),
            const SizedBox(height: 16),

            // ── Photo ─────────────────────────────────────────────────────
            _sectionLabel('Photo', theme),
            const SizedBox(height: 6),
            GestureDetector(
              onTap: _showImagePickerOptions,
              child: Container(
                height: 140,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: colorScheme.outline,
                    width: 1.5,
                  ),
                ),
                child: _photoPath != null
                    ? Stack(
                        fit: StackFit.expand,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(11),
                            child: Image.file(
                              File(_photoPath!),
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            top: 4,
                            right: 4,
                            child: GestureDetector(
                              onTap: () => setState(() => _photoPath = null),
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(
                                  color: Colors.black54,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.close,
                                  size: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    : const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add_a_photo_outlined, size: 32),
                            SizedBox(height: 6),
                            Text(
                              'Ajouter une photo',
                              style: TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 24),

            // ── Save Button ──────────────────────────────────────────────
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _saveProduct,
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  foregroundColor: colorScheme.onPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Text(
                        isEditing ? 'Update Item' : 'Save Item',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // -----------------------------------------------------------------------
  // Helpers
  // -----------------------------------------------------------------------

  Widget _sectionLabel(String label, ThemeData theme) {
    return Text(
      label,
      style: theme.textTheme.labelLarge?.copyWith(
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Future<void> _pickDate(
    BuildContext context, {
    required DateTime initial,
    required ValueChanged<DateTime> onPicked,
  }) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      onPicked(picked);
    }
  }

  void _showImagePickerOptions() {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt_outlined),
              title: const Text('Prendre une photo'),
              onTap: () {
                Navigator.pop(ctx);
                _pickAndSaveImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: const Text('Choisir dans la galerie'),
              onTap: () {
                Navigator.pop(ctx);
                _pickAndSaveImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickAndSaveImage(ImageSource source) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: source, maxWidth: 1024);
    if (picked == null) return;
    final dir = await getApplicationDocumentsDirectory();
    final fileName = '${const Uuid().v4()}.jpg';
    final savedFile = await File(picked.path).copy(p.join(dir.path, fileName));
    if (!mounted) return;
    setState(() => _photoPath = savedFile.path);
  }

  Future<void> _loadProduct() async {
    if (_isInitialized) return;
    _isInitialized = true;

    final product =
        await ref.read(productDaoProvider).getById(widget.id!);
    if (product == null || !mounted) return;

    setState(() {
      _nameController.text = product.name;
      _descriptionController.text = product.description ?? '';
      _categoryId = product.categoryId;
      _purchasePriceController.text = product.purchasePrice.toStringAsFixed(2);
      _purchaseDate = product.purchaseDate;
      _source = product.source;
      _status = product.status;
      _quantity = product.quantity;
      _photoPath = product.photoPath;
      if (product.listingPrice != null) {
        _listingPriceController.text =
            product.listingPrice!.toStringAsFixed(2);
      }
      if (product.minPrice != null) {
        _minPriceController.text = product.minPrice!.toStringAsFixed(2);
      }
      if (product.salePrice != null) {
        _salePriceController.text = product.salePrice!.toStringAsFixed(2);
      }
      _saleDate = product.saleDate;
      _vintedFeesController.text = product.vintedFees.toStringAsFixed(2);
      _shippingCostController.text = product.shippingCost.toStringAsFixed(2);
      _packagingCostController.text = product.packagingCost.toStringAsFixed(2);
      _notesController.text = product.notes ?? '';
    });
  }

  Future<void> _saveProduct() async {
    if (!_formKey.currentState!.validate()) return;
    if (_categoryId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a category')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final dao = ref.read(productDaoProvider);
      final now = DateTime.now();

      double? parsePrice(String? text) {
        if (text == null || text.trim().isEmpty) return null;
        return double.tryParse(text.replaceAll(',', '.'));
      }

      final purchasePrice =
          parsePrice(_purchasePriceController.text) ?? 0.0;
      final salePrice = parsePrice(_salePriceController.text);
      final listingPrice = parsePrice(_listingPriceController.text);
      final minPrice = parsePrice(_minPriceController.text);
      final vintedFees = parsePrice(_vintedFeesController.text) ?? 0.0;
      final shippingCost = parsePrice(_shippingCostController.text) ?? 0.0;
      final packagingCost = parsePrice(_packagingCostController.text) ?? 0.0;

      if (widget.id != null) {
        // Update existing product
        await dao.updateProduct(
          ProductsCompanion(
            id: Value(widget.id!),
            name: Value(_nameController.text.trim()),
            description: _descriptionController.text.trim().isNotEmpty
                ? Value(_descriptionController.text.trim())
                : Value.absent(),
            categoryId: Value(_categoryId!),
            purchasePrice: Value(purchasePrice),
            purchaseDate: Value(_purchaseDate),
            source: Value(_source),
            status: Value(_status),
            quantity: Value(_quantity),
            photoPath: _photoPath != null
                ? Value(_photoPath)
                : Value.absent(),
            listingPrice: listingPrice != null
                ? Value(listingPrice)
                : Value.absent(),
            minPrice:
                minPrice != null ? Value(minPrice) : Value.absent(),
            salePrice:
                salePrice != null ? Value(salePrice) : Value.absent(),
            saleDate: _saleDate != null
                ? Value(_saleDate!)
                : Value.absent(),
            vintedFees: Value(vintedFees),
            shippingCost: Value(shippingCost),
            packagingCost: Value(packagingCost),
            notes: _notesController.text.trim().isNotEmpty
                ? Value(_notesController.text.trim())
                : Value.absent(),
            updatedAt: Value(now),
            createdAt: Value(now), // preserved by drift
          ),
        );
      } else {
        // Insert new product
        final now = DateTime.now();
        await dao.insert(
          ProductsCompanion(
            name: Value(_nameController.text.trim()),
            description: _descriptionController.text.trim().isNotEmpty
                ? Value(_descriptionController.text.trim())
                : Value.absent(),
            categoryId: Value(_categoryId!),
            purchasePrice: Value(purchasePrice),
            purchaseDate: Value(_purchaseDate),
            source: Value(_source),
            status: Value(_status),
            quantity: Value(_quantity),
            photoPath: _photoPath != null
                ? Value(_photoPath)
                : Value.absent(),
            listingPrice: Value(listingPrice),
            minPrice: Value(minPrice),
            salePrice: Value(salePrice),
            saleDate: Value(_saleDate),
            vintedFees: Value(vintedFees),
            shippingCost: Value(shippingCost),
            packagingCost: Value(packagingCost),
            notes: _notesController.text.trim().isNotEmpty
                ? Value(_notesController.text.trim())
                : Value.absent(),
            createdAt: Value(now),
            updatedAt: Value(now),
          ),
        );
      }

      if (mounted) {
        HapticFeedback.mediumImpact();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Article enregistré'),
            duration: Duration(seconds: 2),
          ),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}

// ---------------------------------------------------------------------------
// Date picker field widget
// ---------------------------------------------------------------------------

class _DatePickerField extends StatelessWidget {
  final DateTime date;
  final VoidCallback onTap;
  final String? label;

  const _DatePickerField({
    required this.date,
    required this.onTap,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    final displayLabel =
        label ?? DateFormat('dd/MM/yyyy').format(date);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Theme.of(context).cardTheme.color,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Theme.of(context).colorScheme.outline,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              displayLabel,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
            ),
            Icon(
              Icons.calendar_today_outlined,
              size: 18,
              color: Theme.of(context).colorScheme.primary,
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../shared/ui_constants.dart';
import 'address_model.dart';

class AddEditAddressPage extends StatefulWidget {
  final AddressModel? address; // If null, we are adding. If not null, editing.

  const AddEditAddressPage({super.key, this.address});

  @override
  State<AddEditAddressPage> createState() => _AddEditAddressPageState();
}

class _AddEditAddressPageState extends State<AddEditAddressPage> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  late TextEditingController _nameCtrl;
  late TextEditingController _phoneCtrl;
  late TextEditingController _streetCtrl;
  late TextEditingController _cityCtrl;
  late TextEditingController _zipCtrl;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Pre-fill if editing
    _nameCtrl = TextEditingController(text: widget.address?.name ?? '');
    _phoneCtrl = TextEditingController(text: widget.address?.phone ?? '');
    _streetCtrl = TextEditingController(text: widget.address?.street ?? '');
    _cityCtrl = TextEditingController(text: widget.address?.city ?? '');
    _zipCtrl = TextEditingController(text: widget.address?.zip ?? '');
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _streetCtrl.dispose();
    _cityCtrl.dispose();
    _zipCtrl.dispose();
    super.dispose();
  }

  Future<void> _saveAddress() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final collection = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('addresses');

    final data = {
      'name': _nameCtrl.text,
      'phone': _phoneCtrl.text,
      'street': _streetCtrl.text,
      'city': _cityCtrl.text,
      'zip': _zipCtrl.text,
      'createdAt': FieldValue.serverTimestamp(),
    };

    try {
      if (widget.address == null) {
        // Create new
        await collection.add(data);
      } else {
        // Update existing
        await collection.doc(widget.address!.id).update(data);
      }
      if (mounted) Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.address != null;
    return Scaffold(
      backgroundColor: kScaffoldBg,
      appBar: AppBar(
        backgroundColor: kScaffoldBg,
        elevation: 0,
        centerTitle: true,
        title: Text(
          isEditing ? 'Edit Address' : 'Add Address',
          style: const TextStyle(
            color: kTextPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: kTextPrimary,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildField('Full Name', _nameCtrl),
              const SizedBox(height: 16),
              _buildField(
                'Phone Number',
                _phoneCtrl,
                type: TextInputType.phone,
              ),
              const SizedBox(height: 16),
              _buildField('Street Address', _streetCtrl),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: _buildField('City', _cityCtrl)),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildField(
                      'Zip Code',
                      _zipCtrl,
                      type: TextInputType.number,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _saveAddress,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'Save Address',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildField(
    String label,
    TextEditingController ctrl, {
    TextInputType type = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: ctrl,
          keyboardType: type,
          validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
        ),
      ],
    );
  }
}

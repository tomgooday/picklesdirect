import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pickles_direct/features/bulk_lead_capture/presentation/bloc/bulk_lead_bloc.dart';

/// Contact detail fields for the bulk lead form (BR-07E).
/// Full name, phone, and email — all mandatory.
class VendorContactFields extends StatefulWidget {
  const VendorContactFields({super.key});

  @override
  State<VendorContactFields> createState() => _VendorContactFieldsState();
}

class _VendorContactFieldsState extends State<VendorContactFields> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _dispatch(BuildContext context) {
    context.read<BulkLeadBloc>().add(
      BulkLeadVendorDetailsChanged(
        vendorName: _nameController.text,
        phone: _phoneController.text,
        email: _emailController.text,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: _nameController,
          onChanged: (_) => _dispatch(context),
          textCapitalization: TextCapitalization.words,
          decoration: const InputDecoration(
            labelText: 'Full name *',
            hintText: 'e.g. David Harper',
          ),
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _phoneController,
          onChanged: (_) => _dispatch(context),
          keyboardType: TextInputType.phone,
          decoration: const InputDecoration(
            labelText: 'Phone number *',
            hintText: 'e.g. 0412 345 678',
          ),
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _emailController,
          onChanged: (_) => _dispatch(context),
          keyboardType: TextInputType.emailAddress,
          autocorrect: false,
          decoration: const InputDecoration(
            labelText: 'Email address *',
            hintText: 'e.g. david@yourcompany.com.au',
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import '../repositories/sesi_repository.dart';

class PapanDiagnostikPenyimpanan extends StatefulWidget {
  final SesiRepository repository;

  const PapanDiagnostikPenyimpanan({super.key, required this.repository});

  @override
  State<PapanDiagnostikPenyimpanan> createState() => _PapanDiagnostikPenyimpananState();
}

class _PapanDiagnostikPenyimpananState extends State<PapanDiagnostikPenyimpanan> {
  String? _hasilIntip;
  bool _sedangMengintip = false;
  bool _sudahMengintip = false;

  Future<void> _intip() async {
    setState(() => _sedangMengintip = true);
    final String? hasil = await widget.repository.intipMentah();
    if (!mounted) return;
    setState(() {
      _hasilIntip = hasil;
      _sudahMengintip = true;
      _sedangMengintip = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData tema = Theme.of(context);
    return Card(
      color: tema.colorScheme.surfaceContainerHighest,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Diagnostik Penyimpanan Aktif', style: tema.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text('Tipe: ${widget.repository.nama}', style: const TextStyle(fontWeight: FontWeight.w600)),
            Text(widget.repository.keterangan, style: tema.textTheme.bodySmall),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: _sedangMengintip ? null : _intip,
              icon: const Icon(Icons.bug_report_outlined),
              label: Text(_sedangMengintip ? 'Mengintip...' : 'Intip isi penyimpanan'),
            ),
            if (_sudahMengintip) ...<Widget>[
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: tema.colorScheme.surface,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: SelectableText(
                  _hasilIntip ?? 'null (Penyimpanan aman / tidak dapat dibaca mentah)',
                  style: TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 12,
                    color: _hasilIntip != null ? Colors.red : Colors.green,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

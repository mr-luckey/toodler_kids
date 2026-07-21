// Generates 50 unique high-quality coloring-book SVG templates.
// Run: dart run tool/generate_drawing_svgs.dart

import 'dart:convert';
import 'dart:io';

void main() {
  final templates = _allTemplates();
  final dir = Directory('assets/drawing/svg');
  if (dir.existsSync()) {
    for (final f in dir.listSync()) {
      if (f is File && f.path.endsWith('.svg')) f.deleteSync();
    }
  }
  dir.createSync(recursive: true);

  final jsonTemplates = <Map<String, dynamic>>[];

  for (final t in templates) {
    final path = 'assets/drawing/svg/${t.id}.svg';
    File(path).writeAsStringSync(t.svg);
    final regionIds = t.regions.map((r) => r['id'] as String).toList();
    jsonTemplates.add({
      'id': t.id,
      'nameKey': 'drawing.${t.id}',
      'displayName': t.displayName,
      'category': t.category,
      'svgPath': path,
      'isFree': t.isFree,
      'suggestedPalette': t.palette,
      'fillRegions': _regionsFromSvg(t.svg, regionIds),
    });
    stdout.writeln('  ✓ ${t.displayName} (${t.id}.svg)');
  }

  File('assets/content/games/drawing_den/templates.json').writeAsStringSync(
    const JsonEncoder.withIndent('  ').convert({'templates': jsonTemplates}),
  );
  stdout.writeln('\n✅ ${templates.length} unique drawing templates generated.');
}

class _Tpl {
  _Tpl({
    required this.id,
    required this.displayName,
    required this.category,
    required this.svg,
    required this.regions,
    this.isFree = true,
    this.palette = const ['#FF5252', '#448AFF', '#69F0AE', '#FFD740', '#AB47BC'],
  });
  final String id;
  final String displayName;
  final String category;
  final String svg;
  final List<Map<String, dynamic>> regions;
  final bool isFree;
  final List<String> palette;
}

List<_Tpl> _allTemplates() => [
      ..._animals(),
      ..._nature(),
      ..._dinosaurs(),
      ..._space(),
      ..._vehicles(),
    ];

// ─── ANIMALS (10) ───────────────────────────────────────────────

List<_Tpl> _animals() => [
      _Tpl(
        id: 'cat',
        displayName: 'Cute Cat',
        category: 'animals',
        isFree: true,
        svg: _svg('''<ellipse id="body" cx="100" cy="130" rx="55" ry="40" fill="#FFF" stroke="#222" stroke-width="2.5"/>
<circle id="head" cx="100" cy="70" r="35" fill="#FFF" stroke="#222" stroke-width="2.5"/>
<polygon id="ear_l" points="72,45 82,20 95,48" fill="#FFF" stroke="#222" stroke-width="2"/>
<polygon id="ear_r" points="128,45 118,20 105,48" fill="#FFF" stroke="#222" stroke-width="2"/>
<circle id="eye_l" cx="88" cy="68" r="6" fill="#FFF" stroke="#222" stroke-width="1.5"/>
<circle id="eye_r" cx="112" cy="68" r="6" fill="#FFF" stroke="#222" stroke-width="1.5"/>
<path id="nose" d="M100,78 L95,85 L105,85 Z" fill="#FFF" stroke="#222" stroke-width="1.5"/>
<path id="tail" d="M155,120 Q180,90 170,60" fill="none" stroke="#222" stroke-width="2.5"/>
<ellipse id="paw_l" cx="75" cy="165" rx="12" ry="8" fill="#FFF" stroke="#222" stroke-width="2"/>
<ellipse id="paw_r" cx="125" cy="165" rx="12" ry="8" fill="#FFF" stroke="#222" stroke-width="2"/>'''),
        regions: _regions(['body', 'head', 'ear_l', 'ear_r', 'eye_l', 'eye_r', 'nose', 'paw_l', 'paw_r']),
      ),
      _Tpl(
        id: 'dog',
        displayName: 'Happy Dog',
        category: 'animals',
        isFree: true,
        svg: _svg('''<ellipse id="body" cx="105" cy="135" rx="60" ry="38" fill="#FFF" stroke="#222" stroke-width="2.5"/>
<circle id="head" cx="80" cy="75" r="32" fill="#FFF" stroke="#222" stroke-width="2.5"/>
<ellipse id="ear_l" cx="58" cy="60" rx="14" ry="22" fill="#FFF" stroke="#222" stroke-width="2" transform="rotate(-20 58 60)"/>
<ellipse id="ear_r" cx="102" cy="58" rx="14" ry="22" fill="#FFF" stroke="#222" stroke-width="2" transform="rotate(20 102 58)"/>
<circle id="eye" cx="72" cy="72" r="5" fill="#FFF" stroke="#222" stroke-width="1.5"/>
<circle id="nose" cx="68" cy="85" r="7" fill="#FFF" stroke="#222" stroke-width="1.5"/>
<path id="tongue" d="M65,92 Q68,105 75,92" fill="#FFF" stroke="#222" stroke-width="1.5"/>
<rect id="leg_fl" x="70" y="155" width="14" height="30" rx="5" fill="#FFF" stroke="#222" stroke-width="2"/>
<rect id="leg_fr" x="95" y="155" width="14" height="30" rx="5" fill="#FFF" stroke="#222" stroke-width="2"/>
<path id="tail" d="M160,120 Q185,80 175,50" fill="none" stroke="#222" stroke-width="3"/>'''),
        regions: _regions(['body', 'head', 'ear_l', 'ear_r', 'eye', 'nose', 'tongue', 'leg_fl', 'leg_fr']),
      ),
      _Tpl(
        id: 'fish',
        displayName: 'Rainbow Fish',
        category: 'animals',
        svg: _svg('''<ellipse id="body" cx="100" cy="100" rx="55" ry="35" fill="#FFF" stroke="#222" stroke-width="2.5"/>
<polygon id="tail" points="155,100 190,70 190,130" fill="#FFF" stroke="#222" stroke-width="2.5"/>
<circle id="eye" cx="65" cy="92" r="8" fill="#FFF" stroke="#222" stroke-width="2"/>
<circle id="pupil" cx="67" cy="92" r="3" fill="#222"/>
<path id="fin_top" d="M90,65 Q100,40 120,65" fill="#FFF" stroke="#222" stroke-width="2"/>
<path id="fin_bot" d="M85,130 Q100,155 115,130" fill="#FFF" stroke="#222" stroke-width="2"/>
<ellipse id="scale1" cx="90" cy="100" rx="8" ry="5" fill="#FFF" stroke="#222" stroke-width="1"/>
<ellipse id="scale2" cx="110" cy="95" rx="8" ry="5" fill="#FFF" stroke="#222" stroke-width="1"/>
<ellipse id="scale3" cx="120" cy="108" rx="8" ry="5" fill="#FFF" stroke="#222" stroke-width="1"/>'''),
        regions: _regions(['body', 'tail', 'eye', 'fin_top', 'fin_bot', 'scale1', 'scale2', 'scale3']),
      ),
      _Tpl(
        id: 'bird',
        displayName: 'Little Bird',
        category: 'animals',
        svg: _svg('''<ellipse id="body" cx="100" cy="115" rx="40" ry="35" fill="#FFF" stroke="#222" stroke-width="2.5"/>
<circle id="head" cx="100" cy="65" r="25" fill="#FFF" stroke="#222" stroke-width="2.5"/>
<circle id="eye" cx="108" cy="62" r="5" fill="#FFF" stroke="#222" stroke-width="1.5"/>
<polygon id="beak" points="118,65 135,68 118,72" fill="#FFF" stroke="#222" stroke-width="1.5"/>
<path id="wing" d="M75,105 Q55,90 60,120 Q80,130 90,115" fill="#FFF" stroke="#222" stroke-width="2"/>
<path id="wing_r" d="M125,105 Q145,90 140,120 Q120,130 110,115" fill="#FFF" stroke="#222" stroke-width="2"/>
<rect id="leg_l" x="88" y="145" width="4" height="25" fill="#222"/>
<rect id="leg_r" x="108" y="145" width="4" height="25" fill="#222"/>
<ellipse id="belly" cx="100" cy="120" rx="22" ry="18" fill="#FFF" stroke="#222" stroke-width="1.5"/>'''),
        regions: _regions(['body', 'head', 'eye', 'beak', 'wing', 'wing_r', 'belly']),
      ),
      _Tpl(
        id: 'butterfly',
        displayName: 'Butterfly',
        category: 'animals',
        svg: _svg('''<ellipse id="body" cx="100" cy="100" rx="6" ry="40" fill="#FFF" stroke="#222" stroke-width="2"/>
<circle id="head" cx="100" cy="55" r="10" fill="#FFF" stroke="#222" stroke-width="2"/>
<ellipse id="wing_tl" cx="65" cy="80" rx="30" ry="35" fill="#FFF" stroke="#222" stroke-width="2.5"/>
<ellipse id="wing_tr" cx="135" cy="80" rx="30" ry="35" fill="#FFF" stroke="#222" stroke-width="2.5"/>
<ellipse id="wing_bl" cx="70" cy="120" rx="22" ry="25" fill="#FFF" stroke="#222" stroke-width="2"/>
<ellipse id="wing_br" cx="130" cy="120" rx="22" ry="25" fill="#FFF" stroke="#222" stroke-width="2"/>
<circle id="spot1" cx="60" cy="75" r="8" fill="#FFF" stroke="#222" stroke-width="1"/>
<circle id="spot2" cx="140" cy="75" r="8" fill="#FFF" stroke="#222" stroke-width="1"/>
<path id="antenna_l" d="M95,48 Q85,30 80,25" fill="none" stroke="#222" stroke-width="1.5"/>
<path id="antenna_r" d="M105,48 Q115,30 120,25" fill="none" stroke="#222" stroke-width="1.5"/>'''),
        regions: _regions(['wing_tl', 'wing_tr', 'wing_bl', 'wing_br', 'body', 'head', 'spot1', 'spot2']),
      ),
      _Tpl(
        id: 'bunny',
        displayName: 'Easter Bunny',
        category: 'animals',
        svg: _svg('''<ellipse id="body" cx="100" cy="140" rx="45" ry="40" fill="#FFF" stroke="#222" stroke-width="2.5"/>
<circle id="head" cx="100" cy="80" r="30" fill="#FFF" stroke="#222" stroke-width="2.5"/>
<ellipse id="ear_l" cx="82" cy="35" rx="10" ry="30" fill="#FFF" stroke="#222" stroke-width="2"/>
<ellipse id="ear_r" cx="118" cy="35" rx="10" ry="30" fill="#FFF" stroke="#222" stroke-width="2"/>
<circle id="eye_l" cx="90" cy="78" r="5" fill="#FFF" stroke="#222" stroke-width="1.5"/>
<circle id="eye_r" cx="110" cy="78" r="5" fill="#FFF" stroke="#222" stroke-width="1.5"/>
<circle id="nose" cx="100" cy="88" r="5" fill="#FFF" stroke="#222" stroke-width="1.5"/>
<ellipse id="cheek_l" cx="82" cy="90" rx="8" ry="5" fill="#FFF" stroke="#222" stroke-width="1"/>
<ellipse id="cheek_r" cx="118" cy="90" rx="8" ry="5" fill="#FFF" stroke="#222" stroke-width="1"/>
<circle id="tail" cx="145" cy="145" r="12" fill="#FFF" stroke="#222" stroke-width="2"/>'''),
        regions: _regions(['body', 'head', 'ear_l', 'ear_r', 'eye_l', 'eye_r', 'nose', 'cheek_l', 'cheek_r', 'tail']),
      ),
      _Tpl(
        id: 'turtle',
        displayName: 'Sea Turtle',
        category: 'animals',
        svg: _svg('''<ellipse id="shell" cx="100" cy="105" rx="55" ry="45" fill="#FFF" stroke="#222" stroke-width="2.5"/>
<circle id="head" cx="45" cy="100" r="18" fill="#FFF" stroke="#222" stroke-width="2"/>
<circle id="eye" cx="40" cy="96" r="4" fill="#FFF" stroke="#222" stroke-width="1"/>
<ellipse id="flipper_tl" cx="70" cy="70" rx="20" ry="10" fill="#FFF" stroke="#222" stroke-width="2" transform="rotate(-30 70 70)"/>
<ellipse id="flipper_tr" cx="130" cy="70" rx="20" ry="10" fill="#FFF" stroke="#222" stroke-width="2" transform="rotate(30 130 70)"/>
<ellipse id="flipper_bl" cx="70" cy="140" rx="20" ry="10" fill="#FFF" stroke="#222" stroke-width="2" transform="rotate(30 70 140)"/>
<ellipse id="flipper_br" cx="130" cy="140" rx="20" ry="10" fill="#FFF" stroke="#222" stroke-width="2" transform="rotate(-30 130 140)"/>
<polygon id="pattern1" points="100,80 115,95 100,110 85,95" fill="none" stroke="#222" stroke-width="1.5"/>
<circle id="spot_c" cx="100" cy="105" r="10" fill="#FFF" stroke="#222" stroke-width="1"/>'''),
        regions: _regions(['shell', 'head', 'eye', 'flipper_tl', 'flipper_tr', 'flipper_bl', 'flipper_br', 'spot_c']),
      ),
      _Tpl(
        id: 'elephant',
        displayName: 'Elephant',
        category: 'animals',
        svg: _svg('''<ellipse id="body" cx="110" cy="130" rx="55" ry="40" fill="#FFF" stroke="#222" stroke-width="2.5"/>
<circle id="head" cx="65" cy="90" r="35" fill="#FFF" stroke="#222" stroke-width="2.5"/>
<ellipse id="ear" cx="45" cy="80" rx="22" ry="30" fill="#FFF" stroke="#222" stroke-width="2"/>
<circle id="eye" cx="60" cy="82" r="5" fill="#FFF" stroke="#222" stroke-width="1.5"/>
<path id="trunk" d="M55,105 Q40,130 45,160 Q50,165 55,155 Q52,130 65,110" fill="#FFF" stroke="#222" stroke-width="2"/>
<rect id="leg1" x="80" y="155" width="18" height="30" rx="4" fill="#FFF" stroke="#222" stroke-width="2"/>
<rect id="leg2" x="105" y="155" width="18" height="30" rx="4" fill="#FFF" stroke="#222" stroke-width="2"/>
<rect id="leg3" x="130" y="155" width="18" height="30" rx="4" fill="#FFF" stroke="#222" stroke-width="2"/>
<path id="tusk" d="M70,105 L65,120" fill="none" stroke="#222" stroke-width="2"/>'''),
        regions: _regions(['body', 'head', 'ear', 'eye', 'trunk', 'leg1', 'leg2', 'leg3']),
      ),
      _Tpl(
        id: 'lion',
        displayName: 'Friendly Lion',
        category: 'animals',
        svg: _svg('''<circle id="mane" cx="100" cy="85" r="48" fill="#FFF" stroke="#222" stroke-width="2.5"/>
<circle id="face" cx="100" cy="85" r="28" fill="#FFF" stroke="#222" stroke-width="2"/>
<circle id="eye_l" cx="90" cy="80" r="5" fill="#FFF" stroke="#222" stroke-width="1.5"/>
<circle id="eye_r" cx="110" cy="80" r="5" fill="#FFF" stroke="#222" stroke-width="1.5"/>
<path id="nose" d="M100,88 L95,95 L105,95 Z" fill="#FFF" stroke="#222" stroke-width="1.5"/>
<path id="mouth" d="M95,98 Q100,105 105,98" fill="none" stroke="#222" stroke-width="1.5"/>
<ellipse id="body" cx="100" cy="155" rx="40" ry="30" fill="#FFF" stroke="#222" stroke-width="2.5"/>
<rect id="leg_l" x="75" y="175" width="14" height="20" rx="3" fill="#FFF" stroke="#222" stroke-width="2"/>
<rect id="leg_r" x="111" y="175" width="14" height="20" rx="3" fill="#FFF" stroke="#222" stroke-width="2"/>
<path id="tail" d="M135,155 Q160,140 165,120" fill="none" stroke="#222" stroke-width="2"/>'''),
        regions: _regions(['mane', 'face', 'eye_l', 'eye_r', 'nose', 'body', 'leg_l', 'leg_r']),
      ),
      _Tpl(
        id: 'frog',
        displayName: 'Jumping Frog',
        category: 'animals',
        svg: _svg('''<ellipse id="body" cx="100" cy="120" rx="50" ry="35" fill="#FFF" stroke="#222" stroke-width="2.5"/>
<circle id="head" cx="100" cy="75" r="30" fill="#FFF" stroke="#222" stroke-width="2.5"/>
<circle id="eye_l" cx="82" cy="62" r="14" fill="#FFF" stroke="#222" stroke-width="2"/>
<circle id="eye_r" cx="118" cy="62" r="14" fill="#FFF" stroke="#222" stroke-width="2"/>
<circle id="pupil_l" cx="82" cy="62" r="5" fill="#222"/>
<circle id="pupil_r" cx="118" cy="62" r="5" fill="#222"/>
<path id="smile" d="M85,82 Q100,95 115,82" fill="none" stroke="#222" stroke-width="1.5"/>
<ellipse id="leg_l" cx="65" cy="145" rx="18" ry="12" fill="#FFF" stroke="#222" stroke-width="2"/>
<ellipse id="leg_r" cx="135" cy="145" rx="18" ry="12" fill="#FFF" stroke="#222" stroke-width="2"/>
<ellipse id="spot1" cx="90" cy="115" rx="8" ry="5" fill="#FFF" stroke="#222" stroke-width="1"/>
<ellipse id="spot2" cx="115" cy="125" rx="8" ry="5" fill="#FFF" stroke="#222" stroke-width="1"/>'''),
        regions: _regions(['body', 'head', 'eye_l', 'eye_r', 'leg_l', 'leg_r', 'spot1', 'spot2']),
      ),
    ];

List<_Tpl> _nature() => [
      _Tpl(id: 'tree', displayName: 'Big Tree', category: 'nature', isFree: true,
        svg: _svg('''<rect id="trunk" x="88" y="110" width="24" height="70" fill="#FFF" stroke="#222" stroke-width="2.5"/>
<circle id="leaves" cx="100" cy="75" r="50" fill="#FFF" stroke="#222" stroke-width="2.5"/>
<circle id="apple1" cx="75" cy="60" r="8" fill="#FFF" stroke="#222" stroke-width="1.5"/>
<circle id="apple2" cx="120" cy="70" r="8" fill="#FFF" stroke="#222" stroke-width="1.5"/>
<circle id="apple3" cx="95" cy="45" r="8" fill="#FFF" stroke="#222" stroke-width="1.5"/>
<ellipse id="hole" cx="100" cy="130" rx="8" ry="10" fill="#FFF" stroke="#222" stroke-width="1.5"/>'''),
        regions: _regions(['trunk', 'leaves', 'apple1', 'apple2', 'apple3']),
      ),
      _Tpl(id: 'flower', displayName: 'Sunflower', category: 'nature',
        svg: _svg('''<rect id="stem" x="97" y="100" width="6" height="80" fill="#FFF" stroke="#222" stroke-width="2"/>
<ellipse id="leaf_l" cx="80" cy="130" rx="18" ry="8" fill="#FFF" stroke="#222" stroke-width="2" transform="rotate(-30 80 130)"/>
<ellipse id="leaf_r" cx="120" cy="150" rx="18" ry="8" fill="#FFF" stroke="#222" stroke-width="2" transform="rotate(30 120 150)"/>
<circle id="center" cx="100" cy="70" r="18" fill="#FFF" stroke="#222" stroke-width="2"/>
<ellipse id="petal1" cx="100" cy="40" rx="10" ry="18" fill="#FFF" stroke="#222" stroke-width="1.5"/>
<ellipse id="petal2" cx="130" cy="55" rx="10" ry="18" fill="#FFF" stroke="#222" stroke-width="1.5" transform="rotate(60 130 55)"/>
<ellipse id="petal3" cx="130" cy="85" rx="10" ry="18" fill="#FFF" stroke="#222" stroke-width="1.5" transform="rotate(120 130 85)"/>
<ellipse id="petal4" cx="100" cy="100" rx="10" ry="18" fill="#FFF" stroke="#222" stroke-width="1.5" transform="rotate(180 100 100)"/>
<ellipse id="petal5" cx="70" cy="85" rx="10" ry="18" fill="#FFF" stroke="#222" stroke-width="1.5" transform="rotate(240 70 85)"/>
<ellipse id="petal6" cx="70" cy="55" rx="10" ry="18" fill="#FFF" stroke="#222" stroke-width="1.5" transform="rotate(300 70 55)"/>'''),
        regions: _regions(['stem', 'leaf_l', 'leaf_r', 'center', 'petal1', 'petal2', 'petal3', 'petal4', 'petal5', 'petal6']),
      ),
      _Tpl(id: 'sun', displayName: 'Smiling Sun', category: 'nature', isFree: true,
        svg: _svg('''<circle id="face" cx="100" cy="100" r="40" fill="#FFF" stroke="#222" stroke-width="2.5"/>
<circle id="eye_l" cx="88" cy="92" r="5" fill="#FFF" stroke="#222" stroke-width="1.5"/>
<circle id="eye_r" cx="112" cy="92" r="5" fill="#FFF" stroke="#222" stroke-width="1.5"/>
<path id="smile" d="M85,108 Q100,120 115,108" fill="none" stroke="#222" stroke-width="2"/>
<rect id="ray1" x="97" y="20" width="6" height="25" rx="3" fill="#FFF" stroke="#222" stroke-width="1.5"/>
<rect id="ray2" x="97" y="155" width="6" height="25" rx="3" fill="#FFF" stroke="#222" stroke-width="1.5"/>
<rect id="ray3" x="20" y="97" width="25" height="6" rx="3" fill="#FFF" stroke="#222" stroke-width="1.5"/>
<rect id="ray4" x="155" y="97" width="25" height="6" rx="3" fill="#FFF" stroke="#222" stroke-width="1.5"/>
<rect id="ray5" x="40" y="40" width="20" height="6" rx="3" fill="#FFF" stroke="#222" stroke-width="1.5" transform="rotate(45 50 43)"/>
<rect id="ray6" x="140" y="40" width="20" height="6" rx="3" fill="#FFF" stroke="#222" stroke-width="1.5" transform="rotate(-45 150 43)"/>'''),
        regions: _regions(['face', 'eye_l', 'eye_r', 'ray1', 'ray2', 'ray3', 'ray4', 'ray5', 'ray6']),
      ),
      _Tpl(id: 'rainbow', displayName: 'Rainbow', category: 'nature',
        svg: _svg('''<path id="arc1" d="M30,150 Q100,20 170,150" fill="none" stroke="#222" stroke-width="8"/>
<path id="arc2" d="M40,150 Q100,35 160,150" fill="none" stroke="#222" stroke-width="8"/>
<path id="arc3" d="M50,150 Q100,50 150,150" fill="none" stroke="#222" stroke-width="8"/>
<path id="arc4" d="M60,150 Q100,65 140,150" fill="none" stroke="#222" stroke-width="8"/>
<path id="arc5" d="M70,150 Q100,80 130,150" fill="none" stroke="#222" stroke-width="8"/>
<ellipse id="cloud_l" cx="45" cy="155" rx="25" ry="15" fill="#FFF" stroke="#222" stroke-width="2"/>
<ellipse id="cloud_r" cx="155" cy="155" rx="25" ry="15" fill="#FFF" stroke="#222" stroke-width="2"/>'''),
        regions: [
          {'id': 'arc1', 'path': 'rect:0.1,0.15,0.8,0.15'},
          {'id': 'arc2', 'path': 'rect:0.15,0.25,0.7,0.12'},
          {'id': 'arc3', 'path': 'rect:0.2,0.35,0.6,0.12'},
          {'id': 'cloud_l', 'path': 'circle:0.15,0.82,0.12'},
          {'id': 'cloud_r', 'path': 'circle:0.85,0.82,0.12'},
        ],
      ),
      _Tpl(id: 'house', displayName: 'Cozy House', category: 'nature',
        svg: _svg('''<rect id="walls" x="50" y="100" width="100" height="80" fill="#FFF" stroke="#222" stroke-width="2.5"/>
<polygon id="roof" points="100,40 40,100 160,100" fill="#FFF" stroke="#222" stroke-width="2.5"/>
<rect id="door" x="85" y="130" width="30" height="50" fill="#FFF" stroke="#222" stroke-width="2"/>
<circle id="knob" cx="108" cy="155" r="3" fill="#222"/>
<rect id="window_l" x="60" y="115" width="25" height="25" fill="#FFF" stroke="#222" stroke-width="2"/>
<rect id="window_r" x="115" y="115" width="25" height="25" fill="#FFF" stroke="#222" stroke-width="2"/>
<rect id="chimney" x="120" y="55" width="15" height="30" fill="#FFF" stroke="#222" stroke-width="2"/>
<circle id="sun" cx="170" cy="50" r="15" fill="#FFF" stroke="#222" stroke-width="2"/>'''),
        regions: _regions(['walls', 'roof', 'door', 'window_l', 'window_r', 'chimney', 'sun']),
      ),
      _Tpl(id: 'apple', displayName: 'Red Apple', category: 'nature',
        svg: _svg('''<circle id="fruit" cx="100" cy="115" r="45" fill="#FFF" stroke="#222" stroke-width="2.5"/>
<path id="stem" d="M100,70 Q105,55 100,45" fill="none" stroke="#222" stroke-width="3"/>
<ellipse id="leaf" cx="115" cy="55" rx="15" ry="8" fill="#FFF" stroke="#222" stroke-width="2" transform="rotate(30 115 55)"/>
<ellipse id="highlight" cx="85" cy="95" rx="10" ry="15" fill="#FFF" stroke="#222" stroke-width="1" transform="rotate(-20 85 95)"/>'''),
        regions: _regions(['fruit', 'leaf', 'highlight']),
      ),
      _Tpl(id: 'cloud', displayName: 'Fluffy Cloud', category: 'nature',
        svg: _svg('''<ellipse id="puff1" cx="70" cy="110" rx="35" ry="28" fill="#FFF" stroke="#222" stroke-width="2.5"/>
<ellipse id="puff2" cx="110" cy="100" rx="40" ry="32" fill="#FFF" stroke="#222" stroke-width="2.5"/>
<ellipse id="puff3" cx="140" cy="115" rx="30" ry="25" fill="#FFF" stroke="#222" stroke-width="2.5"/>
<ellipse id="puff4" cx="90" cy="95" rx="28" ry="22" fill="#FFF" stroke="#222" stroke-width="2"/>'''),
        regions: _regions(['puff1', 'puff2', 'puff3', 'puff4']),
      ),
      _Tpl(id: 'mushroom', displayName: 'Mushroom', category: 'nature',
        svg: _svg('''<rect id="stem" x="88" y="110" width="24" height="60" rx="5" fill="#FFF" stroke="#222" stroke-width="2.5"/>
<ellipse id="cap" cx="100" cy="95" rx="50" ry="30" fill="#FFF" stroke="#222" stroke-width="2.5"/>
<circle id="spot1" cx="75" cy="88" r="8" fill="#FFF" stroke="#222" stroke-width="1.5"/>
<circle id="spot2" cx="100" cy="80" r="10" fill="#FFF" stroke="#222" stroke-width="1.5"/>
<circle id="spot3" cx="125" cy="90" r="7" fill="#FFF" stroke="#222" stroke-width="1.5"/>
<ellipse id="grass" cx="100" cy="175" rx="60" ry="10" fill="#FFF" stroke="#222" stroke-width="1.5"/>'''),
        regions: _regions(['cap', 'stem', 'spot1', 'spot2', 'spot3', 'grass']),
      ),
      _Tpl(id: 'leaf', displayName: 'Autumn Leaf', category: 'nature',
        svg: _svg('''<path id="leaf" d="M100,30 Q130,60 125,100 Q120,140 100,170 Q80,140 75,100 Q70,60 100,30" fill="#FFF" stroke="#222" stroke-width="2.5"/>
<path id="vein" d="M100,35 L100,165" fill="none" stroke="#222" stroke-width="1.5"/>
<path id="vein_l1" d="M100,70 Q80,75 70,85" fill="none" stroke="#222" stroke-width="1"/>
<path id="vein_r1" d="M100,70 Q120,75 130,85" fill="none" stroke="#222" stroke-width="1"/>
<path id="vein_l2" d="M100,110 Q78,118 68,130" fill="none" stroke="#222" stroke-width="1"/>
<path id="vein_r2" d="M100,110 Q122,118 132,130" fill="none" stroke="#222" stroke-width="1"/>'''),
        regions: [{'id': 'leaf', 'path': 'circle:0.5,0.5,0.4'}],
      ),
      _Tpl(id: 'star_nature', displayName: 'Shining Star', category: 'nature',
        svg: _svg('''<polygon id="star" points="100,20 115,70 170,70 125,105 140,160 100,130 60,160 75,105 30,70 85,70" fill="#FFF" stroke="#222" stroke-width="2.5"/>
<circle id="center" cx="100" cy="95" r="12" fill="#FFF" stroke="#222" stroke-width="1.5"/>'''),
        regions: _regions(['star', 'center']),
      ),
    ];

List<_Tpl> _dinosaurs() => [
      _Tpl(id: 'trex', displayName: 'T-Rex', category: 'dinosaurs', isFree: true,
        svg: _svg('''<ellipse id="body" cx="110" cy="120" rx="50" ry="35" fill="#FFF" stroke="#222" stroke-width="2.5"/>
<circle id="head" cx="55" cy="75" r="28" fill="#FFF" stroke="#222" stroke-width="2.5"/>
<circle id="eye" cx="48" cy="70" r="6" fill="#FFF" stroke="#222" stroke-width="1.5"/>
<path id="jaw" d="M35,85 Q55,100 75,85" fill="#FFF" stroke="#222" stroke-width="2"/>
<rect id="arm" x="85" y="105" width="8" height="15" rx="3" fill="#FFF" stroke="#222" stroke-width="1.5"/>
<rect id="leg_l" x="85" y="145" width="16" height="35" rx="4" fill="#FFF" stroke="#222" stroke-width="2"/>
<rect id="leg_r" x="115" y="145" width="16" height="35" rx="4" fill="#FFF" stroke="#222" stroke-width="2"/>
<path id="tail" d="M155,115 Q185,100 190,80" fill="none" stroke="#222" stroke-width="4"/>
<polygon id="teeth" points="40,88 42,95 44,88" fill="#222"/>'''),
        regions: _regions(['body', 'head', 'eye', 'jaw', 'arm', 'leg_l', 'leg_r']),
      ),
      _Tpl(id: 'triceratops', displayName: 'Triceratops', category: 'dinosaurs',
        svg: _svg('''<ellipse id="body" cx="110" cy="130" rx="55" ry="35" fill="#FFF" stroke="#222" stroke-width="2.5"/>
<circle id="head" cx="55" cy="90" r="25" fill="#FFF" stroke="#222" stroke-width="2.5"/>
<polygon id="frill" points="30,90 55,50 80,90" fill="#FFF" stroke="#222" stroke-width="2"/>
<polygon id="horn1" points="40,75 42,55 44,75" fill="#FFF" stroke="#222" stroke-width="1.5"/>
<polygon id="horn2" points="52,72 54,50 56,72" fill="#FFF" stroke="#222" stroke-width="1.5"/>
<polygon id="horn3" points="64,75 66,58 68,75" fill="#FFF" stroke="#222" stroke-width="1.5"/>
<circle id="eye" cx="50" cy="88" r="4" fill="#FFF" stroke="#222" stroke-width="1"/>
<rect id="leg1" x="80" y="155" width="14" height="30" rx="3" fill="#FFF" stroke="#222" stroke-width="2"/>
<rect id="leg2" x="105" y="155" width="14" height="30" rx="3" fill="#FFF" stroke="#222" stroke-width="2"/>
<rect id="leg3" x="130" y="155" width="14" height="30" rx="3" fill="#FFF" stroke="#222" stroke-width="2"/>'''),
        regions: _regions(['body', 'head', 'frill', 'horn1', 'horn2', 'horn3', 'leg1', 'leg2', 'leg3']),
      ),
      _Tpl(id: 'stegosaurus', displayName: 'Stegosaurus', category: 'dinosaurs',
        svg: _svg('''<ellipse id="body" cx="100" cy="130" rx="55" ry="30" fill="#FFF" stroke="#222" stroke-width="2.5"/>
<circle id="head" cx="40" cy="120" r="15" fill="#FFF" stroke="#222" stroke-width="2"/>
<polygon id="plate1" points="80,95 85,60 90,95" fill="#FFF" stroke="#222" stroke-width="1.5"/>
<polygon id="plate2" points="95,95 100,55 105,95" fill="#FFF" stroke="#222" stroke-width="1.5"/>
<polygon id="plate3" points="110,95 115,60 120,95" fill="#FFF" stroke="#222" stroke-width="1.5"/>
<polygon id="plate4" points="125,95 130,65 135,95" fill="#FFF" stroke="#222" stroke-width="1.5"/>
<path id="tail" d="M150,130 Q175,120 185,100" fill="none" stroke="#222" stroke-width="3"/>
<polygon id="spike" points="183,98 188,88 193,98" fill="#FFF" stroke="#222" stroke-width="1.5"/>
<rect id="leg1" x="70" y="150" width="12" height="30" rx="3" fill="#FFF" stroke="#222" stroke-width="2"/>
<rect id="leg2" x="110" y="150" width="12" height="30" rx="3" fill="#FFF" stroke="#222" stroke-width="2"/>'''),
        regions: _regions(['body', 'head', 'plate1', 'plate2', 'plate3', 'plate4', 'leg1', 'leg2']),
      ),
      _Tpl(id: 'brachiosaurus', displayName: 'Brachiosaurus', category: 'dinosaurs',
        svg: _svg('''<ellipse id="body" cx="100" cy="150" rx="45" ry="30" fill="#FFF" stroke="#222" stroke-width="2.5"/>
<path id="neck" d="M80,140 Q70,100 75,50" fill="none" stroke="#222" stroke-width="12" stroke-linecap="round"/>
<circle id="head" cx="75" cy="45" r="15" fill="#FFF" stroke="#222" stroke-width="2"/>
<circle id="eye" cx="72" cy="43" r="3" fill="#222"/>
<rect id="leg1" x="70" y="165" width="12" height="25" rx="3" fill="#FFF" stroke="#222" stroke-width="2"/>
<rect id="leg2" x="90" y="165" width="12" height="25" rx="3" fill="#FFF" stroke="#222" stroke-width="2"/>
<rect id="leg3" x="110" y="165" width="12" height="25" rx="3" fill="#FFF" stroke="#222" stroke-width="2"/>
<rect id="leg4" x="130" y="165" width="12" height="25" rx="3" fill="#FFF" stroke="#222" stroke-width="2"/>
<path id="tail" d="M140,155 Q165,150 175,140" fill="none" stroke="#222" stroke-width="3"/>'''),
        regions: _regions(['body', 'head', 'leg1', 'leg2', 'leg3', 'leg4']),
      ),
      _Tpl(id: 'pterodactyl', displayName: 'Pterodactyl', category: 'dinosaurs',
        svg: _svg('''<ellipse id="body" cx="100" cy="110" rx="20" ry="15" fill="#FFF" stroke="#222" stroke-width="2"/>
<circle id="head" cx="100" cy="85" r="12" fill="#FFF" stroke="#222" stroke-width="2"/>
<polygon id="beak" points="100,78 115,82 100,88" fill="#FFF" stroke="#222" stroke-width="1.5"/>
<circle id="eye" cx="96" cy="83" r="3" fill="#222"/>
<path id="wing_l" d="M80,105 Q20,80 10,110 Q40,120 80,115" fill="#FFF" stroke="#222" stroke-width="2"/>
<path id="wing_r" d="M120,105 Q180,80 190,110 Q160,120 120,115" fill="#FFF" stroke="#222" stroke-width="2"/>
<path id="crest" d="M100,73 Q95,55 100,45" fill="none" stroke="#222" stroke-width="2"/>'''),
        regions: _regions(['body', 'head', 'wing_l', 'wing_r', 'beak']),
      ),
      _Tpl(id: 'dino_egg', displayName: 'Dino Egg', category: 'dinosaurs',
        svg: _svg('''<ellipse id="egg" cx="100" cy="110" rx="40" ry="55" fill="#FFF" stroke="#222" stroke-width="2.5"/>
<path id="crack1" d="M85,80 L90,100 L82,115" fill="none" stroke="#222" stroke-width="2"/>
<path id="crack2" d="M100,75 L105,95 L98,110" fill="none" stroke="#222" stroke-width="2"/>
<circle id="baby_head" cx="100" cy="95" r="12" fill="#FFF" stroke="#222" stroke-width="2"/>
<circle id="baby_eye" cx="97" cy="93" r="2" fill="#222"/>
<ellipse id="nest" cx="100" cy="170" rx="55" ry="15" fill="#FFF" stroke="#222" stroke-width="2"/>'''),
        regions: _regions(['egg', 'baby_head', 'nest']),
      ),
      _Tpl(id: 'dino_footprint', displayName: 'Dino Footprint', category: 'dinosaurs',
        svg: _svg('''<ellipse id="foot" cx="100" cy="120" rx="45" ry="35" fill="#FFF" stroke="#222" stroke-width="2.5"/>
<circle id="toe1" cx="65" cy="85" r="12" fill="#FFF" stroke="#222" stroke-width="2"/>
<circle id="toe2" cx="90" cy="75" r="12" fill="#FFF" stroke="#222" stroke-width="2"/>
<circle id="toe3" cx="115" cy="75" r="12" fill="#FFF" stroke="#222" stroke-width="2"/>
<ellipse id="ground" cx="100" cy="175" rx="70" ry="12" fill="#FFF" stroke="#222" stroke-width="1.5"/>'''),
        regions: _regions(['foot', 'toe1', 'toe2', 'toe3', 'ground']),
      ),
      _Tpl(id: 'volcano', displayName: 'Volcano', category: 'dinosaurs',
        svg: _svg('''<polygon id="mountain" points="100,40 40,170 160,170" fill="#FFF" stroke="#222" stroke-width="2.5"/>
<ellipse id="crater" cx="100" cy="55" rx="15" ry="8" fill="#FFF" stroke="#222" stroke-width="2"/>
<path id="lava1" d="M95,55 Q90,30 100,20 Q110,30 105,55" fill="#FFF" stroke="#222" stroke-width="1.5"/>
<path id="lava2" d="M100,20 Q95,5 100,0 Q105,5 100,20" fill="#FFF" stroke="#222" stroke-width="1.5"/>
<ellipse id="rock1" cx="70" cy="140" rx="8" ry="5" fill="#FFF" stroke="#222" stroke-width="1"/>
<ellipse id="rock2" cx="130" cy="150" rx="10" ry="6" fill="#FFF" stroke="#222" stroke-width="1"/>'''),
        regions: _regions(['mountain', 'crater', 'lava1', 'lava2']),
      ),
      _Tpl(id: 'palm_tree', displayName: 'Palm Tree', category: 'dinosaurs',
        svg: _svg('''<path id="trunk" d="M95,170 Q100,120 95,70 Q105,120 100,170" fill="#FFF" stroke="#222" stroke-width="2.5"/>
<ellipse id="leaf1" cx="60" cy="65" rx="30" ry="8" fill="#FFF" stroke="#222" stroke-width="1.5" transform="rotate(-40 60 65)"/>
<ellipse id="leaf2" cx="100" cy="50" rx="30" ry="8" fill="#FFF" stroke="#222" stroke-width="1.5"/>
<ellipse id="leaf3" cx="140" cy="65" rx="30" ry="8" fill="#FFF" stroke="#222" stroke-width="1.5" transform="rotate(40 140 65)"/>
<ellipse id="leaf4" cx="75" cy="80" rx="25" ry="7" fill="#FFF" stroke="#222" stroke-width="1.5" transform="rotate(-20 75 80)"/>
<ellipse id="leaf5" cx="125" cy="80" rx="25" ry="7" fill="#FFF" stroke="#222" stroke-width="1.5" transform="rotate(20 125 80)"/>
<ellipse id="coconut" cx="100" cy="68" rx="8" ry="8" fill="#FFF" stroke="#222" stroke-width="1.5"/>'''),
        regions: _regions(['trunk', 'leaf1', 'leaf2', 'leaf3', 'leaf4', 'leaf5', 'coconut']),
      ),
      _Tpl(id: 'long_neck_dino', displayName: 'Long Neck Dino', category: 'dinosaurs',
        svg: _svg('''<ellipse id="body" cx="120" cy="155" rx="40" ry="25" fill="#FFF" stroke="#222" stroke-width="2.5"/>
<path id="neck" d="M100,145 Q60,120 55,70 Q50,50 60,40" fill="none" stroke="#222" stroke-width="10" stroke-linecap="round"/>
<circle id="head" cx="62" cy="38" r="14" fill="#FFF" stroke="#222" stroke-width="2"/>
<circle id="eye" cx="58" cy="36" r="3" fill="#222"/>
<rect id="leg1" x="100" y="170" width="10" height="20" rx="2" fill="#FFF" stroke="#222" stroke-width="2"/>
<rect id="leg2" x="130" y="170" width="10" height="20" rx="2" fill="#FFF" stroke="#222" stroke-width="2"/>
<ellipse id="spot1" cx="115" cy="150" rx="8" ry="5" fill="#FFF" stroke="#222" stroke-width="1"/>
<ellipse id="spot2" cx="130" cy="158" rx="8" ry="5" fill="#FFF" stroke="#222" stroke-width="1"/>'''),
        regions: _regions(['body', 'head', 'leg1', 'leg2', 'spot1', 'spot2']),
      ),
    ];

List<_Tpl> _space() => [
      _Tpl(id: 'rocket', displayName: 'Rocket Ship', category: 'space', isFree: true,
        svg: _svg('''<path id="body" d="M100,20 L130,140 L100,130 L70,140 Z" fill="#FFF" stroke="#222" stroke-width="2.5"/>
<circle id="window" cx="100" cy="80" r="18" fill="#FFF" stroke="#222" stroke-width="2"/>
<path id="fin_l" d="M70,140 L50,170 L70,155" fill="#FFF" stroke="#222" stroke-width="2"/>
<path id="fin_r" d="M130,140 L150,170 L130,155" fill="#FFF" stroke="#222" stroke-width="2"/>
<ellipse id="flame" cx="100" cy="155" rx="12" ry="20" fill="#FFF" stroke="#222" stroke-width="2"/>
<circle id="star1" cx="30" cy="40" r="4" fill="#FFF" stroke="#222" stroke-width="1"/>
<circle id="star2" cx="170" cy="60" r="3" fill="#FFF" stroke="#222" stroke-width="1"/>
<circle id="star3" cx="160" cy="30" r="5" fill="#FFF" stroke="#222" stroke-width="1"/>'''),
        regions: _regions(['body', 'window', 'fin_l', 'fin_r', 'flame', 'star1', 'star2', 'star3']),
      ),
      _Tpl(id: 'earth', displayName: 'Planet Earth', category: 'space',
        svg: _svg('''<circle id="planet" cx="100" cy="100" r="60" fill="#FFF" stroke="#222" stroke-width="2.5"/>
<ellipse id="land1" cx="80" cy="85" rx="25" ry="20" fill="#FFF" stroke="#222" stroke-width="1.5"/>
<ellipse id="land2" cx="120" cy="110" rx="20" ry="15" fill="#FFF" stroke="#222" stroke-width="1.5"/>
<ellipse id="land3" cx="90" cy="120" rx="15" ry="10" fill="#FFF" stroke="#222" stroke-width="1.5"/>
<circle id="cloud" cx="110" cy="75" r="12" fill="#FFF" stroke="#222" stroke-width="1"/>'''),
        regions: _regions(['planet', 'land1', 'land2', 'land3', 'cloud']),
      ),
      _Tpl(id: 'moon', displayName: 'The Moon', category: 'space',
        svg: _svg('''<circle id="moon" cx="100" cy="100" r="55" fill="#FFF" stroke="#222" stroke-width="2.5"/>
<circle id="crater1" cx="80" cy="85" r="12" fill="#FFF" stroke="#222" stroke-width="1.5"/>
<circle id="crater2" cx="120" cy="95" r="8" fill="#FFF" stroke="#222" stroke-width="1.5"/>
<circle id="crater3" cx="95" cy="120" r="10" fill="#FFF" stroke="#222" stroke-width="1.5"/>
<circle id="crater4" cx="110" cy="70" r="6" fill="#FFF" stroke="#222" stroke-width="1"/>'''),
        regions: _regions(['moon', 'crater1', 'crater2', 'crater3', 'crater4']),
      ),
      _Tpl(id: 'astronaut', displayName: 'Astronaut', category: 'space',
        svg: _svg('''<circle id="helmet" cx="100" cy="70" r="35" fill="#FFF" stroke="#222" stroke-width="2.5"/>
<ellipse id="visor" cx="100" cy="72" rx="25" ry="20" fill="#FFF" stroke="#222" stroke-width="2"/>
<rect id="body" x="75" y="105" width="50" height="55" rx="10" fill="#FFF" stroke="#222" stroke-width="2.5"/>
<rect id="pack" x="125" y="110" width="20" height="40" rx="5" fill="#FFF" stroke="#222" stroke-width="2"/>
<rect id="arm_l" x="55" y="110" width="20" height="12" rx="5" fill="#FFF" stroke="#222" stroke-width="2"/>
<rect id="arm_r" x="125" y="110" width="20" height="12" rx="5" fill="#FFF" stroke="#222" stroke-width="2"/>
<rect id="leg_l" x="80" y="160" width="15" height="25" rx="4" fill="#FFF" stroke="#222" stroke-width="2"/>
<rect id="leg_r" x="105" y="160" width="15" height="25" rx="4" fill="#FFF" stroke="#222" stroke-width="2"/>'''),
        regions: _regions(['helmet', 'visor', 'body', 'pack', 'arm_l', 'arm_r', 'leg_l', 'leg_r']),
      ),
      _Tpl(id: 'ufo', displayName: 'UFO', category: 'space',
        svg: _svg('''<ellipse id="disc" cx="100" cy="110" rx="55" ry="18" fill="#FFF" stroke="#222" stroke-width="2.5"/>
<path id="dome" d="M60,110 Q100,60 140,110" fill="#FFF" stroke="#222" stroke-width="2.5"/>
<circle id="alien_head" cx="100" cy="90" r="12" fill="#FFF" stroke="#222" stroke-width="2"/>
<circle id="eye_l" cx="94" cy="88" r="4" fill="#222"/>
<circle id="eye_r" cx="106" cy="88" r="4" fill="#222"/>
<circle id="light1" cx="60" cy="118" r="5" fill="#FFF" stroke="#222" stroke-width="1"/>
<circle id="light2" cx="80" cy="122" r="5" fill="#FFF" stroke="#222" stroke-width="1"/>
<circle id="light3" cx="100" cy="124" r="5" fill="#FFF" stroke="#222" stroke-width="1"/>
<circle id="light4" cx="120" cy="122" r="5" fill="#FFF" stroke="#222" stroke-width="1"/>
<circle id="light5" cx="140" cy="118" r="5" fill="#FFF" stroke="#222" stroke-width="1"/>'''),
        regions: _regions(['disc', 'dome', 'alien_head', 'light1', 'light2', 'light3', 'light4', 'light5']),
      ),
      _Tpl(id: 'comet', displayName: 'Comet', category: 'space',
        svg: _svg('''<circle id="head" cx="140" cy="60" r="20" fill="#FFF" stroke="#222" stroke-width="2.5"/>
<path id="tail1" d="M120,65 Q80,80 40,100" fill="none" stroke="#222" stroke-width="3"/>
<path id="tail2" d="M125,70 Q70,95 30,120" fill="none" stroke="#222" stroke-width="2"/>
<path id="tail3" d="M130,75 Q90,100 50,130" fill="none" stroke="#222" stroke-width="2"/>
<circle id="star1" cx="30" cy="40" r="3" fill="#FFF" stroke="#222" stroke-width="1"/>
<circle id="star2" cx="170" cy="100" r="4" fill="#FFF" stroke="#222" stroke-width="1"/>
<circle id="star3" cx="80" cy="30" r="3" fill="#FFF" stroke="#222" stroke-width="1"/>'''),
        regions: _regions(['head', 'star1', 'star2', 'star3']),
      ),
      _Tpl(id: 'saturn', displayName: 'Saturn', category: 'space',
        svg: _svg('''<circle id="planet" cx="100" cy="100" r="35" fill="#FFF" stroke="#222" stroke-width="2.5"/>
<ellipse id="ring" cx="100" cy="100" rx="60" ry="15" fill="none" stroke="#222" stroke-width="3"/>
<ellipse id="ring_inner" cx="100" cy="100" rx="45" ry="10" fill="none" stroke="#222" stroke-width="1.5"/>
<ellipse id="stripe1" cx="100" cy="90" rx="30" ry="4" fill="#FFF" stroke="#222" stroke-width="1"/>
<ellipse id="stripe2" cx="100" cy="105" rx="28" ry="4" fill="#FFF" stroke="#222" stroke-width="1"/>'''),
        regions: _regions(['planet', 'stripe1', 'stripe2']),
      ),
      _Tpl(id: 'stars_space', displayName: 'Starry Night', category: 'space',
        svg: _svg('''<polygon id="star1" points="50,40 53,50 63,50 55,57 58,67 50,60 42,67 45,57 37,50 47,50" fill="#FFF" stroke="#222" stroke-width="1.5"/>
<polygon id="star2" points="120,30 123,40 133,40 125,47 128,57 120,50 112,57 115,47 107,40 117,40" fill="#FFF" stroke="#222" stroke-width="1.5"/>
<polygon id="star3" points="160,80 163,90 173,90 165,97 168,107 160,100 152,107 155,97 147,90 157,90" fill="#FFF" stroke="#222" stroke-width="1.5"/>
<polygon id="star4" points="80,120 83,130 93,130 85,137 88,147 80,140 72,147 75,137 67,130 77,130" fill="#FFF" stroke="#222" stroke-width="1.5"/>
<circle id="moon_c" cx="100" cy="160" r="20" fill="#FFF" stroke="#222" stroke-width="2"/>'''),
        regions: _regions(['star1', 'star2', 'star3', 'star4', 'moon_c']),
      ),
      _Tpl(id: 'alien', displayName: 'Friendly Alien', category: 'space',
        svg: _svg('''<ellipse id="head" cx="100" cy="80" rx="35" ry="40" fill="#FFF" stroke="#222" stroke-width="2.5"/>
<ellipse id="eye_l" cx="82" cy="75" rx="12" ry="18" fill="#FFF" stroke="#222" stroke-width="2"/>
<ellipse id="eye_r" cx="118" cy="75" rx="12" ry="18" fill="#FFF" stroke="#222" stroke-width="2"/>
<circle id="pupil_l" cx="82" cy="78" r="5" fill="#222"/>
<circle id="pupil_r" cx="118" cy="78" r="5" fill="#222"/>
<path id="smile" d="M85,100 Q100,115 115,100" fill="none" stroke="#222" stroke-width="2"/>
<ellipse id="body" cx="100" cy="150" rx="25" ry="30" fill="#FFF" stroke="#222" stroke-width="2"/>
<rect id="arm_l" x="60" y="140" width="20" height="8" rx="4" fill="#FFF" stroke="#222" stroke-width="1.5"/>
<rect id="arm_r" x="120" y="140" width="20" height="8" rx="4" fill="#FFF" stroke="#222" stroke-width="1.5"/>'''),
        regions: _regions(['head', 'eye_l', 'eye_r', 'body', 'arm_l', 'arm_r']),
      ),
      _Tpl(id: 'telescope', displayName: 'Telescope', category: 'space',
        svg: _svg('''<rect id="tube" x="60" y="70" width="80" height="20" rx="5" fill="#FFF" stroke="#222" stroke-width="2.5" transform="rotate(-20 100 80)"/>
<circle id="lens" cx="145" cy="55" r="12" fill="#FFF" stroke="#222" stroke-width="2"/>
<path id="tripod1" d="M80,130 L70,170" fill="none" stroke="#222" stroke-width="3"/>
<path id="tripod2" d="M100,135 L100,170" fill="none" stroke="#222" stroke-width="3"/>
<path id="tripod3" d="M120,130 L130,170" fill="none" stroke="#222" stroke-width="3"/>
<circle id="star1" cx="40" cy="50" r="4" fill="#FFF" stroke="#222" stroke-width="1"/>
<circle id="star2" cx="170" cy="90" r="3" fill="#FFF" stroke="#222" stroke-width="1"/>'''),
        regions: _regions(['tube', 'lens', 'star1', 'star2']),
      ),
    ];

List<_Tpl> _vehicles() => [
      _Tpl(id: 'car', displayName: 'Family Car', category: 'vehicles', isFree: true,
        svg: _svg('''<path id="body" d="M30,120 L50,90 L150,90 L170,120 L170,140 L30,140 Z" fill="#FFF" stroke="#222" stroke-width="2.5"/>
<rect id="window_f" x="55" y="95" width="35" height="22" rx="3" fill="#FFF" stroke="#222" stroke-width="2"/>
<rect id="window_b" x="100" y="95" width="35" height="22" rx="3" fill="#FFF" stroke="#222" stroke-width="2"/>
<circle id="wheel_fl" cx="60" cy="140" r="15" fill="#FFF" stroke="#222" stroke-width="2.5"/>
<circle id="wheel_fr" cx="140" cy="140" r="15" fill="#FFF" stroke="#222" stroke-width="2.5"/>
<circle id="hub_fl" cx="60" cy="140" r="5" fill="#222"/>
<circle id="hub_fr" cx="140" cy="140" r="5" fill="#222"/>
<rect id="headlight" x="165" y="115" width="8" height="10" rx="2" fill="#FFF" stroke="#222" stroke-width="1"/>'''),
        regions: _regions(['body', 'window_f', 'window_b', 'wheel_fl', 'wheel_fr', 'headlight']),
      ),
      _Tpl(id: 'bus', displayName: 'School Bus', category: 'vehicles',
        svg: _svg('''<rect id="body" x="30" y="70" width="140" height="70" rx="8" fill="#FFF" stroke="#222" stroke-width="2.5"/>
<rect id="win1" x="40" y="80" width="22" height="20" rx="2" fill="#FFF" stroke="#222" stroke-width="1.5"/>
<rect id="win2" x="68" y="80" width="22" height="20" rx="2" fill="#FFF" stroke="#222" stroke-width="1.5"/>
<rect id="win3" x="96" y="80" width="22" height="20" rx="2" fill="#FFF" stroke="#222" stroke-width="1.5"/>
<rect id="win4" x="124" y="80" width="22" height="20" rx="2" fill="#FFF" stroke="#222" stroke-width="1.5"/>
<rect id="door" x="148" y="95" width="18" height="45" fill="#FFF" stroke="#222" stroke-width="2"/>
<circle id="wheel_l" cx="60" cy="140" r="14" fill="#FFF" stroke="#222" stroke-width="2.5"/>
<circle id="wheel_r" cx="140" cy="140" r="14" fill="#FFF" stroke="#222" stroke-width="2.5"/>'''),
        regions: _regions(['body', 'win1', 'win2', 'win3', 'win4', 'door', 'wheel_l', 'wheel_r']),
      ),
      _Tpl(id: 'train', displayName: 'Train Engine', category: 'vehicles',
        svg: _svg('''<rect id="engine" x="40" y="80" width="100" height="60" rx="5" fill="#FFF" stroke="#222" stroke-width="2.5"/>
<rect id="cab" x="120" y="70" width="40" height="70" rx="3" fill="#FFF" stroke="#222" stroke-width="2"/>
<rect id="window" x="130" y="80" width="20" height="18" fill="#FFF" stroke="#222" stroke-width="1.5"/>
<rect id="chimney" x="55" y="55" width="15" height="25" fill="#FFF" stroke="#222" stroke-width="2"/>
<circle id="wheel1" cx="60" cy="145" r="12" fill="#FFF" stroke="#222" stroke-width="2"/>
<circle id="wheel2" cx="90" cy="145" r="12" fill="#FFF" stroke="#222" stroke-width="2"/>
<circle id="wheel3" cx="120" cy="145" r="12" fill="#FFF" stroke="#222" stroke-width="2"/>
<circle id="wheel4" cx="145" cy="145" r="12" fill="#FFF" stroke="#222" stroke-width="2"/>
<ellipse id="smoke" cx="62" cy="45" rx="10" ry="8" fill="#FFF" stroke="#222" stroke-width="1.5"/>'''),
        regions: _regions(['engine', 'cab', 'window', 'chimney', 'wheel1', 'wheel2', 'wheel3', 'wheel4', 'smoke']),
      ),
      _Tpl(id: 'airplane', displayName: 'Airplane', category: 'vehicles',
        svg: _svg('''<ellipse id="body" cx="100" cy="100" rx="60" ry="15" fill="#FFF" stroke="#222" stroke-width="2.5"/>
<path id="wing_l" d="M60,100 L20,120 L60,110" fill="#FFF" stroke="#222" stroke-width="2"/>
<path id="wing_r" d="M140,100 L180,120 L140,110" fill="#FFF" stroke="#222" stroke-width="2"/>
<path id="tail" d="M155,95 L175,70 L165,95" fill="#FFF" stroke="#222" stroke-width="2"/>
<circle id="window1" cx="70" cy="97" r="6" fill="#FFF" stroke="#222" stroke-width="1.5"/>
<circle id="window2" cx="90" cy="97" r="6" fill="#FFF" stroke="#222" stroke-width="1.5"/>
<circle id="window3" cx="110" cy="97" r="6" fill="#FFF" stroke="#222" stroke-width="1.5"/>
<circle id="window4" cx="130" cy="97" r="6" fill="#FFF" stroke="#222" stroke-width="1.5"/>'''),
        regions: _regions(['body', 'wing_l', 'wing_r', 'tail', 'window1', 'window2', 'window3', 'window4']),
      ),
      _Tpl(id: 'boat', displayName: 'Sailboat', category: 'vehicles',
        svg: _svg('''<path id="hull" d="M40,140 Q100,170 160,140 L150,155 L50,155 Z" fill="#FFF" stroke="#222" stroke-width="2.5"/>
<rect id="mast" x="97" y="40" width="6" height="100" fill="#222"/>
<path id="sail" d="M103,45 L103,130 L150,130 Z" fill="#FFF" stroke="#222" stroke-width="2"/>
<path id="flag" d="M103,45 L120,52 L103,58" fill="#FFF" stroke="#222" stroke-width="1.5"/>
<path id="wave1" d="M20,165 Q50,155 80,165" fill="none" stroke="#222" stroke-width="2"/>
<path id="wave2" d="M100,165 Q130,155 160,165" fill="none" stroke="#222" stroke-width="2"/>'''),
        regions: _regions(['hull', 'sail', 'flag']),
      ),
      _Tpl(id: 'bicycle', displayName: 'Bicycle', category: 'vehicles',
        svg: _svg('''<circle id="wheel_l" cx="60" cy="130" r="30" fill="none" stroke="#222" stroke-width="2.5"/>
<circle id="wheel_r" cx="140" cy="130" r="30" fill="none" stroke="#222" stroke-width="2.5"/>
<path id="frame" d="M60,130 L100,80 L140,130 M100,80 L100,110" fill="none" stroke="#222" stroke-width="3"/>
<circle id="seat" cx="95" cy="75" r="8" fill="#FFF" stroke="#222" stroke-width="2"/>
<path id="handlebar" d="M95,80 L80,65 M105,80 L120,65" fill="none" stroke="#222" stroke-width="2.5"/>
<circle id="pedal" cx="100" cy="115" r="8" fill="#FFF" stroke="#222" stroke-width="2"/>'''),
        regions: _regions(['wheel_l', 'wheel_r', 'seat', 'pedal']),
      ),
      _Tpl(id: 'truck', displayName: 'Delivery Truck', category: 'vehicles',
        svg: _svg('''<rect id="cargo" x="30" y="70" width="90" height="70" fill="#FFF" stroke="#222" stroke-width="2.5"/>
<path id="cab" d="M120,70 L120,140 L170,140 L170,90 L150,70 Z" fill="#FFF" stroke="#222" stroke-width="2.5"/>
<rect id="window" x="130" y="80" width="30" height="25" fill="#FFF" stroke="#222" stroke-width="2"/>
<circle id="wheel1" cx="55" cy="140" r="14" fill="#FFF" stroke="#222" stroke-width="2.5"/>
<circle id="wheel2" cx="150" cy="140" r="14" fill="#FFF" stroke="#222" stroke-width="2.5"/>'''),
        regions: _regions(['cargo', 'cab', 'window', 'wheel1', 'wheel2']),
      ),
      _Tpl(id: 'helicopter', displayName: 'Helicopter', category: 'vehicles',
        svg: _svg('''<rect id="blade" x="30" y="45" width="140" height="6" rx="3" fill="#FFF" stroke="#222" stroke-width="1.5"/>
<ellipse id="body" cx="100" cy="100" rx="45" ry="25" fill="#FFF" stroke="#222" stroke-width="2.5"/>
<path id="cockpit" d="M130,90 Q160,100 130,110" fill="#FFF" stroke="#222" stroke-width="2"/>
<rect id="tail" x="145" y="95" width="40" height="8" fill="#FFF" stroke="#222" stroke-width="2"/>
<rect id="tail_blade" x="180" y="85" width="6" height="25" fill="#FFF" stroke="#222" stroke-width="1.5"/>
<circle id="wheel_l" cx="75" cy="125" r="8" fill="#FFF" stroke="#222" stroke-width="2"/>
<circle id="wheel_r" cx="125" cy="125" r="8" fill="#FFF" stroke="#222" stroke-width="2"/>'''),
        regions: _regions(['body', 'cockpit', 'tail', 'blade', 'wheel_l', 'wheel_r']),
      ),
      _Tpl(id: 'hot_air_balloon', displayName: 'Hot Air Balloon', category: 'vehicles',
        svg: _svg('''<ellipse id="balloon" cx="100" cy="75" rx="45" ry="55" fill="#FFF" stroke="#222" stroke-width="2.5"/>
<path id="stripe1" d="M60,50 Q100,30 140,50" fill="none" stroke="#222" stroke-width="1.5"/>
<path id="stripe2" d="M55,75 Q100,55 145,75" fill="none" stroke="#222" stroke-width="1.5"/>
<path id="stripe3" d="M58,100 Q100,80 142,100" fill="none" stroke="#222" stroke-width="1.5"/>
<rect id="basket" x="85" y="140" width="30" height="25" rx="3" fill="#FFF" stroke="#222" stroke-width="2"/>
<path id="rope1" d="M70,125 L85,140" fill="none" stroke="#222" stroke-width="1.5"/>
<path id="rope2" d="M130,125 L115,140" fill="none" stroke="#222" stroke-width="1.5"/>'''),
        regions: _regions(['balloon', 'basket']),
      ),
      _Tpl(id: 'submarine', displayName: 'Submarine', category: 'vehicles',
        svg: _svg('''<ellipse id="body" cx="100" cy="110" rx="65" ry="30" fill="#FFF" stroke="#222" stroke-width="2.5"/>
<rect id="tower" x="85" y="65" width="30" height="30" rx="5" fill="#FFF" stroke="#222" stroke-width="2"/>
<circle id="window1" cx="60" cy="108" r="8" fill="#FFF" stroke="#222" stroke-width="1.5"/>
<circle id="window2" cx="85" cy="108" r="8" fill="#FFF" stroke="#222" stroke-width="1.5"/>
<circle id="window3" cx="110" cy="108" r="8" fill="#FFF" stroke="#222" stroke-width="1.5"/>
<circle id="window4" cx="135" cy="108" r="8" fill="#FFF" stroke="#222" stroke-width="1.5"/>
<path id="propeller" d="M165,110 L185,100 M165,110 L185,120" fill="none" stroke="#222" stroke-width="2"/>
<path id="wave" d="M20,150 Q50,140 80,150 Q110,160 140,150 Q170,140 200,150" fill="none" stroke="#222" stroke-width="2"/>'''),
        regions: _regions(['body', 'tower', 'window1', 'window2', 'window3', 'window4']),
      ),
    ];

String _svg(String inner) =>
    '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 200 200">\n$inner\n</svg>';

List<Map<String, dynamic>> _regions(List<String> ids) =>
    ids.map((id) => {'id': id, 'path': 'svg:$id'}).toList();

List<Map<String, dynamic>> _regionsFromSvg(String svg, List<String> ids) =>
    ids.map((id) => {'id': id, 'path': _hitPathForId(svg, id)}).toList();

const _viewBox = 200.0;

String _hitPathForId(String svg, String id) {
  final tagRe = RegExp('<(\\w+)[^>]*\\bid="$id"[^>]*>', dotAll: true);
  final match = tagRe.firstMatch(svg);
  if (match == null) return 'rect:0.4,0.4,0.2,0.2';

  final tag = match.group(0)!;
  final tagName = match.group(1)!;

  switch (tagName) {
    case 'circle':
      final cx = _attr(tag, 'cx') ?? 100;
      final cy = _attr(tag, 'cy') ?? 100;
      final r = _attr(tag, 'r') ?? 10;
      return 'circle:${cx / _viewBox},${cy / _viewBox},${r / _viewBox}';
    case 'ellipse':
      final cx = _attr(tag, 'cx') ?? 100;
      final cy = _attr(tag, 'cy') ?? 100;
      final rx = _attr(tag, 'rx') ?? 10;
      final ry = _attr(tag, 'ry') ?? 10;
      return 'rect:${(cx - rx) / _viewBox},${(cy - ry) / _viewBox},'
          '${(2 * rx) / _viewBox},${(2 * ry) / _viewBox}';
    case 'rect':
      final x = _attr(tag, 'x') ?? 0;
      final y = _attr(tag, 'y') ?? 0;
      final w = _attr(tag, 'width') ?? 20;
      final h = _attr(tag, 'height') ?? 20;
      return 'rect:${x / _viewBox},${y / _viewBox},${w / _viewBox},${h / _viewBox}';
    case 'polygon':
      final points = _attrStr(tag, 'points');
      if (points == null) return 'rect:0.4,0.4,0.2,0.2';
      final coords = points
          .split(RegExp(r'[\s,]+'))
          .where((s) => s.isNotEmpty)
          .map(double.parse)
          .toList();
      if (coords.length < 4) return 'rect:0.4,0.4,0.2,0.2';
      var minX = coords[0];
      var maxX = coords[0];
      var minY = coords[1];
      var maxY = coords[1];
      for (var i = 2; i < coords.length; i += 2) {
        minX = minX < coords[i] ? minX : coords[i];
        maxX = maxX > coords[i] ? maxX : coords[i];
        minY = minY < coords[i + 1] ? minY : coords[i + 1];
        maxY = maxY > coords[i + 1] ? maxY : coords[i + 1];
      }
      return 'rect:${minX / _viewBox},${minY / _viewBox},'
          '${(maxX - minX) / _viewBox},${(maxY - minY) / _viewBox}';
    default:
      return 'rect:0.35,0.35,0.3,0.3';
  }
}

double? _attr(String tag, String name) {
  final m = RegExp('$name="([\\d.]+)"').firstMatch(tag);
  return m != null ? double.tryParse(m.group(1)!) : null;
}

String? _attrStr(String tag, String name) {
  final m = RegExp('$name="([^"]+)"').firstMatch(tag);
  return m?.group(1);
}

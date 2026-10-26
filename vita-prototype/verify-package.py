from pathlib import Path
import hashlib, io, json, struct, zipfile
import xml.etree.ElementTree as ET
from PIL import Image

base = Path(__file__).resolve().parent
package = base / 'SSF2-Vita-Prototype.vpk'
with zipfile.ZipFile(package) as z:
    assert z.testzip() is None, 'ZIP CRC failure'
    expected = {'eboot.bin', 'sce_sys/param.sfo', 'assets/mario.rgba',
                'assets/font.rgba', 'sce_sys/icon0.png',
                'sce_sys/livearea/contents/bg.png',
                'sce_sys/livearea/contents/startup.png',
                'sce_sys/livearea/contents/template.xml'}
    assert expected.issubset(z.namelist()), z.namelist()
    for name in expected - {'sce_sys/param.sfo'}:
        assert z.read(name) == (base / name).read_bytes(), name
    asset_report = json.loads((base/'asset-validation.json').read_text())
    assert len(z.read('assets/mario.rgba')) == asset_report['textureWidth']*asset_report['textureHeight']*4
    assert len(z.read('assets/font.rgba')) == 256*128*4
    assert z.read('eboot.bin')[:4] == b'SCE\0'
    sfo = z.read('sce_sys/param.sfo')
    magic, version, keys, data, count = struct.unpack_from('<5I', sfo)
    assert magic == 0x46535000
    fields = {}
    for i in range(count):
        key, fmt, size, maxsize, offset = struct.unpack_from('<HHIII', sfo, 20+i*16)
        name = sfo[keys+key:].split(b'\0', 1)[0].decode()
        value = sfo[data+offset:data+offset+size]
        fields[name] = value.rstrip(b'\0').decode() if fmt == 0x204 else value.hex()
    assert fields['TITLE_ID'] == 'SSF2P0001'
    assert fields['APP_VER'] == '00.52'
    for name, size in [('sce_sys/icon0.png',(128,128)),
                       ('sce_sys/livearea/contents/bg.png',(840,500)),
                       ('sce_sys/livearea/contents/startup.png',(280,158))]:
        png = z.read(name)
        im = Image.open(io.BytesIO(png))
        assert im.size == size and im.mode == 'P' and png[24] == 8, name
    ET.fromstring(z.read('sce_sys/livearea/contents/template.xml'))
elf = (base/'ssf2-vita.elf').read_bytes()
assert elf[:6] == b'\x7fELF\x01\x01'
assert struct.unpack_from('<H', elf, 18)[0] == 40, 'Not ARM'
report = {'package': package.name, 'bytes': package.stat().st_size,
          'sha256': hashlib.sha256(package.read_bytes()).hexdigest(),
          'checks': ['ZIP CRC', 'required entries and byte equality', 'SELF magic',
                     'SFO title ID/version', 'ARM ELF32', 'RGBA texture sizes',
                     'indexed LiveArea PNG dimensions', 'LiveArea XML'],
          'hardwareTested': False, 'metadata': fields}
(base/'package-validation.json').write_text(json.dumps(report, indent=2))
print(json.dumps(report, indent=2))





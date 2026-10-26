"""Build a static inspection viewer; never executes recovered ActionScript."""
from pathlib import Path
import json, re, copy, xml.etree.ElementTree as ET

BASE = Path(__file__).resolve().parent
ASSETS = BASE / "prototype-assets"
OUT = ASSETS / "viewer"
OUT.mkdir(exist_ok=True)
root = ET.parse(ASSETS / "mario.xml").getroot()
sprites = {int(e.get("spriteId")): e for e in root.iter() if e.get("type") == "DefineSpriteTag"}
HELPER = re.compile(r"^(attackBox|hitBox|grabBox|itemBox|hand|range|touchBox|shieldBox|ledgeBox)\d*$")

def matrix(e):
    m = e.find("matrix")
    if m is None:
        return [1, 0, 0, 1, 0, 0]
    return [float(m.get("scaleX", 1)), float(m.get("rotateSkew0", 0)),
            float(m.get("rotateSkew1", 0)), float(m.get("scaleY", 1)),
            float(m.get("translateX", 0))/20, float(m.get("translateY", 0))/20]

def timeline(sprite):
    display, labels, frames = {}, [], []
    for tag in sprite.find("subTags"):
        kind = tag.get("type", "")
        if kind.startswith("PlaceObject"):
            depth = int(tag.get("depth"))
            obj = copy.deepcopy(display.get(depth, {})) if tag.get("placeFlagMove") == "true" else {}
            if tag.get("placeFlagHasCharacter") == "true":
                obj["symbolId"] = int(tag.get("characterId"))
            if tag.get("placeFlagHasName") == "true":
                obj["name"] = tag.get("name")
            if tag.find("matrix") is not None:
                obj["matrix"] = matrix(tag)
            obj.setdefault("matrix", [1,0,0,1,0,0])
            obj["depth"] = depth
            display[depth] = obj
        elif kind.startswith("RemoveObject"):
            display.pop(int(tag.get("depth")), None)
        elif kind == "FrameLabelTag":
            labels.append(tag.get("name"))
        elif kind == "ShowFrameTag":
            frames.append({"labels": labels, "placements": copy.deepcopy(list(display.values()))})
            labels = []
    assert len(frames) == int(sprite.get("frameCount"))
    return frames

def functions(text):
    result = {}
    for m in re.finditer(r"(?:internal|public|private|protected)\s+function\s+(\w+)\s*\([^)]*\)\s*:\s*[\w*]+\s*\{", text):
        start, pos, depth, quote = m.end(), m.end(), 1, None
        while pos < len(text) and depth:
            c = text[pos]
            if quote:
                if c == "\\":
                    pos += 2
                    continue
                if c == quote:
                    quote = None
            elif c in "\"'":
                quote = c
            elif c == "{":
                depth += 1
            elif c == "}":
                depth -= 1
            pos += 1
        result[m.group(1)] = text[start:pos-1].strip()
    return result

animations = []
for entry in json.loads((ASSETS/"mario-animation-index.json").read_text(encoding="utf-8-sig")):
    sid, name = entry["symbolId"], entry["name"]
    source = BASE / "resource-scripts/DAT357/scripts" / (entry.get("sourceClass", name).replace(".", "/") + ".as")
    text = source.read_text()
    methods = functions(text)
    bindings = {}
    for call in re.findall(r"addFrameScript\((.*?)\);", text, re.S):
        for index, method in re.findall(r"(\d+)\s*,\s*this\.(\w+)", call):
            bindings[int(index)] = method
    frames = timeline(sprites[sid])
    start = 0
    rng = entry.get("frameRange")
    if rng:
        start = rng[0]-1; end = rng[1]
        frames = frames[start:end]
        assert len(frames) == int(entry["frameCount"]), (entry["name"], len(frames))
    assert len(frames) == int(entry["frameCount"]), (name, len(frames))
    folder = ASSETS / "animation-svg" / entry.get("svgFolder", f"DefineSprite_{sid}_{name}")
    for index, frame in enumerate(frames):
        frame["helpers"] = [p for p in frame["placements"] if HELPER.fullmatch(p.get("name", ""))]
        frame["sourceFrame"] = start + index + 1
        method = bindings.get(start + index)
        frame["eventMethod"] = method
        frame["eventSource"] = methods.get(method, "")
        svg_index = start + index + 1 if entry.get("svgUsesSourceFrames") else index + 1
        frame["svg"] = (folder / f"{svg_index}.svg").read_text()
    animations.append({"name": name.split(".")[-1].split("_")[0], "symbolId": sid,
                        "frames": frames, "methods": methods, "source": str(source),
                        "transformSymbolId": entry.get("transformSymbolId", sid), "matrix": entry.get("matrix")})
animations.sort(key=lambda a: ["Idle","Walk","Run","Dash","Turn","Skid","Land","Jump","DoubleJump","Fall","Jab","Hurts","SentFlying","TumbleFall","GetUp","FTilt","UTilt","DTilt","FSmash","USmash","DSmash","NAir","FAir","BAir","UAir","DAir","Crouch","Uncrouch","Shield","ShieldDrop","NSpecial","NSpecialAir","SSpecial","SSpecialAir","USpecial","USpecialAir","DSpecial","Helpless","SpecialLand","Dizzy","Fireball","Grab","DashGrab","GrabHold","Pummel","Caught","FThrow","BThrow","UThrow","DThrow","DashAttack","Hang","HangClimb","HangRoll","HangAttack","GetUpRoll","GetUpAttack","DodgeRoll","SpotDodge","AirDodge","TechGround","TechRoll","EdgeLean","TauntSide","TauntNeutral","TauntUpDown","DodgeLand","CaughtSpin"].index(a["name"]))
stage_types = {}
for source in (BASE/"resource-scripts/DAT213/scripts/finaldestination_fla").glob("*.as"):
    match = re.search(r'this\.type\s*=\s*"([^"]+)"', source.read_text())
    if match:
        stage_types["finaldestination_fla."+source.stem] = match.group(1)
data = {"fps":30, "animations":animations,
        "stage":{"svg":(ASSETS/"stage-svg/DefineSprite_61/1.svg").read_text(), "types":stage_types},
        "limitations": [
            "Authored timeline frames, not a running Flash simulation. Branches, stop(), timers and callbacks are not executed.",
            "Boxes show authored helper bounds; runtime visibility, circular flags and gameplay activation still require validation.",
            "Coordinates are local to the animation symbol, not world-space or normalized character foot positions.",
            "Source colors are shown before runtime costume palette swaps; they may differ from in-game Mario.",
            "Stage view shows source collision artwork and markers, not a completed native collision model."
        ]}
# A machine-readable copy excludes bulky visual SVG strings.
metadata = copy.deepcopy(data)
for anim in metadata["animations"]:
    for frame in anim["frames"]:
        del frame["svg"]
metadata["stage"].pop("svg")
(OUT/"animation-data.json").write_text(json.dumps(metadata, indent=2), encoding="utf-8")
(OUT/"data.js").write_text("window.ASSET_DATA="+json.dumps(data).replace("</", "<\\/")+";", encoding="utf-8")
template = (BASE/"viewer-template.html").read_text(encoding="utf-8")
(OUT/"index.html").write_text(template, encoding="utf-8")
jab = next(a for a in animations if a["name"]=="Jab")
assert len(jab["frames"]) == 30
assert any(h["name"]=="attackBox" for h in jab["frames"][1]["helpers"])
assert jab["frames"][8]["eventMethod"] == "frame9"
assert "damage" in jab["frames"][8]["eventSource"]
print(json.dumps({"animations":len(animations), "frames":sum(len(a["frames"]) for a in animations),
                  "stageMarkerTypes":len(stage_types), "viewer":str(OUT/"index.html")}, indent=2))

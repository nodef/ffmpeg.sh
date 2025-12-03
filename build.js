const fs = require('fs');
const os = require('os');
const cp = require('child_process');


// Read text file with normalized line endings.
function readTextFileSync(pth) {
  var txt = fs.readFileSync(pth, 'utf8');
  return txt.replace(/\r?\n/g, '\n');
}


// Write text file with normalized line endings.
function writeTextFileSync(pth, txt) {
  txt = txt.replace(/\r?\n/g, os.EOL);
  fs.writeFileSync(pth, txt, 'utf8');
}


// Write JSON file with normalized line endings.
function writeJsonFileSync(pth, obj) {
  var txt = JSON.stringify(obj, null, 2) + '\n';
  writeTextFileSync(pth, txt);
}


// Main build function.
function main() {
  var argv = process.argv.slice(2);
  if (argv[0] !== 'windows') {
    console.error('This build script is only for Windows.');
    process.exit(1);
  }
  var packageSh = readTextFileSync('package.json');
  var p = JSON.parse(packageSh);
  p.name = 'ffmpeg.cmd';
  p.bin.ffmpeg  = 'ffmpeg/bin/ffmpeg.exe';
  p.bin.ffplay  = 'ffmpeg/bin/ffplay.exe';
  p.bin.ffprobe = 'ffmpeg/bin/ffprobe.exe';
  p.keywords = [...p.keywords.filter(k => k !== 'linux'), 'windows'];
  writeJsonFileSync('package.json', p);
  cp.execSync('npm publish', { stdio: 'inherit' });
  writeTextFileSync('package.json', packageSh);
}
main();

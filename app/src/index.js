const { sum } = require('./sum');

function main() {
  const a = 2;
  const b = 3;
  console.log(`sum(${a}, ${b}) = ${sum(a, b)}`);
}

if (require.main === module) {
  main();
}

module.exports = { main };

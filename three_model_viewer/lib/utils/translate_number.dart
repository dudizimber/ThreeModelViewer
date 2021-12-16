dynamic translateNumber(num? value, List<num?> comparison,
    {String trns = 'undefined'}) {
  if (comparison.contains(value)) return trns;
  return value;
}

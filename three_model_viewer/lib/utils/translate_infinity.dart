dynamic translateInfinity(num value, {String trns = 'undefined'}) {
  if (value == double.infinity || value == -double.infinity) return trns;
  return value;
}

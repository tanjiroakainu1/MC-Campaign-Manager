import 'package:intl/intl.dart';

const currencyCode = 'PHP';
const currencySymbol = '₱';
const budgetLabel = 'Budget (₱)';

final _currencyFormat = NumberFormat.currency(
  locale: 'en_PH',
  symbol: currencySymbol,
  decimalDigits: 0,
);

final _currencyDecimalFormat = NumberFormat.currency(
  locale: 'en_PH',
  symbol: currencySymbol,
  decimalDigits: 2,
);

String formatCurrency(num amount) => _currencyFormat.format(amount);

String formatCurrencyDecimal(num amount) => _currencyDecimalFormat.format(amount);

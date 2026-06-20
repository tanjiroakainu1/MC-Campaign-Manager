export const CURRENCY_CODE = 'PHP';
export const CURRENCY_SYMBOL = '₱';
export const CURRENCY_LOCALE = 'en-PH';
export const BUDGET_LABEL = 'Budget (₱)';

export function formatCurrency(amount: number): string {
  return amount.toLocaleString(CURRENCY_LOCALE, {
    style: 'currency',
    currency: CURRENCY_CODE,
    minimumFractionDigits: 0,
    maximumFractionDigits: 0,
  });
}

export function formatCurrencyDecimal(amount: number): string {
  return amount.toLocaleString(CURRENCY_LOCALE, {
    style: 'currency',
    currency: CURRENCY_CODE,
    minimumFractionDigits: 2,
    maximumFractionDigits: 2,
  });
}

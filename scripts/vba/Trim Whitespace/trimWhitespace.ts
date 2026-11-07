/**
 * TrimWhitespace  -  Office Script (TypeScript)
 *
 * Trims the leading and trailing spaces from every cell in a range, in place.
 * Run it from Excel's Automate tab; set the inputs at the top of `main`.
 */

// ---- Inputs ----------------------------------------------------------------
function main(workbook: ExcelScript.Workbook): void {
  const address = "A1:C100";

  const summary = trimWhitespace(address, workbook.getActiveWorksheet());
  console.log(summary);
}

/**
 * Trims the leading and trailing spaces from every cell of the range.
 * @param address A range ("A1:C50"), a whole column ("A"), or a name.
 */
function trimWhitespace(address: string, sheet: ExcelScript.Worksheet): string {
  const range = sheet.getRange(address);
  const values = range.getValues();
  let changed = 0;
  for (let r = 0; r < values.length; r++) {
    for (let c = 0; c < values[r].length; c++) {
      const text = cellToString(values[r][c]);
      if (text !== "" && text.trim() !== text) {
        values[r][c] = text.trim();
        changed++;
      }
    }
  }
  if (changed > 0) {
    range.setValues(values);
  }
  return `${changed} cell(s) trimmed`;
}

/** Renders a cell value as text; null/undefined read as empty. */
function cellToString(value: unknown): string {
  return value === null || value === undefined ? "" : String(value);
}

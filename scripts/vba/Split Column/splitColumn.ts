/**
 * SplitColumn  -  Office Script (TypeScript)
 *
 * Splits one column on a delimiter and writes the parts into the columns to its
 * right.  Run it from Excel's Automate tab; set the inputs at the top of `main`.
 */

// ---- Inputs ----------------------------------------------------------------
function main(workbook: ExcelScript.Workbook): void {
  const column = "A";
  const delimiter = ",";

  const summary = splitColumn(column, delimiter, workbook.getActiveWorksheet());
  console.log(summary);
}

/**
 * Splits `column` on `delimiter` and writes the parts into the columns to its right.
 */
function splitColumn(column: string, delimiter: string, sheet: ExcelScript.Worksheet): string {
  const col = columnLetterToNumber(column);
  if (col === 0) {
    return "Invalid column letter: " + column;
  }

  const lastRow = sheet.getUsedRange().getRowCount();
  const values = sheet.getRangeByIndexes(0, col - 1, lastRow, 1).getValues();
  const split = values.map((row) => cellToString(row[0]).split(delimiter));
  const maxParts = split.reduce((max, parts) => Math.max(max, parts.length), 1);

  if (maxParts <= 1) {
    return "Nothing to split";
  }

  const output = split.map((parts) => {
    const row: string[] = [];
    for (let i = 0; i < maxParts; i++) {
      row.push(i < parts.length ? parts[i].trim() : "");
    }
    return row;
  });

  sheet.getRangeByIndexes(0, col, lastRow, maxParts).setValues(output);
  return `${maxParts} column(s) written from ${column.toUpperCase()}`;
}

/** Converts a column letter ("A", "AB") to its 1-based number. */
function columnLetterToNumber(letter: string): number {
  const text = letter.toUpperCase();
  let number = 0;
  for (let i = 0; i < text.length; i++) {
    const code = text.charCodeAt(i);
    if (code < 65 || code > 90) {
      return 0;
    }
    number = number * 26 + (code - 64);
  }
  return number;
}

/** Renders a cell value as text; null/undefined read as empty. */
function cellToString(value: unknown): string {
  return value === null || value === undefined ? "" : String(value);
}

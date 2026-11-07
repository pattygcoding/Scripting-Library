/**
 * CountDistinct  -  Office Script (TypeScript)
 *
 * Counts the distinct, non-blank values in a column.  Run it from Excel's
 * Automate tab; set the inputs at the top of `main`.
 */

// ---- Inputs ----------------------------------------------------------------
function main(workbook: ExcelScript.Workbook): void {
  const column = "A";

  const count = countDistinct(column, workbook.getActiveWorksheet());
  console.log(count);
}

/** Counts the distinct, non-blank values in `column`. */
function countDistinct(column: string, sheet: ExcelScript.Worksheet): number | string {
  const col = columnLetterToNumber(column);
  if (col === 0) {
    return "Invalid column letter";
  }

  const lastRow = sheet.getUsedRange().getRowCount();
  const values = sheet.getRangeByIndexes(0, col - 1, lastRow, 1).getValues();

  const seen: Record<string, boolean> = {};
  let count = 0;
  for (let r = 0; r < lastRow; r++) {
    const key = cellToString(values[r][0]);
    if (key !== "" && !seen[key]) {
      seen[key] = true;
      count++;
    }
  }

  return count;
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

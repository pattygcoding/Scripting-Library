/**
 * CompareRows  -  Office Script (TypeScript)
 *
 * Compares two rows of a worksheet and returns the columns that differ.  Run it
 * from Excel's Automate tab; set the inputs at the top of `main`.
 */

// ---- Inputs ----------------------------------------------------------------
function main(workbook: ExcelScript.Workbook): void {
  const row1 = 2;
  const row2 = 3;
  const includeTimestamps = false;

  const report = compareRows(row1, row2, workbook.getActiveWorksheet(), includeTimestamps);
  console.log(report);
}

/**
 * Compares two rows of `sheet` and returns the columns that differ.
 * @param includeTimestamps When true, every column is compared; when false, columns
 *     whose two cells both look like SQL Server timestamps are skipped.
 */
function compareRows(
  row1: number,
  row2: number,
  sheet: ExcelScript.Worksheet,
  includeTimestamps: boolean,
): string {
  const lastCol = sheet.getUsedRange().getColumnCount();
  const values1 = sheet.getRangeByIndexes(row1 - 1, 0, 1, lastCol).getValues()[0];
  const values2 = sheet.getRangeByIndexes(row2 - 1, 0, 1, lastCol).getValues()[0];

  const differences: string[] = [];
  for (let i = 0; i < lastCol; i++) {
    const a = values1[i];
    const b = values2[i];
    if (!includeTimestamps && isTimestamp(a) && isTimestamp(b)) {
      continue;
    }
    if (cellToString(a) !== cellToString(b)) {
      differences.push(`Column ${columnNumberToLetter(i + 1)}: ${cellToString(a)} vs ${cellToString(b)}`);
    }
  }

  return differences.length === 0 ? "No differences" : differences.join("\n");
}

/** Converts a 1-based column number to its letter (1 -> "A", 28 -> "AB"). */
function columnNumberToLetter(number: number): string {
  let letter = "";
  let value = number;
  while (value > 0) {
    const remainder = (value - 1) % 26;
    letter = String.fromCharCode(65 + remainder) + letter;
    value = Math.floor((value - 1) / 26);
  }
  return letter;
}

/** True for a value shaped like a SQL Server "Mon Jan 01 2024 12:00:00 GMT+0000 (GMT+00:00)". */
function isTimestamp(value: unknown): boolean {
  return typeof value === "string" &&
    /^[A-Za-z]{3} [A-Za-z]{3} \d{2} \d{4} \d{2}:\d{2}:\d{2} GMT[+-]\d{4} \(GMT[+-]\d{2}:\d{2}\)$/.test(value);
}

/** Renders a cell value for the report; null/undefined read as empty. */
function cellToString(value: unknown): string {
  return value === null || value === undefined ? "" : String(value);
}

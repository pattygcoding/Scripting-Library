/**
 * CompareColumns  -  Office Script (TypeScript)
 *
 * Compares two columns of a worksheet and returns the rows that differ.  Run it
 * from Excel's Automate tab; set the inputs at the top of `main`.
 */

// ---- Inputs ----------------------------------------------------------------
function main(workbook: ExcelScript.Workbook): void {
  const column1 = "A";
  const column2 = "B";
  const includeTimestamps = false;

  const report = compareColumns(column1, column2, workbook.getActiveWorksheet(), includeTimestamps);
  console.log(report);
}

/**
 * Compares two columns of `sheet` and returns the rows that differ.
 * @param includeTimestamps When true, every row is compared; when false, rows
 *     whose two cells both look like SQL Server timestamps are skipped.
 */
function compareColumns(
  column1: string,
  column2: string,
  sheet: ExcelScript.Worksheet,
  includeTimestamps: boolean,
): string {
  const col1 = columnLetterToNumber(column1);
  const col2 = columnLetterToNumber(column2);
  if (col1 === 0 || col2 === 0) {
    return "Invalid column letter";
  }

  const lastRow = sheet.getUsedRange().getRowCount();
  const values1 = sheet.getRangeByIndexes(0, col1 - 1, lastRow, 1).getValues();
  const values2 = sheet.getRangeByIndexes(0, col2 - 1, lastRow, 1).getValues();

  const differences: string[] = [];
  for (let i = 0; i < lastRow; i++) {
    const a = values1[i][0];
    const b = values2[i][0];
    if (!includeTimestamps && isTimestamp(a) && isTimestamp(b)) {
      continue;
    }
    if (cellToString(a) !== cellToString(b)) {
      differences.push(`Row ${i + 1}: ${cellToString(a)} vs ${cellToString(b)}`);
    }
  }

  return differences.length === 0 ? "No differences" : differences.join("\n");
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

/** True for a value shaped like a SQL Server "Mon Jan 01 2024 12:00:00 GMT+0000 (GMT+00:00)". */
function isTimestamp(value: unknown): boolean {
  return typeof value === "string" &&
    /^[A-Za-z]{3} [A-Za-z]{3} \d{2} \d{4} \d{2}:\d{2}:\d{2} GMT[+-]\d{4} \(GMT[+-]\d{2}:\d{2}\)$/.test(value);
}

/** Renders a cell value for the report; null/undefined read as empty. */
function cellToString(value: unknown): string {
  return value === null || value === undefined ? "" : String(value);
}

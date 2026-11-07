/**
 * CompareSheets  -  Office Script (TypeScript)
 *
 * Compares two worksheets cell by cell over their shared top-left region.  Run
 * it from Excel's Automate tab; set the inputs at the top of `main`.
 */

// ---- Inputs ----------------------------------------------------------------
function main(workbook: ExcelScript.Workbook): void {
  const sheet1 = "Sheet1";
  const sheet2 = "Sheet2";
  const includeTimestamps = false;

  const report = compareSheets(workbook, sheet1, sheet2, includeTimestamps);
  console.log(report);
}

/**
 * Compares two worksheets of `workbook` cell by cell.
 * @param includeTimestamps When true, every cell is compared; when false, cells
 *     whose two values both look like SQL Server timestamps are skipped.
 */
function compareSheets(
  workbook: ExcelScript.Workbook,
  sheet1: string,
  sheet2: string,
  includeTimestamps: boolean,
): string {
  const ws1 = workbook.getWorksheet(sheet1);
  const ws2 = workbook.getWorksheet(sheet2);
  if (!ws1 || !ws2) {
    return "Sheet not found";
  }

  const rows = Math.min(ws1.getUsedRange().getRowCount(), ws2.getUsedRange().getRowCount());
  const cols = Math.min(ws1.getUsedRange().getColumnCount(), ws2.getUsedRange().getColumnCount());
  const data1 = ws1.getRangeByIndexes(0, 0, rows, cols).getValues();
  const data2 = ws2.getRangeByIndexes(0, 0, rows, cols).getValues();

  const differences: string[] = [];
  for (let r = 0; r < rows; r++) {
    for (let c = 0; c < cols; c++) {
      const a = data1[r][c];
      const b = data2[r][c];
      if (!includeTimestamps && isTimestamp(a) && isTimestamp(b)) {
        continue;
      }
      if (cellToString(a) !== cellToString(b)) {
        differences.push(`Cell ${columnNumberToLetter(c + 1)}${r + 1}: ${cellToString(a)} vs ${cellToString(b)}`);
      }
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

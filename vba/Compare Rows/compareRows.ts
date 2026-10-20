function main(workbook: ExcelScript.Workbook) {
  // Set up the parameters
  let headerRow = 1; // Example header row
  let valueRow = 2;  // Example value row
  let includeTimestamps = false; // Example setting for timestamp inclusion

  // Call the compareRows function with the active sheet
  let result = compareRows(headerRow, valueRow, includeTimestamps, workbook.getActiveWorksheet());
  
  // Output the result (you can change this to display in the sheet, etc.)
  console.log(result);
}

function compareRows(row1: number, row2: number, includeTimestamps: boolean, sheet: ExcelScript.Worksheet): string {
  // Get the data from the specified rows
  let rowData1 = sheet.getRangeByIndexes(row1 - 1, 0, 1, sheet.getUsedRange().getColumnCount()).getValues()[0];
  let rowData2 = sheet.getRangeByIndexes(row2 - 1, 0, 1, sheet.getUsedRange().getColumnCount()).getValues()[0];
  let differences: string[] = [];
  
  for (let i = 0; i < rowData1.length; i++) {
    if (!includeTimestamps && isTimestamp(rowData1[i]) && isTimestamp(rowData2[i])) {
      continue; // Skip comparison if both are timestamps and includeTimestamps is FALSE
    }

    if (includeTimestamps && !isTimestamp(rowData1[i]) && !isTimestamp(rowData2[i])) {
      continue; // Skip comparison if neither are timestamps and includeTimestamps is TRUE
    }
    
    if (rowData1[i] !== rowData2[i]) {
      differences.push(`Column ${String.fromCharCode(65 + i)}: ${rowData1[i]} vs ${rowData2[i]}`);
    }
  }
  
  if (differences.length === 0) {
    return "No differences";
  } else {
    return differences.join("\n");
  }
}

// Function to check if a value is a timestamp
function isTimestamp(value: any): boolean {
  let timestampPattern = /^[A-Za-z]{3} [A-Za-z]{3} \d{2} \d{4} \d{2}:\d{2}:\d{2} GMT[+-]\d{4} \(GMT[+-]\d{2}:\d{2}\)$/;
  return typeof value === 'string' && timestampPattern.test(value);
}

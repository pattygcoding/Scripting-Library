function main(workbook: ExcelScript.Workbook) {
  // Set up the parameters
  let column1 = "A"; // Example column letter for column1
  let column2 = "B"; // Example column letter for column2
  let includeTimestamps = false; // Example setting for timestamp inclusion

  // Call the compareColumns function with the active sheet
  let result = compareColumns(column1, column2, includeTimestamps, workbook.getActiveWorksheet());
  
  // Output the result (you can change this to display in the sheet, etc.)
  console.log(result);
}

function compareColumns(column1: string, column2: string, includeTimestamps: boolean, sheet: ExcelScript.Worksheet): string {
  if (!sheet) {
    return "Sheet not found";
  }

  // Convert column letters to numbers
  let colIndex1 = letterToColumn(column1);
  let colIndex2 = letterToColumn(column2);

  let lastRow = sheet.getUsedRange().getRowCount();
  let columnData1 = sheet.getRangeByIndexes(0, colIndex1 - 1, lastRow, 1).getValues();
  let columnData2 = sheet.getRangeByIndexes(0, colIndex2 - 1, lastRow, 1).getValues();
  let differences: string[] = [];
  
  for (let i = 0; i < lastRow; i++) {
    if (!includeTimestamps && isTimestamp(columnData1[i][0]) && isTimestamp(columnData2[i][0])) {
      continue; // Skip comparison if both are timestamps and includeTimestamps is FALSE
    }

    if (includeTimestamps && !isTimestamp(columnData1[i][0]) && !isTimestamp(columnData2[i][0])) {
      continue; // Skip comparison if neither are timestamps and includeTimestamps is TRUE
    }
    
    if (columnData1[i][0] !== columnData2[i][0]) {
      differences.push(`Row ${i + 1}: ${columnData1[i][0]} vs ${columnData2[i][0]}`);
    }
  }
  
  if (differences.length === 0) {
    return "No differences";
  } else {
    return differences.join("\n");
  }
}

// Function to convert column letter to number
function letterToColumn(letter: string): number {
  let column = 0;
  let length = letter.length;
  for (let i = 0; i < length; i++) {
    column += (letter.charCodeAt(i) - 64) * Math.pow(26, length - 1 - i);
  }
  return column;
}

// Function to check if a value is a timestamp
function isTimestamp(value: any): boolean {
  let timestampPattern = /^[A-Za-z]{3} [A-Za-z]{3} \d{2} \d{4} \d{2}:\d{2}:\d{2} GMT[+-]\d{4} \(GMT[+-]\d{2}:\d{2}\)$/;
  return typeof value === 'string' && timestampPattern.test(value);
}

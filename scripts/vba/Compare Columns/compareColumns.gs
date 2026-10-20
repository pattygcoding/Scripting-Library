function compareColumns(column1, column2, sheet, includeTimestamps) {
  // Set default sheet name to "Sheet1" if not provided
  sheet = sheet || SpreadsheetApp.getActiveSpreadsheet().getActiveSheet();

  if (!sheet) {
    return "Sheet not found";
  }

  // Convert column letters to numbers
  column1 = letterToColumn(column1);
  column2 = letterToColumn(column2);

  var lastRow = sheet.getLastRow();
  var columnData1 = sheet.getRange(1, column1, lastRow).getValues();
  var columnData2 = sheet.getRange(1, column2, lastRow).getValues();
  var differences = [];
  
  for (var i = 0; i < lastRow; i++) {
    if (!includeTimestamps && isTimestamp(columnData1[i][0]) && isTimestamp(columnData2[i][0])) {
      continue; // Skip comparison if both are timestamps and includeTimestamps is FALSE
    }

    if (includeTimestamps && !isTimestamp(columnData1[i][0]) && !isTimestamp(columnData2[i][0])) {
      continue; // Skip comparison if neither are timestamps and includeTimestamps is TRUE
    }
    
    if (columnData1[i][0] !== columnData2[i][0]) {
      differences.push("Row " + (i + 1) + ": " + columnData1[i][0] + " vs " + columnData2[i][0]);
    }
  }
  
  if (differences.length === 0) {
    return "No differences";
  } else {
    return differences.join("\n");
  }
}

// Function to convert column letter to number
function letterToColumn(letter) {
  var column = 0, length = letter.length;
  for (var i = 0; i < length; i++) {
    column += (letter.charCodeAt(i) - 64) * Math.pow(26, length - 1 - i);
  }
  return column;
}

// Function to check if a value is a timestamp
function isTimestamp(value) {
  var timestampPattern = /^[A-Za-z]{3} [A-Za-z]{3} \d{2} \d{4} \d{2}:\d{2}:\d{2} GMT[+-]\d{4} \(GMT[+-]\d{2}:\d{2}\)$/;
  return timestampPattern.test(value);
}

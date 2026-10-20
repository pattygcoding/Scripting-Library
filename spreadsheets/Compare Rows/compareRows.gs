function compareRows(row1, row2, sheet, includeTimestamps) {
  // Set default sheet name to "Sheet1" if not provided
  sheet = sheet || SpreadsheetApp.getActiveSpreadsheet().getActiveSheet();

  if (!sheet) {
    return "Sheet not found";
  }
  
  var rowData1 = sheet.getRange(row1, 1, 1, sheet.getLastColumn()).getValues()[0];
  var rowData2 = sheet.getRange(row2, 1, 1, sheet.getLastColumn()).getValues()[0];
  var differences = [];
  
  for (var i = 0; i < rowData1.length; i++) {
    if (!includeTimestamps && isTimestamp(rowData1[i]) && isTimestamp(rowData2[i])) {
      continue; // Skip comparison if both are timestamps and includeTimestamps is FALSE
    }

    if (includeTimestamps && !isTimestamp(rowData1[i]) && !isTimestamp(rowData2[i])) {
      continue; // Skip comparison if neither are timestamps and includeTimestamps is TRUE
    }
    
    if (rowData1[i] !== rowData2[i]) {
      differences.push("Column " + String.fromCharCode(65 + i) + ": " + rowData1[i] + " vs " + rowData2[i]);
    }
  }
  
  if (differences.length === 0) {
    return "No differences";
  } else {
    return differences.join("\n");
  }
}

// Function to check if a value is a timestamp
function isTimestamp(value) {
  var timestampPattern = /^[A-Za-z]{3} [A-Za-z]{3} \d{2} \d{4} \d{2}:\d{2}:\d{2} GMT[+-]\d{4} \(GMT[+-]\d{2}:\d{2}\)$/;
  return timestampPattern.test(value);
}

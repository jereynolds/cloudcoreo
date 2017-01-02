"use strict"

$(function() {
  pollRefresh();
});

function pollRefresh() {
  $.ajax({
    url: "/status.json",
    success: function(data) {
      render(data);
      setTimeout(pollRefresh, 5000);
    }
  });
}

function render(data, status) {
  drawResultTable(data.results);
  drawJobsTable(data.jobs);
  $("#prime").text(data.max_prime);
}

function createTable(headers, rows) {
  var table = $("<table>");
  var tr = $("<tr>");
  table.append(tr);

  headers.forEach(function(h) {
    tr.append($("<th>").text(h));
  });
  rows.forEach(function(row) {
    table.append(createRow(row));
  });

  return table;
}

function createRow(row) {
  var tr = $("<tr>");
  row.forEach(function(item) {
    tr.append($("<td>").text(item));
  });

  return tr;
}

function drawResultTable(results) {
  var resultsDiv = $("#results");
  var headers = ["Location (X)", "Length (Y)", "Prime", "Position in e"];
  var rows = [];

  Object.keys(results).forEach(function(key) {
    var result = results[key];
    var row = [];

    row.push(result["location"]);
    row.push(result["length"]);
    row.push(result["prime"]);
    row.push(result["position"]);

    rows.push(row);
  });

  var table = createTable(headers, rows);
  resultsDiv.html(table);
}

function drawJobsTable(jobs) {
  var jobsDiv = $("#jobs");
  var headers = ["Location (X)", "Length (Y)"];
  var rows = [];

  jobs.forEach(function(job) {
    rows.push([ job["location"], job["length"] ]);
  });

  jobsDiv.html(createTable(headers, rows));
}

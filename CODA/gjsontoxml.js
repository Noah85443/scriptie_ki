const fs = require("fs");
const { create } = require("xmlbuilder2");

const geoJson = JSON.parse(
  fs.readFileSync("deeplearning/H21-066.4_HE332_225_Scan1#1-1.geojson", {
    encoding: "utf8",
    flag: "r",
  })
);

const root = create({ version: "1.0" })
  .ele("Annotations", { MicronsPerPixel: 1 })
  .ele("Annotation", { Type: "normal" })
  .ele("Regions");

// loop through regions (these are the different objects {} in features array)
geoJson.features.map((feature) => {
  let w = root
    .ele("Region", {
      Id: feature.Id,
      Type: feature.geometry.properties.objectType,
    })
    .ele("Vertices");
  // loop through vertices (these are the coordinates in the feature variable now)
  // the coordinates are a nested array??? stupid haha
  feature.geometry.coordinates[0].map((c) => {
    w.ele("Vertex", { X: c[0] / 8, Y: c[1] / 8 });
  });
});
root.up().ele("Plots");

// convert the XML tree to string
const xml = root.end({ prettyPrint: true });
console.log(xml);

// write to file
fs.writeFileSync("deeplearning/H21-066.4_HE332_225_Scan1.xml", xml);
